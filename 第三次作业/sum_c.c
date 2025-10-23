#include <stdio.h>

int main() {

	int Sum = 0;
	for (int i = 1; i <= 100; i++) {
		Sum += i;
	}

	printf("Sum is %d\n", Sum);
}