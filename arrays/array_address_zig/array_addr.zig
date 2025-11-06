const std = @import("std");

// Function to calculate address for 1D array
fn calculate1DAddress(comptime T: type, base: [*]T, index: usize) [*]T {
    return base + index;
}

// Function to calculate address for 2D array (Row-major)
fn calculate2DRowMajor(comptime T: type, base: [*]T, i: usize, j: usize, cols: usize) [*]T {
    const offset = i * cols + j;
    return base + offset;
}

// Function to calculate address for 2D array (Column-major)
fn calculate2DColMajor(comptime T: type, base: [*]T, i: usize, j: usize, rows: usize) [*]T {
    const offset = j * rows + i;
    return base + offset;
}

// Function to calculate address for 3D array (Row-major)
fn calculate3DRowMajor(comptime T: type, base: [*]T, i: usize, j: usize, k: usize, cols: usize, depth: usize) [*]T {
    const offset = (i * cols * depth) + (j * depth) + k;
    return base + offset;
}

// Function to calculate address for 3D array (Column-major)
fn calculate3DColMajor(comptime T: type, base: [*]T, i: usize, j: usize, k: usize, rows: usize, cols: usize) [*]T {
    const offset = (k * rows * cols) + (j * rows) + i;
    return base + offset;
}

// Generic function for n-dimensional array (Row-major)
fn calculateNDRowMajor(comptime T: type, base: [*]T, indices: []const usize, dimensions: []const usize) [*]T {
    var offset: usize = 0;
    const n = indices.len;

    for (0..n) |dim| {
        var multiplier: usize = 1;
        for (dim + 1..n) |next_dim| {
            multiplier *= dimensions[next_dim];
        }
        offset += indices[dim] * multiplier;
    }

    return base + offset;
}

// Generic function for n-dimensional array (Column-major)
fn calculateNDColMajor(comptime T: type, base: [*]T, indices: []const usize, dimensions: []const usize) [*]T {
    var offset: usize = 0;
    const n = indices.len;

    var dim: isize = @as(isize, @intCast(n)) - 1;
    while (dim >= 0) : (dim -= 1) {
        var multiplier: usize = 1;
        var prev_dim: isize = @as(isize, @intCast(n)) - 1;
        while (prev_dim > dim) : (prev_dim -= 1) {
            multiplier *= dimensions[@as(usize, @intCast(prev_dim))];
        }
        offset += indices[@as(usize, @intCast(dim))] * multiplier;
    }

    return base + offset;
}

fn printArray2D(arr: []const f32, rows: usize, cols: usize) void {
    std.debug.print("Array contents:\n", .{});
    for (0..rows) |row_idx| {
        for (0..cols) |col_idx| {
            std.debug.print("{d:6.1}", .{arr[row_idx * cols + col_idx]});
        }
        std.debug.print("\n", .{});
    }
}

pub fn main() !void {
    std.debug.print("=== MEMORY ADDRESS CALCULATIONS FOR N-DIMENSIONAL ARRAYS ===\n\n", .{});

    // One Dimension Array
    std.debug.print("1. ONE-DIMENSIONAL ARRAY\n", .{});
    std.debug.print("========================\n", .{});
    var a: [10]f32 = undefined;

    // Initialize 1D array
    for (&a, 0..) |*elem, idx| {
        elem.* = @as(f32, @floatFromInt(idx)) * 10.0;
    }

    std.debug.print("Real memory addresses:\n", .{});
    std.debug.print("Base address (a):     {*}\n", .{&a});
    std.debug.print("Address of a[0]:      {*}\n", .{&a[0]});
    std.debug.print("Address of a[1]:      {*}\n", .{&a[1]});
    std.debug.print("Address of a[2]:      {*}\n", .{&a[2]});
    std.debug.print("Address of a[5]:      {*}\n", .{&a[5]});

    // Demonstrate the calculation
    std.debug.print("\nVerification:\n", .{});
    const test_index: usize = 3;
    const calculated_addr = calculate1DAddress(f32, &a, test_index);
    std.debug.print("Calculated a[{}] address: {*}\n", .{ test_index, calculated_addr });
    std.debug.print("Actual a[{}] address:    {*}\n", .{ test_index, &a[test_index] });
    std.debug.print("Value at a[{}]:          {d:.1}\n", .{ test_index, a[test_index] });

    // Two Dimension Array
    std.debug.print("\n\n2. TWO-DIMENSIONAL ARRAY\n", .{});
    std.debug.print("========================\n", .{});
    const ROWS = 3;
    const COLS = 4;
    var b: [ROWS][COLS]f32 = undefined;

    // Initialize 2D array
    for (&b, 0..) |*row, row_idx| {
        for (row, 0..) |*elem, col_idx| {
            elem.* = @as(f32, @floatFromInt(row_idx)) * 10.0 + @as(f32, @floatFromInt(col_idx));
        }
    }

    // Convert to slice for printing
    var flat_b: [ROWS * COLS]f32 = undefined;
    for (0..ROWS) |row_idx| {
        for (0..COLS) |col_idx| {
            flat_b[row_idx * COLS + col_idx] = b[row_idx][col_idx];
        }
    }
    printArray2D(&flat_b, ROWS, COLS);

    std.debug.print("\nBase address: {*}\n", .{&b});
    std.debug.print("Dimensions: {} x {}\n", .{ ROWS, COLS });

    // Test specific element
    const test_i: usize = 1;
    const test_j: usize = 2;
    std.debug.print("\nTesting element b[{}][{}]:\n", .{ test_i, test_j });
    std.debug.print("Actual address:    {*}\n", .{&b[test_i][test_j]});
    std.debug.print("Actual value:      {d:.1}\n", .{b[test_i][test_j]});

    // Row-major calculation
    const row_major_addr = calculate2DRowMajor(f32, @ptrCast(&b[0][0]), test_i, test_j, COLS);
    std.debug.print("Row-major calc:    {*}\n", .{row_major_addr});
    std.debug.print("Row-major value:   {d:.1}\n", .{row_major_addr[0]});

    // Column-major calculation
    const col_major_addr = calculate2DColMajor(f32, @ptrCast(&b[0][0]), test_i, test_j, ROWS);
    std.debug.print("Column-major calc: {*}\n", .{col_major_addr});
    std.debug.print("Column-major value: {d:.1}\n", .{col_major_addr[0]});

    const ordering = if (row_major_addr == &b[test_i][test_j]) "ROW-MAJOR" else "COLUMN-MAJOR";
    std.debug.print("Zig uses {s} ordering for 2D arrays\n", .{ordering});

    // Three Dimension Array
    std.debug.print("\n\n3. THREE-DIMENSIONAL ARRAY\n", .{});
    std.debug.print("==========================\n", .{});
    const DIM1 = 2;
    const DIM2 = 3;
    const DIM3 = 4;
    var c: [DIM1][DIM2][DIM3]f32 = undefined;

    // Initialize 3D array
    for (&c, 0..) |*plane, i| {
        for (plane, 0..) |*row, j| {
            for (row, 0..) |*elem, k| {
                elem.* = @as(f32, @floatFromInt(i)) * 100.0 +
                    @as(f32, @floatFromInt(j)) * 10.0 +
                    @as(f32, @floatFromInt(k));
            }
        }
    }

    std.debug.print("Dimensions: {} x {} x {}\n", .{ DIM1, DIM2, DIM3 });
    std.debug.print("Base address: {*}\n", .{&c});

    // Test specific element
    const test_i3: usize = 1;
    const test_j3: usize = 2;
    const test_k3: usize = 3;
    std.debug.print("\nTesting element c[{}][{}][{}]:\n", .{ test_i3, test_j3, test_k3 });
    std.debug.print("Actual address:    {*}\n", .{&c[test_i3][test_j3][test_k3]});
    std.debug.print("Actual value:      {d:.1}\n", .{c[test_i3][test_j3][test_k3]});

    // Row-major calculation
    const row_major_3d = calculate3DRowMajor(f32, @ptrCast(&c[0][0][0]), test_i3, test_j3, test_k3, DIM2, DIM3);
    std.debug.print("Row-major calc:    {*}\n", .{row_major_3d});
    std.debug.print("Row-major value:   {d:.1}\n", .{row_major_3d[0]});

    // Column-major calculation
    const col_major_3d = calculate3DColMajor(f32, @ptrCast(&c[0][0][0]), test_i3, test_j3, test_k3, DIM1, DIM2);
    std.debug.print("Column-major calc: {*}\n", .{col_major_3d});
    std.debug.print("Column-major value: {d:.1}\n", .{col_major_3d[0]});

    // N-Dimensional Array (Generic)
    std.debug.print("\n\n4. N-DIMENSIONAL ARRAY (GENERIC)\n", .{});
    std.debug.print("================================\n", .{});

    // Simulate a 4D array with dimensions 2x3x4x2
    const dimensions = [_]usize{ 2, 3, 4, 2 };
    const test_indices = [_]usize{ 1, 2, 3, 1 };

    // Create a flat array that represents our n-dimensional array
    var total_elements: usize = 1;
    for (dimensions) |dim| {
        total_elements *= dim;
    }

    const d = try std.heap.page_allocator.alloc(f32, total_elements);
    defer std.heap.page_allocator.free(d);

    // Initialize with predictable values
    for (d, 0..) |*elem, idx| {
        elem.* = @as(f32, @floatFromInt(idx)) * 10.0;
    }

    std.debug.print("Dimensions: ", .{});
    for (dimensions, 0..) |dim, pos| {
        std.debug.print("{}", .{dim});
        if (pos < dimensions.len - 1) {
            std.debug.print(" x ", .{});
        }
    }
    std.debug.print("\n", .{});

    std.debug.print("Testing element d[", .{});
    for (test_indices, 0..) |idx, pos| {
        std.debug.print("{}", .{idx});
        if (pos < test_indices.len - 1) {
            std.debug.print("][", .{});
        }
    }
    std.debug.print("]\n", .{});

    // Calculate the actual index in our flat array using row-major
    var actual_index: usize = 0;
    var multiplier: usize = 1;
    var dim_idx: isize = @as(isize, @intCast(dimensions.len)) - 1;
    while (dim_idx >= 0) : (dim_idx -= 1) {
        actual_index += test_indices[@as(usize, @intCast(dim_idx))] * multiplier;
        multiplier *= dimensions[@as(usize, @intCast(dim_idx))];
    }

    std.debug.print("Actual address:    {*}\n", .{&d[actual_index]});
    std.debug.print("Actual value:      {d:.1}\n", .{d[actual_index]});

    // Row-major calculation
    const row_major_nd = calculateNDRowMajor(f32, d.ptr, &test_indices, &dimensions);
    std.debug.print("Row-major calc:    {*}\n", .{row_major_nd});
    std.debug.print("Row-major value:   {d:.1}\n", .{row_major_nd[0]});

    // Column-major calculation
    const col_major_nd = calculateNDColMajor(f32, d.ptr, &test_indices, &dimensions);
    std.debug.print("Column-major calc: {*}\n", .{col_major_nd});
    std.debug.print("Column-major value: {d:.1}\n", .{col_major_nd[0]});

    // Additional demonstration: Access patterns
    std.debug.print("\n\n5. ACCESS PATTERN DEMONSTRATION\n", .{});
    std.debug.print("===============================\n", .{});

    const SIZE = 3;
    var matrix: [SIZE][SIZE]f32 = undefined;

    // Initialize matrix
    for (&matrix, 0..) |*row, row_idx| {
        for (row, 0..) |*elem, col_idx| {
            elem.* = @as(f32, @floatFromInt(row_idx * SIZE + col_idx));
        }
    }

    std.debug.print("Matrix ({}x{}):\n", .{ SIZE, SIZE });
    for (matrix) |row| {
        for (row) |elem| {
            std.debug.print("{d:4.1}", .{elem});
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\nMemory layout (row-major order):\n", .{});
    for (0..SIZE) |row_idx| {
        for (0..SIZE) |col_idx| {
            std.debug.print("matrix[{}][{}] = {d:.1} at address {*}\n", .{
                row_idx, col_idx, matrix[row_idx][col_idx], &matrix[row_idx][col_idx],
            });
        }
    }

    // Summary
    std.debug.print("\n\n6. SUMMARY\n", .{});
    std.debug.print("==========\n", .{});
    std.debug.print("Row-major order: Elements are stored row by row\n", .{});
    std.debug.print("  Formula 2D: base + (i * COLS + j) * sizeof(element)\n", .{});
    std.debug.print("  Formula 3D: base + ((i * COLS * DEPTH) + (j * DEPTH) + k) * sizeof(element)\n", .{});
    std.debug.print("  Used by: C, C++, Python (numpy default), Pascal, Go, Rust, Zig\n\n", .{});

    std.debug.print("Column-major order: Elements are stored column by column\n", .{});
    std.debug.print("  Formula 2D: base + (j * ROWS + i) * sizeof(element)\n", .{});
    std.debug.print("  Formula 3D: base + ((k * ROWS * COLS) + (j * ROWS) + i) * sizeof(element)\n", .{});
    std.debug.print("  Used by: Fortran, MATLAB, R, Julia\n\n", .{});

    std.debug.print("Key differences:\n", .{});
    std.debug.print("  - Row-major: Rightmost index varies fastest\n", .{});
    std.debug.print("  - Column-major: Leftmost index varies fastest\n", .{});
    std.debug.print("  - Zig uses row-major order for arrays\n", .{});
    std.debug.print("  - Performance depends on access patterns:\n", .{});
    std.debug.print("    * Row-major: Efficient for row-wise access\n", .{});
    std.debug.print("    * Column-major: Efficient for column-wise access\n", .{});
}
