#include <stdio.h>
#include <stdlib.h>

// Function to merge two sorted subarrays
void merge(long arr[], long left, long mid, long right) {
    long i, j, k;
    long n1 = mid - left + 1;
    long n2 = right - mid;

    // Create temporary arrays
    long *L = (long*)malloc(n1 * sizeof(long));
    long *R = (long*)malloc(n2 * sizeof(long));

    // Copy data to temporary arrays L[] and R[]
    for (i = 0; i < n1; i++)
        L[i] = arr[left + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[mid + 1 + j];

    // Merge the temporary arrays back into arr[left..right]
    i = 0; // Initial index of first subarray
    j = 0; // Initial index of second subarray
    k = left; // Initial index of merged subarray

    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        } else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }

    // Copy the remaining elements of L[], if any
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }

    // Copy the remaining elements of R[], if any
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }

    free(L);
    free(R);
}

// Main function that implements merge sort
void mergeSort(long arr[], long left, long right) {
    if (left < right) {
        // Same as (left+right)/2, but avoids overflow for large left and right
        long mid = left + (right - left) / 2;

        // Sort first and second halves
        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);

        // Merge the sorted halves
        merge(arr, left, mid, right);
    }
}

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
