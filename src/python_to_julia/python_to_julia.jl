include("pass_helpers.jl")
include("pass1.jl")
include("pass2.jl")
include("pass3.jl")

function transpile_py_2_jl(project)

    # pass1(project)
    # pass2(project)
    pass3(project)

end
