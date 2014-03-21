ENTRY(_kernel)
SECTIONS
{
  . = 0x10000;
  _kernel = .;

  .text :
  {
    kernel.o
    *(.text)
  }
  . = ALIGN(4096);

  .rodata :
  {
    *(.rodata)
  }
  . = ALIGN(4096);

  .data :
  {
    *(.data)
  }
  . = ALIGN(4096);

  .bss :
  {
    bss = .;
    *(.bss)
  }
  . = ALIGN(4096);

  . = . + 0x1000; /* 4kb kernel stack */
  stack_top = .;

  . = . + 0x1000; /* 4kb irq stack */
  irq_stack_top = .;
}
