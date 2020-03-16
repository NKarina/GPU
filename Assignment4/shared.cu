//Assignment 4- shared


#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <curand_kernel.h>

#define TILE_SIZE 7
#define MAX_MASK_WIDTH 7
__constant__ float M[MAX_MASK_WIDTH];

__global__ void convo(float *N, float *P, int Mask_Width, int Width){
        int i = blockIdx.x*blockDim.x + threadIdx.x;
        float Pvalue = 0;

        __shared__ float N_ds[TILE_SIZE];
        N_ds[threadIdx.x] = N[i];
        __syncthreads();

        int This_tile_start_point = blockIdx.x * blockDim.x;
        int Next_tile_start_point = (blockIdx.x + 1)*blockDim.x;
        int N_start_point = i - (Mask_Width/2);

        for (int j = 0; j < Mask_Width; j++){
                int N_index = N_start_point + j;

                if(N_index >= 0 && N_index < Width) {
                        if((N_index >= This_tile_start_point) && (N_index < Next_tile_start_point)) {
                                Pvalue += N_ds[threadIdx.x+j-(Mask_Width/2)]*M[j];
                        }
                        else{
                                Pvalue += N[N_index] * M[j];
                        }
                }
        }

}

int main(){
        float t = 0;
        cudaEvent_t start, stop;

        cudaEventCreate(&start);
        cudaEventCreate(&stop);

        int n = 16;
        int msize = MAX_MASK_WIDTH * sizeof(float);
        float In[n], O[n];

        int size = n * sizeof(float);

        float *d_i, *d_o, *d_m;

        cudaMalloc((void **) &d_i, size);
        cudaMalloc((void **) &d_o, size);
        cudaMalloc((void **) &d_m, msize);

        for(int i = 0; i < n; i++){
                if( i < n/2 - 1){
                        M[i] = (i * 7) % 9;
                }
                In[i] = (i * 7) % 10;
        }

        cudaMemcpy(d_i, In, size, cudaMemcpyHostToDevice);
        cudaMemcpyToSymbol(d_m, M, msize);

        cudaEventRecord(start, 0);

        convo<<<1, 2>>> (d_i, d_o, n/2 - 1, n);

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

