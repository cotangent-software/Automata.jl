using Automata
using Test

function allequal(arr1, arr2)
  return sum(arr1 .!= arr2) == 0
end

function tests()
  @testset "Elementary Tests" begin
    state = elementary(30, 10)[end]
    @test allequal(state[1], Bool[1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1])
    @test state[2] == false

    state = elementary(90, 10)[end]
    @test allequal(state[1], Bool[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1])
    @test state[2] == false

    state = elementary(110, 10)[end]
    @test allequal(state[1], Bool[1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    @test state[2] == false
  end
  @testset "Totalistic Tests" begin
    state = totalistic(177, 10)[end]
    @test allequal(state[1], UInt8[0x02, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x00, 0x02])
    @test state[2] == 0x00

    state = totalistic(777, 10)[end]
    @test allequal(state[1], UInt8[0x01, 0x01, 0x00, 0x00, 0x01, 0x02, 0x02, 0x02, 0x02, 0x01, 0x02, 0x02, 0x02, 0x02, 0x01, 0x00, 0x00, 0x01, 0x01])
    @test state[2] == 0x00

    state = totalistic(2530, 10, 4)[end]
    @test allequal(state[1], UInt8[0x00, 0x03, 0x02, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x03, 0x00])
    @test state[2] == 0x02
  end
end

tests()
