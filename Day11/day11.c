#include <stdio.h>
#include <stdbool.h>
#include <inttypes.h>
#include <stdlib.h>

// Expand the galaxy on empty lines by 1 and calculate the manhattan distance of all pair of points.
// Answer -> sum of all distances.
// Part 2 -> expand by 1_000_000 instead.

#define MAX_MAPS_SIZE 200

typedef struct {
    int64_t x, y;
} Point;

int64_t manhattanDistance(char map[MAX_MAPS_SIZE][MAX_MAPS_SIZE], int size, int64_t expansion);

int main(void)
{
    char map[MAX_MAPS_SIZE][MAX_MAPS_SIZE];
    FILE* fp = fopen("input.txt", "r");
    int size = -1;

    while (fgets(&map[++size], 512, fp) != NULL);
    fclose(fp);

    uint32_t answer1 = manhattanDistance(map, size, 1);
    printf("Part 1: %u\n", answer1);

    uint64_t answer2 = manhattanDistance(map, size, 1000000 - 1);
    printf("Total dist = %" PRId64 "\n", answer2);

    return 0;
}

int64_t manhattanDistance(char map[MAX_MAPS_SIZE][MAX_MAPS_SIZE], int size, int64_t expansion) {
    bool occupiedX[MAX_MAPS_SIZE] = {0};
    bool occupiedY[MAX_MAPS_SIZE] = {0};
    
    for (int y = 0; y < size; ++y) 
    {
        for (int x = 0; x < size; ++x) 
        {
            bool isOccupied = map[y][x] != '.';
            
            occupiedX[x] |= isOccupied;
            occupiedY[y] |= isOccupied;
        }
    }
    
    int64_t remappedX[MAX_MAPS_SIZE] = {0};
    int64_t remappedY[MAX_MAPS_SIZE] = {0};
    int64_t offset = 0;

    for(int x = 0; x < size; ++x) 
    {
        if (!occupiedX[x]) offset += expansion;
        remappedX[x] = x + offset;
    }
    
    offset = 0;
    for(int y = 0; y < size; ++y)
    {
        if (!occupiedY[y]) offset += expansion;
        remappedY[y] = y + offset;
    }

    int numGalaxies = 0;
    uint64_t totalDist = 0;
    
    Point positions[2000] = {0};
    for (int y = 0; y < size; ++y) 
    {
        for (int x = 0; x < size; ++x)
        {
            if (map[y][x] == '#') 
            {
                Point newPos = {x, y};
                for(int idx = 0; idx < numGalaxies; ++idx) 
                {
                    int dist = abs(remappedX[newPos.x] - remappedX[positions[idx].x]) +
                               abs(remappedY[newPos.y] - remappedY[positions[idx].y]);
                    totalDist += dist;
                }
                positions[numGalaxies++] = newPos;
            }
        }
    }
    return totalDist;
}
