/*!
 * @file      Interrupts.c
 * @date      2019-03-24
 * @note      Taken from https://embedds.com/programming-avr-usart-with-avr-gcc-part-2/
 * @version   1.0.0
 * @brief     ATmega328_UART interrupts example.
 *
 * @details Demonstrates the usage of interrupts for transmitting and
 *          receiving characters through UART.
 *
 * There are 3 interrupt sources for UART:
 *  - RX complete is triggered when a character is received and
 *    stored in the data buffer.
 *  - TX ready is triggered when a character transmission is in
 *    progress, but the data register buffer is ready for new
 *    transmit data.
 *  - TX complete is triggered when a character transmission is
 *    completed (useful for half-duplex).
 *
 * The example receives characters through UART and writes them to a
 * buffer, when the buffer becomes full, it is returned back through
 * UART.
 *
 * @note The size of the buffer is configured inside `Buffer.h`.
 */

#include <stdio.h>
#include <avr/interrupt.h>

#include "ATmega328_UART.h"
#include "Buffer/Buffer.h" // buffer struct and access functions

volatile Buffer buffer;
volatile uint8_t txIndex = 0; // used when returning the received data


int main(void) {
	buffer_clear(&buffer);

	// Initialize UART
	UART_Init(UART_CHARACTER_SIZE_8, UART_PARITY_DISABLED,
		      UART_STOP_BITS_1);
	UART_EnableInterruptRxComplete(); // enable RX complete interrupt

	sei(); // enable interrupts

	for (;;) {}
}

// RX complete interrupt
// (triggered when a character is received through UART)
ISR(USART_RX_vect) {
	/* Read a character from UART and write it to the buffer. When
	 * the buffer becomes full, it will be returned back. */
	uint8_t data = UART_Read();

	// if the buffer is full - return the received data
	if (buffer_write(&buffer, data) == BUFFER_STATUS_ERROR) {
		UART_EnableInterruptTxReady(); // enable TX ready interrupt
		UART_DisableInterruptRxComplete(); // disable RX complete interrupt
		txIndex = 0;
	}
}

// TX ready interrupt
// (triggered when the TX buffer is ready for new data)
ISR(USART_UDRE_vect) {
	/* Read a character from the buffer and write it to UART. When
	 * every character is written to the UART, the buffer is cleared,
	 * the TX ready interrupt is disabled and the RX complete
	 * interrupt is reenabled. */
	uint8_t data;
	if (buffer_read(&buffer, txIndex, &data) == BUFFER_STATUS_SUCCESS) {
		++txIndex;
		UART_Write(data); // send a character through UART
	} else {
		buffer_clear(&buffer);
		UART_DisableInterruptTxReady(); // disable TX ready interrupt
		UART_EnableInterruptRxComplete(); // enable RX complete interrupt
	}
}