  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main


.text

.macro SAVE_PATTERN pattern
 .irp reg_num, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
  mov r\reg_num, \pattern
 .endr
.endm

.macro READ_AND_CMP_PATTERN pattern
 .irp reg_num, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
  cmp r\reg_num, \pattern
  bne test_failed
 .endr
.endm


main:

 SAVE_PATTERN 0xAAAAAAAA
 READ_AND_CMP_PATTERN 0xAAAAAAAA

 SAVE_PATTERN 0x55555555
 READ_AND_CMP_PATTERN 0x55555555

 SAVE_PATTERN 0xFFFFFFFF
 READ_AND_CMP_PATTERN 0xFFFFFFFF

 SAVE_PATTERN 0x00000000
 READ_AND_CMP_PATTERN 0x00000000

 SAVE_PATTERN 0x0F0F0F0F
 READ_AND_CMP_PATTERN 0x0F0F0F0F

 SAVE_PATTERN 0xF0F0F0F0
 READ_AND_CMP_PATTERN 0xF0F0F0F0

 b test_passed


test_passed:
 b test_passed

test_failed:
 b test_failed

