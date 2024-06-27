; https://stackoverflow.com/questions/70886455/how-to-get-qemu-to-run-an-arm-thumb-binary
.arch armv6-m
.cpu cortex-m0
.thumb
.syntax unified

.extern loop

.section .reset
.thumb
.globl reset_entry
reset_entry:
    .word 0x20001000
    .word reset
    .word hang
    .word hang
    .word hang

.thumb_func
reset:
    b loop
    ldr r0,=0x40002500
    ldr r1,=4
    str r1,[r0]
    ldr r0,=0x40002008
    ldr r1,=1
    str r1,[r0]

    ldr r0,=0x4000251C
    ldr r1,=0x30
    ldr r2,=0x37
loop_top:
    str r1,[r0]
    adds r1,r1,#1
    ands r1,r1,r2
    b loop_top

.thumb_func
hang:
    b hang
