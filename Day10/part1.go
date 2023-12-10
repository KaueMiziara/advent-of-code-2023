package main

import (
	"bufio"
	"fmt"
	"os"
)

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

	var answer = maxDist
	fmt.Println("Answer: ", answer)
}

func findStart(grid []string) Point {
	for y, row := range grid {
		for x, col := range row {
			if byte(col) == 'S' {
				return Point{x, y}
			}
		}
	}
	return Point{}
}

func nextPoints(grid []string, p Point) []Point {
	points := []Point{}

	switch grid[p.y][p.x] {
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
		down, right, up, left := grid[p.y+1][p.x], grid[p.y][p.x+1], grid[p.y-1][p.x], grid[p.y][p.x-1]

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
