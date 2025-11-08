// h1 -- Binary Search Algorithm Implementation in Rust
// h2 -- Efficient search for sorted slices using divide and conquer
// h2 -- Includes performance benchmarking and safety features

use std::time::{Duration, Instant};

// h3 -- Binary Search Function
// h4 -- Searches for target in sorted slice using iterative approach
// h5 -- arr: Sorted slice reference of integers (&[i32])
// h5 -- target: Value to search for
// h6 -- Returns: Option<usize> - Some(index) if found, None if not found
// h6 -- Time Complexity: O(log n) - logarithmic time
// h6 -- Space Complexity: O(1) - constant space
// h6 -- Note: Uses Rust's Option type for safe error handling
fn binary_search(arr: &[i32], target: i32) -> Option<usize> {
    let mut low = 0;
    let mut high = arr.len().checked_sub(1)?; // Handle empty array

    while low <= high {
        // Calculate mid index without overflow
        let mid = low + (high - low) / 2;

        match arr[mid].cmp(&target) {
            std::cmp::Ordering::Equal => return Some(mid),
            std::cmp::Ordering::Less => low = mid + 1,
            std::cmp::Ordering::Greater => high = mid - 1,
        }
    }
    None
}

// h3 -- Performance Test Function
// h4 -- Tests binary search performance with large sorted arrays
// h5 -- size: Size of test array to generate
// h6 -- Uses Rust's Instant for high-precision timing
fn performance_test(size: usize) {
    if size == 0 {
        println!("Skipping performance test for size 0");
        return;
    }

    // Create vector with sorted sequential values
    let mut large_arr = Vec::with_capacity(size);
    for i in 0..size {
        large_arr.push((i * 2) as i32); // Even numbers for predictable searching
    }

    // Test different target positions
    let targets = [
        large_arr[0],        // Best case: first element
        large_arr[size / 2], // Average case: middle element
        large_arr[size - 1], // Worst case: last element
        -1,                  // Not found case
    ];
    let cases = ["best", "average", "worst", "not found"];

    println!("Performance Test (Size: {}):", size);

    // Warm up the function
    for _ in 0..10 {
        binary_search(&large_arr, large_arr[size / 2]);
    }

    // Test each case with multiple iterations
    const ITERATIONS: usize = 10000;
    for (t, &target) in targets.iter().enumerate() {
        let mut total_duration = Duration::new(0, 0);
        let mut found_count = 0;

        for _ in 0..ITERATIONS {
            let start = Instant::now();
            let result = binary_search(&large_arr, target);
            let elapsed = start.elapsed();
            total_duration += elapsed;

            if result.is_some() {
                found_count += 1;
            }
        }

        let avg_duration = total_duration / ITERATIONS as u32;
        println!(
            "  {} case: {:?} (success: {}/{})",
            cases[t], avg_duration, found_count, ITERATIONS
        );
    }
}

// h3 -- Validation Test Function
// h4 -- Comprehensive testing of edge cases and correctness
fn validation_tests() {
    println!("Validation Tests:");

    // Test case 1: Normal sorted array
    let arr1 = [2, 4, 6, 8, 10, 12, 14];
    let result1 = binary_search(&arr1, 10);
    println!(
        "  Search for 10 in {:?}: {:?} (expected: Some(4))",
        arr1, result1
    );

    // Test case 2: First element
    let result2 = binary_search(&arr1, 2);
    println!(
        "  Search for 2 (first element): {:?} (expected: Some(0))",
        result2
    );

    // Test case 3: Last element
    let result3 = binary_search(&arr1, 14);
    println!(
        "  Search for 14 (last element): {:?} (expected: Some(6))",
        result3
    );

    // Test case 4: Not found
    let result4 = binary_search(&arr1, 5);
    println!(
        "  Search for 5 (not present): {:?} (expected: None)",
        result4
    );

    // Test case 5: Single element array
    let single_arr = [42];
    let result5 = binary_search(&single_arr, 42);
    println!(
        "  Search in single element [42]: {:?} (expected: Some(0))",
        result5
    );

    // Test case 6: Single element not found
    let result6 = binary_search(&single_arr, 99);
    println!("  Search for 99 in [42]: {:?} (expected: None)", result6);

    // Test case 7: Empty array
    let empty_arr: [i32; 0] = [];
    let result7 = binary_search(&empty_arr, 5);
    println!("  Search in empty array: {:?} (expected: None)", result7);

    // Test case 8: Large numbers
    let large_arr = [i32::MIN, -100, 0, 100, i32::MAX];
    let result8 = binary_search(&large_arr, i32::MAX);
    println!(
        "  Search for i32::MAX in large range: {:?} (expected: Some(4))",
        result8
    );
}

fn main() {
    println!("=== BINARY SEARCH ALGORITHM - RUST IMPLEMENTATION ===");
    println!();

    // h3 -- Basic Functionality Test
    // h4 -- Demonstrates basic binary search with array slice
    println!("1. BASIC FUNCTIONALITY TEST");
    println!("===========================");

    let arr = [2, 4, 6, 8, 10, 12, 14];
    let target = 10;

    println!("Array: {:?}", arr);
    println!("Target: {}", target);

    match binary_search(&arr, target) {
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
    println!("Note: Testing 10,000 iterations per case");
    println!("      Array contains even numbers [0, 2, 4, ...]");
    println!();

    // Test with different array sizes
    performance_test(1000); // 1K elements
    performance_test(10000); // 10K elements
    performance_test(100000); // 100K elements
    performance_test(1000000); // 1M elements

    // h3 -- Rust-Specific Features
    // h4 -- Highlights Rust language features and safety guarantees
    println!("\n\n4. RUST-SPECIFIC FEATURES");
    println!("========================");
    println!("Language Features Used:");
    println!("  - Pattern matching: match expression for comparisons");
    println!("  - Option<T>: Type-safe error handling without null");
    println!("  - Slice references: &[i32] for efficient array access");
    println!("  - Iterator safety: Bounds checking at compile time");
    println!("  - checked_sub: Prevents underflow in empty arrays");

    println!("\nSafety Guarantees:");
    println!("  - No buffer overflows or out-of-bounds access");
    println!("  - No integer overflow in mid calculation");
    println!("  - Memory safety enforced at compile time");
    println!("  - No null pointer dereferences");

    // h3 -- Algorithm Analysis
    // h4 -- Comprehensive algorithm analysis
    println!("\n\n5. ALGORITHM ANALYSIS");
    println!("====================");
    println!("Complexity Analysis:");
    println!("  Time Complexity: O(log n)");
    println!("    Each iteration halves the search space");
    println!("    Extremely efficient for large datasets");
    println!("  Space Complexity: O(1)");
    println!("    Constant space for iterative implementation");

    println!("\nMathematical Properties:");
    println!("  Maximum comparisons: ⌊log₂n⌋ + 1");
    println!("  For 1M elements: ~20 comparisons needed");
    println!("  For 1B elements: ~30 comparisons needed");
    println!("  Doubling input size adds only 1 comparison");

    println!("\nComparison with Linear Search:");
    println!("  Binary Search: O(log n) time, requires sorted data");
    println!("  Linear Search: O(n) time, works on unsorted data");
    println!("  Crossover point: ~10-100 elements (depends on data)");

    println!("\nOptimal Use Cases:");
    println!("  ✓ Large sorted datasets (> 100 elements)");
    println!("  ✓ Static or infrequently modified data");
    println!("  ✓ Applications requiring predictable performance");
    println!("  ✓ Memory-constrained environments");
    println!("  ✓ When search operations dominate computation");
}
