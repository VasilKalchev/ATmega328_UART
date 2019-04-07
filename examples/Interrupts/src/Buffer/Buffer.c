#include "Buffer.h"

void buffer_clear(volatile Buffer* buffer) {
	buffer->index = 0;
}

uint8_t buffer_write(volatile Buffer* buffer, const uint8_t data) {
	if (buffer->index < BUFFER_SIZE) {
		buffer->data[buffer->index] = data;
		++buffer->index;
		return BUFFER_STATUS_SUCCESS;
	} else {
		return BUFFER_STATUS_ERROR;
	}
}

uint8_t buffer_read(volatile Buffer* buffer, const uint8_t index, uint8_t* data) {
	if (index < buffer->index) {
		*data = buffer->data[index];
		return BUFFER_STATUS_SUCCESS;
	} else {
		return BUFFER_STATUS_ERROR;
	}
}