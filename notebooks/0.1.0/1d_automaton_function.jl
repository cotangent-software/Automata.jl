### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 21346b42-29f2-11eb-37be-93e9e286032b
using Automata

# ╔═╡ 287d8030-29f2-11eb-11f1-57b2b9f1038f
using Plots

# ╔═╡ 81ce2f92-29f2-11eb-1255-f74ff4d43aa1
using Images

# ╔═╡ 447fe1d0-29f5-11eb-2a6e-a5c55163cd23
md"
# 1D Cellular Automata Function
"

# ╔═╡ 36ac5460-29f2-11eb-1fc8-1d02c14dfc7c
plot(Gray.(Automata.to_array(continuous(x -> (x / 2) % 1, 100))))

# ╔═╡ 2d272abe-29f5-11eb-14a2-33e070036822
a(x, θ) = continuous(x -> sum(fill(x / 3, length(θ)) .^ collect(0:(length(θ)-1)) .* θ) % 1, 3, Float32[x])[end][1][3]

# ╔═╡ 862fd4a0-29f5-11eb-262e-7d7b5bcb39ff
r = collect(0:0.01:1)

# ╔═╡ c27a8db0-29f5-11eb-2495-6f8b73b8acbd
anim = @animate for i = r
	plot(r, (x -> a(x, [i*3, i*3])).(r), ylim=(0, 1))
end

# ╔═╡ e38993b2-29f6-11eb-1c2b-2f961ace6f85
gif(anim, "tmp.gif")

# ╔═╡ Cell order:
# ╟─447fe1d0-29f5-11eb-2a6e-a5c55163cd23
# ╠═21346b42-29f2-11eb-37be-93e9e286032b
# ╠═287d8030-29f2-11eb-11f1-57b2b9f1038f
# ╠═81ce2f92-29f2-11eb-1255-f74ff4d43aa1
# ╠═36ac5460-29f2-11eb-1fc8-1d02c14dfc7c
# ╠═2d272abe-29f5-11eb-14a2-33e070036822
# ╠═862fd4a0-29f5-11eb-262e-7d7b5bcb39ff
# ╠═c27a8db0-29f5-11eb-2495-6f8b73b8acbd
# ╠═e38993b2-29f6-11eb-1c2b-2f961ace6f85
