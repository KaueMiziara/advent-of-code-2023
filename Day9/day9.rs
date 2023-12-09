use std::{fs::File, io::Read};

// Extrapolate the next value by finding the difference in the sequence's values.
// Part 2: extrapolate backwards.

fn main() {
    let lines = read_input("input.txt");
    let days: Vec<_> = lines
        .iter()
        .map(|l| l.split(" ").map(|x| x.parse::<i32>().unwrap()).collect())
        .collect();

    let mut answer_part1: i32 = 0;
    let mut answer_part2: i32 = 0;

    days.iter().for_each(|day| {
        answer_part1 += extrapolate(&day);
        answer_part2 += extrapolate_backwards(&day);
    });

    println!("Answers:");
    println!("Part1: {}", answer_part1);
    println!("Part2: {}", answer_part2);
}

fn extrapolate(x: &Vec<i32>) -> i32 {
    if is_all_zeroes(x) {
        return 0;
    }

    let value_to_append = extrapolate(&get_differences(x));

    x.last().unwrap() + value_to_append
}

fn extrapolate_backwards(x: &Vec<i32>) -> i32 {
    if is_all_zeroes(x) {
        return 0;
    }

    let value_to_prepend = extrapolate_backwards(&get_differences(x));

    x.first().unwrap() - value_to_prepend
}

fn get_differences(values: &Vec<i32>) -> Vec<i32> {
    values
        .windows(2)
        .map(|values| values[1] - values[0])
        .collect()
}

fn is_all_zeroes(values: &Vec<i32>) -> bool {
    values.iter().all(|value| *value == 0)
}

fn read_input(filename: &str) -> Vec<String> {
    let mut file = File::open(filename).unwrap();

    let mut file_contents = String::new();

    file.read_to_string(&mut file_contents).unwrap();

    let mut lines: Vec<String> = file_contents
        .split("\n")
        .map(|s: &str| s.to_string())
        .collect();

    lines.remove(lines.len() - 1);
    lines
}
