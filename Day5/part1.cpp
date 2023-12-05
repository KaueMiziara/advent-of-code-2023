#include <cctype>
#include <cstdint>
#include <cstdio>
#include <iostream>
#include <fstream>
#include <limits>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

/*
 * Each line has 3 values: destination range, source range start and range length.
 * "dest range" and "source range start" are arrays of "renge length" size.
 * dest range is the converted value for a given source.
 * source range start is the initial source value to be mapped with dest range.
 * source numbers that aren't mapped correspond to the same destination number.
 * Example:
 * * 50 98 2
 * * means that
 * * src -> dest
 * * 98 -> 50
 * * 99 -> 51
 * * else -> same
 */

class ConversionMap
{
  public:
    uint32_t dest = 0;
    uint32_t src = 0;
    uint32_t len = 0;

    ConversionMap(uint32_t dest, uint32_t src, uint32_t len) : dest(dest), src(src), len(len) {}
};

struct Map
{
  std::vector<ConversionMap> entries;
};


using Lines = std::vector<std::string>;

std::pair<std::vector<uint32_t>, std::vector<Map>> makeMaps();


int main(void)
{
  auto [seeds, maps] = makeMaps();
  uint32_t minLocation = std::numeric_limits<uint32_t>::max();

  for (uint32_t location : seeds)
  {
    for (const Map& map : maps)
    {
      for (const ConversionMap& entry : map.entries)
      {
        if (entry.src <= location && location < entry.src + entry.len)
        {
          location = entry.dest + (location - entry.src);
          break;
        }
      }
    }

    minLocation = std::min(minLocation, location);
  }

  std::cout << minLocation << '\n';
}


Lines readInput()
{
  Lines lines = Lines();

  std::ifstream inputFile("sample.txt");
  std::string line;
  
  while (std::getline(inputFile, line))
  {
    lines.emplace_back(line);
  }
  
  inputFile.close();
  return lines;
}

std::vector<uint32_t> splitBySpace(std::string input)
{
  std::string token;
  std::stringstream ss(input);

  std::vector<uint32_t> result;

  while (std::getline(ss, token, ' '))
  {
    try
    {
      size_t pos;
      uint32_t num = std::stoul(token, &pos);
      if (pos == token.size() && num)
      {
        result.emplace_back(num);
      }
    }
    catch (...) {}
  }

  return result;
}

std::pair<std::vector<uint32_t>, std::vector<Map>> makeMaps()
{
  Lines input = readInput();

  std::vector<uint32_t> seeds = splitBySpace(input[0]);

  std::vector<Map> maps;
  maps.resize(7);
  int iMap = 0;
 
  for (int i = 2; i < input.size(); ++i) 
  {
    const std::string& line = input[i];

    if (line.empty())
    {
      ++iMap;
      continue;
    }

    if (!std::isdigit(line[0])) continue;

    std::vector<uint32_t> tokens = splitBySpace(line);
    maps[iMap].entries.emplace_back(tokens[0], tokens[1], tokens[2]);
  }

  return std::make_pair(seeds, maps);
}
