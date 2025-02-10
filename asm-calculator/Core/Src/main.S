  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main

src1_reg .req r0
src2_reg .req r1
dest_reg .req r2
op_id_reg .req r3

.equ src1_val, 12
.equ src2_val, 6

.equ op_add, 1
.equ op_sub, 2
.equ op_mul, 3
.equ op_div, 4

.equ op_id, 4

main:

 mov op_id_reg, op_id
 mov src1_reg, src1_val
 mov src2_reg, src2_val

 cmp op_id_reg, op_add
 beq sum
 cmp op_id_reg, op_sub
 beq sub
 cmp op_id_reg, op_mul
 beq multiplication
 cmp op_id_reg, op_div
 beq unsigned_division

 b end_ops

sum:
 add dest_reg, src1_reg, src2_reg
 b end_ops

sub:
 sub dest_reg, src1_reg, src2_reg
 b end_ops

multiplication:
 mul dest_reg, src1_reg, src2_reg
 b end_ops

unsigned_division:
 udiv dest_reg, src1_reg, src2_reg
 b end_ops

end_ops:
 bx lr
