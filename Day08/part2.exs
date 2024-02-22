defmodule Day8 do
  # Now you should start by all nodes that ends with 'A' and follow them together.
  # The problem is solved when all paths are in a node that ends with 'Z' at the same time.
  
  def answer() do
    {actions, map} = parse()

    map
    |> Map.to_list()
    |> Enum.filter(fn {start, _} ->
      start
      |> String.graphemes()
      |> List.last()
      |> then(fn l -> l == "A" end)
    end)
    |> Enum.map(fn {start, _} ->
      recursive(actions, start, actions, map, 0, "..Z")
    end)
    |> lcm_of_list()
  end


  def recursive([], current, actions_backup, map, count, target) do
    recursive(actions_backup, current, actions_backup, map, count, target)
  end


  def recursive([h | tail], current, actions_backup, map, count, target) do
    right_or_left = if h == "L", do: 0, else: 1
    next = map[current] |> elem(right_or_left)
    reach? = compare(target, next)

    if reach?, do: count + 1, else: recursive(tail, next, actions_backup, map, count + 1, target)
  end


  def compare("..Z", next), do: String.last(next) == "Z"


  def lcm(a, b) do
    div(abs(a * b), gcd(a, b))
  end


  def gcd(a, 0), do: a
  def gcd(a, b), do: gcd(b, rem(a, b))


  def lcm_of_list([]), do: nil


  def lcm_of_list([head | tail]) do
    Enum.reduce(tail, head, &lcm/2)
  end


  def parse() do
    [actions | nodes] =
      "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    map =
      nodes
      |> Enum.map(&String.replace(&1, ~r/[()=,]/, ""))
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Map.new(fn [start, left, right] -> {start, {left, right}} end)

    {String.graphemes(actions), map}
  end
end


IO.inspect("Answer: #{Day8.answer()}")
