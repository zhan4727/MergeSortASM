#include <stdio.h>
#include <stdlib.h>

// Function to merge two sorted subarrays
void merge(long arr[], long left, long mid, long right);
// Main function that implements merge sort
void mergeSort(long arr[], long left, long right);

// Utility function to print an array
void printArray(long arr[], long size) {
    for (long i = 0; i < size; i++)
        printf("%ld ", arr[i]);
    printf("\n");
}

// Driver program to test above functions
int main() {
    long arr[] = {12, 11, 13, 5, 6, 7};
    long arr_size = sizeof(arr) / sizeof(arr[0]);

    printf("Given array is \n");
    printArray(arr, arr_size);

    mergeSort(arr, 0, arr_size - 1);

    printf("\nSorted array is \n");
    printArray(arr, arr_size);
    return 0;
}
