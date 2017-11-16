__precompile__()
module Gym

using PyCall
using IntervalSets

export GymEnv, GymSpec, reset!, step!, action_space, observation_space, render, spec

mutable struct GymEnv
    pyenv
    done
    spec # specifications    
end

function GymEnv(name::String)
    specs = [:id, :nondeterministic, :reward_threshold, :tags, :timestep_limit, :trials]
    pyenv = gym.make(name)
    pyspec = pyenv[:spec]         
    return GymEnv(pyenv, true,  Dict(s => pyspec[s] for s in specs))
end

spec(env::GymEnv) = env.spec

Base.srand(env::GymEnv, seed) = env.pyenv[:seed](seed)

Base.done(env::GymEnv) = env.done

reset!(env::GymEnv) = env.pyenv[:reset]()

function step!(env::GymEnv, action)
    return obs, r, env.done, info = env.pyenv[:step](action)
end

action_space(env::GymEnv) = pyset_to_julia(env.pyenv[:action_space])
observation_space(env::GymEnv) = pyset_to_julia(env.pyenv[:observation_space])

# use keyword argument close=true to close
render(env::GymEnv, args...; kws...) = env.pyenv[:render](args...; kws...)

function pyset_to_julia(A::PyObject)
    if haskey(A, :n)
        # choose from n actions
        return 0:A[:n]-1
    elseif haskey(A, :spaces)
        # array of action sets
        return ([pyset_to_julia(a) for a in A[:spaces]]...)
    elseif haskey(A, :high)
        # continuous interval
        return A[:low]..A[:high] # interval from IntervalSets
    # elseif haskey(A, :buttonmasks)
    #     # assumed VNC actions... keys to press, buttons to mask, and screen position
    #     # keyboard = DiscreteSet(A[:keys])
    #     keyboard = KeyboardActionSet(A[:keys])
    #     buttons = DiscreteSet(Int[bm for bm in A[:buttonmasks]])
    #     width,height = A[:screen_shape]
    #     mouse = MouseActionSet(width, height, buttons)
    #     TupleSet(keyboard, mouse)
    # elseif haskey(A, :actions)
    #     # Hardcoded
    #     TupleSet(DiscreteSet(A[:actions]))
    else
        @show A
        @show keys(A)
        error("Unknown set type: $A")
    end
end


function __init__()
    global const gym = PyCall.pywrap(PyCall.pyimport("gym"))
end

end # module
