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

.global _start
_start:
    ldr   sp, =stack_top
    ldr   r0, =1234567890
    bl    print_int

    ldr   r0, =0x101f1000
    ldr   r1, =hello
.loop:
    ldrb  r2, [r1], #1
    cmp   r2, #0
    beq   .end
    strb  r2, [r0]
    b     .loop
.end:

    b     .

.section .data
  hello: .ascii "Hello, world\0"
