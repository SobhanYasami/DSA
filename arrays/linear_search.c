// h1 -- Linear Search Algorithm Implementation in C
// h2 -- Simple linear search that sequentially checks each element
// h2 -- Includes proper performance timing and validation

#include <stdio.h>
#include <time.h>   // For clock() and timing functions
#include <stdlib.h> // For rand() and srand()

// h3 -- Linear Search Function
// h4 -- Searches for target value in array by checking each element sequentially
// h5 -- arr[]: Integer array to search through
// h5 -- size: Number of elements in the array
// h5 -- target: Value to search for
// h6 -- Returns: Index of target if found, -1 if not found
// h6 -- Time Complexity: O(n) - linear time
// h6 -- Space Complexity: O(1) - constant space
int linear_search(int arr[], int size, int target)
{
    // Handle empty array case immediately
    if (size <= 0)
    {
        return -1;
    }

    for (int i = 0; i < size; i++)
    {
        if (arr[i] == target)
            return i; // Found at index i
    }
    return -1; // Not found
}

// h3 -- Performance Test Function
// h4 -- Tests linear search performance with proper timing
// h5 -- size: Size of test array to generate
// h6 -- Uses multiple iterations for accurate timing
void performance_test(int size)
{
    // Don't test with size 0
    if (size <= 0)
    {
        printf("Invalid size for performance test: %d\n", size);
        return;
    }

    // Allocate memory for test array
    int *large_arr = (int *)malloc(size * sizeof(int));
    if (large_arr == NULL)
    {
        printf("Memory allocation failed for size %d!\n", size);
        return;
    }

    // Initialize array with sequential values
    for (int i = 0; i < size; i++)
    {
        large_arr[i] = i; // Sequential for consistent testing
    }

    // Set target to last element for worst-case scenario
    int target = size - 1;

    // Warm up the cache (run a few times)
    for (int warmup = 0; warmup < 10; warmup++)
    {
        linear_search(large_arr, size, target);
    }

    // Time multiple iterations for accuracy
    const int iterations = 1000;
    clock_t total_time = 0;
    int found_count = 0;

    for (int iter = 0; iter < iterations; iter++)
    {
        clock_t start = clock();
        int result = linear_search(large_arr, size, target);
        clock_t end = clock();
        total_time += (end - start);

        if (result != -1)
        {
            found_count++;
        }
    }

    double avg_cpu_time_used = ((double)total_time / iterations) / CLOCKS_PER_SEC;

    printf("Performance Test (Size: %d):\n", size);
    printf("  Target: %d (worst case - last element)\n", target);
    printf("  Average execution time: %.6f seconds\n", avg_cpu_time_used);
    printf("  Time per element: %.9f seconds\n", avg_cpu_time_used / size);
    printf("  Total iterations: %d\n", iterations);
    printf("  Success rate: %d/%d\n", found_count, iterations);

    free(large_arr);
}

// h3 -- Validate Search Function
// h4 -- Tests the linear search with various test cases
void validate_search()
{
    printf("Search Validation Tests:\n");

    // Test case 1: Normal array
    int arr1[] = {5, 3, 8, 4, 2};
    int size1 = sizeof(arr1) / sizeof(arr1[0]);
    int result1 = linear_search(arr1, size1, 4);
    printf("  Search for 4 in [5,3,8,4,2]: index %d (expected: 3)\n", result1);

    // Test case 2: First element
    int result2 = linear_search(arr1, size1, 5);
    printf("  Search for 5 (first element): index %d (expected: 0)\n", result2);

    // Test case 3: Last element
    int result3 = linear_search(arr1, size1, 2);
    printf("  Search for 2 (last element): index %d (expected: 4)\n", result3);

    // Test case 4: Not found
    int result4 = linear_search(arr1, size1, 9);
    printf("  Search for 9 (not present): index %d (expected: -1)\n", result4);

    // Test case 5: Single element array
    int single_arr[] = {42};
    int result5 = linear_search(single_arr, 1, 42);
    printf("  Search in single element [42]: index %d (expected: 0)\n", result5);

    // Test case 6: Single element not found
    int result6 = linear_search(single_arr, 1, 99);
    printf("  Search for 99 in [42]: index %d (expected: -1)\n", result6);

    // Test case 7: Duplicate elements (should find first occurrence)
    int dup_arr[] = {1, 2, 3, 2, 1};
    int result7 = linear_search(dup_arr, 5, 2);
    printf("  Search for 2 in [1,2,3,2,1]: index %d (expected: 1)\n", result7);
}

// h3 -- Empty Array Test (Separate function)
// h4 -- Specifically tests the empty array case safely
void test_empty_array()
{
    printf("\nEmpty Array Test:\n");
    // Create a pointer to simulate empty array rather than zero-sized array
    int *empty_arr_ptr = NULL;
    int result = linear_search(empty_arr_ptr, 0, 5);
    printf("  Search in empty array (size 0): index %d (expected: -1)\n", result);
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
    // Seed random number generator
    srand((unsigned int)time(NULL));

    printf("=== LINEAR SEARCH ALGORITHM - C IMPLEMENTATION ===\n\n");

    // h3 -- Basic Functionality Test
    // h4 -- Demonstrates basic linear search with small array
    printf("1. BASIC FUNCTIONALITY TEST\n");
    printf("===========================\n");

    int arr[] = {5, 3, 8, 4, 2};
    int size = sizeof(arr) / sizeof(arr[0]);
    int target = 4;

    printf("Array: ");
    print_array(arr, size);
    printf("\n");
    printf("Target: %d\n", target);

    int index = linear_search(arr, size, target);
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
    validate_search();
    test_empty_array();

    // h3 -- Performance Tests
    // h4 -- Measure performance with different array sizes
    printf("\n\n3. PERFORMANCE TESTS\n");
    printf("===================\n");
    printf("Note: Testing worst-case scenario (target at end)\n");
    printf("      Averaging over 1000 iterations for accuracy\n");
    printf("      CLOCKS_PER_SEC = %ld\n\n", CLOCKS_PER_SEC);

    // Test with different array sizes
    performance_test(100);    // 100 elements
    performance_test(1000);   // 1K elements
    performance_test(10000);  // 10K elements
    performance_test(100000); // 100K elements

    // h3 -- Complexity Verification
    // h4 -- Demonstrate O(n) time complexity
    printf("\n4. COMPLEXITY VERIFICATION\n");
    printf("=========================\n");
    printf("To verify O(n) time complexity:\n");
    printf("  - As array size increases by 10x, time should increase by ~10x\n");
    printf("  - Time per element should remain approximately constant\n");
    printf("  - This confirms linear relationship between size and time\n");

    // h3 -- Algorithm Analysis
    // h4 -- Educational summary of linear search characteristics
    printf("\n\n5. ALGORITHM ANALYSIS\n");
    printf("====================\n");
    printf("Time Complexity Analysis:\n");
    printf("  Best case: O(1) - target is first element\n");
    printf("  Average case: O(n) - target is in the middle\n");
    printf("  Worst case: O(n) - target is last element or not present\n\n");

    printf("Space Complexity: O(1) - constant space\n");
    printf("  - Only uses fixed number of variables: i, size, target\n");
    printf("  - No additional memory allocation during search\n\n");

    printf("Mathematical Analysis:\n");
    printf("  Let n = number of elements\n");
    printf("  Expected comparisons = (n + 1) / 2 (uniform distribution)\n");
    printf("  Maximum comparisons = n (worst case)\n");
    printf("  Minimum comparisons = 1 (best case)\n\n");

    printf("Use Cases and Recommendations:\n");
    printf("  ✓ Small datasets (< 1000 elements)\n");
    printf("  ✓ Unsorted data where sorting cost > search cost\n");
    printf("  ✓ Frequently updated data\n");
    printf("  ✓ Simple implementations where code clarity is important\n");
    printf("  ✓ Educational purposes and algorithm understanding\n");
    printf("  ✗ Large sorted datasets (use binary search - O(log n))\n");
    printf("  ✗ Frequent searches on static data (use hash table - O(1))\n");
    printf("  ✗ Real-time systems with strict timing requirements\n\n");

    printf("Compiler Information:\n");
    printf("  - Compiler: gcc\n");
    printf("  - Optimization: Can use -O2 for better performance\n");
    printf("  - Warning flags: -Wall -Wextra for comprehensive checking\n");

    return 0;
}