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

# Installation
First, make sure you  have the `gym` library installed in your Python distribution.
To install `gym` using `pip`
```bash
pip install gym
pip install gym[atari]
``` 
Add to the above commands the `--user` flag if you don't have root access.

Then you can install `Gym.jl` from the Julia REPL with  
```julia
Pkg.clone("https://github.com/CarloLucibello/Gym.jl")
```

