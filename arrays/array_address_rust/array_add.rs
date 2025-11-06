use std::mem;

fn main() {
    let mut A: [f32; 10] = [0.0; 10];

    println!("Real memory addresses:");
    println!("Base address (A):     {:p}", &A);
    println!("Address of A[0]:      {:p}", &A[0]);
    println!("Address of A[1]:      {:p}", &A[1]);
    println!("Address of A[2]:      {:p}", &A[2]);
    println!("Address of A[5]:      {:p}", &A[5]);

    // Demonstrate the calculation
    println!("\nVerification:");
    let i = 3;
    
    // Method 1: Using pointer arithmetic
    let base_addr = A.as_ptr();
    let calculated_addr = unsafe {
        base_addr.add(i) // add() automatically multiplies by sizeof(f32)
    };
    
    println!("Calculated A[{}] address: {:p}", i, calculated_addr);
    println!("Actual A[{}] address:    {:p}", i, &A[i]);
    
    // Method 2: Manual calculation with size_of
    println!("\nManual calculation:");
    let base_addr_usize = base_addr as usize;
    let calculated_addr_manual = (base_addr_usize + i * mem::size_of::<f32>()) as *const f32;
    println!("Manual calculated A[{}] address: {:p}", i, calculated_addr_manual);
    
    // Verify the addresses match
    println!("\nComparison:");
    println!("Method 1 (add()):     {:p}", calculated_addr);
    println!("Method 2 (manual):    {:p}", calculated_addr_manual);
    println!("Actual:               {:p}", &A[i]);
    
    // Show the size information
    println!("\nSize information:");
    println!("sizeof(f32): {} bytes", mem::size_of::<f32>());
    println!("Array stride: {} bytes between elements", 
             (&A[1] as *const f32 as usize) - (&A[0] as *const f32 as usize));
}