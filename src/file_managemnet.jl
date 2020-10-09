#### File management

export Project
struct Project
    paths::Dict
    files::Dict
    file_filter
    folder_filter
    base_name
    name
    preserve_comments
    language_to
    language_from
end

function configure_project(;
    paths,
    file_filter,
    folder_filter,
    skip_import,
    preserve_comments=false,
    language_to,
    language_from)
    files = [joinpath(root, f) for
            (root, dirs, files) in
            Base.Filesystem.walkdir(paths[:foreign]) for f in files]
    files = filter(x->file_filter(x), files)
    files = filter(x->folder_filter(x), files)

    # Copy foreign files to Transpiler directory in flattened directory:
    mkpath(paths[:example_root])
    mkpath(paths[:local_original])
    if !skip_import
        cd(paths[:local_original]) do
            for f in files
                cp(f, basename(f);force=true)
            end
        end
    end
    base_name = basename(paths[:foreign])
    name = base_name*".jl"
    files = Dict(
        :foreign=>[joinpath(paths[:local_original], basename(f)) for f in files],
        :local_original=>[joinpath(paths[:local_original], basename(f)) for f in files],
        )
    return Project(
        paths,
        files,
        file_filter,
        folder_filter,
        base_name,
        name,
        preserve_comments,
        language_to,
        language_from
        )
end
