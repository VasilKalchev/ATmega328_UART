/*!
 * @file      IO_streams.c
 * @date      2019-03-24
 * @note      Taken from https://embedds.com/using-standard-io-streams-in-avr-gcc/
 * @version   1.0.0
 * @brief     ATmega328_UART streams example.
 *
 * @details Demonstrates the usage of formatted data streams for UART
 *          communication.
 */

#include <stdio.h>
#include <math.h>
#include <avr/pgmspace.h>

#include "ATmega328_UART.h"


// Set stream pointer
static FILE uartStream = FDEV_SETUP_STREAM(UART_Putchar, UART_Getchar,
	_FDEV_SETUP_RW);

int main(void) {
	uint16_t u16Data = 10;
	double fltData = 3.141593;
	int8_t s8Data = -5;
	uint8_t u8str[] = "Hello world";
	uint8_t u8Data;

	// Initialize UART
	UART_Init(UART_CHARACTER_SIZE_8, UART_PARITY_DISABLED, UART_STOP_BITS_1);

	// Assign our stream to standard I/O streams
	stdin = stdout = &uartStream;

	// Print unsigned integer
	printf("u16Data: %u \n", u16Data);

	// Print hexadecimal number
	printf("u16Data(hex): %#04x \n", u16Data);

	// Print double with fprint function
	fprintf(stdout, "double: %08.3f \n", fltData);

	// Print signed data
	printf("s8Data: %d \n", s8Data);

	// Print string
	printf("u8str: %-20s \n", u8str);

	// Print string stored in flash
	printf_P(PSTR("String stored in flash\n"));

	// Printing back, slash and percent symbol
	printf("printf(\"\\nstring = %%-20s\",u8str);\n");

	for(;;) {
		printf_P(PSTR("\nPress any key...\n"));

		// Scan standard stream
		scanf("%c", &u8Data);

		printf_P(PSTR("You pressed: "));
		// Print scanned character and its code	
		printf("%c; Key code: %u \n", u8Data, u8Data);
	}
}