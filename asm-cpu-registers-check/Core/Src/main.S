  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main


.text

.macro WRITE_PATTERN pattern
 .irp reg_num, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
  mov r\reg_num, \pattern
 .endr
.endm

.macro CMP_AND_WRITE_PATTERN pattern_old, pattern_new
 .irp reg_num, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
  cmp r\reg_num, \pattern_old
  bne test_failed
  mov r\reg_num, \pattern_new
 .endr
.endm

.macro CMP_AND_WRITE_PATTERN_REVERSE pattern_old, pattern_new
 .irp reg_num, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
  cmp r\reg_num, \pattern_old
  bne test_failed
  mov r\reg_num, \pattern_new
 .endr
.endm

.macro CMP_PATTERN pattern
 .irp reg_num, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
  cmp r\reg_num, \pattern
  bne test_failed
 .endr
.endm


main:

 WRITE_PATTERN 0xAAAAAAAA

 CMP_AND_WRITE_PATTERN_REVERSE 0xAAAAAAAA 0x55555555
 CMP_AND_WRITE_PATTERN         0x55555555 0xFFFFFFFF
 CMP_AND_WRITE_PATTERN_REVERSE 0xFFFFFFFF 0x00000000
 CMP_AND_WRITE_PATTERN         0x00000000 0x0F0F0F0F
 CMP_AND_WRITE_PATTERN_REVERSE 0x0F0F0F0F 0xF0F0F0F0

 CMP_PATTERN 0xF0F0F0F0


 b test_passed

test_passed:
 b test_passed

test_failed:
 b test_failed

