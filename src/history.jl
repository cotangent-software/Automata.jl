abstract type AutomataHistory end

struct AutomataBinaryHistory <: AutomataHistory
    states::Vector{AbstractArray{Bool, 1}}
    uncomputed::Vector{Bool}
end
AutomataBinaryHistory() = AutomataBinaryHistory([], [])
function Base.push!(history::AutomataBinaryHistory, state::AbstractArray{Bool, 1}, uncomputed::Bool)
    push!(history.states, state)
    push!(history.uncomputed, uncomputed)
end
Base.length(history::AutomataBinaryHistory) = length(history.states)
Base.iterate(history::AutomataBinaryHistory, state=1) = state > length(history) ? nothing : ((history.states[state], history.uncomputed[state]), state + 1)
Base.getindex(history::AutomataBinaryHistory, idx::Int) = (history.states[idx], history.uncomputed[idx])
Base.firstindex(history::AutomataBinaryHistory) = 1
Base.lastindex(history::AutomataBinaryHistory) = length(history.states)


struct AutomataColorHistory <: AutomataHistory
    states::Vector{Vector{UInt8}}
    uncomputed::Vector{UInt8}
    colors::UInt8
end
AutomataColorHistory(colors::UInt8=0x3) = AutomataColorHistory([], [], colors)
function Base.push!(history::AutomataColorHistory, state::Vector{UInt8}, uncomputed::UInt8)
    push!(history.states, state)
    push!(history.uncomputed, uncomputed)
end
Base.length(history::AutomataColorHistory) = length(history.states)
Base.iterate(history::AutomataColorHistory, state=1) = state > length(history) ? nothing : ((history.states[state], history.uncomputed[state]), state + 1)
Base.getindex(history::AutomataColorHistory, idx::Int) = (history.states[idx], history.uncomputed[idx])
Base.firstindex(history::AutomataColorHistory) = 1
Base.lastindex(history::AutomataColorHistory) = length(history.states)


struct AutomataContinuousHistory <: AutomataHistory
    states::Vector{Vector{Float32}}
    uncomputed::Vector{Float32}
end
AutomataContinuousHistory() = AutomataContinuousHistory([], [])
function Base.push!(history::AutomataContinuousHistory, state::Vector{Float32}, uncomputed::Float32)
    push!(history.states, state)
    push!(history.uncomputed, uncomputed)
end
Base.length(history::AutomataContinuousHistory) = length(history.states)
Base.iterate(history::AutomataContinuousHistory, state=1) = state > length(history) ? nothing : ((history.states[state], history.uncomputed[state]), state + 1)
Base.getindex(history::AutomataContinuousHistory, idx::Int) = (history.states[idx], history.uncomputed[idx])
Base.firstindex(history::AutomataContinuousHistory) = 1
Base.lastindex(history::AutomataContinuousHistory) = length(history.states)
