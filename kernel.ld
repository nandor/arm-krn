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
  . = ALIGN(0x1000);

  .rodata :
  {
    *(.rodata)
  }
  . = ALIGN(0x1000);

  .data :
  {
    *(.data)
  }
  . = ALIGN(0x1000);

  _bss_start = .;
  .bss :
  {
    bss = .;
    *(.bss)
  }
  . = ALIGN(0x1000);
  _bss_end = .;

  /* 16kb for supervisor mode */
  . = . + 0x4000;
  stack_svc = .;

  /* 2kb for other modes */
  . = . + 0x800;
  stack_und = .;
  . = . + 0x800;
  stack_abt = .;
  . = . + 0x800;
  stack_irq = .;
  . = . + 0x800;
  stack_fiq = .;

  /* 32kb for every thread, up to 128 */
  . = . + 0x4000000;
  stack_sys = .;
}
