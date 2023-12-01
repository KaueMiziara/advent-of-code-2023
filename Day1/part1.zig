const std = @import("std");
const ArrayList = std.ArrayList;
const print = std.debug.print;

// For each line of the input file, the calibration value is the combination of the
// first and last digit; if the line has only one digit, double it.
// Examples:
// // 1abc2 -> 12
// // treb7uchet -> 77
// - What is the sum of all of the calibration values?

const inputFile = @embedFile("input.txt");
const split = std.mem.split;

fn getCalibrationValue(line: []const u8) !u8 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var numbers = ArrayList(u8).init(allocator);
    defer numbers.deinit();

    for (line) |char| {
        if (std.ascii.isDigit(char)) {
            try numbers.append(char - '0');
        }
    }

    var calibration_value: u8 = 0;
    switch (numbers.items.len) {
        0 => {},
        1 => {
            const value = numbers.items[0];
            calibration_value = value * 10 + value;
        },
        else => {
            const first = numbers.items[0];
            const last = numbers.getLast();
            calibration_value = first * 10 + last;
        },
    }

    return calibration_value;
}

pub fn main() !void {
    var splits = split(u8, inputFile, "\n");

    var sum: u32 = 0;
    while (splits.next()) |line| {
        var calibration_value = try getCalibrationValue(line);
        sum += calibration_value;
    }

    print("Answer: the sum is {}\n", .{sum});
}

test "getCalibrationValue returns expected Calibration Values" {
    const input = [_][]const u8{
        "1abc2",
        "pqr3stu8vwx",
        "a1b2c3d4e5f",
        "treb7uchet",
    };

    const expected_output = [_]u8{ 12, 38, 15, 77 };

    var output: [4]u8 = undefined;
    for (&input, 0..) |line, i| {
        print("{s}", .{line});
        output[i] = try getCalibrationValue(line);
    }
    try std.testing.expectEqual(expected_output, output);
}
