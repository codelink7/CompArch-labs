#include <iostream>
#include <vector>
#include <chrono>
#include <cstdlib>
#include <iomanip>
#include <cuda_runtime.h>

__global__ void matMulKernel(const float* A, const float* B, float* C, int N){
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if(row < N && col < N) {
        float sum = 0.0f;
        for(int k=0; k<N; k++)
            sum += A[row*N + k] * B[k*N + col];
        C[row*N + col] = sum;
    }
}

__global__ void matAddKernel(const float* A, const float* B, float* C, int N){
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if(idx < N*N)
        C[idx] = A[idx] + B[idx];
}

void fillRandom(float* M, int N){
    for(int i=0; i<N*N; i++)
        M[i] = static_cast<float>(rand()) / RAND_MAX;
}

double benchmark_gpu(int N){
    srand(42);
    size_t bytes = N*N*sizeof(float);

    float* hA = new float[N*N];
    float* hB = new float[N*N];
    float* hC = new float[N*N];

    fillRandom(hA, N);
    fillRandom(hB, N);
    fillRandom(hC, N);

    float *dA, *dB, *dC, *dAB, *dABC, *dResult;
    cudaMalloc(&dA, bytes);
    cudaMalloc(&dB, bytes);
    cudaMalloc(&dC, bytes);
    cudaMalloc(&dAB, bytes);
    cudaMalloc(&dABC, bytes);
    cudaMalloc(&dResult, bytes);

    cudaMemcpy(dA, hA, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, hB, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(dC, hC, bytes, cudaMemcpyHostToDevice);

    dim3 blockDim(16, 16);
    dim3 gridDim((N+15)/16, (N+15)/16);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    matMulKernel<<<gridDim, blockDim>>>(dA, dB, dAB, N);
    matMulKernel<<<gridDim, blockDim>>>(dAB, dC, dABC, N);
    
    int threads1D = 256;
    int blocks1D = (N*N + threads1D-1) / threads1D;
    matAddKernel<<<blocks1D, threads1D>>>(dABC, dA, dResult, N);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms = 0;
    cudaEventElapsedTime(&ms, start, stop);

    cudaFree(dA); cudaFree(dB); cudaFree(dC);
    cudaFree(dAB); cudaFree(dABC); cudaFree(dResult);
    cudaEventDestroy(start); cudaEventDestroy(stop);
    delete[] hA; delete[] hB; delete[] hC;

    return ms/1000.0;
}

double benchmark_cpu(int N){
    srand(42);
    std::vector<float> A(N*N), B(N*N), C(N*N), AB(N*N, 0), ABC(N*N, 0), result(N*N);

    for(int i=0; i<N*N; i++){
        A[i] = static_cast<float>(rand())/RAND_MAX;
        B[i] = static_cast<float>(rand())/RAND_MAX;
        C[i] = static_cast<float>(rand())/RAND_MAX;
    }

    auto start = std::chrono::high_resolution_clock::now();

    for(int i=0; i<N; i++)
        for(int k=0; k<N; k++)
            for(int j=0; j<N; j++)
                AB[i*N+j] += A[i*N+k] * B[k*N+j];

    for(int i=0; i<N; i++)
        for(int k=0; k<N; k++)
            for(int j=0; j<N; j++)
                ABC[i*N+j] += AB[i*N+k] * C[k*N+j];

    for(int i=0; i<N*N; i++)
        result[i] = ABC[i] + A[i];

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end-start;
    return elapsed.count();
}

int main(){
    std::cout << "=====================================================\n";
    std::cout << "   GPU vs CPU Benchmark - A x B x C + A\n";
    std::cout << "=====================================================\n";
    std::cout << std::fixed << std::setprecision(6);
    std::cout << "N\t\tCPU (s)\t\tGPU (s)\t\tSpeedup\n";
    std::cout << "-----------------------------------------------------\n";

    for(int N: {256, 512, 1024, 2048, 4096}){
        double cpu = benchmark_cpu(N);
        double gpu = benchmark_gpu(N);
        
        double speedup = (gpu > 0.000001) ? cpu/gpu : 0.0;

        std::cout << N << "\t\t"
                  << cpu << "\t"
                  << gpu << "\t"
                  << speedup << "x\n";
    }

    return 0;
}
