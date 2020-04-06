//Assignment 5


#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <curand_kernel.h>

#define TC 256

__device__ bool comp(char *l, char *r, int width){
        char * tmp;
        for(int i = 0; i < width; i++){
                if (l[i] > r[i]){
                        tmp = r;
                        r = l;
                        l = tmp;
                        return true;
                }
        }
        return false;
}

__global__ void rotate(char *N, char **P, int width){
        int i = blockIdx.x * blockDim.x + threadIdx.x;
        //float Pvalue = 0;
        char *current = N;
        P[0] = current;
        char *tmp;
        char ll;
        for(int j = 1; j < width; j++){
                ll = current[width - 1];
                tmp[i] = ll;
                for (int w = 0; w < width; w++){
                        tmp[w + 1] = current[w];
                }
                P[j + i] = tmp;
                current = tmp;
        }
}

__global__ void sort(char **N, char *P, int width){
        int i = blockIdx.x * blockDim.x + threadIdx.x;
        //char ** current = N;
        bool c1, c2;
        for(int j = 0; j < width; j + 2){
                c1 = comp(N[j + i], N[j+ 1 + i], width);
        }
        for (int j = 1; j < width; j + 2){
                c2 = comp(N[j + i], N[j+1 + i], width);
        }
        while (c1 || c2){
                for (int j = 0; j < width; j + 2){
                        c1 = comp(N[i + j], N[i + j+1], width);
                }
                for (int j = 1; j < width; j + 2){
                        c2 = comp(N[i + j], N[i + j+1], width);
                }
        }
        //take last letters
        for (int j = 0; j < width; j++){
                P[i] = N[i + j][width - 1];
        }
}


int main(){
        float t = 0;
        cudaEvent_t start, stop;


        cudaEventCreate(&start);
        cudaEventCreate(&stop);

       int width = 6;
        char I[width] = "orange";
        char O[width*width], FO[width];

        int size = width * sizeof(char);
        int bsize = width * width * sizeof(char);

        char *a, **o, *fo;

        cudaMalloc((void **) &a, size);
        cudaMalloc((void **) &o, bsize);
        cudaMalloc((void **) &fo, size);

        cudaMemcpy(a, I, size, cudaMemcpyHostToDevice);

        cudaEventRecord(start, 0);

        rotate<<<6,TC>>>(a, o, 6);

        cudaMemcpy(O, o, bsize, cudaMemcpyDeviceToHost);
        sort<<<6,TC>>>(o, fo, 6);

        cudaMemcpy(FO, fo, size, cudaMemcpyDeviceToHost);

        cudaFree(a);
        cudaFree(o);
        cudaFree(fo);

        cudaEventRecord(stop, 0);
        cudaEventSynchronize(stop);
        cudaEventElapsedTime(&t, start, stop);

        printf("Time: %.2f ms \n", t);
        return 0;

}

