function state_at(state_var, uns, pos)
    if pos < 1 || pos > length(state_var)
        return uns
    end
    return state_var[pos]
end
