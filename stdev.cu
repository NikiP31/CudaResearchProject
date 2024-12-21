#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/transform_reduce.h>
#include <thrust/reduce.h>
#include <thrust/sequence.h>
#include <iostream>
#include <cmath> 
#include <math.h>
#include <chrono>

struct SquaredDeviation {
    float mean;

    
    __host__ __device__
        SquaredDeviation(float m) : mean(m) {}

    __host__ __device__
        float operator()(float x) const {
        return (x - mean) * (x - mean);
    }
};


float compute_sum_of_squared_deviations(const thrust::device_vector<int>& d_vec) {
    const int N = d_vec.size();

    
    float sum = thrust::reduce(d_vec.begin(), d_vec.end(), 0.0f, thrust::plus<float>());
    float mean = sum / N;

   
    float sum_of_squares = thrust::transform_reduce(
        d_vec.begin(), d_vec.end(),   
        SquaredDeviation(mean),       
        0.0f,                         
        thrust::plus<float>()         
    );

    return sum_of_squares;
}

int main(int argc, char **argv) {
    const int N = atoi(argv[1]);;
    thrust::host_vector<int> h_vec(N);
    thrust::sequence(h_vec.begin(), h_vec.end(), 1);
    thrust::device_vector<int> d_vec = h_vec;

    
    auto start = std::chrono::high_resolution_clock::now();

    float result = compute_sum_of_squared_deviations(d_vec);

    auto stop = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start);

    float sum = thrust::reduce(d_vec.begin(), d_vec.end(), 0.0f, thrust::plus<float>());
    
    std::cout << duration.count() / 1000.0 << std::endl;

    return 0;
}
