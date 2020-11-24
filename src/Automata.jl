module Automata

# include("util.jl")
# include("history.jl")
# include("render.jl")
# include("elementary.jl")
# include("totalistic.jl")
# include("continuous.jl")


_bounds = Dict(
    "nn" => ((-1, -1), (-1, 1)),
    "nn2t" => ((-2, -1), (-1, 1))
)


export Rule
struct Rule{T, N, F}
    map_fn::F
    bounds::Tuple{Tuple{Int, Int}, Tuple{Int, Int}}
    default_initial_state::Array{T, N}
end


export ElementaryRule
function ElementaryRule(rule::Int)
    rule = UInt8(rule)
    rule_map = zeros(Bool, 2^3)
    for i = 1:length(rule_map)
        rule_map[i] = rule >> (i - 1) & 1
    end

    map_fn = @inline (v) -> rule_map[v[1, 1] << 2 | v[1, 2] << 1 | v[1, 3] + 1]
    return Rule(map_fn, _bounds["nn"], reshape(Bool[ true ], 1, 1))
end


export ElementaryReversibleRule
function ElementaryReversibleRule(rule::Int)
    rule = UInt8(rule)
    rule_map = zeros(Bool, 2^4)
    for p = 0:1
        for i = 1:2^3
            rule_map[p * 8 + i] = rule >> (i - 1) & 1
            if p == 1
                rule_map[p * 8 + i] = !rule_map[p * 8 + i]
            end
        end
    end

    map_fn = @inline (v) -> rule_map[v[1, 2] << 3 | v[2, 1] << 2 | v[2, 2] << 1 | v[2, 3] + 1]
    return Rule(map_fn, _bounds["nn2t"], reshape(Bool[ false true ], 2, 1))
end


export TotalisticRule
function TotalisticRule(code::Int, colors::Int)
    code_count = 3 * (colors - 1) + 1
    code_map = zeros(UInt8, code_count)
    for i in 1:code_count
        code_map[i] = (code ÷ Int64(colors)^(i-1)) % Int64(colors)
    end

    map_fn = @inline (v) -> code_map[sum(v) + 1]
    return Rule(map_fn, _bounds["nn"], reshape(UInt8[ 1 ], 1, 1))
end


export ContinuousRule
function ContinuousRule(map_val_fn)
    map_fn = @inline (v) -> map_val_fn(sum(v))
    return Rule(map_fn, _bounds["nn"], reshape(Float32[ 1 ], 1, 1))
end


export automaton
function automaton(rule::Rule, steps::Int, initial_state::Vector{T}; edges=nothing) where {T}
    return automaton(rule, steps, reshape(initial_state, 1, length(initial_state)); edges=edges)
end
function automaton(rule::Rule{T, 2}, steps::Int; edges=nothing) where {T}
    return automaton(rule, steps, rule.default_initial_state; edges=nothing)
end
function automaton(rule::Rule{T, 2}, steps::Int, initial_state::Array{T, 2}; edges=nothing) where {T}
    rule_fn = rule.map_fn
    bounds = rule.bounds

    if isnothing(edges)
        edges = (steps - 1)
    end
    space = zeros(T, steps, edges * 2 + size(initial_state)[2])

    slice_y, slice_x = bounds
    space[1:size(initial_state)[1], (edges + 1):(edges + size(initial_state)[2])] .= initial_state

    width = size(space)[2]

    left_start = width+slice_x[1]+1
    left_end = 1+slice_x[2]
    right_start = width+slice_x[1]
    right_end = slice_x[2]

    @views for i = (size(initial_state)[1]+1):steps
        vertical_slice = (i+slice_y[1]):(i+slice_y[2])
        for j = 2:(edges*2-1+size(initial_state)[2])
            space[i, j] = rule_fn(space[vertical_slice, (j+slice_x[1]):(j+slice_x[2])])
        end
        space[i, 1] = rule_fn(hcat(space[vertical_slice, left_start:width], space[vertical_slice, 1:left_end]))
        space[i, end] = rule_fn(hcat(space[vertical_slice, right_start:width], space[vertical_slice, 1:right_end]))
    end

    return space
end

export automaton_simple
function automaton_simple(rule::UInt8, steps::Int, initial_state::Union{Array{T, 2}, Nothing}=nothing; edges=nothing) where {T}
    rule_fn = rule.map_fn
    bounds = rule.bounds

    if isnothing(initial_state)
        initial_state = rule.default_initial_state
    end

    if isnothing(edges)
        edges = (steps - 1)
    end
    space = zeros(T, steps, edges * 2 + size(initial_state)[2])

    slice_y, slice_x = bounds
    space[1:size(initial_state)[1], (edges + 1):(edges + size(initial_state)[2])] .= initial_state

    width = size(space)[2]

    left_start = width+slice_x[1]+1
    left_end = 1+slice_x[2]
    right_start = width+slice_x[1]
    right_end = slice_x[2]

    for i = (size(initial_state)[1]+1):steps
        vertical_slice = (i+slice_y[1]):(i+slice_y[2])
        for j = 2:(edges*2-1+size(initial_state)[2])
            v = space[vertical_slice, (j+slice_x[1]):(j+slice_x[2])]
            space[i, j] = rule_fn(v)
        end
        space[i, 1] = rule_fn(hcat(space[vertical_slice, left_start:width], space[vertical_slice, 1:left_end]))
        space[i, end] = rule_fn(hcat(space[vertical_slice, right_start:width], space[vertical_slice, 1:right_end]))
    end

    return space
end


end # module
