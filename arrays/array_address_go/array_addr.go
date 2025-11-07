// h1 -- Memory Address Calculator for N-Dimensional Arrays in Go
// h2 -- This program demonstrates memory address calculations for arrays of various dimensions
// h2 -- using both row-major and column-major ordering approaches

package main

import (
	"fmt"
	"unsafe"
)

// h3 -- 1D Array Address Calculation
// h4 -- Calculates the memory address of an element in a 1-dimensional array
// h5 -- base: pointer to the start of the array
// h5 -- i: index of the element to calculate
// h5 -- elementSize: size of each element in bytes
// h6 -- Returns: pointer to the calculated memory address
func calculate1DAddress(base unsafe.Pointer, i int, elementSize uintptr) unsafe.Pointer {
	return unsafe.Pointer(uintptr(base) + uintptr(i)*elementSize)
}

// h3 -- 2D Array Address Calculation (Row-Major)
// h4 -- Calculates memory address using row-major ordering for 2D arrays
// h5 -- base: pointer to the start of the array
// h5 -- i, j: row and column indices of the element
// h5 -- cols: number of columns in the 2D array
// h5 -- elementSize: size of each element in bytes
// h6 -- Returns: pointer to the calculated memory address using row-major formula
func calculate2DRowMajor(base unsafe.Pointer, i, j, cols int, elementSize uintptr) unsafe.Pointer {
	offset := i*cols + j
	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// h3 -- 2D Array Address Calculation (Column-Major)
// h4 -- Calculates memory address using column-major ordering for 2D arrays
// h5 -- base: pointer to the start of the array
// h5 -- i, j: row and column indices of the element
// h5 -- rows: number of rows in the 2D array
// h5 -- elementSize: size of each element in bytes
// h6 -- Returns: pointer to the calculated memory address using column-major formula
func calculate2DColMajor(base unsafe.Pointer, i, j, rows int, elementSize uintptr) unsafe.Pointer {
	offset := j*rows + i
	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// h3 -- 3D Array Address Calculation (Row-Major)
// h4 -- Calculates memory address using row-major ordering for 3D arrays
// h5 -- base: pointer to the start of the array
// h5 -- i, j, k: indices for the three dimensions
// h5 -- cols: number of columns in the 3D array
// h5 -- depth: depth dimension size
// h5 -- elementSize: size of each element in bytes
// h6 -- Returns: pointer to the calculated memory address using 3D row-major formula
func calculate3DRowMajor(base unsafe.Pointer, i, j, k, cols, depth int, elementSize uintptr) unsafe.Pointer {
	offset := (i * cols * depth) + (j * depth) + k
	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// h3 -- 3D Array Address Calculation (Column-Major)
// h4 -- Calculates memory address using column-major ordering for 3D arrays
// h5 -- base: pointer to the start of the array
// h5 -- i, j, k: indices for the three dimensions
// h5 -- rows: number of rows in the 3D array
// h5 -- cols: number of columns in the 3D array
// h5 -- elementSize: size of each element in bytes
// h6 -- Returns: pointer to the calculated memory address using 3D column-major formula
func calculate3DColMajor(base unsafe.Pointer, i, j, k, rows, cols int, elementSize uintptr) unsafe.Pointer {
	offset := (k * rows * cols) + (j * rows) + i
	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// h3 -- N-Dimensional Array Address Calculation (Row-Major)
// h4 -- Generic function to calculate memory address for n-dimensional arrays using row-major ordering
// h5 -- base: pointer to the start of the array
// h5 -- indices: slice containing indices for each dimension
// h5 -- dimensions: slice containing sizes of each dimension
// h5 -- elementSize: size of each element in bytes
// h6 -- Returns: pointer to the calculated memory address using n-dimensional row-major formula
func calculateNDRowMajor(base unsafe.Pointer, indices, dimensions []int, elementSize uintptr) unsafe.Pointer {
	offset := 0
	n := len(indices)

	for dim := 0; dim < n; dim++ {
		multiplier := 1
		for nextDim := dim + 1; nextDim < n; nextDim++ {
			multiplier *= dimensions[nextDim]
		}
		offset += indices[dim] * multiplier
	}

	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// h3 -- N-Dimensional Array Address Calculation (Column-Major)
// h4 -- Generic function to calculate memory address for n-dimensional arrays using column-major ordering
// h5 -- base: pointer to the start of the array
// h5 -- indices: slice containing indices for each dimension
// h5 -- dimensions: slice containing sizes of each dimension
// h5 -- elementSize: size of each element in bytes
// h6 -- Returns: pointer to the calculated memory address using n-dimensional column-major formula
func calculateNDColMajor(base unsafe.Pointer, indices, dimensions []int, elementSize uintptr) unsafe.Pointer {
	offset := 0
	n := len(indices)

	for dim := n - 1; dim >= 0; dim-- {
		multiplier := 1
		for prevDim := n - 1; prevDim > dim; prevDim-- {
			multiplier *= dimensions[prevDim]
		}
		offset += indices[dim] * multiplier
	}

	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// h3 -- 2D Array Print Function
// h4 -- Utility function to print the contents of a 2D array stored in a flat slice
// h5 -- arr: flat slice containing the 2D array data
// h5 -- rows: number of rows in the array
// h5 -- cols: number of columns in the array
// h6 -- Prints: formatted 2D array contents to stdout
func printArray2D(arr []float32, rows, cols int) {
	fmt.Println("Array contents:")
	for i := 0; i < rows; i++ {
		for j := 0; j < cols; j++ {
			fmt.Printf("%6.1f", arr[i*cols+j])
		}
		fmt.Println()
	}
}

// h1 -- Main Function - Memory Address Calculation Demonstrations
// h2 -- Demonstrates memory address calculations for arrays of various dimensions
func main() {
	// h3 -- Program Header
	fmt.Println("=== MEMORY ADDRESS CALCULATIONS FOR N-DIMENSIONAL ARRAYS ===")

	// h3 -- Section 1: One-Dimensional Array Demonstration
	// h4 -- Demonstrates basic 1D array address calculation
	fmt.Println("1. ONE-DIMENSIONAL ARRAY")
	fmt.Println("========================")
	var A [10]float32

	// h4 -- Initialize 1D array with sample values
	for i := 0; i < 10; i++ {
		A[i] = float32(i) * 10.0
	}

	// h4 -- Display actual memory addresses of array elements
	fmt.Println("Real memory addresses:")
	fmt.Printf("Base address (A):     %p\n", &A)
	fmt.Printf("Address of A[0]:      %p\n", &A[0])
	fmt.Printf("Address of A[1]:      %p\n", &A[1])
	fmt.Printf("Address of A[2]:      %p\n", &A[2])
	fmt.Printf("Address of A[5]:      %p\n", &A[5])

	// h4 -- Verify calculation matches actual address
	fmt.Println("\nVerification:")
	i := 3
	calculatedAddr := calculate1DAddress(unsafe.Pointer(&A[0]), i, unsafe.Sizeof(float32(0)))
	fmt.Printf("Calculated A[%d] address: %p\n", i, calculatedAddr)
	fmt.Printf("Actual A[%d] address:    %p\n", i, &A[i])
	fmt.Printf("Value at A[%d]:          %.1f\n", i, A[i])

	// h3 -- Section 2: Two-Dimensional Array Demonstration
	// h4 -- Demonstrates 2D array address calculations with both row-major and column-major
	fmt.Println("\n\n2. TWO-DIMENSIONAL ARRAY")
	fmt.Println("========================")
	const ROWS = 3
	const COLS = 4
	var B [ROWS][COLS]float32

	// h4 -- Initialize 2D array with sample values
	for i := 0; i < ROWS; i++ {
		for j := 0; j < COLS; j++ {
			B[i][j] = float32(i)*10.0 + float32(j)
		}
	}

	// h4 -- Convert to flat slice for printing and display array contents
	sliceB := make([]float32, ROWS*COLS)
	for i := 0; i < ROWS; i++ {
		for j := 0; j < COLS; j++ {
			sliceB[i*COLS+j] = B[i][j]
		}
	}
	printArray2D(sliceB, ROWS, COLS)

	fmt.Printf("\nBase address: %p\n", &B)
	fmt.Printf("Dimensions: %d x %d\n", ROWS, COLS)

	// h4 -- Test specific element with both calculation methods
	testI, testJ := 1, 2
	fmt.Printf("\nTesting element B[%d][%d]:\n", testI, testJ)
	fmt.Printf("Actual address:    %p\n", &B[testI][testJ])
	fmt.Printf("Actual value:      %.1f\n", B[testI][testJ])

	// h5 -- Row-major calculation and verification
	rowMajorAddr := calculate2DRowMajor(unsafe.Pointer(&B[0][0]), testI, testJ, COLS, unsafe.Sizeof(float32(0)))
	fmt.Printf("Row-major calc:    %p\n", rowMajorAddr)
	fmt.Printf("Row-major value:   %.1f\n", *(*float32)(rowMajorAddr))

	// h5 -- Column-major calculation and verification
	colMajorAddr := calculate2DColMajor(unsafe.Pointer(&B[0][0]), testI, testJ, ROWS, unsafe.Sizeof(float32(0)))
	fmt.Printf("Column-major calc: %p\n", colMajorAddr)
	fmt.Printf("Column-major value: %.1f\n", *(*float32)(colMajorAddr))

	// h4 -- Determine which ordering Go uses for 2D arrays
	ordering := "ROW-MAJOR"
	if uintptr(rowMajorAddr) != uintptr(unsafe.Pointer(&B[testI][testJ])) {
		ordering = "COLUMN-MAJOR"
	}
	fmt.Printf("Go uses %s ordering for 2D arrays\n", ordering)

	// h3 -- Section 3: Three-Dimensional Array Demonstration
	// h4 -- Demonstrates 3D array address calculations
	fmt.Println("\n\n3. THREE-DIMENSIONAL ARRAY")
	fmt.Println("==========================")
	const DIM1, DIM2, DIM3 = 2, 3, 4
	var C [DIM1][DIM2][DIM3]float32

	// h4 -- Initialize 3D array with sample values
	for i := 0; i < DIM1; i++ {
		for j := 0; j < DIM2; j++ {
			for k := 0; k < DIM3; k++ {
				C[i][j][k] = float32(i)*100.0 + float32(j)*10.0 + float32(k)
			}
		}
	}

	fmt.Printf("Dimensions: %d x %d x %d\n", DIM1, DIM2, DIM3)
	fmt.Printf("Base address: %p\n", &C)

	// h4 -- Test specific 3D element with both calculation methods
	testI3, testJ3, testK3 := 1, 2, 3
	fmt.Printf("\nTesting element C[%d][%d][%d]:\n", testI3, testJ3, testK3)
	fmt.Printf("Actual address:    %p\n", &C[testI3][testJ3][testK3])
	fmt.Printf("Actual value:      %.1f\n", C[testI3][testJ3][testK3])

	// h5 -- 3D Row-major calculation
	rowMajor3D := calculate3DRowMajor(unsafe.Pointer(&C[0][0][0]), testI3, testJ3, testK3, DIM2, DIM3, unsafe.Sizeof(float32(0)))
	fmt.Printf("Row-major calc:    %p\n", rowMajor3D)
	fmt.Printf("Row-major value:   %.1f\n", *(*float32)(rowMajor3D))

	// h5 -- 3D Column-major calculation
	colMajor3D := calculate3DColMajor(unsafe.Pointer(&C[0][0][0]), testI3, testJ3, testK3, DIM1, DIM2, unsafe.Sizeof(float32(0)))
	fmt.Printf("Column-major calc: %p\n", colMajor3D)
	fmt.Printf("Column-major value: %.1f\n", *(*float32)(colMajor3D))

	// h3 -- Section 4: N-Dimensional Array Demonstration
	// h4 -- Demonstrates generic n-dimensional array address calculations
	fmt.Println("\n\n4. N-DIMENSIONAL ARRAY (GENERIC)")
	fmt.Println("================================")

	// h4 -- Simulate a 4D array with specific dimensions
	dimensions := []int{2, 3, 4, 2}
	testIndices := []int{1, 2, 3, 1}

	// h4 -- Create flat array to represent n-dimensional data
	totalElements := 1
	for _, dim := range dimensions {
		totalElements *= dim
	}

	D := make([]float32, totalElements)

	// h4 -- Initialize with predictable values
	for idx := 0; idx < totalElements; idx++ {
		D[idx] = float32(idx) * 10.0
	}

	// h4 -- Display array dimensions and test element
	fmt.Printf("Dimensions: ")
	for d, dim := range dimensions {
		fmt.Printf("%d", dim)
		if d < len(dimensions)-1 {
			fmt.Printf(" x ")
		}
	}
	fmt.Println()

	fmt.Printf("Testing element D[")
	for d, idx := range testIndices {
		fmt.Printf("%d", idx)
		if d < len(testIndices)-1 {
			fmt.Printf("][")
		}
	}
	fmt.Printf("]\n")

	// h4 -- Calculate actual index in flat array
	actualIndex := 0
	multiplier := 1
	for d := len(dimensions) - 1; d >= 0; d-- {
		actualIndex += testIndices[d] * multiplier
		multiplier *= dimensions[d]
	}

	fmt.Printf("Actual address:    %p\n", &D[actualIndex])
	fmt.Printf("Actual value:      %.1f\n", D[actualIndex])

	// h5 -- N-dimensional row-major calculation
	rowMajorND := calculateNDRowMajor(unsafe.Pointer(&D[0]), testIndices, dimensions, unsafe.Sizeof(float32(0)))
	fmt.Printf("Row-major calc:    %p\n", rowMajorND)
	fmt.Printf("Row-major value:   %.1f\n", *(*float32)(rowMajorND))

	// h5 -- N-dimensional column-major calculation
	colMajorND := calculateNDColMajor(unsafe.Pointer(&D[0]), testIndices, dimensions, unsafe.Sizeof(float32(0)))
	fmt.Printf("Column-major calc: %p\n", colMajorND)
	fmt.Printf("Column-major value: %.1f\n", *(*float32)(colMajorND))

	// h3 -- Section 5: Access Pattern Demonstration
	// h4 -- Shows memory layout patterns for better understanding
	fmt.Println("\n\n5. ACCESS PATTERN DEMONSTRATION")
	fmt.Println("===============================")

	const SIZE = 3
	var matrix [SIZE][SIZE]float32

	// h4 -- Initialize matrix with sequential values
	for i := 0; i < SIZE; i++ {
		for j := 0; j < SIZE; j++ {
			matrix[i][j] = float32(i*SIZE + j)
		}
	}

	// h4 -- Display matrix contents
	fmt.Printf("Matrix (%dx%d):\n", SIZE, SIZE)
	for i := 0; i < SIZE; i++ {
		for j := 0; j < SIZE; j++ {
			fmt.Printf("%4.1f", matrix[i][j])
		}
		fmt.Println()
	}

	// h4 -- Show memory addresses to demonstrate row-major layout
	fmt.Println("\nMemory layout (row-major order):")
	for i := 0; i < SIZE; i++ {
		for j := 0; j < SIZE; j++ {
			fmt.Printf("matrix[%d][%d] = %.1f at address %p\n",
				i, j, matrix[i][j], &matrix[i][j])
		}
	}

	// h3 -- Section 6: Summary and Educational Information
	// h4 -- Provides educational summary of row-major vs column-major ordering
	fmt.Println("\n\n6. SUMMARY")
	fmt.Println("==========")
	fmt.Println("Row-major order: Elements are stored row by row")
	fmt.Println("  Formula 2D: base + (i * COLS + j) * sizeof(element)")
	fmt.Println("  Formula 3D: base + ((i * COLS * DEPTH) + (j * DEPTH) + k) * sizeof(element)")
	fmt.Println("  Used by: C, C++, Python (numpy default), Pascal, Go")

	fmt.Println("Column-major order: Elements are stored column by column")
	fmt.Println("  Formula 2D: base + (j * ROWS + i) * sizeof(element)")
	fmt.Println("  Formula 3D: base + ((k * ROWS * COLS) + (j * ROWS) + i) * sizeof(element)")
	fmt.Println("  Used by: Fortran, MATLAB, R, Julia")

	// h4 -- Key differences and performance considerations
	fmt.Println("Key differences:")
	fmt.Println("  - Row-major: Rightmost index varies fastest")
	fmt.Println("  - Column-major: Leftmost index varies fastest")
	fmt.Println("  - Go uses row-major order for arrays")
	fmt.Println("  - Performance depends on access patterns:")
	fmt.Println("    * Row-major: Efficient for row-wise access")
	fmt.Println("    * Column-major: Efficient for column-wise access")
}
