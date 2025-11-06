package main

import (
	"fmt"
	"unsafe"
)

func main() {
	var A [10]float32

	fmt.Println("Real memory addresses:")
	fmt.Printf("Base address (A):     %p\n", &A)
	fmt.Printf("Address of A[0]:      %p\n", &A[0])
	fmt.Printf("Address of A[1]:      %p\n", &A[1])
	fmt.Printf("Address of A[2]:      %p\n", &A[2])
	fmt.Printf("Address of A[5]:      %p\n", &A[5])

	// Demonstrate the calculation
	fmt.Println("\nVerification:")
	i := 3
	// Using unsafe.Pointer for pointer arithmetic
	baseAddr := unsafe.Pointer(&A[0])
	calculatedAddr := unsafe.Pointer(uintptr(baseAddr) + uintptr(i)*unsafe.Sizeof(A[0]))

	fmt.Printf("Calculated A[%d] address: %p\n", i, calculatedAddr)
	fmt.Printf("Actual A[%d] address:    %p\n", i, &A[i])

	// Alternative using slice header
	fmt.Println("\nUsing slice approach:")
	slice := A[:]
	sliceHeader := (*[10]float32)(unsafe.Pointer(&slice[0]))
	fmt.Printf("Slice base address: %p\n", sliceHeader)
}
