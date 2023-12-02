const std = @import("std");
const ArrayList = std.ArrayList;
const print = std.debug.print;

// Same as part 1, but digits may be spelled out with letters.
// Example: two1nine -> 29
// - What is the sum of all of the calibration values?

const inputFile = @embedFile("output.txt");
const split = std.mem.split;

pub fn main() !void {
    var splits = split(u8, inputFile, "\n");

    var sum: u32 = 0;
    while (splits.next()) |line| {
        var calibration_value = try getCalibrationValue(line);
        sum += calibration_value;
    }

    print("Answer: the sum is {}\n", .{sum});
}

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
