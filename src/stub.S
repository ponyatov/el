.arch armv6-m
.cpu cortex-m0
.thumb
.syntax unified

; https://stackoverflow.com/questions/70886455/how-to-get-qemu-to-run-an-arm-thumb-binary

.section .text
.global _start

.align 2
_start:

.globl loop
loop:
    nop
    b loop
