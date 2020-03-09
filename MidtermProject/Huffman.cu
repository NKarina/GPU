

#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <curand_kernel.h>


//tree node
struct Node {

	char data;
	unsigned freq;
	struct Node *left; *right;
}:

//holds Nodes
struct Tree {
	unsigned size;
	unsigned capacity
	struct Node**array;
};


//make new node
struct Tree* newNode(char data, unsigned freq) 
{ 
	struct Tree* temp 
		= (struct Tree*)malloc
(sizeof(struct Tree)); 

	temp->left = temp->right = NULL; 
	temp->data = data; 
	temp->freq = freq; 

	return temp; 
}



struct *Tree buildLeaves(char data[], int freq[], int size){
	struct *Tree tree = {size, size};
	for (int i = 0; i < size; ++i)
		tree->array[i] = newNode(data[i], freq[i]);

	tree->size = size;

	return tree;

}

__global__ void findMin(struct *Tree t, struct Node* min){
	Node *ptr1, *ptr2;
	ptr2 = t.array
	min = ptr2.freq
	for (ptr1 = t.array; *ptr1 != 0; ptr1++){
		if (ptr1.freq < min)
			min = ptr1
	}
}

void Insert(struct *Tree, struct Node *p){
	//
}

struct Node* buildTree(char letters[], int freq[], int size){
	struct Node *left, *right, *parent;	//set to null
	
	//build tree starting bottom up
	struct Tree* tree = buildLeaves(data, freq, size);
	struct Tree* t;	

	while (Tree.size != 1){

		//gpu functions
		cudaMalloc(&t, size)
		cudaMemcpy(t, tree,size, cudaMemcpyHosttoDevice);

		cudaMalloc(&l, size)
		cudaMemcpy(l, left, size, cudaMemcpyHosttoDevice);

		cudaMalloc(&r, size)
		cudaMemcpy(r, right, size, cudaMemcpyHosttoDevice);		

		findMin<<<2, 20>>>(t, struct Node* l);
		findMin<<<2, 20>>>(t, struct Node* r);

		cudaMemcpy(left, l, size, cudaMemcpyDevicetoHost);
		cudaMemcpy(right, r, size, cudaMemcpyDevicetoHost);
		
		parent = newNode('#', left->freq + right->freq);
		
		parent->left = left;
		parent->right = right;

		Insert(tree, parent);

	}
	
	findMin(tree, struct Node* root);

}

int Leaf(struct Tree* root){
	return !(root->left) && !(root->right);
}

void printCode(int code[], int a){
	for( int i = 0; i < a; ++i) printf("%d", code[i]);
	printf("\n")
}

void printAllCodes(struct Tree* root, int code[], int parent){
	if (root->left){
		code[parent] = 0;
		printAllCodes(root->left, code, parent + 1);
	}

	if(root->right){
		code[parent] = 1;
		printAllCodes(root->right, code, parent + 1);
	}
	if(Leaf(root)){
		printf("%c ", root->letter);
		printCode(code, parent);
	}

}

void Huffman(char letters[], int freq[], int size){
	//build tree
	struct Tree* root = buildTree(letters, freq, size);

	//print code
	int code[MAX_TREE_HT], parent = 0;

	printAllCodes(root, code, parent);
}


int main(){
	
	char letters[] = {a, b, c, d, e, f, g}
	int fq[] = {10, 42, 22, 30, 4, 58, 67}
	int size = sizeof(letters) / sizeof(letters[0]);
	Huffman(letters, fq, size)
	return 0;

}

	



