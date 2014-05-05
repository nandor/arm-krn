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
.global setup_timer


.include "sys/ports.s"


@ ------------------------------------------------------------------------------
@ Enables the system timer
@ Arguments:
@   none
@ Return values:
@   none
@ Clobbers:
@   none
@ ------------------------------------------------------------------------------
setup_timer:
  @ ARM timer
  ldr     r0, =0x003E0000
  ldr     r1, =TIMER_CTL
  str     r0, [r1]

  ldr     r0, =99999
  ldr     r1, =TIMER_LOD
  str     r0, [r1]

  ldr     r0, =99999
  ldr     r1, =TIMER_RLD
  str     r0, [r1]

  ldr     r0, =0x000000F9
  ldr     r1, =TIMER_DIV
  str     r0, [r1]

  ldr     r0, =0
  ldr     r1, =TIMER_CLI
  str     r0, [r1]

  ldr     r0, =0x003E00A2
  ldr     r1, =TIMER_CTL
  str     r0, [r1]

  @ System timer
  ldr     r1, =STIMER_CLO
  ldr     r1, [r1]
  add     r1, #500
  ldr     r0, =STIMER_C3
  str     r1, [r0]

  ldr     r1, =0x02
  ldr     r0, =STIMER_CS
  str     r1, [r0]

  mov     pc, lr
