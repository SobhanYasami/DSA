// h1 -- Binary Search Algorithm Implementation in C
// h2 -- Efficient search algorithm for sorted arrays using divide and conquer
// h2 -- Includes performance timing and comprehensive testing

#include <stdio.h>
#include <time.h>   // For clock() and timing functions
#include <stdlib.h> // For malloc() and free()

// h3 -- Binary Search Function
// h4 -- Searches for target in sorted array using divide and conquer approach
// h5 -- arr[]: Sorted integer array to search through
// h5 -- size: Number of elements in the array
// h5 -- target: Value to search for
// h6 -- Returns: Index of target if found, -1 if not found
// h6 -- Time Complexity: O(log n) - logarithmic time
// h6 -- Space Complexity: O(1) - constant space (iterative implementation)
// h6 -- Note: Array must be sorted for algorithm to work correctly
int binary_search(int arr[], int size, int target)
{
    int low = 0;
    int high = size - 1;

    while (low <= high)
    {
        // Calculate mid index without potential integer overflow
        // Using low + (high - low) / 2 instead of (low + high) / 2
        int mid = low + (high - low) / 2;

        if (arr[mid] == target)
            return mid; // Found at index mid
        else if (arr[mid] < target)
            low = mid + 1; // Search right half
        else
            high = mid - 1; // Search left half
    }
    return -1; // Not found
}

// h3 -- Performance Test Function
// h4 -- Tests binary search performance with large sorted arrays
// h5 -- size: Size of test array to generate
// h6 -- Measures execution time for multiple search operations
void performance_test(int size)
{
    // Don't test with invalid sizes
    if (size <= 0)
    {
        printf("Invalid size for performance test: %d\n", size);
        return;
    }

    // Allocate memory for large test array
    int *large_arr = (int *)malloc(size * sizeof(int));
    if (large_arr == NULL)
    {
        printf("Memory allocation failed for size %d!\n", size);
        return;
    }

    // Initialize array with sorted sequential values
    for (int i = 0; i < size; i++)
    {
        large_arr[i] = i * 2; // Even numbers for predictable searching
    }

    // Test different target positions
    int targets[] = {
        large_arr[0],        // Best case: first element
        large_arr[size / 2], // Average case: middle element
        large_arr[size - 1], // Worst case: last element
        -1                   // Not found case
    };
    const char *cases[] = {"best", "average", "worst", "not found"};

    printf("Performance Test (Size: %d):\n", size);

    // Warm up the function
    for (int i = 0; i < 10; i++)
    {
        binary_search(large_arr, size, large_arr[size / 2]);
    }

    // Test each case with multiple iterations
    const int iterations = 10000;
    for (int t = 0; t < 4; t++)
    {
        clock_t total_time = 0;
        int found_count = 0;

        for (int iter = 0; iter < iterations; iter++)
        {
            clock_t start = clock();
            int result = binary_search(large_arr, size, targets[t]);
            clock_t end = clock();
            total_time += (end - start);

            if (result != -1)
            {
                found_count++;
            }
        }

        double avg_time = ((double)total_time / iterations) / CLOCKS_PER_SEC;
        printf("  %s case: %.6f seconds (success: %d/%d)\n",
               cases[t], avg_time, found_count, iterations);
    }

    free(large_arr);
}

// h3 -- Validation Test Function
// h4 -- Tests binary search with various test cases
void validation_tests()
{
    printf("Validation Tests:\n");

    // Test case 1: Normal sorted array
    int arr1[] = {2, 4, 6, 8, 10, 12, 14};
    int size1 = sizeof(arr1) / sizeof(arr1[0]);
    int result1 = binary_search(arr1, size1, 10);
    printf("  Search for 10 in [2,4,6,8,10,12,14]: index %d (expected: 4)\n", result1);

    // Test case 2: First element
    int result2 = binary_search(arr1, size1, 2);
    printf("  Search for 2 (first element): index %d (expected: 0)\n", result2);

    // Test case 3: Last element
    int result3 = binary_search(arr1, size1, 14);
    printf("  Search for 14 (last element): index %d (expected: 6)\n", result3);

    // Test case 4: Not found
    int result4 = binary_search(arr1, size1, 5);
    printf("  Search for 5 (not present): index %d (expected: -1)\n", result4);

    // Test case 5: Single element array
    int single_arr[] = {42};
    int result5 = binary_search(single_arr, 1, 42);
    printf("  Search in single element [42]: index %d (expected: 0)\n", result5);

    // Test case 6: Single element not found
    int result6 = binary_search(single_arr, 1, 99);
    printf("  Search for 99 in [42]: index %d (expected: -1)\n", result6);

    // Test case 7: Empty array
    int *empty_arr = NULL;
    int result7 = binary_search(empty_arr, 0, 5);
    printf("  Search in empty array: index %d (expected: -1)\n", result7);
}

// h3 -- Print Array Helper Function
// h4 -- Utility to print array contents
void print_array(int arr[], int size)
{
    printf("[");
    for (int i = 0; i < size; i++)
    {
        printf("%d", arr[i]);
        if (i < size - 1)
        {
            printf(", ");
        }
    }
    printf("]");
}

int main()
{
    printf("=== BINARY SEARCH ALGORITHM - C IMPLEMENTATION ===\n\n");

    // h3 -- Basic Functionality Test
    // h4 -- Demonstrates basic binary search with sorted array
    printf("1. BASIC FUNCTIONALITY TEST\n");
    printf("===========================\n");

    int arr[] = {2, 4, 6, 8, 10, 12, 14};
    int size = sizeof(arr) / sizeof(arr[0]);
    int target = 10;

    printf("Array: ");
    print_array(arr, size);
    printf("\n");
    printf("Target: %d\n", target);

    int index = binary_search(arr, size, target);
    if (index != -1)
    {
        printf("Result: Found %d at index %d\n", target, index);
    }
    else
    {
        printf("Result: Not found\n");
    }

    // h3 -- Validation Tests
    // h4 -- Comprehensive testing of edge cases
    printf("\n2. VALIDATION TESTS\n");
    printf("===================\n");
    validation_tests();

    // h3 -- Performance Tests
    // h4 -- Measure performance with different array sizes
    printf("\n\n3. PERFORMANCE TESTS\n");
    printf("===================\n");
    printf("Note: Testing 10,000 iterations per case\n");
    printf("      Array contains even numbers [0, 2, 4, ...]\n\n");

    // Test with different array sizes
    performance_test(1000);    // 1K elements
    performance_test(10000);   // 10K elements
    performance_test(100000);  // 100K elements
    performance_test(1000000); // 1M elements

    // h3 -- Algorithm Analysis
    // h4 -- Educational summary of binary search characteristics
    printf("\n\n4. ALGORITHM ANALYSIS\n");
    printf("====================\n");
    printf("Time Complexity: O(log n) - logarithmic time\n");
    printf("  Best case: O(1) - target is middle element\n");
    printf("  Average case: O(log n) - typical case\n");
    printf("  Worst case: O(log n) - target at ends or not present\n\n");

    printf("Space Complexity: O(1) - constant space (iterative)\n");
    printf("  Alternative recursive: O(log n) - call stack depth\n\n");

    printf("Mathematical Analysis:\n");
    printf("  Maximum comparisons: log₂(n) + 1\n");
    printf("  For 1M elements: ~20 comparisons vs 1M for linear search\n");
    printf("  Doubling input size adds only 1 more comparison\n\n");

    printf("Key Requirements:\n");
    printf("  ✓ Array must be sorted\n");
    printf("  ✓ Random access to elements (arrays, not linked lists)\n\n");

    printf("Comparison with Linear Search:\n");
    printf("  Binary Search: O(log n) time, O(1) space (iterative)\n");
    printf("  Linear Search: O(n) time, O(1) space\n");
    printf("  For 1M elements: 20 ops vs 1M ops (50,000x faster!)\n\n");

    printf("Use Cases:\n");
    printf("  ✓ Large sorted datasets\n");
    printf("  ✓ Frequent search operations\n");
    printf("  ✓ Static or infrequently changed data\n");
    printf("  ✓ Applications requiring fast lookup times\n");

    return 0;
}