//Assignment 4- Naive


#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <curand_kernel.h>


__global__ void convolution_1D(float *N, float *M, float *P, int Mask_width, int Width){
        int i = blockIdx.x*blockDim.x + threadIdx.x;

        float Pvalue = 0;
        int N_start_point = i - (Mask_width/2);
        for (int j = 0; j< Mask_width; j++){
                if(N_start_point + j >= 0 && N_start_point + j < Width){
                        Pvalue += N[N_start_point + j]*M[j];
                }
        }
        P[i] = Pvalue;
}

int main(){
        float t = 0;
        cudaEvent_t start, stop;

        cudaEventCreate(&start);
        cudaEventCreate(&stop);

        int n = 16;
        float In[n], O[n], M[(n/2 - 1)];

        int size = n  * sizeof(float);
        int msize = (n/2 - 1) * sizeof(float);
        float *d_i, *d_m, *d_o;

        cudaMalloc((void **) &d_i, size);
        cudaMalloc((void **) &d_m, msize);
        cudaMalloc((void **) &d_o, size);

        for(int i = 0; i < n; i++){
                if (i < n/2 - 1){
                        M[i] = (i * 7) % 9;
                }
                In[i] = (i * 7) % 10;
        }

        cudaMemcpy(d_i, In, size, cudaMemcpyHostToDevice);
        cudaMemcpy(d_m, M, msize, cudaMemcpyHostToDevice);

        cudaEventRecord(start, 0);

        convolution_1D<<<1, 2>>> (d_i, d_m, d_o, n/2 - 1, n);

        cudaMemcpy(O, d_o, size, cudaMemcpyDeviceToHost);

        cudaFree(d_o);
        cudaFree(d_m);
        cudaFree(d_i);


        cudaEventRecord(stop, 0);
        cudaEventSynchronize (stop);
        cudaEventElapsedTime(&t, start, stop);

        printf("Time: %.2f ms \n", t);

        return 0;

}
