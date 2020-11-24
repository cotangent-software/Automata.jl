### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ aff6e710-27c0-11eb-1782-91c83dd55c13
using Automata

# ╔═╡ c2dd9e00-27c0-11eb-148d-d5fc9de0997f
using Images

# ╔═╡ 8bd97320-27c0-11eb-0a34-535cdfded71b
md"
## Random initial conditions for cellular automata
"

# ╔═╡ d90af470-27c0-11eb-3bc5-abb917b5234d
Gray.(1 .- Float32.(Automata.to_array(elementary(30, 1000))))

# ╔═╡ 774e3e80-27c1-11eb-19f2-25fbb633dc17
mkdir("random_initial")

# ╔═╡ 68a6744e-27c2-11eb-2082-796e0b0a16bb
mkdir("elementary")

# ╔═╡ a59a0d00-27c1-11eb-1db6-8fa51f230fe1
rule = 110

# ╔═╡ ad300970-27c1-11eb-0db8-57b9b7e88b71
steps = 1000

# ╔═╡ 7b389810-27c1-11eb-1c82-492fa5aad6cb
for i = 1:1000
	initial_state = zeros(Bool, Int(ceil(log2(i+1))))
	for j = 1:length(initial_state)
		initial_state[j] = i >> (j - 1) & 1
	end
	render("random_initial/elementary/$i.png", elementary(rule, steps, initial_state))
end

# ╔═╡ 46d0b100-27c3-11eb-2755-75a521586609
mkdir("totalistic")

# ╔═╡ b90af0a0-27c3-11eb-2ea6-1723d1eaf6cd
mkdir("totalistic_diff")

# ╔═╡ 85bee130-27c2-11eb-0209-4be164f25ffb
colors = 4

# ╔═╡ 9a4e8d30-27c2-11eb-06ac-2101484da7d5
code = 2530

# ╔═╡ a3224450-27c3-11eb-3cc3-6b7060b71981
diff_arr(arr) = abs.(diff(arr, dims=2))

# ╔═╡ 780bf3c0-27c2-11eb-062b-c500ef9e2dee
for i = 1:10
	initial_state = zeros(UInt8, Int(ceil(log(colors, i+1))))
	acc = i
	for j = length(initial_state):-1:1
		digit = colors ^ (j - 1)
		initial_state[length(initial_state) - j + 1] = acc ÷ digit
		acc %= digit
	end
	render("random_initial/totalistic_diff/$i.png", totalistic(code, steps, colors, initial_state), [diff_arr])
end

# ╔═╡ Cell order:
# ╟─8bd97320-27c0-11eb-0a34-535cdfded71b
# ╠═aff6e710-27c0-11eb-1782-91c83dd55c13
# ╠═c2dd9e00-27c0-11eb-148d-d5fc9de0997f
# ╠═d90af470-27c0-11eb-3bc5-abb917b5234d
# ╠═774e3e80-27c1-11eb-19f2-25fbb633dc17
# ╠═68a6744e-27c2-11eb-2082-796e0b0a16bb
# ╠═a59a0d00-27c1-11eb-1db6-8fa51f230fe1
# ╠═ad300970-27c1-11eb-0db8-57b9b7e88b71
# ╠═7b389810-27c1-11eb-1c82-492fa5aad6cb
# ╠═46d0b100-27c3-11eb-2755-75a521586609
# ╠═b90af0a0-27c3-11eb-2ea6-1723d1eaf6cd
# ╠═85bee130-27c2-11eb-0209-4be164f25ffb
# ╠═9a4e8d30-27c2-11eb-06ac-2101484da7d5
# ╠═a3224450-27c3-11eb-3cc3-6b7060b71981
# ╠═780bf3c0-27c2-11eb-062b-c500ef9e2dee
