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
.global syscall

@ ------------------------------------------------------------------------------
@ System Call handlers
@ ------------------------------------------------------------------------------
@ System calls receive the following arguments:
@   r0 - 1st user argument
@   r1 - 2nd user argument
@   r2 - 3rd user argument
@   r3 - 4th user argument
@   r4 - bits [23:8] of syscall
@   r5 - bits [7:0] of syscall
@   r6 - procedure address
@ Register saving:
@   r4-r6 are preserved by the wrapper, so individual syscall only
@   need to preserve r7-r12. Unless stated otherwise, r0-r4 are
@   overwritten by syscalls
@ ------------------------------------------------------------------------------
syscall:
  .word sys_spawn     @ 0x00
  .word sys_gettid    @ 0x01
  .word sys_yield     @ 0x02
  .word sys_panic     @ 0x03
  .rept (syscall + 1024 - .) / 4
    .word 0x0
  .endr

@ ------------------------------------------------------------------------------
@ swi 0x03 - Kernel panic
@ Arguments:
@   none
@ Return value:
@   none
@ ------------------------------------------------------------------------------
sys_panic:
  @ Disable interrupts
  mrs     r0, cpsr
  orr     r0, r0, #0xC0
  msr     cpsr, r0

  @ Print panic message
  ldr     r0, =.msg_beg
  ldr     lr, =.msg_end
  b       prints
.msg_beg:
  .ascii "\n\nKERNEL PANIC: Softare interrupt\n\n\n\0"
  .align 4
.msg_end:

  @ Sleep & hang
.hang:
  b     .hang