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
.global thread_id
.global thread_count
.global thread_stack
.global entry

@ ------------------------------------------------------------------------------
@ Saves the context of a thread
@ ------------------------------------------------------------------------------

@ ------------------------------------------------------------------------------
@ Restores the context of a thread
@ ------------------------------------------------------------------------------

@ ------------------------------------------------------------------------------
@ Entry point of the example thread
@ ------------------------------------------------------------------------------
entry:
    stmfd sp!, {lr}
    swi   0x1       @ get thread id
    mov   r4, r0

    cmp   r0, #0    @ fork another thread
    swieq 0x0

.loop:
    mov   r0, r4
    bl    print_int

    ldr   r0, =message
    bl    print_string
    ldr   r1, =50000000
.wait:
    subs  r1, #1
    bne   .wait

    b     .loop

    ldmfd sp!, {pc}

.section .rodata
  message: .ascii " tid\n\0"

@ ------------------------------------------------------------------------------
@ Thread contexts
@ ------------------------------------------------------------------------------
.section .data
thread_id: .word 0
thread_count: .word 1

thread_stack:
.rept 100
  .space (14 * 4), 0x0
.endr
