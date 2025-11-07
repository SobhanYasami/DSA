// h1 -- Memory Address Calculator for N-Dimensional Arrays in Rust
// h2 -- This program demonstrates memory address calculations for arrays of various dimensions
// h2 -- using both row-major and column-major ordering approaches in Rust
// h2 -- Rust provides memory safety while allowing low-level pointer operations through unsafe blocks

use std::mem;

// h3 -- 1D Array Address Calculation Function
// h4 -- Calculates the memory address of an element in a 1-dimensional array
// h4 -- Uses Rust's generic type system to work with any data type
// h5 -- <T>: Generic type parameter - works with any data type (f32, i32, etc.)
// h5 -- base: Raw pointer to the start of the array (*const T)
// h5 -- i: Index of the element to calculate (usize - unsigned integer)
// h5 -- Returns: Raw pointer to the calculated memory address (*const T)
// h6 -- Note: Uses unsafe block because pointer arithmetic bypasses Rust's safety checks
// h6 -- The add() method automatically multiplies by sizeof(T) behind the scenes
fn calculate_1d_address<T>(base: *const T, i: usize) -> *const T {
    unsafe { base.add(i) }
}

// h3 -- 2D Array Address Calculation (Row-Major)
// h4 -- Calculates memory address using row-major ordering for 2D arrays
// h4 -- Row-major: Elements are stored row by row in memory
// h5 -- base: Raw pointer to the start of the 2D array
// h5 -- i, j: Row and column indices (0-based)
// h5 -- cols: Number of columns in the 2D array
// h5 -- Returns: Pointer to calculated address using formula: base + (i * cols + j)
// h6 -- Formula: offset = i * cols + j (standard row-major indexing)
// h6 -- Example: For a 3x4 array, element [1][2] is at offset (1*4 + 2) = 6
fn calculate_2d_row_major<T>(base: *const T, i: usize, j: usize, cols: usize) -> *const T {
    let offset = i * cols + j;
    unsafe { base.add(offset) }
}

// h3 -- 2D Array Address Calculation (Column-Major)
// h4 -- Calculates memory address using column-major ordering for 2D arrays
// h4 -- Column-major: Elements are stored column by column in memory
// h5 -- base: Raw pointer to the start of the 2D array
// h5 -- i, j: Row and column indices (0-based)
// h5 -- rows: Number of rows in the 2D array
// h5 -- Returns: Pointer to calculated address using formula: base + (j * rows + i)
// h6 -- Formula: offset = j * rows + i (standard column-major indexing)
// h6 -- Example: For a 3x4 array, element [1][2] is at offset (2*3 + 1) = 7
fn calculate_2d_col_major<T>(base: *const T, i: usize, j: usize, rows: usize) -> *const T {
    let offset = j * rows + i;
    unsafe { base.add(offset) }
}

// h3 -- 3D Array Address Calculation (Row-Major)
// h4 -- Calculates memory address using row-major ordering for 3D arrays
// h4 -- 3D arrays can be thought of as arrays of 2D arrays (planes of rows and columns)
// h5 -- base: Raw pointer to the start of the 3D array
// h5 -- i, j, k: Indices for the three dimensions (plane, row, column)
// h5 -- cols: Number of columns in each 2D slice
// h5 -- depth: Size of the third dimension (number of elements in k-direction)
// h5 -- Returns: Pointer using formula: base + ((i * cols * depth) + (j * depth) + k)
// h6 -- Formula: Elements are stored with k varying fastest, then j, then i
// h6 -- This follows the pattern: rightmost index varies most frequently
fn calculate_3d_row_major<T>(
    base: *const T,
    i: usize,
    j: usize,
    k: usize,
    cols: usize,
    depth: usize,
) -> *const T {
    let offset = (i * cols * depth) + (j * depth) + k;
    unsafe { base.add(offset) }
}

// h3 -- 3D Array Address Calculation (Column-Major)
// h4 -- Calculates memory address using column-major ordering for 3D arrays
// h4 -- Column-major in 3D: Elements stored with first dimension varying fastest
// h5 -- base: Raw pointer to the start of the 3D array
// h5 -- i, j, k: Indices for the three dimensions
// h5 -- rows: Number of rows in the array
// h5 -- cols: Number of columns in the array
// h5 -- Returns: Pointer using formula: base + ((k * rows * cols) + (j * rows) + i)
// h6 -- Formula: Elements are stored with i varying fastest, then j, then k
// h6 -- This follows the pattern: leftmost index varies most frequently
fn calculate_3d_col_major<T>(
    base: *const T,
    i: usize,
    j: usize,
    k: usize,
    rows: usize,
    cols: usize,
) -> *const T {
    let offset = (k * rows * cols) + (j * rows) + i;
    unsafe { base.add(offset) }
}

// h3 -- N-Dimensional Array Address Calculation (Row-Major)
// h4 -- Generic function for n-dimensional arrays using row-major ordering
// h4 -- Handles arrays with any number of dimensions dynamically
// h5 -- base: Raw pointer to the start of the n-dimensional array
// h5 -- indices: Slice reference (&[usize]) containing indices for each dimension
// h5 -- dimensions: Slice reference containing sizes of each dimension
// h5 -- Returns: Pointer to calculated address using generalized row-major formula
// h6 -- Formula: Σ (indices[dim] * Π dimensions[next_dim] for next_dim > dim)
// h6 -- For 4D: offset = i*(d1*d2*d3) + j*(d2*d3) + k*(d3) + l
// h6 -- Rust slices (&[T]) are fat pointers containing both data pointer and length
fn calculate_nd_row_major<T>(base: *const T, indices: &[usize], dimensions: &[usize]) -> *const T {
    let n = indices.len();
    let mut offset = 0;

    // h4 -- Calculate offset using nested loops
    // h5 -- Outer loop: Process each dimension from left to right
    // h5 -- Inner loop: Calculate multiplier for current dimension
    for dim in 0..n {
        let mut multiplier = 1;
        for next_dim in dim + 1..n {
            multiplier *= dimensions[next_dim];
        }
        offset += indices[dim] * multiplier;
    }

    unsafe { base.add(offset) }
}

// h3 -- N-Dimensional Array Address Calculation (Column-Major)
// h4 -- Generic function for n-dimensional arrays using column-major ordering
// h4 -- Handles arrays with any number of dimensions dynamically
// h5 -- base: Raw pointer to the start of the n-dimensional array
// h5 -- indices: Slice reference containing indices for each dimension
// h5 -- dimensions: Slice reference containing sizes of each dimension
// h5 -- Returns: Pointer to calculated address using generalized column-major formula
// h6 -- Formula: Σ (indices[dim] * Π dimensions[prev_dim] for prev_dim > dim)
// h6 -- For 4D: offset = l + k*d3 + j*d2*d3 + i*d1*d2*d3
// h6 -- Note: Processes dimensions from right to left (rev() reverses iteration)
fn calculate_nd_col_major<T>(base: *const T, indices: &[usize], dimensions: &[usize]) -> *const T {
    let n = indices.len();
    let mut offset = 0;

    // h4 -- Calculate offset processing dimensions from right to left
    // h5 -- (0..n).rev(): Iterate from last dimension to first
    // h5 -- This matches column-major order: rightmost index in formula varies fastest
    for dim in (0..n).rev() {
        let mut multiplier = 1;
        for prev_dim in (dim + 1..n).rev() {
            multiplier *= dimensions[prev_dim];
        }
        offset += indices[dim] * multiplier;
    }

    unsafe { base.add(offset) }
}

// h3 -- 2D Array Print Utility Function
// h4 -- Helper function to display 2D array contents stored in a flat slice
// h4 -- Demonstrates how multi-dimensional arrays are laid out in memory
// h5 -- arr: Slice reference to the flat array data (&[f32])
// h5 -- rows: Number of rows to display
// h5 -- cols: Number of columns to display
// h6 -- Uses row-major indexing: arr[i * cols + j] to access element [i][j]
// h6 -- Rust's print! and println! macros provide formatted output
fn print_array_2d(arr: &[f32], rows: usize, cols: usize) {
    println!("Array contents:");
    for i in 0..rows {
        for j in 0..cols {
            print!("{:6.1}", arr[i * cols + j]);
        }
        println!();
    }
}

// h1 -- Main Function: Memory Address Calculation Demonstrations
// h2 -- Comprehensive demonstration of array memory layout in Rust
// h2 -- Shows actual memory addresses and compares with calculated addresses
fn main() {
    // h3 -- Program Header
    println!("=== MEMORY ADDRESS CALCULATIONS FOR N-DIMENSIONAL ARRAYS ===\n");

    // h3 -- Section 1: One-Dimensional Array Demonstration
    // h4 -- Basic 1D array showing simple linear memory layout
    println!("1. ONE-DIMENSIONAL ARRAY");
    println!("========================");

    // h4 -- Array declaration and initialization
    // h5 -- [f32; 10]: Array type - 10 elements of f32 (32-bit floating point)
    // h5 -- [0.0; 10]: Array literal - create array with 10 elements all initialized to 0.0
    // h5 -- let mut: Mutable variable binding - allows modification of array elements
    let mut a: [f32; 10] = [0.0; 10];

    // h4 -- Initialize array with sample values using for loop
    // h5 -- 0..10: Range expression creating values 0 through 9
    // h5 -- as f32: Type casting from integer to 32-bit float
    for i in 0..10 {
        a[i] = i as f32 * 10.0;
    }

    // h4 -- Display actual memory addresses using Rust's pointer formatting
    // h5 -- {:p}: Pointer formatter - displays memory address in hexadecimal
    // h5 -- &a: Reference to entire array (type: &[f32; 10])
    // h5 -- &a[0]: Reference to first element (type: &f32)
    println!("Real memory addresses:");
    println!("Base address (a):     {:p}", &a);
    println!("Address of a[0]:      {:p}", &a[0]);
    println!("Address of a[1]:      {:p}", &a[1]);
    println!("Address of a[2]:      {:p}", &a[2]);
    println!("Address of a[5]:      {:p}", &a[5]);

    // h4 -- Verify calculation matches actual address
    // h5 -- a.as_ptr(): Get raw pointer to array start (*const f32)
    // h5 -- calculate_1d_address: Our custom function for address calculation
    println!("\nVerification:");
    let i = 3;
    let calculated_addr = calculate_1d_address(a.as_ptr(), i);
    println!("Calculated a[{}] address: {:p}", i, calculated_addr);
    println!("Actual a[{}] address:    {:p}", i, &a[i]);
    println!("Value at a[{}]:          {:.1}", i, a[i]);

    // h3 -- Section 2: Two-Dimensional Array Demonstration
    // h4 -- 2D array showing row-major vs column-major calculations
    println!("\n\n2. TWO-DIMENSIONAL ARRAY");
    println!("========================");

    // h4 -- Compile-time constants for array dimensions
    // h5 -- const: Compile-time constant, must have type annotation
    // h5 -- usize: Architecture-dependent unsigned integer (32 or 64 bits)
    const ROWS: usize = 3;
    const COLS: usize = 4;

    // h4 -- 2D array declaration and initialization
    // h5 -- [[f32; COLS]; ROWS]: Array of ROWS elements, each being an array of COLS f32
    // h5 -- [[0.0; COLS]; ROWS]: Initialize all elements to 0.0
    let mut b: [[f32; COLS]; ROWS] = [[0.0; COLS]; ROWS];

    // h4 -- Initialize 2D array with predictable values
    for i in 0..ROWS {
        for j in 0..COLS {
            b[i][j] = i as f32 * 10.0 + j as f32;
        }
    }

    // h4 -- Convert 2D array to flat slice for printing
    // h5 -- unsafe block: Required for raw pointer operations
    // h5 -- b.as_ptr() as *const f32: Cast array pointer to element pointer
    // h5 -- std::slice::from_raw_parts: Create slice from raw pointer and length
    // h6 -- This demonstrates that 2D arrays are contiguous in memory
    let flat_b: &[f32] =
        unsafe { std::slice::from_raw_parts(b.as_ptr() as *const f32, ROWS * COLS) };
    print_array_2d(flat_b, ROWS, COLS);

    println!("\nBase address: {:p}", &b);
    println!("Dimensions: {} x {}", ROWS, COLS);

    // h4 -- Test specific element with both calculation methods
    let test_i = 1;
    let test_j = 2;
    println!("\nTesting element b[{}][{}]:", test_i, test_j);
    println!("Actual address:    {:p}", &b[test_i][test_j]);
    println!("Actual value:      {:.1}", b[test_i][test_j]);

    // h5 -- Row-major calculation and verification
    // h5 -- b.as_ptr() as *const f32: Get base pointer to array data
    let row_major_addr = calculate_2d_row_major(b.as_ptr() as *const f32, test_i, test_j, COLS);
    println!("Row-major calc:    {:p}", row_major_addr);
    unsafe {
        // h6 -- Dereference raw pointer to get value
        // h6 -- *row_major_addr: Dereference operator for raw pointers
        println!("Row-major value:   {:.1}", *row_major_addr);
    }

    // h5 -- Column-major calculation and verification
    let col_major_addr = calculate_2d_col_major(b.as_ptr() as *const f32, test_i, test_j, ROWS);
    println!("Column-major calc: {:p}", col_major_addr);
    unsafe {
        println!("Column-major value: {:.1}", *col_major_addr);
    }

    // h4 -- Determine which ordering Rust uses by comparing addresses
    // h5 -- if expression: Rust's if is an expression that returns a value
    // h5 -- == comparison: Compares raw pointers for equality
    let ordering = if row_major_addr == &b[test_i][test_j] as *const f32 {
        "ROW-MAJOR"
    } else {
        "COLUMN-MAJOR"
    };
    println!("Rust uses {} ordering for 2D arrays", ordering);

    // h3 -- Section 3: Three-Dimensional Array Demonstration
    // h4 -- 3D array showing more complex memory layout patterns
    println!("\n\n3. THREE-DIMENSIONAL ARRAY");
    println!("==========================");

    // h4 -- 3D array dimensions
    const DIM1: usize = 2;
    const DIM2: usize = 3;
    const DIM3: usize = 4;

    // h4 -- 3D array declaration - array of 2D arrays
    let mut c: [[[f32; DIM3]; DIM2]; DIM1] = [[[0.0; DIM3]; DIM2]; DIM1];

    // h4 -- Initialize 3D array with predictable values
    for i in 0..DIM1 {
        for j in 0..DIM2 {
            for k in 0..DIM3 {
                c[i][j][k] = i as f32 * 100.0 + j as f32 * 10.0 + k as f32;
            }
        }
    }

    println!("Dimensions: {} x {} x {}", DIM1, DIM2, DIM3);
    println!("Base address: {:p}", &c);

    // h4 -- Test specific 3D element
    let test_i3 = 1;
    let test_j3 = 2;
    let test_k3 = 3;
    println!(
        "\nTesting element c[{}][{}][{}]:",
        test_i3, test_j3, test_k3
    );
    println!("Actual address:    {:p}", &c[test_i3][test_j3][test_k3]);
    println!("Actual value:      {:.1}", c[test_i3][test_j3][test_k3]);

    // h5 -- 3D Row-major calculation
    let row_major_3d = calculate_3d_row_major(
        c.as_ptr() as *const f32,
        test_i3,
        test_j3,
        test_k3,
        DIM2,
        DIM3,
    );
    println!("Row-major calc:    {:p}", row_major_3d);
    unsafe {
        println!("Row-major value:   {:.1}", *row_major_3d);
    }

    // h5 -- 3D Column-major calculation
    let col_major_3d = calculate_3d_col_major(
        c.as_ptr() as *const f32,
        test_i3,
        test_j3,
        test_k3,
        DIM1,
        DIM2,
    );
    println!("Column-major calc: {:p}", col_major_3d);
    unsafe {
        println!("Column-major value: {:.1}", *col_major_3d);
    }

    // h3 -- Section 4: N-Dimensional Array Demonstration
    // h4 -- Generic n-dimensional array using dynamic vectors
    println!("\n\n4. N-DIMENSIONAL ARRAY (GENERIC)");
    println!("================================");

    // h4 -- Simulate a 4D array with specific dimensions
    // h5 -- [usize; 4]: Fixed-size array of 4 usize elements
    let dimensions: [usize; 4] = [2, 3, 4, 2];
    let test_indices: [usize; 4] = [1, 2, 3, 1];

    // h4 -- Create flat vector to represent n-dimensional data
    // h5 -- dimensions.iter().product(): Calculate total elements by multiplying dimensions
    // h5 -- Vec::with_capacity(): Create vector with pre-allocated capacity
    // h5 -- Vec<T>: Heap-allocated growable array (similar to ArrayList in other languages)
    let total_elements: usize = dimensions.iter().product();
    let mut d: Vec<f32> = Vec::with_capacity(total_elements);

    // h4 -- Initialize vector with predictable values
    for idx in 0..total_elements {
        d.push(idx as f32 * 10.0);
    }

    // h4 -- Display array dimensions using iterator methods
    // h5 -- dimensions.iter().enumerate(): Get (index, value) pairs
    // h5 -- print! vs println!: print! doesn't add newline
    print!("Dimensions: ");
    for (d, &dim) in dimensions.iter().enumerate() {
        print!("{}", dim);
        if d < dimensions.len() - 1 {
            print!(" x ");
        }
    }
    println!();

    // h4 -- Display test element indices
    print!("Testing element d[");
    for (d, &idx) in test_indices.iter().enumerate() {
        print!("{}", idx);
        if d < test_indices.len() - 1 {
            print!("][");
        }
    }
    println!("]");

    // h4 -- Calculate actual index in flat array using row-major
    let mut actual_index = 0;
    let mut multiplier = 1;
    for d in (0..dimensions.len()).rev() {
        actual_index += test_indices[d] * multiplier;
        multiplier *= dimensions[d];
    }

    println!("Actual address:    {:p}", &d[actual_index]);
    println!("Actual value:      {:.1}", d[actual_index]);

    // h5 -- N-dimensional row-major calculation
    // h5 -- d.as_ptr(): Get raw pointer to vector data
    // h5 -- &test_indices: Reference to fixed-size array (coerced to slice)
    let row_major_nd = calculate_nd_row_major(d.as_ptr(), &test_indices, &dimensions);
    println!("Row-major calc:    {:p}", row_major_nd);
    unsafe {
        println!("Row-major value:   {:.1}", *row_major_nd);
    }

    // h5 -- N-dimensional column-major calculation
    let col_major_nd = calculate_nd_col_major(d.as_ptr(), &test_indices, &dimensions);
    println!("Column-major calc: {:p}", col_major_nd);
    unsafe {
        println!("Column-major value: {:.1}", *col_major_nd);
    }

    // h3 -- Section 5: Access Pattern Demonstration
    // h4 -- Visual demonstration of memory layout patterns
    println!("\n\n5. ACCESS PATTERN DEMONSTRATION");
    println!("===============================");

    const SIZE: usize = 3;
    let mut matrix: [[f32; SIZE]; SIZE] = [[0.0; SIZE]; SIZE];

    // h4 -- Initialize matrix with sequential values
    for i in 0..SIZE {
        for j in 0..SIZE {
            matrix[i][j] = (i * SIZE + j) as f32;
        }
    }

    // h4 -- Display matrix contents
    println!("Matrix ({}x{}):", SIZE, SIZE);
    for i in 0..SIZE {
        for j in 0..SIZE {
            print!("{:4.1}", matrix[i][j]);
        }
        println!();
    }

    // h4 -- Show memory addresses to demonstrate row-major layout
    // h5 -- This clearly shows contiguous memory blocks for each row
    println!("\nMemory layout (row-major order):");
    for i in 0..SIZE {
        for j in 0..SIZE {
            println!(
                "matrix[{}][{}] = {:.1} at address {:p}",
                i, j, matrix[i][j], &matrix[i][j]
            );
        }
    }

    // h3 -- Section 6: Summary and Educational Information
    // h4 -- Comprehensive summary of memory ordering concepts
    println!("\n\n6. SUMMARY");
    println!("==========");
    println!("Row-major order: Elements are stored row by row");
    println!("  Formula 2D: base + (i * COLS + j) * sizeof(element)");
    println!("  Formula 3D: base + ((i * COLS * DEPTH) + (j * DEPTH) + k) * sizeof(element)");
    println!("  Used by: C, C++, Python (numpy default), Pascal, Go, Rust\n");

    println!("Column-major order: Elements are stored column by column");
    println!("  Formula 2D: base + (j * ROWS + i) * sizeof(element)");
    println!("  Formula 3D: base + ((k * ROWS * COLS) + (j * ROWS) + i) * sizeof(element)");
    println!("  Used by: Fortran, MATLAB, R, Julia\n");

    // h4 -- Key differences and performance considerations
    println!("Key differences:");
    println!("  - Row-major: Rightmost index varies fastest");
    println!("  - Column-major: Leftmost index varies fastest");
    println!("  - Rust uses row-major order for arrays");
    println!("  - Performance depends on access patterns:");
    println!("    * Row-major: Efficient for row-wise access");
    println!("    * Column-major: Efficient for column-wise access");

    // h4 -- Rust-specific notes for beginners
    println!("\nRust-specific notes:");
    println!("  - Arrays ([T; N]) are stack-allocated and fixed-size");
    println!("  - Vectors (Vec<T>) are heap-allocated and growable");
    println!("  - Raw pointers (*const T, *mut T) require unsafe blocks");
    println!("  - References (&T, &mut T) are safe and checked at compile time");
    println!("  - as_ptr() method gets raw pointer, as_ref() gets reference");
    println!("  - Unsafe code is needed for low-level memory operations");
}
