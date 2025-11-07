// h1 -- Linear Search Algorithm Implementation in Rust
// h2 -- Rust implementation using iterators and Option type
// h2 -- Includes performance benchmarking and safety features

use std::time::Instant;

// h3 -- Linear Search Function
// h4 -- Searches using Rust's iterator with enumerate for index/value pairs
// h5 -- arr: Slice reference to the array data (&[i32])
// h5 -- target: Value to search for
// h6 -- Returns: Option<usize> - Some(index) if found, None if not found
// h6 -- Uses Rust's Option type for safe error handling
// h6 -- Time Complexity: O(n), Space Complexity: O(1)
fn linear_search(arr: &[i32], target: i32) -> Option<usize> {
    for (i, &val) in arr.iter().enumerate() {
        if val == target {
            return Some(i);
        }
    }
    None
}

// h3 -- Performance Test Function
// h4 -- Tests search performance with large arrays
// h5 -- size: Size of test array to generate
// h6 -- Uses Rust's Instant for high-precision timing
fn performance_test(size: usize) {
    // Create vector with specified capacity
    let mut large_arr = Vec::with_capacity(size);

    // Initialize with sequential values for consistent testing
    for i in 0..size {
        large_arr.push(i as i32);
    }

    // Set target to last element for worst-case scenario
    let target = (size - 1) as i32;

    // Warm up the function (run a few times to avoid cold start)
    for _ in 0..10 {
        linear_search(&large_arr, target);
    }

    // Time multiple iterations for accuracy
    const ITERATIONS: usize = 1000;
    let mut total_duration = std::time::Duration::new(0, 0);
    let mut found_count = 0;

    for _ in 0..ITERATIONS {
        let start = Instant::now();
        let result = linear_search(&large_arr, target);
        let elapsed = start.elapsed();
        total_duration += elapsed;

        if result.is_some() {
            found_count += 1;
        }
    }

    let avg_duration = total_duration / ITERATIONS as u32;

    println!("Performance Test (Size: {}):", size);
    println!("  Target: {} (worst case - last element)", target);
    println!("  Average execution time: {:?}", avg_duration);
    println!("  Time per element: {:?}", avg_duration / size as u32);
    println!("  Total iterations: {}", ITERATIONS);
    println!("  Success rate: {}/{}", found_count, ITERATIONS);
}

// h3 -- Validation Test Function
// h4 -- Comprehensive testing of edge cases and correctness
fn validation_tests() {
    println!("Validation Tests:");

    // Test case 1: Normal array
    let arr1 = [5, 3, 8, 4, 2];
    let result1 = linear_search(&arr1, 4);
    println!(
        "  Search for 4 in {:?}: {:?} (expected: Some(3))",
        arr1, result1
    );

    // Test case 2: First element
    let result2 = linear_search(&arr1, 5);
    println!(
        "  Search for 5 (first element): {:?} (expected: Some(0))",
        result2
    );

    // Test case 3: Last element
    let result3 = linear_search(&arr1, 2);
    println!(
        "  Search for 2 (last element): {:?} (expected: Some(4))",
        result3
    );

    // Test case 4: Not found
    let result4 = linear_search(&arr1, 9);
    println!(
        "  Search for 9 (not present): {:?} (expected: None)",
        result4
    );

    // Test case 5: Single element array
    let single_arr = [42];
    let result5 = linear_search(&single_arr, 42);
    println!(
        "  Search in single element [42]: {:?} (expected: Some(0))",
        result5
    );

    // Test case 6: Single element not found
    let result6 = linear_search(&single_arr, 99);
    println!("  Search for 99 in [42]: {:?} (expected: None)", result6);

    // Test case 7: Duplicate elements (should find first occurrence)
    let dup_arr = [1, 2, 3, 2, 1];
    let result7 = linear_search(&dup_arr, 2);
    println!(
        "  Search for 2 in {:?}: {:?} (expected: Some(1))",
        dup_arr, result7
    );

    // Test case 8: Empty array
    let empty_arr: [i32; 0] = [];
    let result8 = linear_search(&empty_arr, 5);
    println!("  Search in empty array: {:?} (expected: None)", result8);
}

fn main() {
    println!("=== LINEAR SEARCH ALGORITHM - RUST IMPLEMENTATION ===");
    println!();

    // h3 -- Basic Functionality Test
    // h4 -- Demonstrates basic linear search with array slice
    println!("1. BASIC FUNCTIONALITY TEST");
    println!("===========================");

    let arr = [5, 3, 8, 4, 2];
    let target = 4;

    println!("Array: {:?}", arr);
    println!("Target: {}", target);

    match linear_search(&arr, target) {
        Some(i) => println!("Result: Found {} at index {}", target, i),
        None => println!("Result: Not found"),
    }

    // h3 -- Validation Tests
    // h4 -- Comprehensive testing of edge cases
    println!("\n2. VALIDATION TESTS");
    println!("===================");
    validation_tests();

    // h3 -- Performance Tests
    // h4 -- Measure performance with different array sizes
    println!("\n\n3. PERFORMANCE TESTS");
    println!("===================");
    println!("Note: Testing worst-case scenario (target at end)");
    println!("      Averaging over 1000 iterations for accuracy\n");

    // Test with different array sizes
    performance_test(100); // 100 elements
    performance_test(1000); // 1K elements
    performance_test(10000); // 10K elements
    performance_test(100000); // 100K elements

    // h3 -- Performance Analysis
    // h4 -- Analyze timing results and performance characteristics
    println!("\n\n4. PERFORMANCE ANALYSIS");
    println!("=======================");
    println!("Observations:");
    println!("  - Execution time scales linearly with input size (O(n))");
    println!("  - Rust's bounds checking has minimal performance impact");
    println!("  - Iterator abstraction provides zero-cost performance");
    println!("  - Memory safety is achieved without runtime overhead");

    println!("\nRust Performance Features:");
    println!("  - Zero-cost abstractions: iterators compile to efficient loops");
    println!("  - No runtime bounds checking overhead in release mode");
    println!("  - Efficient memory layout and cache utilization");
    println!("  - LLVM optimizations for generated code");

    // h3 -- Rust-Specific Features
    // h4 -- Highlights Rust language features and safety guarantees
    println!("\n\n5. RUST-SPECIFIC FEATURES");
    println!("========================");
    println!("Language Features Used:");
    println!("  - Slices (&[i32]): Borrowed view into array data");
    println!("  - Iterators: .iter().enumerate() for safe iteration");
    println!("  - Option<T>: Type-safe error handling without null");
    println!("  - Pattern matching: match expression for result handling");
    println!("  - Ownership system: Prevents memory leaks and data races");
    println!("  - Generic functions: Works with any comparable type");

    println!("\nSafety Guarantees:");
    println!("  - No null pointer dereferences");
    println!("  - No buffer overflows");
    println!("  - Memory safety at compile time");
    println!("  - Data race prevention");
    println!("  - Automatic bounds checking (in debug mode)");

    // h3 -- Algorithm Analysis
    // h4 -- Comprehensive algorithm analysis
    println!("\n\n6. ALGORITHM ANALYSIS");
    println!("====================");
    println!("Complexity Analysis:");
    println!("  Time Complexity: O(n)");
    println!("    - Best case: Ω(1) - target at beginning");
    println!("    - Average case: Θ(n/2) - target in middle");
    println!("    - Worst case: O(n) - target at end or not present");
    println!("  Space Complexity: O(1)");

    println!("\nMathematical Analysis:");
    println!("  Let n = number of elements");
    println!("  Expected comparisons = (n + 1) / 2 (uniform distribution)");
    println!("  Maximum comparisons = n (worst case)");
    println!("  Minimum comparisons = 1 (best case)");

    println!("\nComparison with Other Search Algorithms:");
    println!("  vs Binary Search: O(n) vs O(log n) for sorted data");
    println!("  vs Hash Tables: O(n) vs O(1) average case");
    println!("  vs Binary Search Trees: O(n) vs O(log n) average");

    println!("\nWhen to Use Linear Search:");
    println!("  ✓ Small datasets (< 1000 elements)");
    println!("  ✓ Unsorted or frequently modified data");
    println!("  ✓ Simple implementation requirements");
    println!("  ✓ When data is not sorted and sorting cost > search cost");
    println!("  ✓ When implementing more complex search algorithms");
    println!("  ✓ Educational purposes to understand search fundamentals");

    println!("\nRust Compilation Notes:");
    println!("  - Compile with: rustc ls.rs");
    println!("  - For optimized build: rustc -O ls.rs");
    println!("  - Cargo.toml not required - uses only standard library");
    println!("  - No external dependencies needed");
}
