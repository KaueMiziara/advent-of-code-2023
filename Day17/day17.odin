package day17

import "core:fmt"
import "core:slice"
import "core:strings"
import pq "core:container/priority_queue"

main :: proc() {
    input := #load("./input.txt", string)
    
    answer := part_1(input)
    fmt.println("Part 1:", answer)

    answer_2 := part_2(input)
    fmt.println("Part 2:", answer_2)
}

part_1 :: proc(data: string) -> int {
    newline_idx := strings.index_byte(data, '\n')
    grid_width := newline_idx + 1
    grid_height := len(data) / grid_width
    grid := Grid{transmute([]u8) data, grid_width, grid_height}

    heat_loss, found := astar(grid, 0, len(data) - 2)

    assert(found)
    return heat_loss
}

part_2 :: proc(data: string) -> int {
    newline_idx := strings.index_byte(data, '\n')
    grid_width := newline_idx + 1
    grid_height := len(data) / grid_width
    grid := Grid{transmute([]u8) data, grid_width, grid_height}

    heat_loss, found := astar_ultra(grid, 0, len(data) - 2)

    assert(found)
    return heat_loss
}

Grid :: struct {
    data: []u8,
    width, height: int
}

Directions :: bit_set[Direction]
Direction :: enum {
    Up,
    Down,
    Left,
    Right,
}

opposite_direction := [Direction]Direction{.Up = .Down, .Down = .Up, .Left = .Right, .Right = .Left}

Pos :: [2]i32

Node :: struct {
    location: Pos,
    direction_entered: Direction,
    steps_in_dir: int,
}

QueueNode :: struct {
    node: Node,
    cost: int,
}

astar :: proc(grid: Grid, start, end: int) -> (heat_loss: int, found: bool) {
    g :: proc(square, end: [2]i32) -> int {
        return int(abs(end.x - square.x) + abs(end.y - square.y))
    }

    hl :: proc(grid: Grid, pos: Pos) -> int {
        idx := int(pos.y) * grid.width + int(pos.x)
        if grid.data[idx] == '\n' do return 1_000_000
        else do return int(grid.data[idx] - '0')
    }

    offsets := [Direction]Pos{.Up = {0, -1}, .Down = {0, 1}, .Left = {-1, 0}, .Right = {1, 0}}

    start_pos := [2]i32{i32(start % grid.width), i32(start / grid.width)}
    end_pos := [2]i32{i32(end % grid.width), i32(end / grid.width)}
    grid_len := len(grid.data)

    start_node := Node{start_pos, .Right, 1}

    heat_loss_cache := make(map[Node]int, 1 << 20)
    heat_loss_cache[start_node] = 0

    Context :: struct {
        goal: Pos,
        hl_cache: ^map[Node]int,
    }
    
    ctx := Context{end_pos, &heat_loss_cache}
    context.user_ptr = &ctx

    queue: pq.Priority_Queue(Node)
    pq.init(&queue, (proc(a, b: Node) -> bool {
        ctx := cast(^Context) context.user_ptr

        ga := g(a.location, ctx.goal)
        gb := g(b.location, ctx.goal)

        cost_a := ctx.hl_cache[a] + ga
        cost_b := ctx.hl_cache[b] + gb

        return cost_a < cost_b
    }), pq.default_swap_proc(Node))

    pq.push(&queue, start_node)

    for pq.len(queue) != 0 {
        next := pq.pop(&queue)

        if next.location == end_pos {
            return heat_loss_cache[next], true
        }

        current_heat_loss, exists := heat_loss_cache[next]
        assert(exists)

        opp_dir := opposite_direction[next.direction_entered]

        for direction in Direction {
            if direction == opp_dir do continue
            if direction == next.direction_entered && next.steps_in_dir == 3 do continue

            next_steps := next.steps_in_dir + 1 if direction == next.direction_entered else 1

            neighbor := Node{next.location + offsets[direction], direction, next_steps}
            neighbor_idx := int(neighbor.location.y) * grid.width + int(neighbor.location.x)

            if neighbor_idx < 0 || neighbor_idx >= grid_len do continue

            next_heat := current_heat_loss + hl(grid, neighbor.location)

            if neighbor_heat, ok := heat_loss_cache[neighbor]; ok {
                if next_heat < neighbor_heat {
                    heat_loss_cache[neighbor] = next_heat

                    if !slice.contains(queue.queue[:], neighbor) {
                        pq.push(&queue, neighbor)
                    }
                }
            } else {
                heat_loss_cache[neighbor] = next_heat
                pq.push(&queue, neighbor)
            }
        }
    }

    return {}, false
}

astar_ultra :: proc(grid: Grid, start, end: int) -> (heat_loss: int, found: bool) {
    g :: proc(square, end: [2]i32) -> int {
        return int(abs(end.x - square.x) + abs(end.y - square.y))
    }

    hl :: proc(grid: Grid, pos: Pos) -> int {
        idx := int(pos.y) * grid.width + int(pos.x)
        if grid.data[idx] == '\n' do return 1_000_000
        else do return int(grid.data[idx] - '0')
    }

    offsets := [Direction]Pos{.Up = {0, -1}, .Down = {0, 1}, .Left = {-1, 0}, .Right = {1, 0}}

    start_pos := [2]i32{i32(start % grid.width), i32(start / grid.width)}
    end_pos := [2]i32{i32(end % grid.width), i32(end / grid.width)}
    grid_len := len(grid.data)

    start_node := Node{start_pos, .Right, 0}
    start_node_2 := Node{start_pos, .Down, 0}

    heat_loss_cache := make(map[Node]int, 1 << 20)
    heat_loss_cache[start_node] = 0
    heat_loss_cache[start_node_2] = 0

    right_hl, down_hl: int
    for i in i32(1)..=4 {
        right_hl += hl(grid, start_pos + {i, 0})
        down_hl += hl(grid, start_pos + {0, i})
    }

    start_node = Node{start_pos + {4, 0}, .Right, 4}
    start_node_2 = Node{start_pos + {0, 4}, .Down, 4}
    
    heat_loss_cache[start_node] = right_hl
    heat_loss_cache[start_node_2] = down_hl


    queue: pq.Priority_Queue(QueueNode)
    pq.init(&queue, (proc(a, b: QueueNode) -> bool {
        return a.cost < b.cost
    }), pq.default_swap_proc(QueueNode))

    pq.push(&queue, QueueNode{start_node, g(start_node.location, end_pos) + right_hl})
    pq.push(&queue, QueueNode{start_node_2, g(start_node_2.location, end_pos) + down_hl})

    for pq.len(queue) != 0 {
        next_node := pq.pop(&queue)
        next := next_node.node

        if next.location == end_pos {
            return heat_loss_cache[next], true
        }

        current_heat_loss, exists := heat_loss_cache[next]
        assert(exists)

        opp_dir := opposite_direction[next.direction_entered]

        for direction in Direction {
            if direction == opp_dir do continue

            next_heat: int
            neighbor: Node
            if direction == next.direction_entered {
                if next.steps_in_dir == 10 do continue

                next_steps := next.steps_in_dir + 1
                
                neighbor = Node{next.location + offsets[direction], direction, next_steps}
                neighbor_idx := int(neighbor.location.y) * grid.width + int(neighbor.location.x)
                
                if neighbor_idx < 0 || neighbor_idx >= grid_len do continue

                next_heat = current_heat_loss + hl(grid, neighbor.location)
            } else {
                next_steps := 4

                neighbor = Node{next.location + (offsets[direction] * 4), direction, next_steps}
                neighbor_idx := int(neighbor.location.y) * grid.width + int(neighbor.location.x)
                
                if neighbor_idx < 0 || neighbor_idx >= grid_len do continue

                added_hl: int
                
                for i in i32(1)..=4 {
                    added_hl += hl(grid, next.location + (offsets[direction] * i))
                }
                
                next_heat = current_heat_loss + added_hl
            }
            
            cost := next_heat + g(neighbor.location, end_pos)

            if neighbor_heat, ok := heat_loss_cache[neighbor]; ok {
                if next_heat < neighbor_heat {
                    heat_loss_cache[neighbor] = next_heat
                    
                    found: bool
                    idx: int

                    for qn in queue.queue[:] {
                        if qn.node == neighbor {
                            found = true
                            break
                        }
                    }
                    if !found {
                        pq.push(&queue, QueueNode{neighbor, cost})
                    } else {
                        queue.queue[idx].cost = cost
                        pq.fix(&queue, idx)
                    }
                }
            } else {
                heat_loss_cache[neighbor] = next_heat
                pq.push(&queue, QueueNode{neighbor, cost})
            }
        }
    }

    return {}, false
}
