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
.global test_math

@ ------------------------------------------------------------------------------
@ Multiplies two column-major matrices
@ r0 - Address of the first matrix
@ r1 - Address of the second matrix
@ r2 - Address where the result is stored
@ ------------------------------------------------------------------------------
mat4_mul:
  @ldr     r0, [r1], #4
  @vdup.32 q0, r0
  mov     pc, lr

@ ------------------------------------------------------------------------------
@ Test suite for the math library
@ ------------------------------------------------------------------------------
test_math:
  stmfd sp!, {lr}
  sub sp, #64

  @ Test mat4 mul
  ldr     r0, =test_mat4_mul_a
  ldr     r1, =test_mat4_mul_b
  mov     r2, sp
  bl      mat4_mul

  mov     r0, sp
  ldr     r1, =test_mat4_mul_b
  mov     r2, #64
  bl      assert_mem_equ

  add sp, #64
  ldmfd sp!, {pc}

.section .data
test_mat4_mul_a:
  .float 1.0, 0.0, 0.0, 0.0
  .float 0.0, 1.0, 0.0, 0.0
  .float 0.0, 0.0, 1.0, 0.0
  .float 0.0, 0.0, 0.0, 1.0

test_mat4_mul_b:
  .float 1.0, 2.0, 3.0, 4.0
  .float 2.0, 3.0, 4.0, 5.0
  .float 3.0, 4.0, 5.0, 6.0
  .float 4.0, 5.0, 6.0, 5.0

@ ------------------------------------------------------------------------------
@ Data
@ ------------------------------------------------------------------------------
.section .rodata
test_mat4_mul_title:
  .ascii "Testing mat4_mul: \0"

