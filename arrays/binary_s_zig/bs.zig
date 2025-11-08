// h1 -- Binary Search Algorithm Implementation in Zig
// h2 -- Efficient search for sorted slices using divide and conquer
// h2 -- Includes performance timing and manual memory management

const std = @import("std");

// h3 -- Binary Search Function
// h4 -- Searches for target in sorted slice using iterative approach
// h5 -- arr: Slice of constant integers ([]const i32)
// h5 -- target: Value to search for
// h6 -- Returns: ?usize - optional usize (index if found, null if not)
// h6 -- Time Complexity: O(log n) - logarithmic time
// h6 -- Space Complexity: O(1) - constant space
// h6 -- Note: Uses Zig's optional types for safe error handling
fn binarySearch(arr: []const i32, target: i32) ?usize {
    var low: usize = 0;
    var high: usize = if (arr.len > 0) arr.len - 1 else return null;

    while (low <= high) {
        // Calculate mid index without potential overflow
        const mid = low + (high - low) / 2;

        if (arr[mid] == target) {
            return mid; // Found at index mid
        } else if (arr[mid] < target) {
            low = mid + 1; // Search right half
        } else {
            // Use checked subtraction to prevent underflow
            high = if (mid > 0) mid - 1 else break;
        }
    }
    return null; // Not found
}

// h3 -- Performance Test Function
// h4 -- Tests binary search performance with large sorted arrays
// h5 -- allocator: Memory allocator for dynamic allocation
// h5 -- size: Size of test array to generate
// h6 -- Uses Zig's precise timing and manual memory management
fn performanceTest(allocator: std.mem.Allocator, size: usize) !void {
    if (size == 0) {
        std.debug.print("Skipping performance test for size 0\n", .{});
        return;
    }

    // Allocate memory for large array
    var large_arr = try allocator.alloc(i32, size);
    // Ensure memory is freed
    defer allocator.free(large_arr);

    // Initialize with sorted sequential values
    for (0..size) |i| {
        large_arr[i] = @as(i32, @intCast(i * 2)); // Even numbers for predictable searching
    }

    // Test different target positions
    const targets = [_]i32{
        large_arr[0], // Best case: first element
        large_arr[size / 2], // Average case: middle element
        large_arr[size - 1], // Worst case: last element
        -1, // Not found case
    };
    const cases = [_][]const u8{ "best", "average", "worst", "not found" };

    std.debug.print("Performance Test (Size: {}):\n", .{size});

    // Warm up the function
    for (0..10) |_| {
        _ = binarySearch(large_arr, large_arr[size / 2]);
    }

    // Test each case with multiple iterations
    const iterations = 10000;
    for (targets, 0..) |target, t| {
        var total_ns: u64 = 0;
        var found_count: u32 = 0;

        for (0..iterations) |_| {
            const start = std.time.nanoTimestamp();
            const found_index = binarySearch(large_arr, target);
            const end = std.time.nanoTimestamp();
            total_ns += @as(u64, @intCast(end - start));

            if (found_index != null) {
                found_count += 1;
            }
        }

        const avg_ns = @as(f64, @floatFromInt(total_ns)) / @as(f64, @floatFromInt(iterations));
        const avg_seconds = avg_ns / 1_000_000_000.0;

        std.debug.print("  {s} case: {d:.6} seconds (success: {}/{})\n", .{ cases[t], avg_seconds, found_count, iterations });
    }
}

// h3 -- Validation Test Function
// h4 -- Comprehensive testing of edge cases and correctness
fn validationTests() void {
    std.debug.print("Validation Tests:\n", .{});

    // Test case 1: Normal sorted array
    const arr1 = [_]i32{ 2, 4, 6, 8, 10, 12, 14 };
    const result1 = binarySearch(&arr1, 10);
    std.debug.print("  Search for 10 in [2,4,6,8,10,12,14]: {?} (expected: 4)\n", .{result1});

    // Test case 2: First element
    const result2 = binarySearch(&arr1, 2);
    std.debug.print("  Search for 2 (first element): {?} (expected: 0)\n", .{result2});

    // Test case 3: Last element
    const result3 = binarySearch(&arr1, 14);
    std.debug.print("  Search for 14 (last element): {?} (expected: 6)\n", .{result3});

    // Test case 4: Not found
    const result4 = binarySearch(&arr1, 5);
    std.debug.print("  Search for 5 (not present): {?} (expected: null)\n", .{result4});

    // Test case 5: Single element array
    const single_arr = [_]i32{42};
    const result5 = binarySearch(&single_arr, 42);
    std.debug.print("  Search in single element [42]: {?} (expected: 0)\n", .{result5});

    // Test case 6: Single element not found
    const result6 = binarySearch(&single_arr, 99);
    std.debug.print("  Search for 99 in [42]: {?} (expected: null)\n", .{result6});

    // Test case 7: Empty array
    const empty_arr = [_]i32{};
    const result7 = binarySearch(&empty_arr, 5);
    std.debug.print("  Search in empty array: {?} (expected: null)\n", .{result7});

    // Test case 8: Boundary values
    const boundary_arr = [_]i32{ std.math.minInt(i32), -100, 0, 100, std.math.maxInt(i32) };
    const result8 = binarySearch(&boundary_arr, std.math.maxInt(i32));
    std.debug.print("  Search for max i32 in boundary array: {?} (expected: 4)\n", .{result8});
}

// h3 -- Print Array Helper Function
// h4 -- Utility to print array contents in a formatted way
fn printArray(arr: []const i32) void {
    std.debug.print("[", .{});
    for (arr, 0..) |val, i| {
        std.debug.print("{}", .{val});
        if (i < arr.len - 1) {
            std.debug.print(", ", .{});
        }
    }
    std.debug.print("]", .{});
}

pub fn main() !void {
    std.debug.print("=== BINARY SEARCH ALGORITHM - ZIG IMPLEMENTATION ===\n\n", .{});

    // h3 -- Basic Functionality Test
    // h4 -- Demonstrates basic binary search with array slice
    std.debug.print("1. BASIC FUNCTIONALITY TEST\n", .{});
    std.debug.print("===========================\n", .{});

    const arr = [_]i32{ 2, 4, 6, 8, 10, 12, 14 };
    const target: i32 = 10;

    std.debug.print("Array: ", .{});
    printArray(&arr);
    std.debug.print("\n", .{});
    std.debug.print("Target: {}\n", .{target});

    if (binarySearch(&arr, target)) |index| {
        std.debug.print("Result: Found {} at index {}\n", .{ target, index });
    } else {
        std.debug.print("Result: Not found\n", .{});
    }
}
