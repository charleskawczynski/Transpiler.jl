using Test
using Transpiler
const root_dir = dirname(dirname(pathof(Transpiler)))

@testset "Transpiler" begin
    include(joinpath("unit","runtests.jl"))
    include(joinpath("run_examples","examples.jl"))
end
