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


.include "sys/ports.s"


@ ------------------------------------------------------------------------------
@ Entry point of the kernel
@ ------------------------------------------------------------------------------
kernel_entry:
  @ Disable IRQ & FIQ
  mrs     r0, cpsr
  orr     r0, r0, #0xC0
  msr     cpsr, r0


  @ Initialise subsystems
  bl      setup_stacks
  bl      setup_handlers
  bl      setup_uart
  bl      setup_timer
  bl      setup_irq

  @ Enable IRQ, FIQ and enter user mode
  mrs     r0, cpsr
  bic     r0, r0, #0xCF
  orr     r0, r0, #0x02
  msr     cpsr, r0
  ldr     sp, =stack_sys

  @ Spawn 3 threads
  @ldr     r0, =thread_test
  @swi     #0x00
  @swi     #0x00
  @swi     #0x00
  @swi     #0x00

1:
  b        1b

@ ------------------------------------------------------------------------------
@ Relocates interrupt handlers to 0x0
@ Arguments:
@   none
@ Return value:
@   none
@ ------------------------------------------------------------------------------
setup_handlers:
  mov     r1, #0x0
  ldr     r2, =_handlers

1:
  ldr     r3, [r2], #4
  str     r3, [r1], #4
  cmp     r1, #64
  bls     1b

  mov     pc, lr

@ ------------------------------------------------------------------------------
@ Sets up statcks for all modes
@ Arguments:
@   none
@ Return value:
@   none
@ ------------------------------------------------------------------------------
setup_stacks:
  mrs     r0, cpsr
  bic     r0, r0, #0x1F

  @ IRQ mode
  orr     r1, r0, #0x12
  msr     cpsr, r1
  ldr     sp, =stack_irq

  @ FIQ mode
  orr     r1, r0, #0x11
  msr     cpsr, r1
  ldr     sp, =stack_fiq

  @ UND mode
  orr     r1, r0, #0x1B
  msr     cpsr, r1
  ldr     sp, =stack_und

  @ ABT mode
  orr     r1, r0, #0x17
  msr     cpsr, r1
  ldr     sp, =stack_abt

  @ SVC mode
  orr     r1, r0, #0x13
  msr     cpsr, r1
  ldr     sp, =stack_svc

  mov     pc, lr


@ ------------------------------------------------------------------------------
@ Interrupts
@ ------------------------------------------------------------------------------
@ When an interrupt is triggered, the CPU jumps to the interrupt vector &
@ executes an instruction. That instruction has to be a jump to the actual
@ interrupt handler.
@ Due to the fact that ARM does not support absolute jumps, @ we fill the table
@ with ldr pc, [pc, #32] and we store the actual addresses after the jumps
@ On some platfroms, this table is not loaded to 0x0, so the first thing our
@ kernel does is to move the table to the correct location
@ ------------------------------------------------------------------------------
_handlers:
  ldr     pc, _handler_reset
  ldr     pc, _handler_undef
  ldr     pc, _handler_swi
  ldr     pc, _handler_prefetch_abort
  ldr     pc, _handler_data_abort
  b       .
  ldr     pc, _handler_irq
  ldr     pc, _handler_fiq

_handler_reset:          .word handler_reset
_handler_undef:          .word handler_undef
_handler_swi:            .word handler_swi
_handler_prefetch_abort: .word handler_prefetch_abort
_handler_data_abort:     .word handler_data_abort
_handler_unused:         .word 0x0
_handler_irq:            .word handler_irq
_handler_fiq:            .word handler_fiq

@ ------------------------------------------------------------------------------
@ Reset interrupt handler
@ ------------------------------------------------------------------------------
handler_reset:
  b       .


@ ------------------------------------------------------------------------------
@ Undefined instruction interrupt
@ ------------------------------------------------------------------------------
handler_undef:
  stmfd   sp!, {lr}

  ldr     r0, =.msg_beg
  ldr     lr, =.msg_end
  b       prints
.msg_beg:
  .ascii "\n\nKERNEL PANIC: Undefined Instruction\n\n\0"
  .align 4
.msg_end:
  b       .


@ ------------------------------------------------------------------------------
@ SWI handler
@ ------------------------------------------------------------------------------
handler_swi:
  stmfd   sp!, {r4-r6, lr}

  @ Get swi opcode
  ldr     r5, [lr, #-4]

  @ Get first argument
  ldr     r4, =0x0000FFFF
  and     r4, r5, lsr #8

  @ Syscall number
  and     r5, #0xFF

  @ Jump to syscall
  ldr     r6, =syscall
  add     r6, r5, lsl #2
  mov     lr, pc
  ldr     pc, [r6]

  ldmfd   sp!, {r4-r6, pc}^


@ ------------------------------------------------------------------------------
@ Prefetch abort interrupt
@ ------------------------------------------------------------------------------
handler_prefetch_abort:
  sub     lr, lr, #4
  stmfd   sp!, {r0-r12, lr}
  @ Do nothing
  ldmfd   sp!, {r0-r12, pc}^


@ ------------------------------------------------------------------------------
@ Data abort interrupt
@ ------------------------------------------------------------------------------
handler_data_abort:
  sub     lr, lr, #8
  stmfd   sp!, {r0-r12, lr}
  @ Do nothing
  ldmfd   sp!, {r0-r12, pc}^


@ ------------------------------------------------------------------------------
@ IRQ
@ ------------------------------------------------------------------------------
handler_irq:
  sub     lr, lr, #4
  stmfd   sp!, {r0-r12, lr}

  mov     r0, #2
  bl      printi

  ldr     r1, =STIMER_C3
  ldr     r2, =0x100000
  ldr     r0, [r1]
  add     r0, r2
  str     r0, [r1]

  ldr     r1, =STIMER_CS
  ldr     r0, =0x08
  str     r0, [r1]

  ldmfd   sp!, {r0-r12, pc}^


@ ------------------------------------------------------------------------------
@ FIQ
@ ------------------------------------------------------------------------------
handler_fiq:
  sub     lr, #4
  stmfd   sp!, {r0-r6, lr}

  @ Clear interrupt flag
  ldr     r8, =TIMER_CLI
  mov     r9, #0
  str     r9, [r8]

  mov     r0, #1
  bl      printi

  ldmfd   sp!, {r0-r6, pc}^
