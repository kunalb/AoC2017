#include "stdio.h"
#include "stdlib.h"

int fill_buffer(int step_size) {
    int *buffer = (int*) malloc(50000000 * sizeof(int));
    int cur = 0;

    buffer[0] = 0;

    for (int i = 1; i <= 50000000; i++) {
        for (int j = 0; j < step_size; j++) {
            cur = buffer[cur];
        }

        buffer[i] = buffer[cur];
        buffer[cur] = i;
        cur = i;
    }

    return buffer[0];
}

int main() {
    printf("%d", fill_buffer(314));
}