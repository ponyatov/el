OUTPUT(elf32-littlearm)
ENTRY(reset)

MEMORY
{
    ram  : ORIGIN = 0x00000000, LENGTH = 32K
}

SECTIONS
{
   .text : { *(.reset) *(.text*) } > ram
   .stack : { . = 0x40002500; _stack = .; }
}
