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
@   need to preserve r7-r12
@ ------------------------------------------------------------------------------
syscall:
  .word sys_fork
  .word sys_gettid
  .word sys_yield
  .word sys_print
  .word sys_read
  .rept (syscall + 1024 - .) / 4
    .word 0x0
  .endr

@ ------------------------------------------------------------------------------
@ swi 0x00
@ ------------------------------------------------------------------------------
sys_fork:
  stmfd sp!, {lr}
  ldr r0, =0
  bl  print_int
  ldmfd sp!, {pc}

@ ------------------------------------------------------------------------------
@ swi 0x01
@ ------------------------------------------------------------------------------
sys_gettid:
  stmfd sp!, {lr}
  ldr r0, =1
  bl  print_int
  ldmfd sp!, {pc}

@ ------------------------------------------------------------------------------
@ swi 0x02
@ ------------------------------------------------------------------------------
sys_yield:
  stmfd sp!, {lr}
  bl  print_int
  ldmfd sp!, {pc}

@ ------------------------------------------------------------------------------
@ swi 0x03
@ ------------------------------------------------------------------------------
sys_print:
  stmfd sp!, {lr}
  bl  print_int
  ldmfd sp!, {pc}

@ ------------------------------------------------------------------------------
@ swi 0x04
@ ------------------------------------------------------------------------------
sys_read:
  stmfd sp!, {lr}
  bl  print_int
  ldmfd sp!, {pc}
