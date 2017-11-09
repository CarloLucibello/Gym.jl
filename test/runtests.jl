using Gym
using Base.Test

function sim(env, nsteps=100, rng=Base.Random.GLOBAL_RNG)
    println("### Playing ", env.name)
    step = 1
    done = false
    r_tot = 0.0
    o = reset!(env)
    na = n_actions(env)
    dims = obs_dimensions(env)
    srand(env, 17)
    while !done && step <= nsteps
        A = actions(env)
        action = rand(A)
        @show A action
        obs, rew, done, info = step!(env, action)
        #print  ln(obs, " ", rew, " ", done, " ", info)
        r_tot += rew
        step += 1
        # render(env)
        sleep(0.02)
    end
    render(env, close=true)

    return r_tot
end

envs = [GymEnv("Breakout-v0"), GymEnv("CartPole-v0"), GymEnv("Pong-v0")]

for env in envs
    r = sim(env)
end
