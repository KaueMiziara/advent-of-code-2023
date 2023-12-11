package main

import (
	"bufio"
	"fmt"
	"os"
)

// Input: pipes maze, with symbols representing connections.
// The maze is a loop.
// Part1: given a starting point, find the farthest point in the loop. Answer: number of steps to reach it.
// Part2: find how many tiles are enclosed by the loop.

type Point struct {
	x int
	y int
}

func main() {
	grid, _ := readInput("input.txt")

	startingPoint := findStart(grid)
	visited := map[Point]int{startingPoint: 0}
	notChecked := []Point{startingPoint}

	maxDist := 0
	for len(notChecked) > 0 {
		current := notChecked[0]
		notChecked = notChecked[1:]

		next := nextPoints(grid, current)
		for _, point := range next {
			if _, found := visited[point]; !found {
				visited[point] = visited[current] + 1
				maxDist = max(maxDist, visited[current]+1)
				notChecked = append(notChecked, point)
			}
		}
	}

	fmt.Println("Part1 answer: ", maxDist)

	countInside := 0
	for y, row := range grid {
		for x := range row {
			if isInside(grid, Point{x, y}, visited) {
				countInside++
			}
		}
	}

	fmt.Println("Part2 answer: ", countInside)
}

func isInside(maze []string, p Point, visitedPoints map[Point]int) bool {
	if _, part := visitedPoints[p]; part {
		return false
	}

	count := 0
	cornerCounts := map[byte]int{}

	for y := p.y + 1; y < len(maze); y++ {
		check := Point{p.x, y}

		tile := maze[y][p.x]

		if tile == 'S' {
			tile = findStartTile(Point{p.x, y}, maze)
		}

		if _, part := visitedPoints[check]; part {
			if tile == '-' {
				count++
			} else if tile != '|' && tile != '.' {
				cornerCounts[tile]++
			}
		}
	}

	countL, count7 := cornerCounts['L'], cornerCounts['7']
	countF, countJ := cornerCounts['F'], cornerCounts['J']

	count += max(countL, count7) - abs(countL-count7)
	count += max(countF, countJ) - abs(countF-countJ)

	return count%2 == 1
}

func findStart(maze []string) Point {
	for y, row := range maze {
		for x, col := range row {
			if byte(col) == 'S' {
				return Point{x, y}
			}
		}
	}
	return Point{}
}

func findStartTile(start Point, grid []string) byte {
	points := nextPoints(grid, start)
	minX := min(points[0].x, points[1].x)
	maxX := max(points[0].x, points[1].x)
	minY := min(points[0].y, points[1].y)
	maxY := max(points[0].y, points[1].y)

	if points[0].x == points[1].x {
		return '|'
	}

	if points[0].y == points[1].y {
		return '-'
	}

	if minX < start.x && minY < start.y {
		return 'J'
	}

	if maxX > start.x && maxY > start.y {
		return 'F'
	}

	if maxX > start.x && minY < start.y {
		return 'L'
	}

	if minX < start.x && maxY > start.y {
		return '7'
	}

	return '.'
}

func nextPoints(maze []string, p Point) []Point {
	points := []Point{}

	switch maze[p.y][p.x] {
	case '|':
		points = append(points, Point{p.x, p.y + 1})
		points = append(points, Point{p.x, p.y - 1})

	case '-':
		points = append(points, Point{p.x + 1, p.y})
		points = append(points, Point{p.x - 1, p.y})

	case 'L':
		points = append(points, Point{p.x, p.y - 1})
		points = append(points, Point{p.x + 1, p.y})

	case 'J':
		points = append(points, Point{p.x, p.y - 1})
		points = append(points, Point{p.x - 1, p.y})

	case '7':
		points = append(points, Point{p.x, p.y + 1})
		points = append(points, Point{p.x - 1, p.y})

	case 'F':
		points = append(points, Point{p.x, p.y + 1})
		points = append(points, Point{p.x + 1, p.y})

	case '.':
	case 'S':
		down := maze[p.y+1][p.x]
		right := maze[p.y][p.x+1]
		up := maze[p.y-1][p.x]
		left := maze[p.y][p.x-1]

		if down == '|' || down == 'L' || down == 'J' {
			points = append(points, Point{p.x, p.y + 1})
		}

		if right == '-' || right == '7' || right == 'J' {
			points = append(points, Point{p.x + 1, p.y})
		}

		if up == '|' || up == '7' || up == 'F' {
			points = append(points, Point{p.x, p.y - 1})
		}

		if left == '-' || left == 'L' || left == 'F' {
			points = append(points, Point{p.x - 1, p.y})
		}
	}
	return points
}

func abs(n int) int {
	if n < 0 {
		return n * (-1)
	}
	return n
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
