# Gym

[![Build Status](https://travis-ci.org/CarloLucibello/Gym.jl.svg?branch=master)](https://travis-ci.org/CarloLucibello/Gym.jl)

Julia wrapper for [OpenAI Gym](https://gym.openai.com/). 

See [DeepRLexamples.jl](https://github.com/CarloLucibello/DeepRLexamples.jl) for some examples of deep reinforcement learning
using the `Gym` enviroment.

## Usage Example
```julia
using Gym

env = GymEnv("Breakout-v0") # initialize the environment
println(spec(env)) # print specifications
state = reset!(env)
srand(17); srand(env, 17) #for reproducible results
r_tot = 0.0
while true # play one episode
    A = action_space(env)
    action = rand(A)
    obs, rew, isdone, info = step!(env, action)
    r_tot += rew
    render(env)
    isdone && break    
end

render(env, close=true)
```

# Installation
First, make sure you  have the `gym` library installed in your Python distribution.
To install `gym` using `pip`:
```bash
pip install gym
pip install gym[atari]
``` 
Add to the above commands the `--user` flag if you don't have root access.

You can then install `Gym.jl` from the Julia REPL with  
```julia
Pkg.clone("https://github.com/CarloLucibello/Gym.jl")
```

