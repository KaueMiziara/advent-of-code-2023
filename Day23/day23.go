package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	trailMap, _ := readInput("input.txt")
	start, end := Coordinate{1, 0}, Coordinate{len(trailMap[0]) - 2, len(trailMap) - 1}

	visited := map[Coordinate]int{start: 0}
	currentDirection := Coordinate{0, 1}

	traverseTrail(trailMap, start, currentDirection, visited)

	var part1Result = visited[end]
	fmt.Println("Part 1 answer: ", part1Result)

	junctions := findJunctions(trailMap)
	junctions[start] = true
	junctions[end] = true

	paths := calculatePaths(trailMap, junctions)

	var part2Result = findLongestHike(trailMap, paths, start, end, 0, map[Coordinate]bool{start: true})
	fmt.Println("Part 2 answer: ", part2Result)
}

func findJunctions(trailMap []string) map[Coordinate]bool {
	junctions := map[Coordinate]bool{}
	for row, line := range trailMap {
		for col, char := range line {
			if char == '#' {
				continue
			}

			point := Coordinate{col, row}

			neighbours := 0

			for _, dir := range [4]Coordinate{{1, 0}, {-1, 0}, {0, 1}, {0, -1}} {
				next := Coordinate{point.x + dir.x, point.y + dir.y}
				if isInsideGrid(trailMap, next) && trailMap[next.y][next.x] != '#' {
					neighbours++
				}
			}

			if neighbours > 2 {
				junctions[point] = true
			}
		}
	}
	return junctions
}

type PathTo struct {
	end    Coordinate
	length int
}

func calculatePaths(trailMap []string, junctions map[Coordinate]bool) map[Coordinate][]PathTo {
	paths := map[Coordinate][]PathTo{}
	for junctionPoint := range junctions {
		for _, startDir := range [4]Coordinate{{1, 0}, {-1, 0}, {0, 1}, {0, -1}} {
			currentPoint := Coordinate{junctionPoint.x + startDir.x, junctionPoint.y + startDir.y}

			if isInsideGrid(trailMap, currentPoint) && trailMap[currentPoint.y][currentPoint.x] != '#' {
				path := calculatePath(trailMap, junctionPoint, currentPoint, startDir, 1, junctions)
				paths[junctionPoint] = append(paths[junctionPoint], path)
			}
		}
	}
	return paths
}

func calculatePath(
	trailMap []string, pathStart, currentPoint, currentDir Coordinate,
	pathLength int, junctions map[Coordinate]bool,
) PathTo {
	for _, dir := range [3]Coordinate{currentDir, dirLeft(currentDir), dirRight(currentDir)} {
		next := Coordinate{currentPoint.x + dir.x, currentPoint.y + dir.y}

		if trailMap[next.y][next.x] != '#' {
			if _, found := junctions[next]; found {
				return PathTo{next, pathLength + 1}
			} else {
				return calculatePath(trailMap, pathStart, next, dir, pathLength+1, junctions)
			}
		}
	}
	return PathTo{Coordinate{-1, -1}, 0}
}

func findLongestHike(
	trailMap []string, paths map[Coordinate][]PathTo, start, end Coordinate,
	step int, visited map[Coordinate]bool,
) int {
	maxStep := 0
	for _, path := range paths[start] {
		if val, found := visited[path.end]; !found || !val {
			if path.end == end {
				return step + path.length
			}

			visited[path.end] = true

			maxStep = max(maxStep, findLongestHike(trailMap, paths, path.end, end, step+path.length, visited))

			visited[path.end] = false
		}
	}
	return maxStep
}

func traverseTrail(trailMap []string, start, currentDir Coordinate, visited map[Coordinate]int) {
	current := start
	currentStep := visited[current]

	for _, dir := range [3]Coordinate{currentDir, dirLeft(currentDir), dirRight(currentDir)} {
		next := Coordinate{current.x + dir.x, current.y + dir.y}
		if isInsideGrid(trailMap, next) && trailMap[next.y][next.x] != '#' {
			char := trailMap[next.y][next.x]

			oppositeChar := map[Coordinate]byte{{1, 0}: '<', {-1, 0}: '>', {0, 1}: '^', {0, -1}: 'v'}

			if oppositeChar[dir] == char {
				continue
			}

			if val, found := visited[next]; !found || val < currentStep+1 {
				visited[next] = currentStep + 1

				traverseTrail(trailMap, next, dir, visited)
			}
		}
	}
}

type Coordinate struct {
	x, y int
}

func dirLeft(p Coordinate) Coordinate {
	return Coordinate{p.y, -p.x}
}

func dirRight(p Coordinate) Coordinate {
	return Coordinate{-p.y, p.x}
}

func isInsideGrid(trailMap []string, pos Coordinate) bool {
	return pos.x >= 0 && pos.x < len(trailMap[0]) && pos.y >= 0 && pos.y < len(trailMap)
}

func readInput(fileName string) ([]string, error) {
	file, err := os.Open(fileName)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	return lines, scanner.Err()
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
