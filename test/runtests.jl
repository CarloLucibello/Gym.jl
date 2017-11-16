using Gym
using IntervalSets
using Base.Test

function sim(env, nsteps=100, rng=Base.Random.GLOBAL_RNG)
    println("### Playing ", spec(env))
    step = 1
    done = false
    r_tot = 0.0
    obs = reset!(env)
    srand(env, 17)
    while !done && step <= nsteps
        A = action_space(env)
        action = rand(A)
        obs, rew, done, info = step!(env, action)
        r_tot += rew
        step += 1
        # render(env)
        # sleep(0.02)
    end
    # render(env, close=true)

    return r_tot
end

envs = [GymEnv("Breakout-v0"), GymEnv("CartPole-v0"), GymEnv("Pong-v0")]

for env in envs
    r = sim(env)
end

env = GymEnv("CartPole-v0")
@test action_space(env) == 0:1
O = observation_space(env)
@test O.left ≈ [-4.8, -3.40282e38, -0.418879, -3.40282e38] rtol=1e-4
@test O.right ≈ [4.8, 3.40282e38, 0.418879, 3.40282e38]  rtol=1e-4

env = GymEnv("DuplicatedInput-v0")
@test action_space(env) == (0:1,0:1,0:4)
@test observation_space(env) == 0:5