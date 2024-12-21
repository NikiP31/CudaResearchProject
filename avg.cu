#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <thrust/reduce.h>
#include <iostream>
#include <chrono> 
#include <stdlib.h>

int main(int argc, char **argv) {
    int N=atoi(argv[1]);;

    thrust::host_vector<int> h_vec(N);
    thrust::sequence(h_vec.begin(), h_vec.end(), 1);

    thrust::device_vector<int> d_vec = h_vec;
    auto start = std::chrono::high_resolution_clock::now();

    float sum = thrust::reduce(d_vec.begin(), d_vec.end(), 0.0f, thrust::plus<float>());
    float mean = sum / N;

    auto stop = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start);
    std::cout << duration.count() / 1000.0 << std::endl;

    return 0;
}
