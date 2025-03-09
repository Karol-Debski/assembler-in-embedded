  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main

src1_reg .req r0
.equ src1_val, 12
.equ op_add, 1

.data
 tab1: .word 1, 2, 3, 4, 5, 6, 7, 8
 tab2: .fill 8, 4, 0xFFFFFFFF
 tab3: .fill 8, 4, 0xAAAAAAAA

.text

main:

 //src
 movw r0, :lower16:tab1
 movt r0, :upper16:tab1
 //dst
 movw r1, :lower16:tab2
 movt r1, :upper16:tab2
 //size in bytes
 mov r2, 2


 push {r0-r2}
 bl memcopy_stack


 //src
 movw r0, :lower16:tab3
 movt r0, :upper16:tab3
 //dst
 movw r1, :lower16:tab2
 movt r1, :upper16:tab2
 //size in bytes
 mov r2, 3


 bl memcopy_regs


 bx lr


memcopy_stack:
 pop {r0-r2}
 // cnt
 mov r3, 0

 push {lr}
 bl loop
 pop {lr}
 bx lr


memcopy_regs:
 // cnt
 mov r3, 0

 push {lr}
 bl loop
 pop {lr}
 bx lr


loop:
 cmp r2, r3
 it eq
 bxeq lr
 ldr r4, [r0], 1
 ldr r5, [r1]
 // move first 8 bits to r5
 bfi r5, r4, 0, 8
 str r5, [r1], 1
 //cnt++
 add r3, 1
 b loop

