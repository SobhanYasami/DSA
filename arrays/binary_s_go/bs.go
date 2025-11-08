// h1 -- Binary Search Algorithm Implementation in Go
// h2 -- Efficient search for sorted slices using divide and conquer
// h2 -- Includes performance benchmarking and comprehensive testing

package main

import (
	"fmt"
	"time"
)

// h3 -- Binary Search Function
// h4 -- Searches for target in sorted slice using iterative approach
// h5 -- arr: Sorted slice of integers to search through
// h5 -- target: Value to search for
// h6 -- Returns: Index of target if found, -1 if not found
// h6 -- Time Complexity: O(log n) - logarithmic time
// h6 -- Space Complexity: O(1) - constant space
// h6 -- Note: Slice must be sorted in ascending order
func binarySearch(arr []int, target int) int {
	low := 0
	high := len(arr) - 1

	for low <= high {
		// Prevent integer overflow with this calculation
		mid := low + (high-low)/2

		if arr[mid] == target {
			return mid // Found at index mid
		} else if arr[mid] < target {
			low = mid + 1 // Search right half
		} else {
			high = mid - 1 // Search left half
		}
	}
	return -1 // Not found
}

// h3 -- Performance Test Function
// h4 -- Tests binary search performance with large sorted slices
// h5 -- size: Size of test slice to generate
// h6 -- Uses Go's time package for precise timing
func performanceTest(size int) {
	if size <= 0 {
		fmt.Printf("Invalid size for performance test: %d\n", size)
		return
	}

	// Create slice with sorted sequential values
	largeArr := make([]int, size)
	for i := 0; i < size; i++ {
		largeArr[i] = i * 2 // Even numbers for predictable searching
	}

	// Test different target positions
	targets := []int{
		largeArr[0],      // Best case: first element
		largeArr[size/2], // Average case: middle element
		largeArr[size-1], // Worst case: last element
		-1,               // Not found case
	}
	cases := []string{"best", "average", "worst", "not found"}

	fmt.Printf("Performance Test (Size: %d):\n", size)

	// Warm up the function
	for i := 0; i < 10; i++ {
		binarySearch(largeArr, largeArr[size/2])
	}

	// Test each case with multiple iterations
	const iterations = 10000
	for t, target := range targets {
		totalDuration := time.Duration(0)
		foundCount := 0

		for iter := 0; iter < iterations; iter++ {
			start := time.Now()
			result := binarySearch(largeArr, target)
			elapsed := time.Since(start)
			totalDuration += elapsed

			if result != -1 {
				foundCount++
			}
		}

		avgDuration := totalDuration / time.Duration(iterations)
		fmt.Printf("  %s case: %v (success: %d/%d)\n",
			cases[t], avgDuration, foundCount, iterations)
	}
}

// h3 -- Validation Test Function
// h4 -- Tests binary search with various test cases
func validationTests() {
	fmt.Println("Validation Tests:")

	// Test case 1: Normal sorted slice
	arr1 := []int{2, 4, 6, 8, 10, 12, 14}
	result1 := binarySearch(arr1, 10)
	fmt.Printf("  Search for 10 in %v: index %d (expected: 4)\n", arr1, result1)

	// Test case 2: First element
	result2 := binarySearch(arr1, 2)
	fmt.Printf("  Search for 2 (first element): index %d (expected: 0)\n", result2)

	// Test case 3: Last element
	result3 := binarySearch(arr1, 14)
	fmt.Printf("  Search for 14 (last element): index %d (expected: 6)\n", result3)

	// Test case 4: Not found
	result4 := binarySearch(arr1, 5)
	fmt.Printf("  Search for 5 (not present): index %d (expected: -1)\n", result4)

	// Test case 5: Single element slice
	singleArr := []int{42}
	result5 := binarySearch(singleArr, 42)
	fmt.Printf("  Search in single element [42]: index %d (expected: 0)\n", result5)

	// Test case 6: Single element not found
	result6 := binarySearch(singleArr, 99)
	fmt.Printf("  Search for 99 in [42]: index %d (expected: -1)\n", result6)

	// Test case 7: Empty slice
	emptyArr := []int{}
	result7 := binarySearch(emptyArr, 5)
	fmt.Printf("  Search in empty slice: index %d (expected: -1)\n", result7)

	// Test case 8: Duplicate values (finds first occurrence in sorted array)
	dupArr := []int{1, 2, 2, 2, 3, 4, 5}
	result8 := binarySearch(dupArr, 2)
	fmt.Printf("  Search for 2 in %v: index %d (finds an occurrence)\n", dupArr, result8)
}

func main() {
	fmt.Println("=== BINARY SEARCH ALGORITHM - GO IMPLEMENTATION ===")
	fmt.Println()

	// h3 -- Basic Functionality Test
	// h4 -- Demonstrates basic binary search with sorted slice
	fmt.Println("1. BASIC FUNCTIONALITY TEST")
	fmt.Println("===========================")

	arr := []int{2, 4, 6, 8, 10, 12, 14}
	target := 10

	fmt.Printf("Array: %v\n", arr)
	fmt.Printf("Target: %d\n", target)

	index := binarySearch(arr, target)
	if index != -1 {
		fmt.Printf("Result: Found %d at index %d\n", target, index)
	} else {
		fmt.Println("Result: Not found")
	}

	// h3 -- Validation Tests
	// h4 -- Comprehensive testing of edge cases
	fmt.Println("\n2. VALIDATION TESTS")
	fmt.Println("===================")
	validationTests()

	// h3 -- Performance Tests
	// h4 -- Measure performance with different slice sizes
	fmt.Println("\n\n3. PERFORMANCE TESTS")
	fmt.Println("===================")
	fmt.Println("Note: Testing 10,000 iterations per case")
	fmt.Println("      Slice contains even numbers [0, 2, 4, ...]")
	fmt.Println()

	// Test with different slice sizes
	performanceTest(1000)    // 1K elements
	performanceTest(10000)   // 10K elements
	performanceTest(100000)  // 100K elements
	performanceTest(1000000) // 1M elements

	// h3 -- Algorithm Analysis
	// h4 -- Educational summary of binary search characteristics
	fmt.Println("\n\n4. ALGORITHM ANALYSIS")
	fmt.Println("====================")
	fmt.Println("Time Complexity: O(log n) - logarithmic time")
	fmt.Println("  Each step halves the search space")
	fmt.Println("  Extremely efficient for large datasets")
	fmt.Println()

	fmt.Println("Space Complexity: O(1) - constant space")
	fmt.Println("  Iterative implementation uses fixed variables")
	fmt.Println("  No recursive call stack overhead")
	fmt.Println()

	fmt.Println("Mathematical Insights:")
	fmt.Println("  Maximum comparisons: ⌊log₂n⌋ + 1")
	fmt.Println("  For 1 billion elements: only ~30 comparisons needed")
	fmt.Println("  Doubling input size adds just 1 more comparison")
	fmt.Println()

	fmt.Println("Comparison with Other Search Algorithms:")
	fmt.Println("  vs Linear Search: O(log n) vs O(n) - exponential speedup")
	fmt.Println("  vs Hash Tables: O(log n) vs O(1) but maintains order")
	fmt.Println("  vs Binary Search Trees: same complexity but simpler")
	fmt.Println()

	fmt.Println("Optimal Use Cases:")
	fmt.Println("  ✓ Large sorted datasets (1K+ elements)")
	fmt.Println("  ✓ Static or rarely modified data")
	fmt.Println("  ✓ Memory-constrained environments")
	fmt.Println("  ✓ Applications requiring predictable performance")
	fmt.Println()

	fmt.Println("Go-Specific Advantages:")
	fmt.Println("  - Slice bounds checking prevents errors")
	fmt.Println("  - Clean, readable syntax")
	fmt.Println("  - Efficient memory management")
	fmt.Println("  - Built-in benchmarking support")
}
