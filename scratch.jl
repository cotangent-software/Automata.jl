using Automata
using Images

function exec()
    println("Starting...")

    # @time automaton(ElementaryRule(30), 10000, reshape(Bool[ 1 ], 1, 1))
    # save("30.png", Gray.(1 .- Float32.(automaton(ElementaryReversibleRule(90), 100))))
    # save("30R.png", Gray.(1 .- Float32.(automaton(ElementaryReversibleRule(30), 100))))
    # save("2530_2.png", Gray.(1 .- Float32.(automaton(TotalisticRule(2530, 4), 100)) ./ 3))
    # save("d3C.png", Gray.(1 .- Float32.(automaton(ContinuousRule(@inline (x -> (x * (3/2)) % 1)), 100))))
    # automaton(ElementaryRule(30), 10)
    # @time automaton(ElementaryRule(30), 10000)
    # @time automaton(ElementaryRule(30), 1000)
    # @time elementary(30, 1000)
end

exec()
