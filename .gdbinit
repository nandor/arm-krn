target remote localhost:1234
file kernel.elf
layout asm
until *0x10000
