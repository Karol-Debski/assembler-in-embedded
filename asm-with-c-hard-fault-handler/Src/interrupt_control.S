  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global disable_interrupts_asm
.global enable_interrupts_asm


.text

disable_interrupts_asm:
 cpsid i
 bx lr

enable_interrupts_asm:
 cpsie i
 bx lr
