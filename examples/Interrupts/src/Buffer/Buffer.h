#pragma once
#include <stdint.h>

#define BUFFER_SIZE (4)

#define BUFFER_STATUS_SUCCESS (0)
#define BUFFER_STATUS_ERROR (1)

typedef struct {
	uint8_t data[BUFFER_SIZE];
	uint8_t index;
} Buffer;

void buffer_clear(volatile Buffer* buffer);
uint8_t buffer_write(volatile Buffer* buffer, const uint8_t data);
uint8_t buffer_read(volatile Buffer* buffer, const uint8_t index, uint8_t* data);
