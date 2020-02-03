#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <curand_kernel.h>

__global__ void multiply(float* Md, float* Nd, float* Pd, int Width){

        //int Row = blockIdx.y * blockDim.y + threadIdx.y;
        //int Col = blockIdx.x * blockDim.x + threadIdx.x;

        float Pvalue = 0;
        for (int k = 0; k < Width; ++k){
                Pvalue += Md[threadIdx.y*Width+k] * Nd[k*Width+threadIdx.x];
        }
        Pd[threadIdx.y*Width+threadIdx.x] = Pvalue;
}

int main(){
        float t= 0;
        cudaEvent_t start, stop;

        cudaEventCreate(&start);
        cudaEventCreate(&stop);

        //HANDLE_ERROR(cudaEventRecord(start, 0));

        //determines properties of matrix i.e. nxn matrix
        int n = 16;

        float A[(n * n)], B[(n *n)], C[(n * n)];
        
        int size = (n * n) * sizeof(float);
        float *d_a, *d_b, *d_c;

        cudaMalloc((void **) &d_a, size);
        cudaMalloc((void **) &d_b, size);
        cudaMalloc((void **) &d_c, size);

        for(int i =0; i< (n * n); i++){
                if (i%2 == 0){
                        A[i] = 0;
                        B[i] = 1;
                }
        }

        cudaMemcpy(d_a, A, size, cudaMemcpyHostToDevice);
        cudaMemcpy(d_b, B, size, cudaMemcpyHostToDevice);

        cudaEventRecord(start, 0);

        multiply<<<1,256>>> (d_a, d_b, d_c, n);

        cudaMemcpy(C, d_c, size, cudaMemcpyDeviceToHost);

        cudaFree(d_c);
        cudaFree(d_b);
        cudaFree(d_a);

        cudaEventRecord(stop, 0);
        cudaEventSynchronize (stop);
        cudaEventElapsedTime(&t, start, stop);
       
        printf("Time:  %.2f ms \n", t);

        return 0;
}
