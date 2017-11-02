using Gym
using Base.Test

function sim(env, nsteps=100, rng=MersenneTwister(0))
    step = 1
    isdone = false
    r_tot = 0.0
    o = reset!(env)
    na = n_actions(env)
    dims = obs_dimensions(env)
    while !isdone && step <= nsteps
        action = sample_action(env)
        obs, rew, isdone, info = step!(env, action)
        #println(obs, " ", rew, " ", done, " ", info)
        r_tot += rew
        step += 1
        render(env)
        sleep(0.02)
    end
    render(env, close=true)

    return r_tot
end

envs = [GymEnvironment("Breakout-v0"), GymEnvironment("CartPole-v0")]

for env in envs
    r = sim(env)
end
