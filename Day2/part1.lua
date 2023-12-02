-- The elf has a number of RGB cubes in his bag
-- Each game has a number of subsets, where he will show a random number of cubes and put them back
-- Example input:
--[[
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
--]]
-- Which games would have been possible if the bag contained 12R, 13G, 14B?
-- Answer: sum of the possible games IDs

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


--[[local function printTable(table)
  for k, v in pairs(table) do
    print(k.." -> "..v)
  end
end
]]--


local function isPossible(colors)
  local maxValues = { red = 12, green = 13, blue = 14 }

  for color, count in pairs(colors) do
    if count > maxValues[color] then return false end
  end

  return true
end


local function main()
  local file = io.open("input.txt", "r")

  local games = createGamesTable(file)

  io.close(file)

  local answer = 0
  for index, game in pairs(games) do
    games[index] = { subsets = splitSubsets(game) }

    local gameIsPossible = true
    for item, subset in pairs(games[index].subsets) do
      games[index].subsets[item] = { colors = countColors(subset) }

      if not isPossible(countColors(subset)) then gameIsPossible = false end
    end

    if gameIsPossible then answer = answer + tonumber(index) end
  end

  print("The answer is "..answer)
end


main()
