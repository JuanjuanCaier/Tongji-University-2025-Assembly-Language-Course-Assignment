#include <stdio.h>
// 为了便于与汇编对应，使用双循环法。

int main() {

    char Ch = 'a';
    for (int i = 0; i < 2; i++) {

        for (int j = 0; j < 13; j++) {

			printf("%c ", Ch);
            Ch++;
        }
		printf("\n");
    }

    return 0;
}