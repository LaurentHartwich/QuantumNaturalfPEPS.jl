# This file contains functions that generate OpSums corresponding to the hamiltonians for different models. L is always assumed to be the side length of a square system.

# WARNING: as of now, none of these functions contains argument-checking logic.
# also, ħ = 1 is assumed everywhere.


# Packages
using ITensorMPS # for OpSum


# general wrapper. No optional/default arguments; all kwargs of the relevant sub-function must be provided.
function hamiltonian_opsum(model::String; kwargs...)
    if model == "TFIM"
        return hamiltonian_opsum_TFIM(kwargs[:L]; J=kwargs[:J], h=kwargs[:h])
    elseif model == "J1J2"
        return hamiltonian_opsum_J1J2(kwargs[:L]; J1=kwargs[:J1], J2=kwargs[:J2])
    else
        throw(ArgumentError("Error: Type $model unknown."))
    end
end


# TFIM Hamiltonian (next neighbors interact only in spin-z component, and every spins x component interacts with external field)
# actually, I think "-J" should be "-(J ħ^2)/4
function hamiltonian_opsum_TFIM(L::Int; J::Real = -1, h::Real = 0)
    ham = OpSum()
    for i in 1:L, j in 1:L
        # spin-spin-interactions between vertical neighbors
        if j < L
            ham .+= (-J, "Z", (i, j), "Z", (i, j+1)) # broadcast op. not necessary but faster
        end
        # spin-spin-interactions between horizontal neighbors
        if i < L
            ham .+= (-J, "Z", (i, j), "Z", (i+1, j))
        end
        # spin-transverse-field-interactions
        if h != 0
            ham .+= (-h, "X", (i, j))
        end
    end
    return ham
end


# Heisenberg J1J2 model (isotropic)
# note the sign choice, H = -J1 ... -J2 ...
function hamiltonian_opsum_J1J2(L::Int; J1::Real = -1, J2::Real = 0)
    ham = OpSum()
    # next neighbor interactions
    if J1 != 0
        for i in 1:L, j in 1:L, t in ["X", "Y", "Z"]
            if j < L
                ham .+= (-J1, t, (i, j), t, (i, j+1))
            end
            if i < L
                ham .+= (-J1, t, (i, j), t, (i+1, j))
            end
        end
    end
    # second-next neighbor interactions
    if J2 != 0
        for i in 1:L, j in 1:L, t in ["X", "Y", "Z"]
            if j < L-1
                ham .+= (-J2, t, (i, j), t, (i, j+2))
            end
            if i < L-1
                ham .+= (-J2, t, (i, j), t, (i+2, j))
            end
        end
    end
    return ham
end


; # suppress output when including file