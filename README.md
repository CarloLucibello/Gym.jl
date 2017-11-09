# Gym

[![Build Status](https://travis-ci.org/sisl/Gym.jl.svg?branch=master)](https://travis-ci.org/sisl/Gym.jl)

Julia wrapper for [OpenAI Gym](https://gym.openai.com/). 
See [DeepRL.jl](https://github.com/CarloLucibello/DeepRL.jl) for some examples of deep reinforcement learning
using the `Gym` enviroment.

```julia
step = 1
done = false
r_tot = 0.0

env = GymEnv("Breakout-v0") # initialize the environment
o = reset(env) # reset the environment
na = n_actions(env)                                                  
dims = obs_dimensions(env)
while !done && step <= nsteps                                       
    action = sample_action(env)                                     
    obs, rew, done, info = step!(env, action)                       
    r_tot += rew
    step += 1
end 
```

