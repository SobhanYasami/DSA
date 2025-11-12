section .data
    ; Test data
    array     dd 2, 4, 6, 8, 10, 12, 14
    size      equ 7
    target    dd 10
    found     db "Found", 10, 0
    notfound  db "Not found", 10, 0

section .text
    global _start

; Binary search function
; Input: array in rdi, size in rsi, target in edx
; Output: index in rax, -1 if not found
binary_search:
    xor rax, rax        ; low = 0
    mov rbx, rsi        ; high = size - 1
    dec rbx
    
.loop:
    cmp rax, rbx
    jg .not_found
    
    ; mid = low + (high - low) / 2
    mov rcx, rbx
    sub rcx, rax
    shr rcx, 1
    add rcx, rax
    
    ; Compare array[mid] with target
    mov r8d, [rdi + rcx*4]
    cmp r8d, edx
    je .found
    jl .right
    
    ; Search left
    mov rbx, rcx
    dec rbx
    jmp .loop
    
.right:
    ; Search right  
    mov rax, rcx
    inc rax
    jmp .loop
    
.found:
    mov rax, rcx
    ret
    
.not_found:
    mov rax, -1
    ret

_start:
    ; Call binary search
    mov rdi, array
    mov rsi, size
    mov edx, [target]
    call binary_search
    
    ; Check result and exit with appropriate code
    cmp rax, -1
    je .exit_not_found
    
    ; Found - exit with code 0
    mov rax, 60
    xor rdi, rdi
    syscall
    
.exit_not_found:
    ; Not found - exit with code 1
    mov rax, 60
    mov rdi, 1
    syscall