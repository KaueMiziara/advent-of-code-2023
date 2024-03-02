### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 8ed57ec4-42b5-451f-a70b-9e9aa174f67b
md"""
# Never Tell Me the Odds (part 2)

This puzzle presents a set of hailstones, each characterized by two vectors representing its position and velocity.

Each hailstone falls with a constant velocity, following a uniform linear motion. Disregard all external forces, such as gavity and air resistance.

Part 2 asks to calculate the vectors for a stone so that it is thrown once and hit all hailstones.

Before we can write the code to solve the puzzle, we need to define a system of equations.
"""

# ╔═╡ 2bee11cf-f8ed-4809-b46a-6dee3aac62cc
md"""
## Future Position

Given a body initially at a point $P_0$, represented by a vector $\vec{P} = \begin{pmatrix} P_{0x} & P_{0y} & P_{0z} \end{pmatrix}$, with a velocity $v$, represented by $\vec{v} = \begin{pmatrix} v_x & v_y & v_z \end{pmatrix}$.

After a certain time $t_0$ passes, it will be at $P_1$, where $\vec{P_1} = \begin{pmatrix} P_{1x} & P_{1y} & P_{1z} \end{pmatrix}$.

The velocity represents the rate at which the body's position grows over the time $t$. Therefore, we can define $P_1$ as: $\vec{P_1} = \vec{P_0} + \vec{v} \cdot t_0$.
"""

# ╔═╡ 0841c978-f310-4ada-9d50-4784d87cc8c8
md"""
## Trajectory

We can generalize $P_1$ as $P_N$, where $N$ represents a point in any arbitraty time $t$. The trajectory of the body can then be described as the following linear equation:

$$\vec{P_N} = \vec{P_0} + \vec{v} \cdot t$$

### Example

Let $\vec{P_0} = \begin{pmatrix} 19 & 13 & 30 \end{pmatrix}$ and $\vec{v} = \begin{pmatrix} -2 & 1 & -2 \end{pmatrix}$. 

By plotting $f(t) = \vec{P_0} + \vec{v} \cdot t$, we'll have all possible values for $P_N$:
"""

# ╔═╡ f192b5e7-320c-444e-91e5-4be327d0ce0a


# ╔═╡ Cell order:
# ╟─8ed57ec4-42b5-451f-a70b-9e9aa174f67b
# ╟─2bee11cf-f8ed-4809-b46a-6dee3aac62cc
# ╟─0841c978-f310-4ada-9d50-4784d87cc8c8
# ╠═f192b5e7-320c-444e-91e5-4be327d0ce0a
