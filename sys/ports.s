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

@ ------------------------------------------------------------------------------
@ PL011 UART Ports
@ ------------------------------------------------------------------------------
.equ UART_DR,          0x20201000
.equ UART_RSECR,       0x20201004
.equ UART_FR,          0x20201018
.equ UART_ILPR,        0x20201020
.equ UART_IBRD,        0x20201024
.equ UART_FBRC,        0x20201028
.equ UART_LCRH,        0x2020102C
.equ UART_CR,          0x20201030
.equ UART_IFLS,        0x20201034
.equ UART_IMSC,        0x20201038
.equ UART_RIS,         0x2020103C
.equ UART_MIS,         0x20201040
.equ UART_ICR,         0x20201044
.equ UART_DMACR,       0x20201048
.equ UART_ITCR,        0x20201080
.equ UART_ITIP,        0x20201084
.equ UART_ITOP,        0x20201088
.equ UART_TDR,         0x2020108C


@ ------------------------------------------------------------------------------
@ Interrupt register
@ ------------------------------------------------------------------------------
.equ IRQ_PENDING,      0x2000B200
.equ IRQ_GPU_PENDING1, 0x2000B204
.equ IRQ_GPU_PENDING2, 0x2000B208
.equ IRQ_FIQ,          0x2000B20C
.equ IRQ_EN1,          0x2000B210
.equ IRQ_EN2,          0x2000B214
.equ IRQ_ENB,          0x2000B218
.equ IRQ_DS1,          0x2000B21C
.equ IRQ_DS2,          0x2000B220
.equ IRQ_DSB,          0x2000B224

@ ------------------------------------------------------------------------------
@ ARM timer
@ ------------------------------------------------------------------------------
.equ TIMER_LOD,        0x2000B400
.equ TIMER_VAL,        0x2000B404
.equ TIMER_CTL,        0x2000B408
.equ TIMER_CLI,        0x2000B40C
.equ TIMER_RIS,        0x2000B410
.equ TIMER_MIS,        0x2000B414
.equ TIMER_RLD,        0x2000B418
.equ TIMER_DIV,        0x2000B41C
.equ TIMER_CNT,        0x2000B420

@ ------------------------------------------------------------------------------
@ System timer
@ ------------------------------------------------------------------------------
.equ STIMER_CS,        0x20003000
.equ STIMER_CLO,       0x20003004
.equ STIMER_CHI,       0x20003008
.equ STIMER_C0,        0x2000300C
.equ STIMER_C1,        0x20003010
.equ STIMER_C2,        0x20003014
.equ STIMER_C3,        0x20003018
