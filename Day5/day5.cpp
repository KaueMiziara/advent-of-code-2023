#include <cstdint>
#include <iostream>
#include <fstream>
#include <limits>
#include <string>
#include <vector>
#include <limits.h>

struct RangeMap
{
  uint64_t source_start;
  uint64_t dest_start;
  uint64_t range;
};

struct Range
{
  uint64_t start;
  uint64_t range;
};

uint64_t part1Answer();
uint64_t part2Answer();

std::vector<uint64_t> seeds;
std::vector<RangeMap> ranges[7];
Range rangeOut;
Range rangeIn1;
Range rangeIn2;


int main()
{
  std::ifstream file("input.txt");
  std::string line;

  int number;
  char *number_size;
  getline(file, line);
  line = line.substr(7);

  while (line.length() > 0)
  {
    seeds.push_back(strtoll(line.c_str(), &number_size, 10));
    line = line.substr(number_size - line.c_str());
  }

  getline(file, line);
  getline(file, line);

  int i = 0; 
  while (getline(file, line))
  {
    if (line == "")
    {
      getline(file, line);
      ++i;
      continue;
    }
    
    RangeMap range;
      
    range.dest_start = strtoll(line.c_str(), &number_size, 10);
    line = line.substr(number_size - line.c_str());  

    range.source_start = strtoll(line.c_str(), &number_size, 10);
    line = line.substr(number_size - line.c_str());  

    range.range = strtoll(line.c_str(), &number_size, 10);
    line = line.substr(number_size - line.c_str());  

    ranges[i].push_back(range);
  }
  file.close();

  std::cout << "Answer 1: " << part1Answer() << std::endl;
  std::cout << "Answer 2: " << part2Answer() << std::endl;
  return 0;
}

bool isInRange(uint64_t source, RangeMap range)
{
  return range.source_start <= source && range.source_start + range.range > source;
}

uint64_t findDestInRange(uint64_t source, int range)
{
  for (int i = 0; i < ranges[range].size(); ++i)
  {
    if (isInRange(source, ranges[range][i]))
      return ranges[range][i].dest_start + (source - ranges[range][i].source_start); 
  }
  return source;
}

uint64_t convertSeedToLocation(uint64_t seed)
{
  for (int i = 0; i < 7; ++i)
    seed = findDestInRange(seed, i);
  return seed;
}

uint64_t part1Answer()
{
  uint64_t lowest = INT_MAX;
  for (int i = 0; i < seeds.size(); ++i)
  {
    uint64_t location = convertSeedToLocation(seeds[i]);
    lowest = location < lowest ? location : lowest;
  }
  return lowest;
}

bool canGenerateRange(Range range, RangeMap map)
{
  return isInRange(range.start, map) || 
    isInRange(range.start + range.range, map) || 
    (range.start < map.source_start && range.start + range.range >= map.source_start + map.range);
}


std::vector<Range> getPossibleRanges(Range range, int rangeMap)
{
  std::vector<Range> in = { range };
  std::vector<Range> out;
  
  for (int i = 0; i < ranges[rangeMap].size(); ++i)
  {
    RangeMap map = ranges[rangeMap][i];
    std::vector<Range> temp;

    for (int j = 0; j < in.size(); ++j)
    {
      Range range = in[j];

      if (canGenerateRange(range, map))
      {
        if (range.start < map.source_start && range.start + range.range < map.source_start + map.range)
        {
          rangeOut.start = map.dest_start;
          rangeOut.range = (range.start + range.range) - map.source_start;
          rangeIn1.start = range.start;
          rangeIn1.range = map.source_start - range.start;
          
          if (rangeIn1.range != 0)
            temp.push_back(rangeIn1);
        }
        else if (range.start + range.range > map.source_start + map.range && range.start >= map.source_start)
        {
          rangeOut.start = map.dest_start + (range.start -  map.source_start);
          rangeOut.range = (map.source_start + map.range) - range.start;
          rangeIn1.start = map.source_start + map.range;
          rangeIn1.range = (range.start + range.range) - (map.source_start + map.range);
          
          if (rangeIn1.range != 0)
            temp.push_back(rangeIn1);
        }
        else if (range.start <= map.source_start && range.start + range.range >= map.source_start + map.range)
        {
          rangeOut.start = map.dest_start;
          rangeOut.range = map.range;
          rangeIn1.start = range.start;
          rangeIn1.range = map.source_start - range.start;
          rangeIn2.start = map.source_start + map.range;
          rangeIn2.range = (range.start + range.range) - (map.source_start + map.range); 
          
          if (rangeIn1.range != 0)
            temp.push_back(rangeIn1);
          
          if (rangeIn2.range != 0)
            temp.push_back(rangeIn2);
        }
        else
        {
          rangeOut.start = map.dest_start + (range.start -  map.source_start);
          rangeOut.range = range.range;
        }
  
        out.push_back(rangeOut);
      }
      else
      {
        rangeIn1.start = range.start;
        rangeIn1.range = range.range;
        temp.push_back(rangeIn1);
      }
    }

    in = temp;
  }

  if (in.size() > 0)
    out.insert(out.end(), in.begin(), in.end());
  return out;
}

uint64_t part2Answer()
{
  uint64_t lowest = std::numeric_limits<uint64_t>::max();
  std::vector<Range> ranges;
  std::vector<Range> swap;

  for (int i = 0; i < seeds.size(); i += 2)
  {
    Range range;
    range.start = seeds[i];
    range.range = seeds[i + 1];
    ranges.push_back(range); 
  }
  
  for (int i = 0; i < 7; ++i)
  {
    swap.clear();  
    for (int j = 0; j < ranges.size(); ++j)
    {
      std::vector<Range> result = getPossibleRanges(ranges[j], i);
      swap.insert(swap.end(), result.begin(), result.end());
    }
    ranges = swap;
  }
  
  for (int i = 0; i < ranges.size(); ++i)
  {
    if (ranges[i].start  < lowest)
      lowest = ranges[i].start;
  }

  return lowest;
}
