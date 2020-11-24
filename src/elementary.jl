function elementary_rules(rule::UInt8)
    rule_map = zeros(Bool, 2^3)
    for i = 1:length(rule_map)
        rule_map[i] = rule >> (i - 1) & 1
    end
    rule_map
end
function elementary_reversible_rules(rule::UInt8)
    rule_map = zeros(Bool, 2^4)
    for p = 0:1
        for i = 1:2^3
            rule_map[p * 8 + i] = rule >> (i - 1) & 1
            if p == 1
                rule_map[p * 8 + i] = !rule_map[p * 8 + i]
            end
        end
    end
    rule_map
end

export elementary
function elementary(rule::Int, steps::Int, initial_state::Vector{Bool}=Bool[ true ])
    return elementary(UInt8(rule), Int64(steps), initial_state)
end
function elementary(rule::UInt8, steps::Int64, initial_state::Vector{Bool}=Bool[ true ])
    rule_map = elementary_rules(rule)

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
function elementary_reversible(rule::UInt8, steps::UInt64, initial_state::AbstractArray{Bool, 1}=Bool[ true ], initial_state_above::AbstractArray{Bool, 1}=Bool[ false, false, false ])
    rule_map = elementary_reversible_rules(rule)

    current_state = initial_state
    uns = false
    pre_uns = false
    states = AutomataBinaryHistory()

    push!(states, current_state, uns)

    for i = 2:steps
        next_state = zeros(Bool, length(current_state) + 2)
        for j = 1:length(next_state)
            next_state[j] = rule_map[(i == 2 ? state_at(initial_state_above, pre_uns, j) : state_at(states[Int(i-2)][1], pre_uns, j-2)) << 3 | state_at(current_state, uns, j-2) << 2 | state_at(current_state, uns, j-1) << 1 | state_at(current_state, uns, j) + 1]
        end
        pre_uns = uns
        uns = rule_map[pre_uns << 3 | uns << 2 | uns << 1 | uns + 1]
        current_state = next_state
        push!(states, current_state, uns)
    end

    return states
end
