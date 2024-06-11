set architecture armv6-m
set processor armv6-m
file tmp/el.o
target remote 127.0.0.1:1234
layout asm
focus cmd
break *reset
continue
