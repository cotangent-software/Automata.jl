export continuous
function continuous(map_fn, steps::Int, initial_state::Vector{Float32}=Float32[ 1 ])
    continuous(map_fn, UInt64(steps), initial_state)
end
function continuous(map_fn, steps::UInt64, initial_state::Vector{Float32})
    current_state = initial_state
    uns::Float32 = 0
    history = AutomataContinuousHistory()

    push!(history, current_state, uns)

    for i = 2:steps
        next_state = zeros(Float32, length(current_state) + 2)
        for i in 1:length(next_state)
            next_state[i] = map_fn(state_at(current_state, uns, i-2) + state_at(current_state, uns, i-1) + state_at(current_state, uns, i))
        end
        uns = map_fn(uns * 3)
        current_state = next_state

        push!(history, next_state, uns)
    end

    return history
end
