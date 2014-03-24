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
.section .text
.global assert_mem_equ


@ ------------------------------------------------------------------------------
@ Checks whether two string in memory are equal
@ ------------------------------------------------------------------------------
assert_mem_equ:
  stmfd   sp!, {r4, lr}

.loop:
  ldrb    r3, [r0], #1
  ldrb    r4, [r1], #1
  cmp     r3, r4
  bne     .fail

  subs    r2, #1
  bne     .loop

  ldr     r0, =msg_pass
  bl      print_string

  ldmfd   sp, {r4, pc}
.fail:

  ldr     r0, =msg_fail
  bl      print_string

  ldmfd   sp!, {r4, pc}

@ ------------------------------------------------------------------------------
@ Status messages
@ ------------------------------------------------------------------------------
.section .data
msg_fail:
  .ascii "Test failed\n\0"
msg_pass:
  .ascii "Test passed\n\0"

