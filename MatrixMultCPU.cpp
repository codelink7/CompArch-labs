#include <iostream>
#include <vector>
#include <chrono>
#include <cstdlib>
#include <iomanip>

using Matrix = std::vector<float>;

Matrix createMatrix(int N){
    Matrix M(N*N);
    for(int i=0; i<N*N; i++)
        M[i] = static_cast<float>(rand())/RAND_MAX;
    return M;
}

Matrix multiply(const Matrix& A, const Matrix& B, int N){
    Matrix C(N*N, 0.0f);
    for(int i=0; i<N; i++)
        for(int k=0; k<N; k++)
            for(int j=0; j<N; j++)
                C[i*N + j] += A[i*N+k] * B[k*N+j];
    return C;
}

Matrix add(const Matrix& A, const Matrix& B, int N){
    Matrix C(N*N);
    for(int i=0; i<N*N; i++)
        C[i] = A[i] + B[i];
    return C;
}

double benchmark(int N){
    srand(42);
    Matrix A = createMatrix(N);
    Matrix B = createMatrix(N);
    Matrix C = createMatrix(N);

    auto start = std::chrono::high_resolution_clock::now();

    Matrix AB = multiply(A, B, N);
    Matrix ABC = multiply(AB, C, N);
    Matrix result = add(ABC, A, N);

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end-start;
    return elapsed.count();
}

int main(){
    std::cout << "==================================\n";
    std::cout << "  CPU Matrix Benchmark (A*B*C+A)\n";
    std::cout << "==================================\n";
    std::cout << std::fixed << std::setprecision(6);
    std::cout << "Size (N)\tTime (s)\n";
    std::cout << "----------------------------------\n";

    for(int N: {128, 256, 512, 1024, 2048}){
        double t = benchmark(N);
        std::cout << N << "\t\t" << t << "\n";
    }

    return 0;
}
