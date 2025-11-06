#include <stdio.h>
#include <stdlib.h> // Added for malloc and free

// Function to calculate address for 1D array
void *calculate_1d_address(void *base, int i, size_t element_size)
{
    return (char *)base + i * element_size;
}

// Function to calculate address for 2D array (Row-major)
void *calculate_2d_row_major(void *base, int i, int j, int cols, size_t element_size)
{
    return (char *)base + (i * cols + j) * element_size;
}

// Function to calculate address for 2D array (Column-major)
void *calculate_2d_col_major(void *base, int i, int j, int rows, size_t element_size)
{
    return (char *)base + (j * rows + i) * element_size;
}

// Function to calculate address for 3D array (Row-major)
void *calculate_3d_row_major(void *base, int i, int j, int k, int cols, int depth, size_t element_size)
{
    return (char *)base + ((i * cols * depth) + (j * depth) + k) * element_size;
}

// Function to calculate address for 3D array (Column-major)
void *calculate_3d_col_major(void *base, int i, int j, int k, int rows, int cols, size_t element_size)
{
    return (char *)base + ((k * rows * cols) + (j * rows) + i) * element_size;
}

// Generic function for n-dimensional array (Row-major)
void *calculate_nd_row_major(void *base, int indices[], int dimensions[], int n, size_t element_size)
{
    int offset = 0;
    int multiplier = 1;

    // Calculate offset using formula: (i0 * d1 * d2 * ... * d_{n-1}) + (i1 * d2 * ... * d_{n-1}) + ... + i_{n-1}
    for (int dim = 0; dim < n; dim++)
    {
        multiplier = 1;
        for (int next_dim = dim + 1; next_dim < n; next_dim++)
        {
            multiplier *= dimensions[next_dim];
        }
        offset += indices[dim] * multiplier;
    }

    return (char *)base + offset * element_size;
}

// Generic function for n-dimensional array (Column-major)
void *calculate_nd_col_major(void *base, int indices[], int dimensions[], int n, size_t element_size)
{
    int offset = 0;
    int multiplier = 1;

    // Calculate offset using formula: i_{n-1} + i_{n-2} * d_{n-1} + i_{n-3} * d_{n-1} * d_{n-2} + ...
    for (int dim = n - 1; dim >= 0; dim--)
    {
        multiplier = 1;
        for (int prev_dim = n - 1; prev_dim > dim; prev_dim--)
        {
            multiplier *= dimensions[prev_dim];
        }
        offset += indices[dim] * multiplier;
    }

    return (char *)base + offset * element_size;
}

void print_array_2d(float arr[], int rows, int cols)
{
    printf("Array contents:\n");
    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            printf("%6.1f", arr[i * cols + j]);
        }
        printf("\n");
    }
}

int main()
{
    printf("=== MEMORY ADDRESS CALCULATIONS FOR N-DIMENSIONAL ARRAYS ===\n\n");

    // One Dimension Array
    printf("1. ONE-DIMENSIONAL ARRAY\n");
    printf("========================\n");
    float A[10];

    // Initialize 1D array
    for (int i = 0; i < 10; i++)
    {
        A[i] = i * 10.0f;
    }

    printf("Real memory addresses:\n");
    printf("Base address (A):     %p\n", (void *)A);
    printf("Address of A[0]:      %p\n", (void *)&A[0]);
    printf("Address of A[1]:      %p\n", (void *)&A[1]);
    printf("Address of A[2]:      %p\n", (void *)&A[2]);
    printf("Address of A[5]:      %p\n", (void *)&A[5]);

    // Demonstrate the calculation
    printf("\nVerification:\n");
    int i = 3;
    void *calculated_addr = (void *)((char *)A + i * sizeof(float));
    printf("Calculated A[%d] address: %p\n", i, calculated_addr);
    printf("Actual A[%d] address:    %p\n", i, (void *)&A[i]);
    printf("Value at A[%d]:          %.1f\n", i, A[i]);

    // Two Dimension Array
    printf("\n\n2. TWO-DIMENSIONAL ARRAY\n");
    printf("========================\n");
    const int ROWS = 3;
    const int COLS = 4;
    float B[ROWS][COLS];

    // Initialize 2D array
    for (int i = 0; i < ROWS; i++)
    {
        for (int j = 0; j < COLS; j++)
        {
            B[i][j] = i * 10.0f + j;
        }
    }

    print_array_2d((float *)B, ROWS, COLS);

    printf("\nBase address: %p\n", (void *)B);
    printf("Dimensions: %d x %d\n", ROWS, COLS);

    // Test specific element
    int test_i = 1, test_j = 2;
    printf("\nTesting element B[%d][%d]:\n", test_i, test_j);
    printf("Actual address:    %p\n", (void *)&B[test_i][test_j]);
    printf("Actual value:      %.1f\n", B[test_i][test_j]);

    // Row-major calculation
    void *row_major_addr = calculate_2d_row_major(B, test_i, test_j, COLS, sizeof(float));
    printf("Row-major calc:    %p\n", row_major_addr);
    printf("Row-major value:   %.1f\n", *(float *)row_major_addr);

    // Column-major calculation
    void *col_major_addr = calculate_2d_col_major(B, test_i, test_j, ROWS, sizeof(float));
    printf("Column-major calc: %p\n", col_major_addr);
    printf("Column-major value: %.1f\n", *(float *)col_major_addr);

    printf("C uses %s ordering for 2D arrays\n",
           (row_major_addr == &B[test_i][test_j]) ? "ROW-MAJOR" : "COLUMN-MAJOR");

    // Three Dimension Array
    printf("\n\n3. THREE-DIMENSIONAL ARRAY\n");
    printf("==========================\n");
    const int DIM1 = 2, DIM2 = 3, DIM3 = 4;
    float C[DIM1][DIM2][DIM3];

    // Initialize 3D array
    for (int i = 0; i < DIM1; i++)
    {
        for (int j = 0; j < DIM2; j++)
        {
            for (int k = 0; k < DIM3; k++)
            {
                C[i][j][k] = i * 100.0f + j * 10.0f + k;
            }
        }
    }

    printf("Dimensions: %d x %d x %d\n", DIM1, DIM2, DIM3);
    printf("Base address: %p\n", (void *)C);

    // Test specific element
    int test_i3 = 1, test_j3 = 2, test_k3 = 3;
    printf("\nTesting element C[%d][%d][%d]:\n", test_i3, test_j3, test_k3);
    printf("Actual address:    %p\n", (void *)&C[test_i3][test_j3][test_k3]);
    printf("Actual value:      %.1f\n", C[test_i3][test_j3][test_k3]);

    // Row-major calculation
    void *row_major_3d = calculate_3d_row_major(C, test_i3, test_j3, test_k3, DIM2, DIM3, sizeof(float));
    printf("Row-major calc:    %p\n", row_major_3d);
    printf("Row-major value:   %.1f\n", *(float *)row_major_3d);

    // Column-major calculation
    void *col_major_3d = calculate_3d_col_major(C, test_i3, test_j3, test_k3, DIM1, DIM2, sizeof(float));
    printf("Column-major calc: %p\n", col_major_3d);
    printf("Column-major value: %.1f\n", *(float *)col_major_3d);

    // N-Dimensional Array (Generic)
    printf("\n\n4. N-DIMENSIONAL ARRAY (GENERIC)\n");
    printf("================================\n");

// Simulate a 4D array with dimensions 2x3x4x2
#define ND 4                            // Use preprocessor directive instead of const
    int dimensions[4] = {2, 3, 4, 2};   // Fixed size array
    int test_indices[4] = {1, 2, 3, 1}; // Fixed size array

    // Create a flat array that represents our n-dimensional array
    int total_elements = 1;
    for (int d = 0; d < ND; d++)
    {
        total_elements *= dimensions[d];
    }

    float *D = (float *)malloc(total_elements * sizeof(float));
    if (D == NULL)
    {
        printf("Memory allocation failed!\n");
        return 1;
    }

    // Initialize with predictable values
    for (int idx = 0; idx < total_elements; idx++)
    {
        D[idx] = idx * 10.0f;
    }

    printf("Dimensions: ");
    for (int d = 0; d < ND; d++)
    {
        printf("%d", dimensions[d]);
        if (d < ND - 1)
            printf(" x ");
    }
    printf("\n");

    printf("Testing element D[");
    for (int d = 0; d < ND; d++)
    {
        printf("%d", test_indices[d]);
        if (d < ND - 1)
            printf("][");
    }
    printf("]\n");

    // Calculate the actual index in our flat array using row-major
    int actual_index = 0;
    int multiplier = 1;
    for (int d = ND - 1; d >= 0; d--)
    {
        actual_index += test_indices[d] * multiplier;
        multiplier *= dimensions[d];
    }

    printf("Actual address:    %p\n", (void *)&D[actual_index]);
    printf("Actual value:      %.1f\n", D[actual_index]);

    // Row-major calculation
    void *row_major_nd = calculate_nd_row_major(D, test_indices, dimensions, ND, sizeof(float));
    printf("Row-major calc:    %p\n", row_major_nd);
    printf("Row-major value:   %.1f\n", *(float *)row_major_nd);

    // Column-major calculation
    void *col_major_nd = calculate_nd_col_major(D, test_indices, dimensions, ND, sizeof(float));
    printf("Column-major calc: %p\n", col_major_nd);
    printf("Column-major value: %.1f\n", *(float *)col_major_nd);

    free(D);

    // Additional demonstration: Access patterns
    printf("\n\n5. ACCESS PATTERN DEMONSTRATION\n");
    printf("===============================\n");

    const int SIZE = 3;
    float matrix[SIZE][SIZE];

    // Initialize matrix
    for (int i = 0; i < SIZE; i++)
    {
        for (int j = 0; j < SIZE; j++)
        {
            matrix[i][j] = i * SIZE + j;
        }
    }

    printf("Matrix (%dx%d):\n", SIZE, SIZE);
    for (int i = 0; i < SIZE; i++)
    {
        for (int j = 0; j < SIZE; j++)
        {
            printf("%4.1f", matrix[i][j]);
        }
        printf("\n");
    }

    printf("\nMemory layout (row-major order):\n");
    for (int i = 0; i < SIZE; i++)
    {
        for (int j = 0; j < SIZE; j++)
        {
            printf("matrix[%d][%d] = %.1f at address %p\n",
                   i, j, matrix[i][j], (void *)&matrix[i][j]);
        }
    }

    // Summary
    printf("\n\n6. SUMMARY\n");
    printf("==========\n");
    printf("Row-major order: Elements are stored row by row\n");
    printf("  Formula 2D: base + (i * COLS + j) * sizeof(element)\n");
    printf("  Formula 3D: base + ((i * COLS * DEPTH) + (j * DEPTH) + k) * sizeof(element)\n");
    printf("  Used by: C, C++, Python (numpy default), Pascal\n\n");

    printf("Column-major order: Elements are stored column by column\n");
    printf("  Formula 2D: base + (j * ROWS + i) * sizeof(element)\n");
    printf("  Formula 3D: base + ((k * ROWS * COLS) + (j * ROWS) + i) * sizeof(element)\n");
    printf("  Used by: Fortran, MATLAB, R, Julia\n\n");

    printf("Key differences:\n");
    printf("  - Row-major: Rightmost index varies fastest\n");
    printf("  - Column-major: Leftmost index varies fastest\n");
    printf("  - C/C++ use row-major order\n");
    printf("  - Performance depends on access patterns:\n");
    printf("    * Row-major: Efficient for row-wise access\n");
    printf("    * Column-major: Efficient for column-wise access\n");

    return 0;
}