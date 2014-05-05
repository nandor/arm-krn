@ ------------------------------------------------------------------------------
@ The MIT License (MIT)
@
@ Copyright (c) 2014 Nandor Licker
@
@ Permission is hereby granted, free of charge, to any person obtaining a copy
@ of this software and associated documentation files (the "Software"), to deal
@ in the Software without restriction, including without limitation the rights
@ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
@ copies of the Software, and to permit persons to whom the Software is
@ furnished to do so, subject to the following conditions:
@
@ The above copyright notice and this permission notice shall be included in
@ all copies or substantial portions of the Software.
@
@ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
@ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
@ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
@ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
@ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
@ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
@ THE SOFTWARE.
@ ------------------------------------------------------------------------------
.global setup_uart
.global uart_putc


.include "sys/ports.s"


@ ------------------------------------------------------------------------------
@ Enables UART
@ Arguments:
@   none
@ Return value:
@   none
@ Clobbers:
@   r0, r1
@ ------------------------------------------------------------------------------
setup_uart:
  mov      pc, lr

@ ------------------------------------------------------------------------------
@ Prints a character to UART
@ Arguments:
@   r0 - Character to be printed
@ Return value:
@   none
@ Clobbers:
@   r1, r2
@ ------------------------------------------------------------------------------
uart_putc:
  @ Wait until bit 7 of UART_FR is set (TX FIFO empty)
  ldr     r2, =UART_FR
1:
  ldr     r1, [r2]
  tst     r1, #0x80
  beq     1b

  @ Write out the byte to UART_DR
  ldr     r2, =UART_DR
  strb    r0, [r2]

  mov     pc, lr

@ ------------------------------------------------------------------------------
@ Retrieves a character from UART
@ Arguments:
@   none
@ Return value:
@   r0 - character read
@ Clobbers:
@   r1
@ ------------------------------------------------------------------------------
uart_getc:
  @ Wait until bit 6 of UART_FR is set (RX FIFO full)
  ldr     r1, =UART_FR
1:
  ldr     r0, [r1]
  tst     r0, #0x40
  beq     1b

  @ Read in the character
  eor     r0, r0
  ldr     r1, =UART
  ldrb    r0, [r1]

  mov     pc, lr
