const std = @import("std");

fn binarySearch(arr: []const i32, target: i32) ?usize {
    var low: usize = 0;
    var high: usize = arr.len;

    while (low < high) {
        const mid = low + (high - low) / 2;

        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return null;
}

pub fn main() !void {
    const arr = [_]i32{ 2, 4, 6, 8, 10, 12, 14 };
    const target = 10;

    if (binarySearch(&arr, target)) |index| {
        std.debug.print("Found {d} at index {d}\n", .{ target, index });
    } else {
        std.debug.print("Not found\n", .{});
    }
}
