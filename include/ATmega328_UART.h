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
 * @file    ATmega328_UART.h
 * @date    2019-03-23
 * @author  Vasil Kalchev
 * @version 1.0.0
 * @copyright The MIT License
 * @brief   ATmega328's UART interface.
 *
 * @todo USART init
 * @todo add polling example
 */

 /*!
  * @defgroup module_dataTypes Data types
  */
 /*!
  * @defgroup module_functions Functions
  */

#pragma once
#include <stdint.h>
#include <stdio.h>

/*! @addtogroup module_dataTypes
 * @{ */

/*!
 * @name Data typedefs
 * @{
 */
typedef uint8_t UART_CharacterSize;
typedef uint8_t UART_Parity;
typedef uint8_t UART_StopBits;
typedef uint8_t UART_Status;
//!@}

/*!
 * @name Character size configuration constants
 * @brief Use one of these as the 1st parameter to
 *        `UART_Init(UART_CharacterSize characterSize, UART_Parity parity, UART_StopBits stopBits)`
 * @anchor UART_CharacterSize
 * @{
 */
#define UART_CHARACTER_SIZE_5 (0x0)
#define UART_CHARACTER_SIZE_6 (0x1)
#define UART_CHARACTER_SIZE_7 (0x2)
#define UART_CHARACTER_SIZE_8 (0x3)
#define UART_CHARACTER_SIZE_9 (0x7)
//!@}

/*!
 * @name Parity configuration constants
 * @brief Use one of these as the 2nd parameter to
 *        `UART_Init(UART_CharacterSize characterSize, UART_Parity parity, UART_StopBits stopBits)`
 * @anchor UART_Parity
 * @{
 */
#define UART_PARITY_DISABLED (0x0 << UPM00)
#define UART_PARITY_EVEN (0x2 << UPM00)
#define UART_PARITY_ODD (0x3 << UPM00)
//!@}

/*!
 * @name Stop bits configuration constants
 * @brief Use one of these as the 3rd parameter to
 *        `UART_Init(UART_CharacterSize characterSize, UART_Parity parity, UART_StopBits stopBits)`
 * @anchor UART_StopBits
 * @{
 */
#define UART_STOP_BITS_1 (0x0 << USBS0)
#define UART_STOP_BITS_2 (0x1 << USBS0)
//!@}

/*!
 * @name Return status masks
 * @anchor ReturnStatus
 * @{
 */
#define UART_STATUS_TRUE (1 << 0)
#define UART_STATUS_FALSE (0 << 0)
#define UART_STATUS_FRAME_ERROR (1 << FE0)
#define UART_STATUS_OVERRUN_ERROR (1 << DOR0)
#define UART_STATUS_PARITY_ERROR (1 << UPE0)
//!@}

//!@} module_dataTypes


/*!
 * @name Initialization
 * @{
 */
/*!
 * @brief Initialize UART.
 * @details Initialzes the UART according to the given parameters and
 *          the defined `BAUD`.
 * @ingroup module_functions
 * @note `F_CPU` and `BAUD` must be already defined.
 *
 * @param[in] characterSize - data length of the frame
 * @param[in] parity - type of parity
 * @param[in] stopBits - number of stop bits
 *
 * @see @ref UART_CharacterSize
 * @see @ref UART_Parity
 * @see @ref UART_StopBits
 */
void UART_Init(const UART_CharacterSize characterSize,
	           const UART_Parity parity,
	           const UART_StopBits stopBits);
//!@}


/*!
 * @name Non-blocking read/write
 * @brief (for interrupts or polling implementation )
 * @{
 */
/*!
 * @brief Receive a single character.
 * @ingroup module_functions
 * @note Non-blocking.
 * @note For interrupts or polling implementation.
 *
 * @return the received character
 */
uint8_t UART_Read(void);

/*!
 * @brief Transmit a single character.
 * @ingroup module_functions
 * @note Non-blocking.
 * @note For interrupts or polling implementation.
 *
 * @param[in] data - the character that will be transmitted
 */
void UART_Write(const uint8_t data);
//!@}


/*!
 * @name Status checking
 * @brief (for polling implementation)
 * @{
 */
/*!
 * @brief Check if UART is ready for transmission.
 * @ingroup module_functions
 *
 * @return status
 * @retval UART_STATUS_TRUE - ready for transmission
 * @retval UART_STATUS_FALSE - last transmission is still in progress
 *
 * @see @ref ReturnStatus
 */
UART_Status UART_WriteReady(void);

/*!
 * @brief Check if there is new data available for reading.
 * @details Also returns the error status of the reception.
 * @ingroup module_functions
 *
 * @return bitfield of the read ready status and the error status
 *         | Position |           Name            |      Explanation     |
 *         | -------- | ------------------------  | -------------------- |
 *         |     0    | UART_STATUS_TRUE          | Successful reception |
 *         |     2    | UART_STATUS_PARITY_ERROR  | Parity error         |
 *         |     3    | UART_STATUS_OVERRUN_ERROR | Overrun error        |
 *         |     4    | UART_STATUS_FRAME_ERROR   | Frame error          |
 * @retval 0 - no new data
 * @retval 1 - successful reception
 * @retval > 1 - failed reception
 *
 * @see @ref ReturnStatus
 */
UART_Status UART_ReadReady(void);
//!@}


/*!
 * @name Interrupts control
 * @brief (for interrupts implementation)
 * @{
 */
/*!
 * @brief Enable TX ready interrupt.
 * @ingroup module_functions
 */
void UART_EnableInterruptTxReady(void);

/*!
 * @brief Disable TX ready interrupt.
 * @ingroup module_functions
 */
void UART_DisableInterruptTxReady(void);

/*!
 * @brief Enable RX complete interrupt.
 * @ingroup module_functions
 */
void UART_EnableInterruptRxComplete(void);

/*!
 * @brief Disable TX complete interrupt.
 * @ingroup module_functions
 */
void UART_DisableInterruptRxComplete(void);
//!@}


/*!
 * @name Stream read/write
 * @brief (for formatted IO streams implementation)
 * @{
 */
/*!
 * @brief Transmit a single character.
 * @ingroup module_functions
 *
 * @note For formatted IO streams implementation.
 * @note Blocks until UART is ready for transmission. To avoid
 *       blocking use `UART_WriteReady(void)` to check if UART is
 *       ready for transmission.
 * @note When sending newline, line feed is automatically appended.
 *
 * @param[in] data - the character that will be transmitted
 * @param stream - pointer to the FILE stream
 *
 * @see `UART_WriteReady(void)`
 * @ingroup io_streams_implementation
 */
void UART_Putchar(const uint8_t data, FILE *stream);


/*!
 * @brief Receive a single character.
 * @ingroup module_functions
 *
 * @note For formatted IO streams implementation.
 * @note Blocks until there is new data to be read. To avoid blocking
 *       use `UART_ReadReady(void)` to check if new data is available.
 * @note Ignores error statuses.
 *
 * @param stream - pointer to the FILE stream
 * @return the received character
 *
 * @see `UART_ReadReady(void)`
 * @ingroup io_streams_implementation
 */
uint8_t UART_Getchar(FILE *stream);
//!@}
