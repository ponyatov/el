MEMORY
{
    ram  : ORIGIN = 0x00000000, LENGTH = 32K
}

SECTIONS
{
   .text : { *(.text*) } > ram
   .stack : { . = 0x40002500; _stack = .; }
}
