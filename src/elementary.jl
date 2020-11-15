export elementary
function elementary(rule::Int, steps::Int, initial_state::Vector{Bool}=Bool[ true ])
    return elementary(UInt8(rule), Int64(steps), initial_state)
end
function elementary(rule::UInt8, steps::Int64, initial_state::Vector{Bool}=Bool[ true ])
    rule_map = zeros(Bool, 2^3)
    for i = 1:length(rule_map)
        rule_map[i] = rule >> (i - 1) & 1
    end

    current_state = initial_state
    uns = false
    states = AutomataBinaryHistory()

    push!(states, current_state, uns)

    for i = 2:steps
        next_state = zeros(Bool, length(current_state) + 2)
        for j = 1:length(next_state)
            next_state[j] = rule_map[state_at(current_state, uns, j-2) << 2 | state_at(current_state, uns, j-1) << 1 | state_at(current_state, uns, j) + 1]
        end
        uns = rule_map[uns ? 8 : 1]
        current_state = next_state
        push!(states, current_state, uns)
    end

    return states
end
