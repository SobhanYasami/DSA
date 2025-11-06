use std::mem;

// Function to calculate address for 1D array
fn calculate_1d_address<T>(base: *const T, i: usize) -> *const T {
    unsafe { base.add(i) }
}

// Function to calculate address for 2D array (Row-major)
fn calculate_2d_row_major<T>(base: *const T, i: usize, j: usize, cols: usize) -> *const T {
    let offset = i * cols + j;
    unsafe { base.add(offset) }
}

// Function to calculate address for 2D array (Column-major)
fn calculate_2d_col_major<T>(base: *const T, i: usize, j: usize, rows: usize) -> *const T {
    let offset = j * rows + i;
    unsafe { base.add(offset) }
}

// Function to calculate address for 3D array (Row-major)
fn calculate_3d_row_major<T>(base: *const T, i: usize, j: usize, k: usize, cols: usize, depth: usize) -> *const T {
    let offset = (i * cols * depth) + (j * depth) + k;
    unsafe { base.add(offset) }
}

// Function to calculate address for 3D array (Column-major)
fn calculate_3d_col_major<T>(base: *const T, i: usize, j: usize, k: usize, rows: usize, cols: usize) -> *const T {
    let offset = (k * rows * cols) + (j * rows) + i;
    unsafe { base.add(offset) }
}

// Generic function for n-dimensional array (Row-major)
fn calculate_nd_row_major<T>(base: *const T, indices: &[usize], dimensions: &[usize]) -> *const T {
    let n = indices.len();
    let mut offset = 0;
    
    for dim in 0..n {
        let mut multiplier = 1;
        for next_dim in dim + 1..n {
            multiplier *= dimensions[next_dim];
        }
        offset += indices[dim] * multiplier;
    }
    
    unsafe { base.add(offset) }
}

// Generic function for n-dimensional array (Column-major)
fn calculate_nd_col_major<T>(base: *const T, indices: &[usize], dimensions: &[usize]) -> *const T {
    let n = indices.len();
    let mut offset = 0;
    
    for dim in (0..n).rev() {
        let mut multiplier = 1;
        for prev_dim in (dim + 1..n).rev() {
            multiplier *= dimensions[prev_dim];
        }
        offset += indices[dim] * multiplier;
    }
    
    unsafe { base.add(offset) }
}

fn print_array_2d(arr: &[f32], rows: usize, cols: usize) {
    println!("Array contents:");
    for i in 0..rows {
        for j in 0..cols {
            print!("{:6.1}", arr[i * cols + j]);
        }
        println!();
    }
}

fn main() {
    println!("=== MEMORY ADDRESS CALCULATIONS FOR N-DIMENSIONAL ARRAYS ===\n");

    // One Dimension Array
    println!("1. ONE-DIMENSIONAL ARRAY");
    println!("========================");
    let mut a: [f32; 10] = [0.0; 10];

    // Initialize 1D array
    for i in 0..10 {
        a[i] = i as f32 * 10.0;
    }

    println!("Real memory addresses:");
    println!("Base address (a):     {:p}", &a);
    println!("Address of a[0]:      {:p}", &a[0]);
    println!("Address of a[1]:      {:p}", &a[1]);
    println!("Address of a[2]:      {:p}", &a[2]);
    println!("Address of a[5]:      {:p}", &a[5]);

    // Demonstrate the calculation
    println!("\nVerification:");
    let i = 3;
    let calculated_addr = calculate_1d_address(a.as_ptr(), i);
    println!("Calculated a[{}] address: {:p}", i, calculated_addr);
    println!("Actual a[{}] address:    {:p}", i, &a[i]);
    println!("Value at a[{}]:          {:.1}", i, a[i]);

    // Two Dimension Array
    println!("\n\n2. TWO-DIMENSIONAL ARRAY");
    println!("========================");
    const ROWS: usize = 3;
    const COLS: usize = 4;
    let mut b: [[f32; COLS]; ROWS] = [[0.0; COLS]; ROWS];

    // Initialize 2D array
    for i in 0..ROWS {
        for j in 0..COLS {
            b[i][j] = i as f32 * 10.0 + j as f32;
        }
    }

    // Convert to flat slice for printing
    let flat_b: &[f32] = unsafe {
        std::slice::from_raw_parts(b.as_ptr() as *const f32, ROWS * COLS)
    };
    print_array_2d(flat_b, ROWS, COLS);

    println!("\nBase address: {:p}", &b);
    println!("Dimensions: {} x {}", ROWS, COLS);

    // Test specific element
    let test_i = 1;
    let test_j = 2;
    println!("\nTesting element b[{}][{}]:", test_i, test_j);
    println!("Actual address:    {:p}", &b[test_i][test_j]);
    println!("Actual value:      {:.1}", b[test_i][test_j]);

    // Row-major calculation
    let row_major_addr = calculate_2d_row_major(b.as_ptr() as *const f32, test_i, test_j, COLS);
    println!("Row-major calc:    {:p}", row_major_addr);
    unsafe {
        println!("Row-major value:   {:.1}", *row_major_addr);
    }

    // Column-major calculation
    let col_major_addr = calculate_2d_col_major(b.as_ptr() as *const f32, test_i, test_j, ROWS);
    println!("Column-major calc: {:p}", col_major_addr);
    unsafe {
        println!("Column-major value: {:.1}", *col_major_addr);
    }

    let ordering = if row_major_addr == &b[test_i][test_j] as *const f32 {
        "ROW-MAJOR"
    } else {
        "COLUMN-MAJOR"
    };
    println!("Rust uses {} ordering for 2D arrays", ordering);

    // Three Dimension Array
    println!("\n\n3. THREE-DIMENSIONAL ARRAY");
    println!("==========================");
    const DIM1: usize = 2;
    const DIM2: usize = 3;
    const DIM3: usize = 4;
    let mut c: [[[f32; DIM3]; DIM2]; DIM1] = [[[0.0; DIM3]; DIM2]; DIM1];

    // Initialize 3D array
    for i in 0..DIM1 {
        for j in 0..DIM2 {
            for k in 0..DIM3 {
                c[i][j][k] = i as f32 * 100.0 + j as f32 * 10.0 + k as f32;
            }
        }
    }

    println!("Dimensions: {} x {} x {}", DIM1, DIM2, DIM3);
    println!("Base address: {:p}", &c);

    // Test specific element
    let test_i3 = 1;
    let test_j3 = 2;
    let test_k3 = 3;
    println!("\nTesting element c[{}][{}][{}]:", test_i3, test_j3, test_k3);
    println!("Actual address:    {:p}", &c[test_i3][test_j3][test_k3]);
    println!("Actual value:      {:.1}", c[test_i3][test_j3][test_k3]);

    // Row-major calculation
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

    // Column-major calculation
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

    // N-Dimensional Array (Generic)
    println!("\n\n4. N-DIMENSIONAL ARRAY (GENERIC)");
    println!("================================");

    // Simulate a 4D array with dimensions 2x3x4x2
    let dimensions: [usize; 4] = [2, 3, 4, 2];
    let test_indices: [usize; 4] = [1, 2, 3, 1];

    // Create a flat array that represents our n-dimensional array
    let total_elements: usize = dimensions.iter().product();
    let mut d: Vec<f32> = Vec::with_capacity(total_elements);

    // Initialize with predictable values
    for idx in 0..total_elements {
        d.push(idx as f32 * 10.0);
    }

    print!("Dimensions: ");
    for (d, &dim) in dimensions.iter().enumerate() {
        print!("{}", dim);
        if d < dimensions.len() - 1 {
            print!(" x ");
        }
    }
    println!();

    print!("Testing element d[");
    for (d, &idx) in test_indices.iter().enumerate() {
        print!("{}", idx);
        if d < test_indices.len() - 1 {
            print!("][");
        }
    }
    println!("]");

    // Calculate the actual index in our flat array using row-major
    let mut actual_index = 0;
    let mut multiplier = 1;
    for d in (0..dimensions.len()).rev() {
        actual_index += test_indices[d] * multiplier;
        multiplier *= dimensions[d];
    }

    println!("Actual address:    {:p}", &d[actual_index]);
    println!("Actual value:      {:.1}", d[actual_index]);

    // Row-major calculation
    let row_major_nd = calculate_nd_row_major(d.as_ptr(), &test_indices, &dimensions);
    println!("Row-major calc:    {:p}", row_major_nd);
    unsafe {
        println!("Row-major value:   {:.1}", *row_major_nd);
    }

    // Column-major calculation
    let col_major_nd = calculate_nd_col_major(d.as_ptr(), &test_indices, &dimensions);
    println!("Column-major calc: {:p}", col_major_nd);
    unsafe {
        println!("Column-major value: {:.1}", *col_major_nd);
    }

    // Additional demonstration: Access patterns
    println!("\n\n5. ACCESS PATTERN DEMONSTRATION");
    println!("===============================");

    const SIZE: usize = 3;
    let mut matrix: [[f32; SIZE]; SIZE] = [[0.0; SIZE]; SIZE];

    // Initialize matrix
    for i in 0..SIZE {
        for j in 0..SIZE {
            matrix[i][j] = (i * SIZE + j) as f32;
        }
    }

    println!("Matrix ({}x{}):", SIZE, SIZE);
    for i in 0..SIZE {
        for j in 0..SIZE {
            print!("{:4.1}", matrix[i][j]);
        }
        println!();
    }

    println!("\nMemory layout (row-major order):");
    for i in 0..SIZE {
        for j in 0..SIZE {
            println!(
                "matrix[{}][{}] = {:.1} at address {:p}",
                i, j, matrix[i][j], &matrix[i][j]
            );
        }
    }

    // Summary
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

    println!("Key differences:");
    println!("  - Row-major: Rightmost index varies fastest");
    println!("  - Column-major: Leftmost index varies fastest");
    println!("  - Rust uses row-major order for arrays");
    println!("  - Performance depends on access patterns:");
    println!("    * Row-major: Efficient for row-wise access");
    println!("    * Column-major: Efficient for column-wise access");
}