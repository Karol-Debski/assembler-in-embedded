  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main
//napisz program testujacy wszystkie flagi CPU poza flaga Q - czyli Z, N, C, V
// 31 - N, 30 - Z, 29 - C, 28 - V
main:
 bl reset_flags
 // test Negative flag
 movs r0, -5
 bl reset_flags
 // test Zero flag
 movs r0, 0
 bl reset_flags
 // test Carry flag
 movw r0, 0xFFFF
 movt r0, 0xFFFF
 adds r0, r1
 bl reset_flags
 // test overflow flag
 movt r0, 0x8000
 movt r1, 0x8FFF
 adds r2, r0, r1
 bl reset_flags

//reset all flags of the CPU
reset_flags:
 mov r0, 0
 adds r0, 1
 bx lr
