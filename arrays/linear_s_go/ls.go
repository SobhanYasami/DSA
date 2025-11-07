// h1 -- Linear Search Algorithm Implementation in Go
// h2 -- Go implementation using slices and range loops
// h2 -- Includes proper benchmarking and performance comparison

package main

import (
	"fmt"
	"math/rand"
	"time"
)

// h3 -- Linear Search Function
// h4 -- Searches for target using Go's range loop with index and value
// h5 -- arr: Slice of integers to search through
// h5 -- target: Value to search for
// h6 -- Returns: Index of target if found, -1 if not found
// h6 -- Uses Go's multiple return values from range
// h6 -- Time Complexity: O(n), Space Complexity: O(1)
func linearSearch(arr []int, target int) int {
	for i, v := range arr {
		if v == target {
			return i
		}
	}
	return -1
}

// h3 -- Performance Test Function
// h4 -- Tests search performance with large slices
// h5 -- size: Size of test slice to generate
// h6 -- Uses proper timing and ensures worst-case scenario
func performanceTest(size int) {
	// Create slice with specified capacity
	largeArr := make([]int, size)

	// Initialize with sequential values (not random for consistency)
	for i := 0; i < size; i++ {
		largeArr[i] = i
	}

	// Set target to last element for worst-case performance
	target := size - 1

	// Warm up the function (run once to avoid cold start)
	linearSearch(largeArr, target)

	// Time multiple iterations for more accurate measurement
	const iterations = 1000
	start := time.Now()

	for i := 0; i < iterations; i++ {
		linearSearch(largeArr, target)
	}

	elapsed := time.Since(start)
	averageTime := elapsed / time.Duration(iterations)

	fmt.Printf("Performance Test (Size: %d):\n", size)
	fmt.Printf("  Target: %d (worst case - last element)\n", target)
	fmt.Printf("  Average execution time: %v\n", averageTime)
	fmt.Printf("  Time per element: %v\n", averageTime/time.Duration(size))
	fmt.Printf("  Total iterations: %d\n", iterations)
}

func main() {
	// Seed random number generator
	rand.Seed(time.Now().UnixNano())

	fmt.Println("=== LINEAR SEARCH ALGORITHM - GO IMPLEMENTATION ===")
	fmt.Println()

	// h3 -- Basic Functionality Test
	// h4 -- Demonstrates basic linear search with slice
	fmt.Println("1. BASIC FUNCTIONALITY TEST")
	fmt.Println("===========================")

	arr := []int{5, 3, 8, 4, 2}
	target := 4

	fmt.Printf("Array: %v\n", arr)
	fmt.Printf("Target: %d\n", target)

	index := linearSearch(arr, target)
	if index != -1 {
		fmt.Printf("Result: Found %d at index %d\n", target, index)
	} else {
		fmt.Println("Result: Not found")
	}

	// Test edge cases
	fmt.Println("\nEdge Case Tests:")

	// Test first element
	index = linearSearch(arr, 5)
	fmt.Printf("Search for 5 (first element): index %d\n", index)

	// Test last element
	index = linearSearch(arr, 2)
	fmt.Printf("Search for 2 (last element): index %d\n", index)

	// Test not found
	index = linearSearch(arr, 9)
	fmt.Printf("Search for 9 (not present): index %d\n", index)

	// h3 -- Performance Tests
	// h4 -- Measure performance with different slice sizes
	fmt.Println("\n\n2. PERFORMANCE TESTS")
	fmt.Println("===================")
	fmt.Println("Note: Testing worst-case scenario (target at end)")
	fmt.Println("      Averaging over 1000 iterations for accuracy")

	// Test with different slice sizes
	performanceTest(1000)   // 1K elements
	performanceTest(10000)  // 10K elements
	performanceTest(100000) // 100K elements

	// h3 -- Performance Analysis
	// h4 -- Analyze the performance characteristics
	fmt.Println("\n\n3. PERFORMANCE ANALYSIS")
	fmt.Println("======================")
	fmt.Println("Observations from performance tests:")
	fmt.Println("  - Execution time grows linearly with input size")
	fmt.Println("  - Confirms O(n) time complexity")
	fmt.Println("  - Go's bounds checking adds minimal overhead")
	fmt.Println("  - Memory access patterns affect real performance")

	fmt.Println("\nPerformance Optimization Tips:")
	fmt.Println("  - Use binary search for sorted data (O(log n))")
	fmt.Println("  - Consider hash tables for frequent searches (O(1))")
	fmt.Println("  - For small arrays, linear search is often fastest")
	fmt.Println("  - Profile with real data patterns, not just worst-case")

	// h3 -- Algorithm Analysis
	// h4 -- Educational summary
	fmt.Println("\n\n4. ALGORITHM ANALYSIS")
	fmt.Println("====================")
	fmt.Println("Time Complexity: O(n) - linear time")
	fmt.Println("Space Complexity: O(1) - constant space")

	fmt.Println("\nMathematical Analysis:")
	fmt.Println("  Let n = number of elements")
	fmt.Println("  Comparisons in worst case: n")
	fmt.Println("  Comparisons in average case: n/2")
	fmt.Println("  Comparisons in best case: 1")

	fmt.Println("\nCharacteristics:")
	fmt.Println("  + Simple to implement and understand")
	fmt.Println("  + Works on unsorted data")
	fmt.Println("  + No pre-processing required")
	fmt.Println("  + Cache-friendly (sequential memory access)")
	fmt.Println("  - Inefficient for large datasets")
	fmt.Println("  - Poor performance compared to binary search on sorted data")

	fmt.Println("\nPractical Considerations:")
	fmt.Println("  - Excellent choice for arrays with < 100 elements")
	fmt.Println("  - Often faster than binary search for very small arrays")
	fmt.Println("  - Preferred when data changes frequently")
	fmt.Println("  - Useful as a building block for more complex algorithms")
}
