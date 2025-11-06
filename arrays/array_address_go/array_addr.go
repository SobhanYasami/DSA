package main

import (
	"fmt"
	"unsafe"
)

// Function to calculate address for 1D array
func calculate1DAddress(base unsafe.Pointer, i int, elementSize uintptr) unsafe.Pointer {
	return unsafe.Pointer(uintptr(base) + uintptr(i)*elementSize)
}

// Function to calculate address for 2D array (Row-major)
func calculate2DRowMajor(base unsafe.Pointer, i, j, cols int, elementSize uintptr) unsafe.Pointer {
	offset := i*cols + j
	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// Function to calculate address for 2D array (Column-major)
func calculate2DColMajor(base unsafe.Pointer, i, j, rows int, elementSize uintptr) unsafe.Pointer {
	offset := j*rows + i
	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// Function to calculate address for 3D array (Row-major)
func calculate3DRowMajor(base unsafe.Pointer, i, j, k, cols, depth int, elementSize uintptr) unsafe.Pointer {
	offset := (i * cols * depth) + (j * depth) + k
	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// Function to calculate address for 3D array (Column-major)
func calculate3DColMajor(base unsafe.Pointer, i, j, k, rows, cols int, elementSize uintptr) unsafe.Pointer {
	offset := (k * rows * cols) + (j * rows) + i
	return unsafe.Pointer(uintptr(base) + uintptr(offset)*elementSize)
}

// Generic function for n-dimensional array (Row-major)
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

// Generic function for n-dimensional array (Column-major)
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

func printArray2D(arr []float32, rows, cols int) {
	fmt.Println("Array contents:")
	for i := 0; i < rows; i++ {
		for j := 0; j < cols; j++ {
			fmt.Printf("%6.1f", arr[i*cols+j])
		}
		fmt.Println()
	}
}

func main() {
	fmt.Println("=== MEMORY ADDRESS CALCULATIONS FOR N-DIMENSIONAL ARRAYS ===")

	// One Dimension Array
	fmt.Println("1. ONE-DIMENSIONAL ARRAY")
	fmt.Println("========================")
	var A [10]float32

	// Initialize 1D array
	for i := 0; i < 10; i++ {
		A[i] = float32(i) * 10.0
	}

	fmt.Println("Real memory addresses:")
	fmt.Printf("Base address (A):     %p\n", &A)
	fmt.Printf("Address of A[0]:      %p\n", &A[0])
	fmt.Printf("Address of A[1]:      %p\n", &A[1])
	fmt.Printf("Address of A[2]:      %p\n", &A[2])
	fmt.Printf("Address of A[5]:      %p\n", &A[5])

	// Demonstrate the calculation
	fmt.Println("\nVerification:")
	i := 3
	calculatedAddr := calculate1DAddress(unsafe.Pointer(&A[0]), i, unsafe.Sizeof(float32(0)))
	fmt.Printf("Calculated A[%d] address: %p\n", i, calculatedAddr)
	fmt.Printf("Actual A[%d] address:    %p\n", i, &A[i])
	fmt.Printf("Value at A[%d]:          %.1f\n", i, A[i])

	// Two Dimension Array
	fmt.Println("\n\n2. TWO-DIMENSIONAL ARRAY")
	fmt.Println("========================")
	const ROWS = 3
	const COLS = 4
	var B [ROWS][COLS]float32

	// Initialize 2D array
	for i := 0; i < ROWS; i++ {
		for j := 0; j < COLS; j++ {
			B[i][j] = float32(i)*10.0 + float32(j)
		}
	}

	// Convert to slice for printing
	sliceB := make([]float32, ROWS*COLS)
	for i := 0; i < ROWS; i++ {
		for j := 0; j < COLS; j++ {
			sliceB[i*COLS+j] = B[i][j]
		}
	}
	printArray2D(sliceB, ROWS, COLS)

	fmt.Printf("\nBase address: %p\n", &B)
	fmt.Printf("Dimensions: %d x %d\n", ROWS, COLS)

	// Test specific element
	testI, testJ := 1, 2
	fmt.Printf("\nTesting element B[%d][%d]:\n", testI, testJ)
	fmt.Printf("Actual address:    %p\n", &B[testI][testJ])
	fmt.Printf("Actual value:      %.1f\n", B[testI][testJ])

	// Row-major calculation
	rowMajorAddr := calculate2DRowMajor(unsafe.Pointer(&B[0][0]), testI, testJ, COLS, unsafe.Sizeof(float32(0)))
	fmt.Printf("Row-major calc:    %p\n", rowMajorAddr)
	fmt.Printf("Row-major value:   %.1f\n", *(*float32)(rowMajorAddr))

	// Column-major calculation
	colMajorAddr := calculate2DColMajor(unsafe.Pointer(&B[0][0]), testI, testJ, ROWS, unsafe.Sizeof(float32(0)))
	fmt.Printf("Column-major calc: %p\n", colMajorAddr)
	fmt.Printf("Column-major value: %.1f\n", *(*float32)(colMajorAddr))

	ordering := "ROW-MAJOR"
	if uintptr(rowMajorAddr) != uintptr(unsafe.Pointer(&B[testI][testJ])) {
		ordering = "COLUMN-MAJOR"
	}
	fmt.Printf("Go uses %s ordering for 2D arrays\n", ordering)

	// Three Dimension Array
	fmt.Println("\n\n3. THREE-DIMENSIONAL ARRAY")
	fmt.Println("==========================")
	const DIM1, DIM2, DIM3 = 2, 3, 4
	var C [DIM1][DIM2][DIM3]float32

	// Initialize 3D array
	for i := 0; i < DIM1; i++ {
		for j := 0; j < DIM2; j++ {
			for k := 0; k < DIM3; k++ {
				C[i][j][k] = float32(i)*100.0 + float32(j)*10.0 + float32(k)
			}
		}
	}

	fmt.Printf("Dimensions: %d x %d x %d\n", DIM1, DIM2, DIM3)
	fmt.Printf("Base address: %p\n", &C)

	// Test specific element
	testI3, testJ3, testK3 := 1, 2, 3
	fmt.Printf("\nTesting element C[%d][%d][%d]:\n", testI3, testJ3, testK3)
	fmt.Printf("Actual address:    %p\n", &C[testI3][testJ3][testK3])
	fmt.Printf("Actual value:      %.1f\n", C[testI3][testJ3][testK3])

	// Row-major calculation
	rowMajor3D := calculate3DRowMajor(unsafe.Pointer(&C[0][0][0]), testI3, testJ3, testK3, DIM2, DIM3, unsafe.Sizeof(float32(0)))
	fmt.Printf("Row-major calc:    %p\n", rowMajor3D)
	fmt.Printf("Row-major value:   %.1f\n", *(*float32)(rowMajor3D))

	// Column-major calculation
	colMajor3D := calculate3DColMajor(unsafe.Pointer(&C[0][0][0]), testI3, testJ3, testK3, DIM1, DIM2, unsafe.Sizeof(float32(0)))
	fmt.Printf("Column-major calc: %p\n", colMajor3D)
	fmt.Printf("Column-major value: %.1f\n", *(*float32)(colMajor3D))

	// N-Dimensional Array (Generic)
	fmt.Println("\n\n4. N-DIMENSIONAL ARRAY (GENERIC)")
	fmt.Println("================================")

	// Simulate a 4D array with dimensions 2x3x4x2
	dimensions := []int{2, 3, 4, 2}
	testIndices := []int{1, 2, 3, 1}

	// Create a flat array that represents our n-dimensional array
	totalElements := 1
	for _, dim := range dimensions {
		totalElements *= dim
	}

	D := make([]float32, totalElements)

	// Initialize with predictable values
	for idx := 0; idx < totalElements; idx++ {
		D[idx] = float32(idx) * 10.0
	}

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

	// Calculate the actual index in our flat array using row-major
	actualIndex := 0
	multiplier := 1
	for d := len(dimensions) - 1; d >= 0; d-- {
		actualIndex += testIndices[d] * multiplier
		multiplier *= dimensions[d]
	}

	fmt.Printf("Actual address:    %p\n", &D[actualIndex])
	fmt.Printf("Actual value:      %.1f\n", D[actualIndex])

	// Row-major calculation
	rowMajorND := calculateNDRowMajor(unsafe.Pointer(&D[0]), testIndices, dimensions, unsafe.Sizeof(float32(0)))
	fmt.Printf("Row-major calc:    %p\n", rowMajorND)
	fmt.Printf("Row-major value:   %.1f\n", *(*float32)(rowMajorND))

	// Column-major calculation
	colMajorND := calculateNDColMajor(unsafe.Pointer(&D[0]), testIndices, dimensions, unsafe.Sizeof(float32(0)))
	fmt.Printf("Column-major calc: %p\n", colMajorND)
	fmt.Printf("Column-major value: %.1f\n", *(*float32)(colMajorND))

	// Additional demonstration: Access patterns
	fmt.Println("\n\n5. ACCESS PATTERN DEMONSTRATION")
	fmt.Println("===============================")

	const SIZE = 3
	var matrix [SIZE][SIZE]float32

	// Initialize matrix
	for i := 0; i < SIZE; i++ {
		for j := 0; j < SIZE; j++ {
			matrix[i][j] = float32(i*SIZE + j)
		}
	}

	fmt.Printf("Matrix (%dx%d):\n", SIZE, SIZE)
	for i := 0; i < SIZE; i++ {
		for j := 0; j < SIZE; j++ {
			fmt.Printf("%4.1f", matrix[i][j])
		}
		fmt.Println()
	}

	fmt.Println("\nMemory layout (row-major order):")
	for i := 0; i < SIZE; i++ {
		for j := 0; j < SIZE; j++ {
			fmt.Printf("matrix[%d][%d] = %.1f at address %p\n",
				i, j, matrix[i][j], &matrix[i][j])
		}
	}

	// Summary
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

	fmt.Println("Key differences:")
	fmt.Println("  - Row-major: Rightmost index varies fastest")
	fmt.Println("  - Column-major: Leftmost index varies fastest")
	fmt.Println("  - Go uses row-major order for arrays")
	fmt.Println("  - Performance depends on access patterns:")
	fmt.Println("    * Row-major: Efficient for row-wise access")
	fmt.Println("    * Column-major: Efficient for column-wise access")
}
