.arch armv6-m
.cpu cortex-m0plus
.syntax unified
.thumb

; https://stackoverflow.com/questions/70886455/how-to-get-qemu-to-run-an-arm-thumb-binary

loop:
    nop
    b loop
