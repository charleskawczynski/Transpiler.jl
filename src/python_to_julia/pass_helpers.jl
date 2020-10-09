"""
    prep_pass(project, pass_num)

 - Remove `pass(pass_num)/`
 - Copy files from `pass(pass_num-1)/` into `pass(pass_num)`
 - Returns files from pass_num
"""
function prep_pass(project, pass_num)
    pass_num <= 1 && error("prep_pass only valid for pass_num>1")
    rm(joinpath(project.paths[:example_root], "pass$pass_num", "src");recursive=true,force=true)
    files = [joinpath(root, f) for
            (root, dirs, files) in
            Base.Filesystem.walkdir(
            joinpath(project.paths[:example_root],
            "pass$(pass_num-1)", "src"))
            for f in files]

    mkpath(joinpath(project.paths[:example_root], "pass$pass_num", "src"))

    cd(joinpath(project.paths[:example_root], "pass$pass_num", "src")) do
        for file in files
            file_new = basename(file)
            cp(file, file_new;force=true)
        end
    end
    files = [joinpath(root, f) for
            (root, dirs, files) in
            Base.Filesystem.walkdir(
            joinpath(project.paths[:example_root],
            "pass$pass_num", "src"))
            for f in files]
    return files
end
