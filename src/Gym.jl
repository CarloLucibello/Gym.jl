__precompile__()
module Gym

using DeepRL
using PyCall

#importall DeepRL
#importall POMDPs
#import DeepRL: reset, step!, actions, rand, sample_action, n_actions, obs_dimensions, render

export
    GymEnvironment,
    GymActionSpace,
    reset!,
    step!,
    actions,
    rand,
    sample_action,
    n_actions,
    obs_dimensions,
    render

mutable struct GymEnvironment <: AbstractEnvironment
    name::AbstractString
    env
end

GymEnvironment(name::AbstractString) = GymEnvironment(name, gym.make(name))

immutable GymActionSpace
    action_space
end
GymActionSpace(env::GymEnvironment) = GymActionSpace(env.env[:action_space])

DeepRL.reset!(env::GymEnvironment) = env.env[:reset]()

function DeepRL.step!(env::GymEnvironment, action)
    return env.env[:step](action)
end

DeepRL.actions(env::GymEnvironment) = GymActionSpace(env)

Base.rand(as::GymActionSpace) = as.action_space[:sample]()

DeepRL.sample_action(env::GymEnvironment) = rand(actions(env))

DeepRL.n_actions(env::GymEnvironment) = env.env[:action_space][:n]

DeepRL.obs_dimensions(env::GymEnvironment) = env.env[:observation_space][:shape]

DeepRL.render(env::GymEnvironment, args...; kws...) = env.env[:render](args...; kws...)

function __init__()
    global const gym = PyCall.pywrap(PyCall.pyimport("gym"))
end

end # module
