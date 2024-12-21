#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char **argv) {
    int N=atoi(argv[1]);;
    long long sum = 0; 
    double average;

    clock_t start_time = clock();

    for (int i = 1; i <= N; i++) {
        sum += i;
    }

    average = (double)sum / N;

    clock_t end_time = clock();
    double time_taken = ((double)(end_time - start_time)) / CLOCKS_PER_SEC * 1000.0; // Convert to milliseconds

    printf("%.2f", time_taken);

    return 0;
}
