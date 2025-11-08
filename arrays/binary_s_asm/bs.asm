; h1 -- Binary Search Algorithm Implementation in x86-64 Assembly
; h2 -- Intel processor assembly implementation using NASM syntax
; h2 -- Iterative binary search for sorted arrays with performance timing

section .data
    ; h3 -- Data Section: Constants and Messages
    ; h4 -- String constants for output and formatting
    found_msg      db "Found %d at index %d", 10, 0
    not_found_msg  db "Not found", 10, 0
    array_label    db "Array: [", 0
    comma_space    db ", ", 0
    close_bracket  db "]", 10, 0
    target_label   db "Target: %d", 10, 0
    result_label   db "Result: ", 0
    perf_label     db "Performance: %ld nanoseconds", 10, 0
    
    ; h4 -- Test array (must be sorted)
    test_array     dd 2, 4, 6, 8, 10, 12, 14, 16, 18, 20
    array_size     equ ($ - test_array) / 4  ; Calculate number of elements
    
    ; h4 -- Test targets for different cases
    target_best    dd 2      ; First element (best case)
    target_avg     dd 12     ; Middle element (average case)
    target_worst   dd 20     ; Last element (worst case)
    target_none    dd 5      ; Not present (not found case)

section .bss
    ; h3 -- Uninitialized Data Section
    ; h4 -- Variables for performance timing
    time_start     resq 1
    time_end       resq 1

section .text
    global main
    extern printf, clock

; h3 -- Binary Search Function
; h4 -- Searches for target in sorted array using iterative binary search
; h5 -- rdi: pointer to array (int*)
; h5 -- rsi: array size (int)
; h5 -- rdx: target value (int)
; h6 -- Returns: rax = index if found, -1 if not found
; h6 -- Time Complexity: O(log n) - logarithmic time
; h6 -- Space Complexity: O(1) - constant space
; h6 -- Registers used: rax, rbx, rcx, rdx, rdi, rsi
binary_search:
    push rbp
    mov rbp, rsp
    
    ; h4 -- Initialize low and high indices
    xor rax, rax            ; low = 0 (rax)
    mov rbx, rsi            ; high = size - 1
    dec rbx
    
    ; h4 -- Main binary search loop
.search_loop:
    cmp rax, rbx            ; while (low <= high)
    jg .not_found
    
    ; h4 -- Calculate mid index: mid = low + (high - low) / 2
    mov rcx, rbx            ; rcx = high
    sub rcx, rax            ; rcx = high - low
    shr rcx, 1              ; rcx = (high - low) / 2
    add rcx, rax            ; rcx = low + (high - low) / 2
    
    ; h4 -- Access array[mid] and compare with target
    mov r8d, [rdi + rcx*4]  ; r8d = array[mid]
    cmp r8d, edx            ; Compare array[mid] with target
    je .found               ; If equal, found target
    
    jl .search_right        ; If array[mid] < target, search right half
    
    ; h4 -- Search left half: high = mid - 1
.search_left:
    mov rbx, rcx
    dec rbx
    jmp .search_loop
    
    ; h4 -- Search right half: low = mid + 1
.search_right:
    mov rax, rcx
    inc rax
    jmp .search_loop
    
    ; h4 -- Target found at index rcx
.found:
    mov rax, rcx            ; Return index in rax
    jmp .exit
    
    ; h4 -- Target not found
.not_found:
    mov rax, -1             ; Return -1 for not found
    
.exit:
    pop rbp
    ret

; h3 -- Print Array Function
; h4 -- Utility function to display array contents
; h5 -- rdi: pointer to array
; h5 -- rsi: array size
print_array:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    
    mov r12, rdi            ; Save array pointer
    mov r13, rsi            ; Save array size
    
    ; Print opening bracket
    mov rdi, array_label
    xor rax, rax
    call printf
    
    ; Print array elements
    xor rcx, rcx            ; i = 0
.print_loop:
    cmp rcx, r13
    jge .print_done
    
    ; Print current element
    mov rdi, found_msg      ; Reuse format string
    mov esi, [r12 + rcx*4]
    xor rdx, rdx            ; Zero out for printf
    xor rax, rax
    call printf
    
    ; Print comma if not last element
    inc rcx
    cmp rcx, r13
    jge .print_done
    
    mov rdi, comma_space
    xor rax, rax
    call printf
    jmp .print_loop
    
.print_done:
    ; Print closing bracket
    mov rdi, close_bracket
    xor rax, rax
    call printf
    
    pop r13
    pop r12
    pop rbp
    ret

; h3 -- Performance Test Function
; h4 -- Measures execution time of binary search
; h5 -- rdi: pointer to array
; h5 -- rsi: array size  
; h5 -- rdx: target value
; h6 -- Returns: time in nanoseconds in rax
performance_test:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    
    mov r12, rdi            ; Save array pointer
    mov r13, rsi            ; Save array size
    mov r14, rdx            ; Save target
    
    ; Get start time (using rdtsc for high precision)
    rdtsc
    shl rdx, 32
    or rax, rdx
    mov [time_start], rax
    
    ; Call binary search
    mov rdi, r12
    mov rsi, r13
    mov rdx, r14
    call binary_search
    
    ; Get end time
    rdtsc
    shl rdx, 32
    or rax, rdx
    mov [time_end], rax
    
    ; Calculate elapsed time
    mov rax, [time_end]
    sub rax, [time_start]
    
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; h3 -- Main Function
; h4 -- Demonstrates binary search with test cases and performance measurement
main:
    push rbp
    mov rbp, rsp
    
    ; h4 -- Display program header
    mov rdi, found_msg      ; Reuse for simple output
    mov rsi, program_title
    xor rax, rax
    call printf
    
    ; h4 -- Display test array
    mov rdi, test_array
    mov rsi, array_size
    call print_array
    
    ; h4 -- Test Case 1: Basic functionality
    mov rdi, result_label
    xor rax, rax
    call printf
    
    mov rdi, test_array
    mov rsi, array_size
    mov edx, 10             ; Target value 10
    call binary_search
    
    ; Display result
    cmp rax, -1
    je .not_found1
    
    mov rdi, found_msg
    mov esi, 10
    mov rdx, rax
    xor rax, rax
    call printf
    jmp .performance_tests
    
.not_found1:
    mov rdi, not_found_msg
    xor rax, rax
    call printf
    
    ; h4 -- Performance Tests
.performance_tests:
    mov rdi, perf_header
    xor rax, rax
    call printf
    
    ; Test best case (first element)
    mov rdi, test_array
    mov rsi, array_size
    mov edx, [target_best]
    call performance_test
    mov rdi, perf_best
    mov rsi, rax
    xor rax, rax
    call printf
    
    ; Test average case (middle element)
    mov rdi, test_array
    mov rsi, array_size
    mov edx, [target_avg]
    call performance_test
    mov rdi, perf_avg
    mov rsi, rax
    xor rax, rax
    call printf
    
    ; Test worst case (last element)
    mov rdi, test_array
    mov rsi, array_size
    mov edx, [target_worst]
    call performance_test
    mov rdi, perf_worst
    mov rsi, rax
    xor rax, rax
    call printf
    
    ; Test not found case
    mov rdi, test_array
    mov rsi, array_size
    mov edx, [target_none]
    call performance_test
    mov rdi, perf_none
    mov rsi, rax
    xor rax, rax
    call printf
    
    ; h4 -- Algorithm Analysis
    mov rdi, analysis_header
    xor rax, rax
    call printf
    
    mov rdi, complexity
    xor rax, rax
    call printf
    
    mov rdi, space_complexity
    xor rax, rax
    call printf
    
    mov rdi, requirements
    xor rax, rax
    call printf
    
    ; Exit program
    xor rax, rax
    pop rbp
    ret

; h3 -- Additional Data for Output
section .data
program_title     db "=== BINARY SEARCH - x86-64 ASSEMBLY IMPLEMENTATION ===", 10, 0
perf_header       db 10, "Performance Tests (CPU cycles):", 10, 0
perf_best         db "  Best case (first element): %ld cycles", 10, 0
perf_avg          db "  Average case (middle element): %ld cycles", 10, 0
perf_worst        db "  Worst case (last element): %ld cycles", 10, 0
perf_none         db "  Not found case: %ld cycles", 10, 0
analysis_header   db 10, "Algorithm Analysis:", 10, 0
complexity        db "  Time Complexity: O(log n)", 10, 0
space_complexity  db "  Space Complexity: O(1) - iterative implementation", 10, 0
requirements      db "  Requirements: Array must be sorted in ascending order", 10, 0