export totalistic
function totalistic(code::Int, steps::Int, colors=3, initial_state::Vector{UInt8}=UInt8[ 1 ])
    totalistic(UInt64(code), Int64(steps), UInt8(colors), initial_state)
end
function totalistic(code::UInt64, steps::Int64, colors::UInt8=0x3, initial_state::Vector{UInt8}=UInt8[ 1 ])
    code_count = 3 * (colors - 1) + 1
    code_map = zeros(UInt8, code_count)
    for i in 1:code_count
        code_map[i] = (code ÷ Int64(colors)^(i-1)) % Int64(colors)
    end

    current_state = initial_state
    uns = 0x0
    history = AutomataColorHistory(colors)

    push!(history, current_state, uns)

    for i = 2:steps
        next_state = zeros(UInt8, length(current_state) + 2)
        for i in 1:length(next_state)
            next_state[i] = code_map[state_at(current_state, uns, i-2) + state_at(current_state, uns, i-1) + state_at(current_state, uns, i) + 1]
        end
        uns = code_map[uns * 3 + 1]
        current_state = next_state

        push!(history, next_state, uns)
    end

    return history
end
