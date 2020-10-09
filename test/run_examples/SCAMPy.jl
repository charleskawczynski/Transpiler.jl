using Test
using Transpiler
const T = Transpiler
const root_dir = dirname(dirname(pathof(Transpiler)))
is_project_file(x) = any(endswith(x,y) for y in (".py",".pxd","pyx"))

@testset "SCAMPy" begin
    foreign = joinpath(root_dir, "..", "CliMA", "SCAMPyRepos", "SCAMPyOriginal", "SCAMPy")
    example_root=joinpath(root_dir,"examples","SCAMPy")

    paths = Dict(
        :foreign=>foreign,
        :local_original=>joinpath(example_root, "original"),
        :example_root=>example_root,
        )

    project = T.configure_project(;
        paths=paths,
        file_filter=is_project_file,
        folder_filter=x->!occursin("__pycache__", x),
        skip_import=true,
        language_to=Julia(),
        language_from=Cython()
        )

    T.transpile_py_2_jl(project)
end
