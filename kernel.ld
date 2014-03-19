ENTRY(_start)
SECTIONS
{
  . = 0x10000;
  .startup : { kernel.o(.text)}
  .data : {*(.data)}
  .bss : {*(.bss)}
  . = . + 0x500;
  stack_top = .;
}