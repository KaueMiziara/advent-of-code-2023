function read_input(file_path)
    lines = readlines(file_path)
    return [lines[row][col] for row in 1:length(lines), col in 1:length(lines[1])]
end


function tilt_north(grid)
    updated_grid = copy(grid)

    for col_index in 1:size(updated_grid, 2)
        column = updated_grid[:, col_index]
        balls = findall(isequal('O'), column)

        new_balls = map(balls) do ball_position
            obstacle = findlast(isequal('#'), column[1:ball_position-1])
            if obstacle != nothing
                min_position = obstacle + 1
            else
                min_position = 1
            end
            return min_position + count(isequal('O'), column[min_position:ball_position-1])
        end

        updated_grid[balls, col_index] .= '.'
        updated_grid[new_balls, col_index] .= 'O'
    end

    return updated_grid
end


function compute_load(grid)
    score = 0

    for col in eachcol(grid)
        score += sum(size(grid, 2) .- findall(isequal('O'), col) .+ 1)
    end

    return score
end


function rotate_cw(matrix)
    hcat(reverse(eachrow(matrix))...)
end


function part2(initial_grid)
    current_grid = copy(initial_grid)
    explored_grids = Dict()

    cycle = 0

    while !(current_grid in keys(explored_grids))
        explored_grids[current_grid] = cycle
        cycle += 1

        for _ in 1:4
            current_grid = rotate_cw(tilt_north(current_grid))
        end
    end

    initial_state = explored_grids[current_grid]
    period = cycle - initial_state

    for (grid, state) in explored_grids
        if state == initial_state + mod(1e9 - initial_state, period)
            return grid
        end
    end
end


function main()
    input_grid = read_input("input.txt")
    println("Part 1 answer: ", compute_load(tilt_north(input_grid)))

    final_grid = part2(input_grid)
    println("Part 2 answer: ", compute_load(final_grid))
end

main()
