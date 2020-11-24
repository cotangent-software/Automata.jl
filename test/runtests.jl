using Automata
using Test

function allequal(arr1, arr2)
  return sum(arr1 .!= arr2) == 0
end

function tests()
  @testset "Elementary Tests" begin
    @test allequal(automaton(ElementaryRule(30), 10)[end, :], Bool[1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1])
    @test allequal(automaton(ElementaryRule(90), 10)[end, :], Bool[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1])
    @test allequal(automaton(ElementaryRule(110), 10)[end, :], Bool[1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
  end
  @testset "Elementary Reversible Tests" begin
    @test allequal(automaton(ElementaryReversibleRule(30), 10)[end, :], Bool[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0])
    @test allequal(automaton(ElementaryReversibleRule(111), 10)[end, :], Bool[0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0])
    @test allequal(automaton(ElementaryReversibleRule(137), 10)[end, :], Bool[0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
  end
  @testset "Totalistic Tests" begin
    @test allequal(automaton(TotalisticRule(177, 3), 10)[end, :], UInt8[0x02, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x00, 0x02])
    @test allequal(automaton(TotalisticRule(777, 3), 10)[end, :], UInt8[0x01, 0x01, 0x00, 0x00, 0x01, 0x02, 0x02, 0x02, 0x02, 0x01, 0x02, 0x02, 0x02, 0x02, 0x01, 0x00, 0x00, 0x01, 0x01])
    @test allequal(automaton(TotalisticRule(2530, 4), 10)[end, :], UInt8[0x00, 0x03, 0x02, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x03, 0x00])
  end
end

tests()
