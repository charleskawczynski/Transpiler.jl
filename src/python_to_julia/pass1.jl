"""
    pass1(project)

 - Remove `pass1/`
 - Copy files from `original/` into `pass1`
 - Convert file extensions (.py, .pyx, .pxd) to .jl, move into `src/`
 - Merge .pxd and .pyx to single file
 - Create `src/project.jl` and include all other files
"""
function pass1(project)
    println("Performing pass1...")
    println("   Copying project...")
    # Clean
    rm(joinpath(project.paths[:example_root], "pass1", "src");recursive=true,force=true)
    # Convert file extension
    # If .pxd and .pyx have the same name,
    # merge the files into one .jl
    files = [joinpath(root, f) for
            (root, dirs, files) in
            Base.Filesystem.walkdir(
            project.paths[:local_original])
            for f in files]

    mkpath(joinpath(project.paths[:example_root], "pass1", "src"))

    println("   Converting file extensions...")
    cd(joinpath(project.paths[:example_root], "pass1", "src")) do
        for file in files
            file_new = basename(file)
            for ext in extensions_from(project.language_from)
                if endswith(file_new, ext)
                    file_new = replace(file_new, ext=>extension_to(project.language_to))
                    cp(file, file_new;force=true)
                end
            end
        end
    end
    println("   Merging files...")
    cd(joinpath(project.paths[:example_root], "pass1", "src")) do
        for file in files
            file_new = basename(file)
            ext = extension_from_append(project.language_from)
            if endswith(file_new, ext)
                file_new = replace(file_new, ext=>extension_to(project.language_to))
                contents_new = ""*open(f->read(f, String), file)*"\n #pyx files\n"
                if isfile(file_new)
                    open(file_new, "a") do io
                        print(io, contents_new)
                    end
                end
            end
        end
    end
    files = [joinpath(root, f) for
            (root, dirs, files) in
            Base.Filesystem.walkdir(joinpath(project.paths[:example_root], "pass1", "src")) for f in files]
    project_src =
        joinpath(project.paths[:example_root],
            "pass1", "src",project.name)

    # TODO: include order requires topological sort of all files
    if !isfile(project_src)
        println("   Creating new project files...")
        open(project_src, "w") do io
            println(io, "module $(project.base_name)\n\n")
            for f in files
                println(io, "include(\"$(basename(f))\")")
            end
            println(io, "\n\nend")
        end
    end
end
