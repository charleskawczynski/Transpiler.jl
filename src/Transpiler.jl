module Transpiler

using BetweenFlags

include(joinpath("intrinsics","FortranIntrinsics.jl"))
include(joinpath("intrinsics","PythonIntrinsics.jl"))
include("types.jl")
include("remove_comments.jl")
include("file_managemnet.jl")

extensions_from(::Union{Python,Cython}) = (".pxd", ".py")
extension_from_append(::Union{Python,Cython}) = ".pyx"
extension_from(::Julia) = ".jl"
extension_to(::Python) = ".py"
folder_filters(::Union{Python,Cython}) = "__pycache__"
extension_to(::Julia) = ".jl"

include(joinpath("python_to_julia","python_to_julia.jl"))

end # module
