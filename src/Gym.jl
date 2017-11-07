# __precompile__()
module Gym

using DeepRL
using PyCall
using IntervalSets
#import DeepRL: reset!, step!, actions, rand, sample_action, n_actions, obs_dimensions, render

export
    GymEnv,
    reset!,
    step!,
    actions,
    n_actions,
    obs_dimensions,
    render

mutable struct GymEnv <: AbstractEnvironment
    name::AbstractString
    env
    state
    done
end

GymEnv(name::AbstractString) = GymEnv(name, gym.make(name), nothing, true)

Base.srand(env::GymEnv, seed) = env.env[:seed](seed)

DeepRL.finished(env::GymEnv) = env.done

DeepRL.reset!(env::GymEnv) = (env.state = env.env[:reset](); env.state)

function DeepRL.step!(env::GymEnv, action)
    return env.state, r, env.done, info = env.env[:step](action) #TODO assuming fully observable here
end

DeepRL.actions(env::GymEnv) = _actions(env.env[:action_space])
function _actions(A::PyObject)
    if haskey(A, :n)
        # choose from n actions
        return 0:A[:n]-1
    elseif haskey(A, :spaces)
        # array of action sets
        return[_actions(a) for a in A[:spaces]]
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
        error("Unknown actionset type: $A")
    end
end


DeepRL.n_actions(env::GymEnv) = env.env[:action_space][:n]

DeepRL.obs_dimensions(env::GymEnv) = env.env[:observation_space][:shape]

DeepRL.render(env::GymEnv, args...; kws...) = env.env[:render](args...; kws...)


function __init__()
    global const gym = PyCall.pywrap(PyCall.pyimport("gym"))
end

end # module
