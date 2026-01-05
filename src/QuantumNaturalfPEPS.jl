module QuantumNaturalfPEPS

using Statistics
using TimerOutputs
using Random
using LogExpFunctions

using Distributed
using SharedArrays
using MPI

using LinearAlgebra
using ITensors
using ITensorMPS

using QuantumNaturalGradient: TensorOperatorSum, Parameters
using QuantumNaturalGradient

include("misc.jl")
include("tensor_ops.jl")
include("mps_ops.jl")
include("PEPS.jl")
include("parameters.jl")
include("Environments.jl")
include("sampling.jl")
include("Ok.jl")
include("Ek.jl")
include("Ok_and_Ek.jl")
include("Observables.jl")
include("Hamiltonians.jl")

include("Operations/Operations.jl")
include("Properties/Properties.jl")
include("Distributed/Distributed.jl")
include("Test.jl")

include("rte_development/rte_development.jl")

export PEPS
export write!
export Ok_and_Ek
export generate_Oks_and_Eks

# warns when using or importing the package from .julia/dev
function __init__()
    if occursin(".julia/dev/", pathof(QuantumNaturalGradient))
        @warn "You are currently on the .julia/dev/ version of QuantumNaturalfPEPS."
    end
end

end
