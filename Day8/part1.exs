defmodule Day8 do
  # The input has directions and a set of maps matching a position to its navigation network.
  # Start from 'AAA' and follow the instructions until you reach 'ZZZ'.
  
  def answer() do
    {actions, map} = parse()
    recursive(actions, "AAA", actions, map, 0, "ZZZ")
  end


  def recursive([], current, actions_backup, map, count, target) do
    recursive(actions_backup, current, actions_backup, map, count, target)
  end


  def recursive([h | tail], current, actions_backup, map, count, target) do
    right_or_left =
      if h == "L",
        do: 0,
        else: 1

    next = map[current] |> elem(right_or_left)
    reach? = compare(target, next)

    if reach?,
      do: count + 1,
      else: recursive(tail, next, actions_backup, map, count + 1, target)
  end


  def compare("ZZZ", next),
    do: "ZZZ" == next


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
