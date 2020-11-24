using Images

function to_array(history::AutomataBinaryHistory)
    start_width = length(history.states[1])
    width = length(history.states[end])
    height = length(history)
    img = zeros(Float32, height, width)

    step = 1
    for (state, uns) = history
        offset = (width - start_width) ÷ 2 - step + 1
        img[step, :] .= uns
        for i = 1:length(state)
            img[step, i + offset] = state[i]
        end
        step += 1
    end

    return img
end
function to_array(history::AutomataColorHistory)
    start_width = length(history.states[1])
    width = length(history.states[end])
    height = length(history)
    img = zeros(Float32, height, width)

    to_color(s) = Float32(s) / (Float32(history.colors) - 1)

    step = 1
    for (state, uns) = history
        offset = (width - start_width) ÷ 2 - step + 1
        img[step, :] .= to_color(uns)
        for i = 1:length(state)
            img[step, i + offset] = to_color(state[i])
        end
        step += 1
    end

    return img
end
function to_array(history::AutomataContinuousHistory)
    start_width = length(history.states[1])
    width = length(history.states[end])
    height = length(history)
    img = zeros(Float32, height, width)

    step = 1
    for (state, uns) = history
        offset = (width - start_width) ÷ 2 - step + 1
        img[step, :] .= uns
        for i = 1:length(state)
            img[step, i + offset] = state[i]
        end
        step += 1
    end

    return img
end

export render
function render(filename::String, arr::Array{Float32, 2}, filters=[])
    for arr_filter = filters
        arr = arr_filter(arr)
    end
    save(filename, Gray.(1 .- arr))
end
function render(filename::String, history::T, filters=[]) where {T <: AutomataHistory}
    render(filename, to_array(history), filters)
end
