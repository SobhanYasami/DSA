#include <stdio.h>

int main()
{
    float A[10];

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

    return 0;
}