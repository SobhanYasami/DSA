// h1 -- Memory Address Calculator for N-Dimensional Arrays in Zig
// h2 -- This program demonstrates memory address calculations for arrays of various dimensions
// h2 -- using both row-major and column-major ordering approaches in Zig
// h2 -- Zig provides low-level control with modern safety features and compile-time execution

const std = @import("std");

// h3 -- 1D Array Address Calculation Function
// h4 -- Calculates the memory address of an element in a 1-dimensional array
// h4 -- Uses Zig's comptime generics for type-safe pointer arithmetic
// h5 -- comptime T: type: Compile-time type parameter - ensures type safety
// h5 -- base: [*]T: Pointer to multiple T (array pointer) - similar to T* in C
// h5 -- index: usize: Index of the element to calculate (unsigned size type)
// h5 -- Returns: [*]T: Pointer to the calculated memory address
// h6 -- Note: Zig's pointer arithmetic automatically handles element size
// h6 -- [*]T is a "many-item pointer" that allows pointer arithmetic
// h6 -- Unlike C, Zig distinguishes between single-item and many-item pointers
fn calculate1DAddress(comptime T: type, base: [*]T, index: usize) [*]T {
    return base + index;
}

// h3 -- 2D Array Address Calculation (Row-Major)
// h4 -- Calculates memory address using row-major ordering for 2D arrays
// h4 -- Row-major: Elements are stored row by row in contiguous memory
// h5 -- comptime T: type: Compile-time type parameter for generic function
// h5 -- base: [*]T: Base pointer to the 2D array data
// h5 -- i, j: usize: Row and column indices (0-based)
// h5 -- cols: usize: Number of columns in the 2D array
// h5 -- Returns: [*]T: Pointer using formula: base + (i * cols + j)
// h6 -- Formula: offset = i * cols + j (standard row-major indexing)
// h6 -- Example: For a 3x4 array, element [1][2] is at offset (1*4 + 2) = 6
// h6 -- Zig's const: Compile-time known value that cannot be changed
fn calculate2DRowMajor(comptime T: type, base: [*]T, i: usize, j: usize, cols: usize) [*]T {
    const offset = i * cols + j;
    return base + offset;
}

// h3 -- 2D Array Address Calculation (Column-Major)
// h4 -- Calculates memory address using column-major ordering for 2D arrays
// h4 -- Column-major: Elements are stored column by column in memory
// h5 -- comptime T: type: Compile-time type parameter
// h5 -- base: [*]T: Base pointer to the 2D array data
// h5 -- i, j: usize: Row and column indices
// h5 -- rows: usize: Number of rows in the 2D array
// h5 -- Returns: [*]T: Pointer using formula: base + (j * rows + i)
// h6 -- Formula: offset = j * rows + i (standard column-major indexing)
// h6 -- Example: For a 3x4 array, element [1][2] is at offset (2*3 + 1) = 7
// h6 -- Used by languages like Fortran and MATLAB
fn calculate2DColMajor(comptime T: type, base: [*]T, i: usize, j: usize, rows: usize) [*]T {
    const offset = j * rows + i;
    return base + offset;
}

// h3 -- 3D Array Address Calculation (Row-Major)
// h4 -- Calculates memory address using row-major ordering for 3D arrays
// h4 -- 3D arrays can be visualized as arrays of 2D arrays (planes)
// h5 -- comptime T: type: Compile-time type parameter
// h5 -- base: [*]T: Base pointer to the 3D array data
// h5 -- i, j, k: usize: Indices for the three dimensions (plane, row, column)
// h5 -- cols: usize: Number of columns in each 2D slice
// h5 -- depth: usize: Size of the third dimension (k-direction)
// h5 -- Returns: [*]T: Pointer using 3D row-major formula
// h6 -- Formula: offset = (i * cols * depth) + (j * depth) + k
// h6 -- Elements stored with k varying fastest, then j, then i
// h6 -- Rightmost index (k) changes most frequently in memory
fn calculate3DRowMajor(comptime T: type, base: [*]T, i: usize, j: usize, k: usize, cols: usize, depth: usize) [*]T {
    const offset = (i * cols * depth) + (j * depth) + k;
    return base + offset;
}

// h3 -- 3D Array Address Calculation (Column-Major)
// h4 -- Calculates memory address using column-major ordering for 3D arrays
// h4 -- Column-major in 3D: Elements stored with first dimension varying fastest
// h5 -- comptime T: type: Compile-time type parameter
// h5 -- base: [*]T: Base pointer to the 3D array data
// h5 -- i, j, k: usize: Indices for the three dimensions
// h5 -- rows: usize: Number of rows in the array
// h5 -- cols: usize: Number of columns in the array
// h5 -- Returns: [*]T: Pointer using 3D column-major formula
// h6 -- Formula: offset = (k * rows * cols) + (j * rows) + i
// h6 -- Elements stored with i varying fastest, then j, then k
// h6 -- Leftmost index (i) changes most frequently in memory
fn calculate3DColMajor(comptime T: type, base: [*]T, i: usize, j: usize, k: usize, rows: usize, cols: usize) [*]T {
    const offset = (k * rows * cols) + (j * rows) + i;
    return base + offset;
}

// h3 -- N-Dimensional Array Address Calculation (Row-Major)
// h4 -- Generic function for n-dimensional arrays using row-major ordering
// h4 -- Handles arrays with any number of dimensions dynamically
// h5 -- comptime T: type: Compile-time type parameter
// h5 -- base: [*]T: Base pointer to the n-dimensional array data
// h5 -- indices: []const usize: Slice containing indices for each dimension
// h5 -- dimensions: []const usize: Slice containing sizes of each dimension
// h5 -- Returns: [*]T: Pointer using generalized row-major formula
// h6 -- Formula: Σ (indices[dim] * Π dimensions[next_dim] for next_dim > dim)
// h6 -- For 4D: offset = i*(d1*d2*d3) + j*(d2*d3) + k*(d3) + l
// h6 -- Zig's for loops: for (range) |capture_variable| { ... }
// h6 -- |dim| captures the current loop index value
fn calculateNDRowMajor(comptime T: type, base: [*]T, indices: []const usize, dimensions: []const usize) [*]T {
    var offset: usize = 0;
    const n = indices.len;

    // h4 -- Calculate offset using nested loops
    // h5 -- Outer loop: Process each dimension from left to right (0..n)
    // h5 -- 0..n: Range from 0 to n-1 inclusive
    // h5 -- |dim|: Capture loop variable - creates a new const for each iteration
    for (0..n) |dim| {
        var multiplier: usize = 1;
        // h5 -- Inner loop: Calculate multiplier for current dimension
        // h5 -- dim + 1..n: Range from next dimension to last dimension
        for (dim + 1..n) |next_dim| {
            multiplier *= dimensions[next_dim];
        }
        offset += indices[dim] * multiplier;
    }

    return base + offset;
}

// h3 -- N-Dimensional Array Address Calculation (Column-Major)
// h4 -- Generic function for n-dimensional arrays using column-major ordering
// h4 -- Handles arrays with any number of dimensions dynamically
// h5 -- comptime T: type: Compile-time type parameter
// h5 -- base: [*]T: Base pointer to the n-dimensional array data
// h5 -- indices: []const usize: Slice containing indices for each dimension
// h5 -- dimensions: []const usize: Slice containing sizes of each dimension
// h5 -- Returns: [*]T: Pointer using generalized column-major formula
// h6 -- Formula: Σ (indices[dim] * Π dimensions[prev_dim] for prev_dim > dim)
// h6 -- For 4D: offset = l + k*d3 + j*d2*d3 + i*d1*d2*d3
// h6 -- Uses while loops for reverse iteration since for loops only go forward
fn calculateNDColMajor(comptime T: type, base: [*]T, indices: []const usize, dimensions: []const usize) [*]T {
    var offset: usize = 0;
    const n = indices.len;

    // h4 -- Calculate offset processing dimensions from right to left
    // h5 -- Use while loop since for loops only iterate forward in Zig
    // h5 -- isize: Signed integer type for negative indexing
    // h5 -- @intCast: Explicit type conversion - Zig requires explicit casts
    var dim: isize = @as(isize, @intCast(n)) - 1;
    while (dim >= 0) : (dim -= 1) {
        var multiplier: usize = 1;
        var prev_dim: isize = @as(isize, @intCast(n)) - 1;
        // h5 -- Calculate multiplier for current dimension
        while (prev_dim > dim) : (prev_dim -= 1) {
            multiplier *= dimensions[@as(usize, @intCast(prev_dim))];
        }
        offset += indices[@as(usize, @intCast(dim))] * multiplier;
    }

    return base + offset;
}

// h3 -- 2D Array Print Utility Function
// h4 -- Helper function to display 2D array contents stored in a flat slice
// h4 -- Demonstrates how multi-dimensional arrays are laid out in memory
// h5 -- arr: []const f32: Slice of constant 32-bit floats (read-only view)
// h5 -- rows: usize: Number of rows to display
// h5 -- cols: usize: Number of columns to display
// h6 -- Uses row-major indexing: arr[row_idx * cols + col_idx]
// h6 -- std.debug.print: Zig's print function for debug output
// h6 -- {d:6.1}: Format specifier - decimal float, 6 width, 1 decimal place
fn printArray2D(arr: []const f32, rows: usize, cols: usize) void {
    std.debug.print("Array contents:\n", .{});
    for (0..rows) |row_idx| {
        for (0..cols) |col_idx| {
            std.debug.print("{d:6.1}", .{arr[row_idx * cols + col_idx]});
        }
        std.debug.print("\n", .{});
    }
}

// h1 -- Main Function: Memory Address Calculation Demonstrations
// h2 -- Comprehensive demonstration of array memory layout in Zig
// h2 -- Shows actual memory addresses and compares with calculated addresses
// h5 -- !void: Return type that may return an error (Error Union Type)
// h5 -- Zig functions can return error types for explicit error handling
pub fn main() !void {
    // h3 -- Program Header
    std.debug.print("=== MEMORY ADDRESS CALCULATIONS FOR N-DIMENSIONAL ARRAYS ===\n\n", .{});

    // h3 -- Section 1: One-Dimensional Array Demonstration
    // h4 -- Basic 1D array showing simple linear memory layout
    std.debug.print("1. ONE-DIMENSIONAL ARRAY\n", .{});
    std.debug.print("========================\n", .{});

    // h4 -- Array declaration and initialization
    // h5 -- [10]f32: Array type - 10 elements of f32 (32-bit floating point)
    // h5 -- undefined: Uninitialized memory - Zig requires explicit initialization
    // h5 -- var: Mutable variable - can be modified
    var a: [10]f32 = undefined;

    // h4 -- Initialize array with sample values using for loop with capture
    // h5 -- for (&a, 0..): Iterate over array with index
    // h5 -- |*elem, idx|: Capture pointer to element and index
    // h5 -- @floatFromInt(): Explicit conversion from integer to float
    // h6 -- &a gets a slice, and for loop iterates over elements with indices
    for (&a, 0..) |*elem, idx| {
        elem.* = @as(f32, @floatFromInt(idx)) * 10.0;
    }

    // h4 -- Display actual memory addresses using Zig's pointer formatting
    // h5 -- {*}: Pointer formatter - displays memory address
    // h5 -- &a: Reference to entire array (type: *[10]f32 - single item pointer)
    // h5 -- &a[0]: Reference to first element
    std.debug.print("Real memory addresses:\n", .{});
    std.debug.print("Base address (a):     {*}\n", .{&a});
    std.debug.print("Address of a[0]:      {*}\n", .{&a[0]});
    std.debug.print("Address of a[1]:      {*}\n", .{&a[1]});
    std.debug.print("Address of a[2]:      {*}\n", .{&a[2]});
    std.debug.print("Address of a[5]:      {*}\n", .{&a[5]});

    // h4 -- Verify calculation matches actual address
    // h5 -- const: Compile-time constant - cannot be modified
    // h5 -- &a: Coerced to [*]f32 (many-item pointer) for pointer arithmetic
    std.debug.print("\nVerification:\n", .{});
    const test_index: usize = 3;
    const calculated_addr = calculate1DAddress(f32, &a, test_index);
    std.debug.print("Calculated a[{}] address: {*}\n", .{ test_index, calculated_addr });
    std.debug.print("Actual a[{}] address:    {*}\n", .{ test_index, &a[test_index] });
    std.debug.print("Value at a[{}]:          {d:.1}\n", .{ test_index, a[test_index] });

    // h3 -- Section 2: Two-Dimensional Array Demonstration
    // h4 -- 2D array showing row-major vs column-major calculations
    std.debug.print("\n\n2. TWO-DIMENSIONAL ARRAY\n", .{});
    std.debug.print("========================\n", .{});

    // h4 -- Compile-time constants for array dimensions
    // h5 -- const: Compile-time constant, must be initialized
    // h5 -- Zig constants are evaluated at compile time
    const ROWS = 3;
    const COLS = 4;

    // h4 -- 2D array declaration
    // h5 -- [ROWS][COLS]f32: Array of ROWS elements, each being an array of COLS f32
    // h5 -- undefined: Uninitialized - we'll initialize in the loop
    var b: [ROWS][COLS]f32 = undefined;

    // h4 -- Initialize 2D array with predictable values
    // h5 -- Nested for loops with capture variables
    // h5 -- |*row, row_idx|: Capture pointer to row and row index
    // h5 -- |*elem, col_idx|: Capture pointer to element and column index
    for (&b, 0..) |*row, row_idx| {
        for (row, 0..) |*elem, col_idx| {
            elem.* = @as(f32, @floatFromInt(row_idx)) * 10.0 + @as(f32, @floatFromInt(col_idx));
        }
    }

    // h4 -- Convert 2D array to flat array for printing
    // h5 -- [ROWS * COLS]f32: Fixed-size array for flat storage
    // h5 -- Demonstrates that 2D arrays are contiguous in memory
    var flat_b: [ROWS * COLS]f32 = undefined;
    for (0..ROWS) |row_idx| {
        for (0..COLS) |col_idx| {
            flat_b[row_idx * COLS + col_idx] = b[row_idx][col_idx];
        }
    }
    printArray2D(&flat_b, ROWS, COLS);

    std.debug.print("\nBase address: {*}\n", .{&b});
    std.debug.print("Dimensions: {} x {}\n", .{ ROWS, COLS });

    // h4 -- Test specific element with both calculation methods
    const test_i: usize = 1;
    const test_j: usize = 2;
    std.debug.print("\nTesting element b[{}][{}]:\n", .{ test_i, test_j });
    std.debug.print("Actual address:    {*}\n", .{&b[test_i][test_j]});
    std.debug.print("Actual value:      {d:.1}\n", .{b[test_i][test_j]});

    // h5 -- Row-major calculation and verification
    // h5 -- @ptrCast(&b[0][0]): Cast single-item pointer to many-item pointer
    // h5 -- Zig requires explicit pointer type conversions
    const row_major_addr = calculate2DRowMajor(f32, @ptrCast(&b[0][0]), test_i, test_j, COLS);
    std.debug.print("Row-major calc:    {*}\n", .{row_major_addr});
    std.debug.print("Row-major value:   {d:.1}\n", .{row_major_addr[0]});

    // h5 -- Column-major calculation and verification
    const col_major_addr = calculate2DColMajor(f32, @ptrCast(&b[0][0]), test_i, test_j, ROWS);
    std.debug.print("Column-major calc: {*}\n", .{col_major_addr});
    std.debug.print("Column-major value: {d:.1}\n", .{col_major_addr[0]});

    // h4 -- Determine which ordering Zig uses by comparing addresses
    // h5 -- if expression: Zig's if returns a value (like ternary operator)
    const ordering = if (row_major_addr == &b[test_i][test_j]) "ROW-MAJOR" else "COLUMN-MAJOR";
    std.debug.print("Zig uses {s} ordering for 2D arrays\n", .{ordering});

    // h3 -- Section 3: Three-Dimensional Array Demonstration
    // h4 -- 3D array showing more complex memory layout patterns
    std.debug.print("\n\n3. THREE-DIMENSIONAL ARRAY\n", .{});
    std.debug.print("==========================\n", .{});

    // h4 -- 3D array dimensions
    const DIM1 = 2;
    const DIM2 = 3;
    const DIM3 = 4;

    // h4 -- 3D array declaration - array of 2D arrays
    var c: [DIM1][DIM2][DIM3]f32 = undefined;

    // h4 -- Initialize 3D array with predictable values
    // h5 -- Triple nested for loops for 3D initialization
    // h5 -- |*plane, i|: Capture plane and first dimension index
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

    // h4 -- Test specific 3D element
    const test_i3: usize = 1;
    const test_j3: usize = 2;
    const test_k3: usize = 3;
    std.debug.print("\nTesting element c[{}][{}][{}]:\n", .{ test_i3, test_j3, test_k3 });
    std.debug.print("Actual address:    {*}\n", .{&c[test_i3][test_j3][test_k3]});
    std.debug.print("Actual value:      {d:.1}\n", .{c[test_i3][test_j3][test_k3]});

    // h5 -- 3D Row-major calculation
    const row_major_3d = calculate3DRowMajor(f32, @ptrCast(&c[0][0][0]), test_i3, test_j3, test_k3, DIM2, DIM3);
    std.debug.print("Row-major calc:    {*}\n", .{row_major_3d});
    std.debug.print("Row-major value:   {d:.1}\n", .{row_major_3d[0]});

    // h5 -- 3D Column-major calculation
    const col_major_3d = calculate3DColMajor(f32, @ptrCast(&c[0][0][0]), test_i3, test_j3, test_k3, DIM1, DIM2);
    std.debug.print("Column-major calc: {*}\n", .{col_major_3d});
    std.debug.print("Column-major value: {d:.1}\n", .{col_major_3d[0]});

    // h3 -- Section 4: N-Dimensional Array Demonstration
    // h4 -- Generic n-dimensional array using dynamic memory allocation
    std.debug.print("\n\n4. N-DIMENSIONAL ARRAY (GENERIC)\n", .{});
    std.debug.print("================================\n", .{});

    // h4 -- Simulate a 4D array with specific dimensions
    // h5 -- [_]usize{...}: Array literal with inferred size
    // h5 -- const dimensions: Compile-time constant array
    const dimensions = [_]usize{ 2, 3, 4, 2 };
    const test_indices = [_]usize{ 1, 2, 3, 1 };

    // h4 -- Create flat array to represent n-dimensional data
    // h5 -- Calculate total elements by multiplying dimensions
    var total_elements: usize = 1;
    for (dimensions) |dim| {
        total_elements *= dim;
    }

    // h4 -- Heap allocation using Zig's page allocator
    // h5 -- try: Error propagation - returns error if allocation fails
    // h5 -- std.heap.page_allocator: System page allocator
    // h5 -- defer: Deferred execution - ensures memory is freed when scope exits
    // h6 -- Zig has no garbage collector - manual memory management required
    const d = try std.heap.page_allocator.alloc(f32, total_elements);
    defer std.heap.page_allocator.free(d);

    // h4 -- Initialize array with predictable values
    // h5 -- for (d, 0..): Iterate over slice with indices
    for (d, 0..) |*elem, idx| {
        elem.* = @as(f32, @floatFromInt(idx)) * 10.0;
    }

    // h4 -- Display array dimensions
    std.debug.print("Dimensions: ", .{});
    for (dimensions, 0..) |dim, pos| {
        std.debug.print("{}", .{dim});
        if (pos < dimensions.len - 1) {
            std.debug.print(" x ", .{});
        }
    }
    std.debug.print("\n", .{});

    // h4 -- Display test element indices
    std.debug.print("Testing element d[", .{});
    for (test_indices, 0..) |idx, pos| {
        std.debug.print("{}", .{idx});
        if (pos < test_indices.len - 1) {
            std.debug.print("][", .{});
        }
    }
    std.debug.print("]\n", .{});

    // h4 -- Calculate actual index in flat array using row-major
    var actual_index: usize = 0;
    var multiplier: usize = 1;
    var dim_idx: isize = @as(isize, @intCast(dimensions.len)) - 1;
    while (dim_idx >= 0) : (dim_idx -= 1) {
        actual_index += test_indices[@as(usize, @intCast(dim_idx))] * multiplier;
        multiplier *= dimensions[@as(usize, @intCast(dim_idx))];
    }

    std.debug.print("Actual address:    {*}\n", .{&d[actual_index]});
    std.debug.print("Actual value:      {d:.1}\n", .{d[actual_index]});

    // h5 -- N-dimensional row-major calculation
    // h5 -- d.ptr: Get raw pointer from slice (type: [*]f32)
    const row_major_nd = calculateNDRowMajor(f32, d.ptr, &test_indices, &dimensions);
    std.debug.print("Row-major calc:    {*}\n", .{row_major_nd});
    std.debug.print("Row-major value:   {d:.1}\n", .{row_major_nd[0]});

    // h5 -- N-dimensional column-major calculation
    const col_major_nd = calculateNDColMajor(f32, d.ptr, &test_indices, &dimensions);
    std.debug.print("Column-major calc: {*}\n", .{col_major_nd});
    std.debug.print("Column-major value: {d:.1}\n", .{col_major_nd[0]});

    // h3 -- Section 5: Access Pattern Demonstration
    // h4 -- Visual demonstration of memory layout patterns
    std.debug.print("\n\n5. ACCESS PATTERN DEMONSTRATION\n", .{});
    std.debug.print("===============================\n", .{});

    const SIZE = 3;
    var matrix: [SIZE][SIZE]f32 = undefined;

    // h4 -- Initialize matrix with sequential values
    for (&matrix, 0..) |*row, row_idx| {
        for (row, 0..) |*elem, col_idx| {
            elem.* = @as(f32, @floatFromInt(row_idx * SIZE + col_idx));
        }
    }

    // h4 -- Display matrix contents
    std.debug.print("Matrix ({}x{}):\n", .{ SIZE, SIZE });
    for (matrix) |row| {
        for (row) |elem| {
            std.debug.print("{d:4.1}", .{elem});
        }
        std.debug.print("\n", .{});
    }

    // h4 -- Show memory addresses to demonstrate row-major layout
    // h5 -- This clearly shows contiguous memory blocks for each row
    std.debug.print("\nMemory layout (row-major order):\n", .{});
    for (0..SIZE) |row_idx| {
        for (0..SIZE) |col_idx| {
            std.debug.print("matrix[{}][{}] = {d:.1} at address {*}\n", .{
                row_idx, col_idx, matrix[row_idx][col_idx], &matrix[row_idx][col_idx],
            });
        }
    }

    // h3 -- Section 6: Summary and Educational Information
    // h4 -- Comprehensive summary of memory ordering concepts
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

    // h4 -- Key differences and performance considerations
    std.debug.print("Key differences:\n", .{});
    std.debug.print("  - Row-major: Rightmost index varies fastest\n", .{});
    std.debug.print("  - Column-major: Leftmost index varies fastest\n", .{});
    std.debug.print("  - Zig uses row-major order for arrays\n", .{});
    std.debug.print("  - Performance depends on access patterns:\n", .{});
    std.debug.print("    * Row-major: Efficient for row-wise access\n", .{});
    std.debug.print("    * Column-major: Efficient for column-wise access\n", .{});

    // h4 -- Zig-specific educational notes
    std.debug.print("\nZig-specific concepts demonstrated:\n", .{});
    std.debug.print("  - comptime: Compile-time execution and type parameters\n", .{});
    std.debug.print("  - Pointer types: [*]T (many), *T (single), []T (slice)\n", .{});
    std.debug.print("  - Explicit casting: @ptrCast, @intCast, @floatFromInt\n", .{});
    std.debug.print("  - Memory management: Manual allocation with defer cleanup\n", .{});
    std.debug.print("  - Error handling: Error union types with try\n", .{});
    std.debug.print("  - Loop captures: for (items, 0..) |*item, index|\n", .{});
    std.debug.print("  - No hidden allocations: All memory operations are explicit\n", .{});
}
