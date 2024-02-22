-- The elf has a number of RGB cubes in his bag
-- Each game has a number of subsets, where he will show a random number of cubes and put them back
-- Example input:
--[[
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
--]]
-- The minimum set of cubes is the fewest number of each color that could make the game possible
-- For Game 1, it is 4 red, 2 green and 6 blue
-- The power of a set is equal to all the colors amount multiplied
-- Answer: What is the sum of the power of the minimum sets?

local function createGamesTable(file)
  io.input(file)

  local gamesTable = {}

  for line in file:lines() do
    local index, contents = line:match("Game (%d+): (.+)")
    gamesTable[index] = contents
  end

  return gamesTable
end


local function splitSubsets(game)
  local subsets = {}

  for subset in game:gmatch("[^;]+") do
    table.insert(subsets, subset)
  end

  return subsets
end


local function countColors(subset)
  local colorCounts = { red = 0, green = 0, blue = 0 }

  if subset then
    for count, color in string.gmatch(subset, "(%d+) (%a+)") do
      colorCounts[color] = tonumber(count)
    end
  end

  return colorCounts
end


--[[
local function printTable(table)
  for k, v in pairs(table) do
    print(k.." -> "..v)
  end
end
--]]


local function findMinimumSet(game)
  local minimumSet = { red = 0, green = 0, blue = 0 }

  for _, subset in pairs(game.subsets) do
    for color, count in pairs(subset.colors) do
      minimumSet[color] = math.max(minimumSet[color], count)
    end
  end

  return minimumSet
end


local function calculateSetPower(game)
  local minimumSet = findMinimumSet(game)
  local power = 1

  for _, count in pairs(minimumSet) do
    power = power * count
  end

  return power
end


local function main()
  local file = io.open("input.txt", "r")

  local games = createGamesTable(file)

  io.close(file)

  local answer = 0
  for index, game in pairs(games) do
    games[index] = { subsets = splitSubsets(game) }

    for item, subset in pairs(games[index].subsets) do
      games[index].subsets[item] = { colors = countColors(subset) }
    end

    answer = answer + calculateSetPower(games[index])
  end

  print("The answer is "..answer)
  -- printTable(games["2"].subsets[1].colors)
end


main()
