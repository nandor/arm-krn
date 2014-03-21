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

@ ------------------------------------------------------------------------------
@ Entry point of the kernel
@ ------------------------------------------------------------------------------
.global _kernel
_kernel:
    ldr     sp, =stack_top

    @ Relocate the interrupt vector table
    mov     r0, #0x0
    ldr     r1, =_handlers
.reloc_loop:
    ldr     r2, [r1], #4
    str     r2, [r0], #4
    cmp     r0, #64
    bls     .reloc_loop

    @ Software interrupt test
    swi     #12345666

    @ Enable IRQ
    mrs     r0, cpsr
    bic     r1, r0, #0x1F
    orr     r1, r1, #0x12
    msr     cpsr, r1
    ldr     sp, =irq_stack_top
    bic     r0, r0, #0x80
    msr     cpsr, r0

    @ Enable UART
    ldr     r0, =0x10140010
    mov     r1, #4096
    str     r1, [r0]
    ldr     r0, =0x101f1038
    mov     r1, #16
    str     r1, [r0]

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
    mov     r0, #111
    bl      print_int
    b       .

@ ------------------------------------------------------------------------------
@ Software interrupt
@ ------------------------------------------------------------------------------
handler_swi:
    sub     sp, sp, #4
    stmfd   sp!, {r0-r12,lr}

    ldr     r0, [lr, #-4]
    bic     r0, r0, #0xff000000
    bl      print_int

    ldmfd   sp!, {r0-r12,lr}
    add     sp, sp, #4
    mov     pc, lr

@ ------------------------------------------------------------------------------
@ Prefetch abort interrupt
@ ------------------------------------------------------------------------------
handler_prefetch_abort:
    b       .

@ ------------------------------------------------------------------------------
@ Data abort interrupt
@ ------------------------------------------------------------------------------
handler_data_abort:
    b       .

@ ------------------------------------------------------------------------------
@ IRQ
@ ------------------------------------------------------------------------------
handler_irq:
    stmfd   sp!, {r0-r12,lr}

    mov     r0, #111
    bl      print_int

    ldmfd   sp!, {r0-r12,lr}
    mov     pc, lr

@ ------------------------------------------------------------------------------
@ FIQ
@ ------------------------------------------------------------------------------
handler_fiq:
    b       .
