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

.equ UART0,             0x101f1000
.equ UART0_DR,          UART0 + 0x0000
.equ UART0_IMSC,        UART0 + 0x0038

.equ TIMER0,            0x101E2000
.equ TIMER0_LOAD,       TIMER0 + 0x0000
.equ TIMER0_VALUE,      TIMER0 + 0x0004
.equ TIMER0_CONTROL,    TIMER0 + 0x0008
.equ TIMER0_INTCLR,     TIMER0 + 0x000C

.equ VIC,               0x10140000
.equ VIC_INTSELECT,     VIC + 0x000C
.equ VIC_INTENABLE,     VIC + 0x0010

@ ------------------------------------------------------------------------------
@ Entry point of the kernel
@ ------------------------------------------------------------------------------
_kernel:
    @ Disable interrupts
    mrs     r0, cpsr
    orr     r0, #0xA0
    msr     cpsr, r0

    @ Relocate the interrupt vector table
    mov     r0, #0x0
    ldr     r1, =_handlers
.reloc_loop:
    ldr     r2, [r1], #4
    str     r2, [r0], #4
    cmp     r0, #64
    bls     .reloc_loop

    @ Setup stacks
    mrs     r0, cpsr
    ldr     sp, =stack_svc

    @ Setup FIQ stack
    msr     cpsr, #0xD1
    ldr     sp, =stack_fiq

    @ Setup IRQ stack
    msr     cpsr, #0xD2
    ldr     sp, =stack_irq

    @ Setup UND stack
    msr     cpsr,  #0xDB
    ldr     sp, =stack_und

    @ Enable IRQ & Enter system mode
    bic     r0, #0xC0
    msr     cpsr, r0

    @ UART0 control
    ldr     r0, =0x101f1038
    mov     r1, #16
    str     r1, [r0]

    @ TIMER0 control
    ldr     r0, =0x101E2000
    ldr     r1, =1000000
    str     r1, [r0]

    ldr     r0, =0x101E2008
    ldr     r1, =0xE2
    str     r1, [r0]

    @ Timer generates a FIQ
    ldr     r0, =VIC_INTSELECT
    ldr     r1, =0x0010
    str     r1, [r0]

    @ Enable UART0 & TIMER0
    ldr     r0, =VIC_INTENABLE
    ldr     r1, =0x1010
    str     r1, [r0]

    @ Enter user mode
    bic     r0, #0x1F
    orr     r0, #0x10
    msr     cpsr, r0

    @ Run threads
    bl      entry

    @ Loop forever
    b       .

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

    ldr     lr, =.end
    mov     r0, pc
    b       print_string
    .ascii  "\n\nKERNEL PANIC: Undefined Instruction\n\n\0"
    .align  4
.end:
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

    ldmfd   sp!, {r0-r12, pc}^

@ ------------------------------------------------------------------------------
@ Data abort interrupt
@ ------------------------------------------------------------------------------
handler_data_abort:
    sub     lr, lr, #8
    stmfd   sp!, {r0-r12, lr}

    ldmfd   sp!, {r0-r12, pc}^

@ ------------------------------------------------------------------------------
@ IRQ
@ ------------------------------------------------------------------------------
handler_irq:
    sub     lr, lr, #4
    stmfd   sp!, {r0-r12, lr}

    ldr     r2, =UART0_DR
    ldr     r0, [r2]
    bl      print_int

    ldmfd   sp!, {r0-r12, pc}^

@ ------------------------------------------------------------------------------
@ FIQ
@ ------------------------------------------------------------------------------
handler_fiq:
    sub     lr, lr, #4
    stmfd   sp!, {r0-r7, lr}

    ldr     r0, =TIMER0_INTCLR
    mov     r1, #1
    str     r1, [r0]

    @ldr     r0, =fiq
    @bl      print_string

    ldmfd   sp!, {r0-r7, pc}^
