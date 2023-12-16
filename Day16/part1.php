<?php

function follow_light_path(
    array $input,
    array &$energized_map,
    array &$movement_map = [],
    int $current_x = 0,
    int $current_y = 0,
    string $direction = 'R'
): void {
    if (!isset($input[$current_y][$current_x])) return;

    $energized_map[$current_y][$current_x] = 1;
    if (isset($movement_map[$current_y][$current_x]) &&
        in_array($direction, $movement_map[$current_y][$current_x])
    ) {
        return;
    }

    $movement_map[$current_y][$current_x][] = $direction;
    if ($input[$current_y][$current_x] === '|' && in_array($direction, ['L', 'R'])) {
        follow_light_path($input, $energized_map, $movement_map, $current_x, $current_y - 1, 'U');
        follow_light_path($input, $energized_map, $movement_map, $current_x, $current_y + 1, 'D');
        return;
    }

    if ($input[$current_y][$current_x] === '-' && in_array($direction, ['U', 'D'])) {
        follow_light_path($input, $energized_map, $movement_map, $current_x + 1, $current_y, 'R');
        follow_light_path($input, $energized_map, $movement_map, $current_x - 1, $current_y, 'L');
        return;
    }

    if ($input[$current_y][$current_x] == '\\') {
        if ($direction === 'R') $direction = 'D';
        elseif ($direction === 'L') $direction = 'U';
        elseif ($direction === 'U') $direction = 'L';
        elseif ($direction === 'D') $direction = 'R';
    }

    if ($input[$current_y][$current_x] == '/') {
        if ($direction === 'R') $direction = 'U';
        elseif ($direction === 'L') $direction = 'D';
        elseif ($direction === 'U') $direction = 'R';
        elseif ($direction === 'D') $direction = 'L';
    }

    if ($direction === 'R') $current_x++;
    if ($direction === 'L') $current_x--;
    if ($direction === 'U') $current_y--;
    if ($direction === 'D') $current_y++;

    follow_light_path($input, $energized_map, $movement_map, $current_x, $current_y, $direction);
}

function main(): void {
    $input = file_get_contents('input.txt');
    $input = explode(PHP_EOL, trim($input));

    foreach ($input as $key => $row)
        $input[$key] = str_split($row);

    $energized_map = $input;
    follow_light_path($input, $energized_map);

    $energized_count = 0;
    foreach ($energized_map as $row)
        $energized_count += array_count_values($row)[1] ?? 0;

    echo "Answer: " . $energized_count . PHP_EOL;
}

main();
