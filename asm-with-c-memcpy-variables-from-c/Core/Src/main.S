  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main

.extern tab1, tab2, num_bytes

.text

main:

 //dst
 ldr r0, =tab1
 //src
 ldr r1, =tab2
 //size in bytes
 ldr r2, =num_bytes
 ldr r2, [r2]

 bl memcpy

loop:
 b loop

