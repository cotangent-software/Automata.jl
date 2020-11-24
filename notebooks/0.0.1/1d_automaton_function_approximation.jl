### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 91e98d52-29f9-11eb-06af-0fe713025110
using Automata

# ╔═╡ 95d8a1d0-29f9-11eb-0da2-0d030aeeb8b9
using Plots

# ╔═╡ 96ff6e90-29f9-11eb-1c14-075e1e729948
using Images

# ╔═╡ 97f9ad10-29f9-11eb-0be4-93844ea7a8d3
using Flux

# ╔═╡ f58eca9e-29fe-11eb-34ae-d1bd20aea5e0
using Zygote

# ╔═╡ 99f81520-29f9-11eb-388f-27ffa5b411e5
md"
## 1D Automata Function Approximation
"

# ╔═╡ c3bf6cf0-29f9-11eb-28d2-dd6eb9fba2ca
θ = zeros(3)

# ╔═╡ df949cae-29ff-11eb-3371-6dfd3d77f8c7
function perform_step(current_state, map_fn, x)
	uns::Float32 = 0
	i = Int(x[1])
	if i == 1 || i == length(current_state)
		return 0.
	end
	return map_fn(Automata.state_at(current_state, uns, i-1) + Automata.state_at(current_state, uns, i) + Automata.state_at(current_state, uns, i+1))
end

# ╔═╡ f27427b0-29ff-11eb-0c41-21eb6e434cae
Zygote.@adjoint perform_step(x) = perform_step(x), Δ->(Δ,)

# ╔═╡ 27129d2e-2a00-11eb-225e-c9a511df0821
Zygote.@adjoint Base.Iterators.Enumerate(c) = Base.Iterators.Enumerate(c), Δ->(Δ,)

# ╔═╡ 836f62d0-29fa-11eb-17c5-4d74c9a9bb86
function continuous_custom(map_fn, steps::UInt64, initial_state::Vector{Float32})
    current_state = initial_state
    uns::Float32 = 0
    history = Automata.AutomataContinuousHistory()

    for i = 2:steps
		next_state = map((x) -> perform_step(current_state, map_fn, x), enumerate(current_state))
        current_state = next_state

    end

    return current_state
end

# ╔═╡ d1961cc0-29fe-11eb-264b-d7f5355c7c60
Zygote.@adjoint continuous_custom(a, b, c) = continuous_custom(a, b, c), Δ->(Δ, Δ, Δ)

# ╔═╡ 0f3f2d52-29ff-11eb-3722-b15a7bd3449b
Zygote.refresh()

# ╔═╡ d98f8830-29f9-11eb-1f67-a90a4c535ee8
ŷ(x) = continuous_custom(x -> sum(fill(x, length(θ)) .^ collect(0:(length(θ)-1)) .* θ), UInt64(5), Float32[0, 0, 0, 0, x, 0, 0, 0, 0])[5]

# ╔═╡ eb783010-29f9-11eb-18e9-c511e061617e
train_x = Float32.(collect(0:0.01:1))

# ╔═╡ 141d760e-29fa-11eb-2803-17f74479ac10
train_y = train_x .^ 2

# ╔═╡ 18480cee-29fa-11eb-02bb-e578f452e751
loss(x, y) = sum(abs.(y .- ŷ.(x)))

# ╔═╡ 35b55090-29fa-11eb-15c6-fb231004dae2
loss(train_x, train_y)

# ╔═╡ 67b9f9a0-2a00-11eb-1125-f5c97a4e9371
δ = 0.00001

# ╔═╡ dccd9800-2a00-11eb-048d-99648eb16f20
μ = 0.0001

# ╔═╡ 6f7630d0-2a02-11eb-0ecb-4f660a1cb96f
for i = 1:1000
	∇J = gradient(() -> loss(train_x, train_y), params(θ))
	θ .-= μ .* ∇J[θ]
	println(θ)
end

# ╔═╡ ada33e70-2a02-11eb-26a5-cf4310fefb23
@time gradient(() -> loss(train_x, train_y), params(θ))

# ╔═╡ aec82480-2a04-11eb-3925-fb5497d53bec
θ

# ╔═╡ eea21ba0-2a00-11eb-2f02-2330fae2c0e5
begin
	p = plot(train_x, train_y, ylim=(0, 1))
	plot!(p, train_x, ŷ.(train_x))
end

# ╔═╡ 3c2fedc0-2a01-11eb-296e-e128d057977d
ŷ.(train_x)

# ╔═╡ Cell order:
# ╟─99f81520-29f9-11eb-388f-27ffa5b411e5
# ╠═91e98d52-29f9-11eb-06af-0fe713025110
# ╠═95d8a1d0-29f9-11eb-0da2-0d030aeeb8b9
# ╠═96ff6e90-29f9-11eb-1c14-075e1e729948
# ╠═97f9ad10-29f9-11eb-0be4-93844ea7a8d3
# ╠═f58eca9e-29fe-11eb-34ae-d1bd20aea5e0
# ╠═c3bf6cf0-29f9-11eb-28d2-dd6eb9fba2ca
# ╠═df949cae-29ff-11eb-3371-6dfd3d77f8c7
# ╠═f27427b0-29ff-11eb-0c41-21eb6e434cae
# ╠═27129d2e-2a00-11eb-225e-c9a511df0821
# ╠═836f62d0-29fa-11eb-17c5-4d74c9a9bb86
# ╠═d1961cc0-29fe-11eb-264b-d7f5355c7c60
# ╠═0f3f2d52-29ff-11eb-3722-b15a7bd3449b
# ╠═d98f8830-29f9-11eb-1f67-a90a4c535ee8
# ╠═eb783010-29f9-11eb-18e9-c511e061617e
# ╠═141d760e-29fa-11eb-2803-17f74479ac10
# ╠═18480cee-29fa-11eb-02bb-e578f452e751
# ╠═35b55090-29fa-11eb-15c6-fb231004dae2
# ╠═67b9f9a0-2a00-11eb-1125-f5c97a4e9371
# ╠═dccd9800-2a00-11eb-048d-99648eb16f20
# ╠═6f7630d0-2a02-11eb-0ecb-4f660a1cb96f
# ╠═ada33e70-2a02-11eb-26a5-cf4310fefb23
# ╠═aec82480-2a04-11eb-3925-fb5497d53bec
# ╠═eea21ba0-2a00-11eb-2f02-2330fae2c0e5
# ╠═3c2fedc0-2a01-11eb-296e-e128d057977d
