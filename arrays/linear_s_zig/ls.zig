// h1 -- Linear Search Algorithm Implementation in Zig
// h2 -- Zig implementation using slices and compile-time known types
// h2 -- Includes performance timing and manual memory management

const std = @import("std");

// h3 -- Linear Search Function
// h4 -- Searches using Zig's for loop with value and index capture
// h5 -- arr: Slice of constant integers ([]const i32)
// h5 -- target: Value to search for
// h6 -- Returns: ?usize - optional usize (index if found, null if not)
// h6 -- Uses Zig's optional types for error handling
// h6 -- Time Complexity: O(n), Space Complexity: O(1)
fn linearSearch(arr: []const i32, target: i32) ?usize {
    for (arr, 0..) |val, i| {
        if (val == target) return i;
    }
    return null;
}

// h3 -- Performance Test Function
// h4 -- Tests search performance with large arrays
// h5 -- allocator: Memory allocator for dynamic allocation
// h5 -- size: Size of test array to generate
// h6 -- Uses Zig's precise timing and manual memory management
fn performanceTest(allocator: std.mem.Allocator, size: usize) !void {
    // Don't test with size 0
    if (size == 0) {
        std.debug.print("Skipping performance test for size 0\n", .{});
        return;
    }

    // Allocate memory for large array
    var large_arr = try allocator.alloc(i32, size);
    // Ensure memory is freed
    defer allocator.free(large_arr);

    // Initialize with sequential values for consistent testing
    for (0..size) |i| {
        large_arr[i] = @as(i32, @intCast(i));
    }

    // Set target to last element for worst-case scenario
    const target: i32 = @as(i32, @intCast(size - 1));

    // Warm up the function (run a few times to avoid cold start)
    for (0..10) |_| {
        _ = linearSearch(large_arr, target);
    }

    // Time multiple iterations for accuracy
    const iterations = 1000;
    var total_ns: u64 = 0;
    var found_count: u32 = 0;

    for (0..iterations) |_| {
        const start = std.time.nanoTimestamp();
        const found_index = linearSearch(large_arr, target);
        const end = std.time.nanoTimestamp();
        total_ns += @as(u64, @intCast(end - start));

        if (found_index != null) {
            found_count += 1;
        }
    }

    const avg_ns = @as(f64, @floatFromInt(total_ns)) / @as(f64, @floatFromInt(iterations));
    const avg_seconds = avg_ns / 1_000_000_000.0;

    std.debug.print("Performance Test (Size: {}):\n", .{size});
    std.debug.print("  Target: {} (worst case - last element)\n", .{target});
    std.debug.print("  Average execution time: {d:.6} seconds\n", .{avg_seconds});
    std.debug.print("  Time per element: {d:.9} seconds\n", .{avg_seconds / @as(f64, @floatFromInt(size))});
    std.debug.print("  Total iterations: {}\n", .{iterations});
    std.debug.print("  Success rate: {}/{}\n", .{ found_count, iterations });
}

// h3 -- Validation Test Function
// h4 -- Comprehensive testing of edge cases and correctness
fn validationTests() void {
    std.debug.print("Validation Tests:\n", .{});

    // Test case 1: Normal array
    const arr1 = [_]i32{ 5, 3, 8, 4, 2 };
    const result1 = linearSearch(&arr1, 4);
    std.debug.print("  Search for 4 in [5,3,8,4,2]: {?} (expected: 3)\n", .{result1});

    // Test case 2: First element
    const result2 = linearSearch(&arr1, 5);
    std.debug.print("  Search for 5 (first element): {?} (expected: 0)\n", .{result2});

    // Test case 3: Last element
    const result3 = linearSearch(&arr1, 2);
    std.debug.print("  Search for 2 (last element): {?} (expected: 4)\n", .{result3});

    // Test case 4: Not found
    const result4 = linearSearch(&arr1, 9);
    std.debug.print("  Search for 9 (not present): {?} (expected: null)\n", .{result4});

    // Test case 5: Single element array
    const single_arr = [_]i32{42};
    const result5 = linearSearch(&single_arr, 42);
    std.debug.print("  Search in single element [42]: {?} (expected: 0)\n", .{result5});

    // Test case 6: Single element not found
    const result6 = linearSearch(&single_arr, 99);
    std.debug.print("  Search for 99 in [42]: {?} (expected: null)\n", .{result6});

    // Test case 7: Duplicate elements (should find first occurrence)
    const dup_arr = [_]i32{ 1, 2, 3, 2, 1 };
    const result7 = linearSearch(&dup_arr, 2);
    std.debug.print("  Search for 2 in [1,2,3,2,1]: {?} (expected: 1)\n", .{result7});

    // Test case 8: Empty array
    const empty_arr = [_]i32{};
    const result8 = linearSearch(&empty_arr, 5);
    std.debug.print("  Search in empty array: {?} (expected: null)\n", .{result8});
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
    std.debug.print("=== LINEAR SEARCH ALGORITHM - ZIG IMPLEMENTATION ===\n\n", .{});

    // h3 -- Basic Functionality Test
    // h4 -- Demonstrates basic linear search with array slice
    std.debug.print("1. BASIC FUNCTIONALITY TEST\n", .{});
    std.debug.print("===========================\n", .{});

    const arr = [_]i32{ 5, 3, 8, 4, 2 };
    const target: i32 = 4;

    std.debug.print("Array: ", .{});
    printArray(&arr);
    std.debug.print("\n", .{});
    std.debug.print("Target: {}\n", .{target});

    if (linearSearch(&arr, target)) |index| {
        std.debug.print("Result: Found {} at index {}\n", .{ target, index });
    } else {
        std.debug.print("Result: Not found\n", .{});
    }

    // h3 -- Validation Tests
    // h4 -- Comprehensive testing of edge cases
    std.debug.print("\n2. VALIDATION TESTS\n", .{});
    std.debug.print("===================\n", .{});
    validationTests();

    // h3 -- Performance Tests
    // h4 -- Measure performance with different array sizes
    std.debug.print("\n\n3. PERFORMANCE TESTS\n", .{});
    std.debug.print("===================\n", .{});
    std.debug.print("Note: Testing worst-case scenario (target at end)\n", .{});
    std.debug.print("      Averaging over 1000 iterations for accuracy\n\n", .{});

    // Get default allocator for dynamic memory
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    // Check for memory leaks
    defer _ = gpa.deinit();

    // Test with different array sizes
    try performanceTest(allocator, 100); // 100 elements
    try performanceTest(allocator, 1000); // 1K elements
    try performanceTest(allocator, 10000); // 10K elements
    try performanceTest(allocator, 100000); // 100K elements

    // h3 -- Complexity Verification
    // h4 -- Demonstrate O(n) time complexity
    std.debug.print("\n4. COMPLEXITY VERIFICATION\n", .{});
    std.debug.print("=========================\n", .{});
    std.debug.print("To verify O(n) time complexity:\n", .{});
    std.debug.print("  - As array size increases by 10x, time should increase by ~10x\n", .{});
    std.debug.print("  - Time per element should remain approximately constant\n", .{});
    std.debug.print("  - This confirms linear relationship between size and time\n", .{});

    // h3 -- Zig-Specific Features
    // h4 -- Highlights Zig language features and design philosophy
    std.debug.print("\n\n5. ZIG-SPECIFIC FEATURES\n", .{});
    std.debug.print("=======================\n", .{});
    std.debug.print("Language Features Used:\n", .{});
    std.debug.print("  - Slices ([]const i32): View into array with length\n", .{});
    std.debug.print("  - Optional types (?usize): Nullable return values\n", .{});
    std.debug.print("  - For loops with capture: |val, i| for value and index\n", .{});
    std.debug.print("  - Manual memory management: Explicit allocators\n", .{});
    std.debug.print("  - Error handling: Error union types with try\n", .{});
    std.debug.print("  - Defer: Automatic cleanup when scope exits\n", .{});
    std.debug.print("  - Compile-time execution: @as() for explicit casting\n", .{});

    std.debug.print("\nZig Design Philosophy:\n", .{});
    std.debug.print("  - No hidden memory allocations\n", .{});
    std.debug.print("  - No garbage collector\n", .{});
    std.debug.print("  - Compile-time execution and metaprogramming\n", .{});
    std.debug.print("  - Explicit error handling\n", .{});
    std.debug.print("  - C interoperability\n", .{});
    std.debug.print("  - Simple language with minimal runtime\n", .{});

    // h3 -- Performance Analysis
    // h4 -- Analyze timing results and performance characteristics
    std.debug.print("\n\n6. PERFORMANCE ANALYSIS\n", .{});
    std.debug.print("=======================\n", .{});
    std.debug.print("Observations:\n", .{});
    std.debug.print("  - Execution time scales linearly with input size (O(n))\n", .{});
    std.debug.print("  - Zig's manual memory management provides control\n", .{});
    std.debug.print("  - No runtime overhead from garbage collection\n", .{});
    std.debug.print("  - Compile-time optimizations enhance performance\n", .{});

    std.debug.print("\nZig Performance Advantages:\n", .{});
    std.debug.print("  - Direct memory access with safety guarantees\n", .{});
    std.debug.print("  - No hidden allocations or runtime overhead\n", .{});
    std.debug.print("  - Efficient generated assembly code\n", .{});
    std.debug.print("  - Predictable performance characteristics\n", .{});

    // h3 -- Algorithm Analysis
    // h4 -- Comprehensive algorithm analysis
    std.debug.print("\n\n7. ALGORITHM ANALYSIS\n", .{});
    std.debug.print("====================\n", .{});
    std.debug.print("Complexity Analysis:\n", .{});
    std.debug.print("  Time Complexity: O(n)\n", .{});
    std.debug.print("    - Best case: Ω(1) - target at beginning\n", .{});
    std.debug.print("    - Average case: Θ(n/2) - target in middle\n", .{});
    std.debug.print("    - Worst case: O(n) - target at end or not present\n", .{});
    std.debug.print("  Space Complexity: O(1)\n", .{});

    std.debug.print("\nMathematical Analysis:\n", .{});
    std.debug.print("  Let n = number of elements\n", .{});
    std.debug.print("  Expected comparisons = (n + 1) / 2 (uniform distribution)\n", .{});
    std.debug.print("  Maximum comparisons = n (worst case)\n", .{});
    std.debug.print("  Minimum comparisons = 1 (best case)\n", .{});

    std.debug.print("\nWhen to Use Linear Search in Zig:\n", .{});
    std.debug.print("  ✓ Small datasets (< 1000 elements)\n", .{});
    std.debug.print("  ✓ Unsorted data where sorting cost > search cost\n", .{});
    std.debug.print("  ✓ Embedded systems with memory constraints\n", .{});
    std.debug.print("  ✓ Performance-critical applications\n", .{});
    std.debug.print("  ✓ When you need predictable memory usage\n", .{});
    std.debug.print("  ✗ Large sorted datasets (use binary search instead)\n", .{});
    std.debug.print("  ✗ Applications requiring frequent dynamic allocations\n", .{});

    std.debug.print("\nCompilation Notes:\n", .{});
    std.debug.print("  - Compile with: zig build-exe ls.zig\n", .{});
    std.debug.print("  - For optimized build: zig build-exe -O ReleaseFast ls.zig\n", .{});
    std.debug.print("  - Run directly: zig run ls.zig\n", .{});
}
