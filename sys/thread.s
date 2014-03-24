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
.global sys_spawn
.global sys_gettid
.global sys_yield
.global thread_test

@ ------------------------------------------------------------------------------
@ swi 0x00 - Spawns a new thread
@ Arguments:
@   r0 - entry point
@ Return value:
@   none
@ ------------------------------------------------------------------------------
sys_spawn:
  stmfd   sp!, {r0, lr}
  ldmfd   sp!, {r0, pc}

@ ------------------------------------------------------------------------------
@ swi 0x01 - Returns the thread id of the current thread
@ Arguments:
@   none
@ Return value:
@   r0 - numeric thread id
@ ------------------------------------------------------------------------------
sys_gettid:
  stmfd   sp!, {lr}
  ldmfd   sp!, {pc}

@ ------------------------------------------------------------------------------
@ swi 0x02 - Transfers control to other threads
@ Arguments:
@   none
@ Return value:
@   none
@ ------------------------------------------------------------------------------
sys_yield:
  stmfd   sp!, {lr}
  ldmfd   sp!, {pc}

@ ------------------------------------------------------------------------------
@ Entry point of the example thread
@ ------------------------------------------------------------------------------
thread_test:
  stmfd sp!, {lr}

  @ get thread id
  swi   0x1
  mov   r4, r0

.loop:
  mov   r0, r4
  bl    printi
  ldr   r1, =50000000
.wait:
  subs  r1, #1
  bne   .wait

  b     .loop

  ldmfd sp!, {pc}

@ ------------------------------------------------------------------------------
@ Thread contexts
@ ------------------------------------------------------------------------------
.section .data
thread_id:
  .word 0
thread_count:
  .word 1
thread_meta:
  .rept 128
    .space 16 * 4, 0x0             @ r0-r12, sp, lr, pc
    .space 16 * 4, 0x0             @ reserved
  .endr
