#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void multiply(float m[], float n[], float p[], int width){
        for(int i = 0; i< width; ++i){
                for(int j = 0; j< width; ++j){
                        int sum = 0;
                        for (int k = 0; k < width; ++k){
                                int a = m[i * width + k];
                                int b = n[k * width + j];
                                sum += a * b;
                        }
                        p[i * width + j] = sum;
                }
        }
}

int main(){
        clock_t start, stop;

        double t = 0;

        //set up matrix
        int n = 128;
        float A[(n * n)], B[(n * n)], C[(n * n)];
        srand(time(0));
        for (int i = 0; i < (n * n); i++){
                A[i] = rand() % 2;
                B[i] = rand() % 2;
        }

        start = clock();

        //multiply code
        multiply(A, B, C, n);
        //MatrixMul(pa, pb, pc, n);

        stop = clock();
        t = ((stop - start)/CLOCKS_PER_SEC);
        printf("Time: %.5f ms \n", t);
        return 0;
}
