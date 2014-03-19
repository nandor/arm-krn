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

.section .text

.equ UART0_ADDR, 0x101f1000

@ Prints r0 to UART0
.global print_int
print_int:
  stmfd   sp!, {r4-r6, lr}
  sub     r3, sp, #12

  @ r0 = abs(s0), r2 = r0
  movs    r2, r0
  negmi   r0, r0

  ldr     r6, =429496730
  mov     r5, #10

.div_loop:
  mvn     r1, r0

  @ r0 = r0 / 10
  @ r1 = r0 % 10
  sub     r0, r0, r0, lsr #30
  umull   r4, r0, r6, r0
  smlal   r1, r4, r0, r5

  @ Store rem + '0' in the buffer
  rsb     r1, #47
  strb    r1, [r3], #1
  cmp     r0, #0
  bne     .div_loop

  @ Write '-' if negative
  cmp     r2, #0
  bgt     .no_sign
  mov     r2, #45
  strb    r2, [r3], #1
.no_sign:

  @ Write inverted buffer to UART0
  sub     r3, #1
  ldr     r2, =UART0_ADDR
.print_loop:
  ldrb    r0, [r3], #-1
  strb    r0, [r2]
  cmp     r0, #0
  bne     .print_loop

  ldmfd   sp!, {r4-r6, pc}
