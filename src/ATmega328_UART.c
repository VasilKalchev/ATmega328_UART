/*
The MIT License (MIT)
Copyright (c) 2019 Vasil Kalchev
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/*!
 * @file    ATmega328_UART.c
 * @date    2019-03-23
 * @author  Vasil Kalchev
 * @version 1.0.0
 * @copyright The MIT License
 * @brief   ATmega328's UART implementation.
 */

#include "ATmega328_UART.h"
#include <avr/io.h>

void UART_Init(const UART_CharacterSize characterSize,
	           const UART_Parity parity,
			   const UART_StopBits stopBits) {
	// Configure baud rate
	#include <util/setbaud.h>
	UBRR0H = UBRRH_VALUE;
	UBRR0L = UBRRL_VALUE;

	#if USE_2X
	UCSR0A |= (1 << U2X0);
	#else
	UCSR0A &= ~(1 << U2X0);
	#endif

	UCSR0A &= ~(1 << FE0); // clear framing error

	// Enable RX, TX and partially configure character size
	UCSR0B = ((1 << RXEN0) | (1 << TXEN0) | (characterSize & 0x04));

	// Configure parity, stop bits and character size
	UCSR0C = (parity | stopBits | ((characterSize & 0x03) << UCSZ00));
}

void UART_EnableInterruptTxReady(void) {
	UCSR0B |= (1 << UDRIE0);
}

void UART_DisableInterruptTxReady(void) {
	UCSR0B &= ~(1 << UDRIE0);
}

void UART_EnableInterruptRxComplete(void) {
	UCSR0B |= (1 << RXCIE0);
}

void UART_DisableInterruptRxComplete(void) {
	UCSR0B &= ~(1 << RXCIE0);
}


UART_Status UART_WriteReady(void) {
	return ((UCSR0A & UDRE0) == UDRE0);
}

void UART_Putchar(const uint8_t data, FILE *stream) {
	// Append line feed to newline character
	if (data == '\n') {
		UART_Putchar('\r', 0);
	}
	// Wait until write buffer is empty
	while ((UCSR0A & (1 << UDRE0)) == 0) {}
	UDR0 = data;
}

UART_Status UART_ReadReady(void) {
	// Read ready status | errors status
	return ((UCSR0A >> RXC0) | (UCSR0A & 0x1C));
}

uint8_t UART_Getchar(FILE *stream) {
	// Wait until there is something in the read buffer
	while (!(UCSR0A & (1 << RXC0)));
	return UDR0;
}


void UART_Write(const uint8_t data) {
	UDR0 = data;
}

uint8_t UART_Read(void) {
	return UDR0;
}