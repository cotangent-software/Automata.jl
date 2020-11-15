using Images

function to_array(history::AutomataBinaryHistory)
    width = length(history.states[end])
    height = length(history)
    img = zeros(Float32, height, width)

    step = 1
    for (state, uns) = history
        offset = width ÷ 2 - step + 1
        img[step, :] .= uns
        for i = 1:length(state)
            img[step, i + offset] = state[i]
        end
        step += 1
    end

    return img
end
function to_array(history::AutomataColorHistory)
    width = length(history.states[end])
    height = length(history)
    img = zeros(Float32, height, width)

    to_color(s) = Float32(s) / (Float32(history.colors) - 1)

    step = 1
    for (state, uns) = history
        offset = width ÷ 2 - step + 1
        img[step, :] .= to_color(uns)
        for i = 1:length(state)
            img[step, i + offset] = to_color(state[i])
        end
        step += 1
    end

    return img
end

export render
function render(filename::String, arr::Array{Float32, 2})
    save(filename, Gray.(1 .- arr))
end
function render(filename::String, history::T) where {T <: AutomataHistory}
    render(filename, to_array(history))
end
