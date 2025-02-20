  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main
.global SysTick_Handler

//gpio PA2 - TX

//rcc
.equ RCC_BASE_ADDR, 0x40023800
.equ RCC_AHB1ENR_OFFSET, 0x30
.equ RCC_AHB1ENR_ADDR, (RCC_BASE_ADDR + RCC_AHB1ENR_OFFSET)
.equ RCC_APB1ENR_OFFSET, 0x40
.equ RCC_APB1ENR_ADDR, (RCC_BASE_ADDR + RCC_APB1ENR_OFFSET)
//moder
.equ GPIOA_ADDR, 0x40020000
.equ GPIOA_MODER_OFFSET, 0x0
.equ GPIOA_MODER_ADDR, (GPIOA_ADDR + GPIOA_MODER_OFFSET)
.equ GPIOA_AFRL_OFFSET, 0x20
.equ GPIOA_AFRL_ADDR, (GPIOA_ADDR + GPIOA_AFRL_OFFSET)
//usart
.equ USART2_BASE_ADDR, 0x40004400
.equ USART2_BRR_OFFSET, 0x08
.equ USART_BRR_ADDR, (USART2_BASE_ADDR + USART2_BRR_OFFSET)
.equ USART2_CR1_OFFSET, 0x0C
.equ USART2_CR1_ADDR, (USART2_BASE_ADDR + USART2_CR1_OFFSET)
.equ USART2_CR2_OFFSET, 0x10
.equ USART2_CR2_ADDR, (USART2_BASE_ADDR + USART2_CR2_OFFSET)
.equ USART2_DR_OFFSET, 0x04
.equ USART2_DR_ADDR, (USART2_BASE_ADDR + USART2_DR_OFFSET)
.equ USART2_SR_OFFSET, 0x0
.equ USART2_SR_ADDR, (USART2_BASE_ADDR + USART2_SR_OFFSET)



.equ STAR_ASCII_CODE, 42
.equ SPACE_ASCII_CODE, 32
.equ NEW_LINE_ASCII_CODE, 10

.equ TREE_SIZE, 5

.text

.macro PRINT_SPACES number
  mov r1, SPACE_ASCII_CODE
 .rept \number
  push {lr}
  bl usart_send_char_pooling
  pop {lr}
 .endr
.endm

.macro PRINT_STARS number
 mov r1, STAR_ASCII_CODE
 .rept \number
  push {lr}
  bl usart_send_char_pooling
  pop {lr}
 .endr
.endm

.macro PRINT_NEW_LINE
 mov r1, NEW_LINE_ASCII_CODE
 push {lr}
 bl usart_send_char_pooling
 push {lr}
.endm

.macro PRINT_TRIANGLE width_of_triangle, width_of_tree
 .set sp_num, (\width_of_tree - 1)/2
 .set st_num, 1
  .rept (1 + (\width_of_triangle/2) )
   PRINT_SPACES sp_num
   PRINT_STARS st_num
   PRINT_NEW_LINE
   .set sp_num, sp_num-1
   .set st_num, st_num+2
  .endr
.endm

.macro PRINT_XMAS_TREE tree_size
.set width_of_triangle, 3
 .rept \tree_size
  PRINT_TRIANGLE width_of_triangle, (1 + 2*\tree_size)
  .set width_of_triangle, width_of_triangle+2
 .endr
.endm
main:

 bl rcc_config
 bl moder_config

 bl usart_config


 PRINT_XMAS_TREE TREE_SIZE

 b wait

/*--------------*/
wait:
 b wait
/*--------------*/
usart_send_char_pooling:
 //program C
 ldr r0, =USART2_DR_ADDR
 //set character code
 str r1, [r0]
 //check TC (transmission complete)
 ldr r0, =USART2_SR_ADDR
loop_check_tc:
 ldr r2, [r0]
 // if TC=0, usart is busy in Tx
 ands r2, (0b1 << 6)
 beq loop_check_tc

 bx lr
/*--------------*/
usart_config:
 //program CR1
 ldr r0, =USART2_CR1_ADDR
 ldr r1, [r0]
 //enable USART
 orr r1, (0b1 << 13)
 //enable TX
 orr r1, (0b1 << 3)
 str r1, [r0]

 //program bbr register, APB1 = 16MHz (by default)
 ldr r0, =USART_BRR_ADDR
 //set fraction for 19200b/s
 mov r1, (0b1 << 3)
 //set mantissa for 19200b/s
 orr r1, (0b110100 << 4)
 str r1, [r0]

 //check TC (transmission complete) for initial frame
 ldr r0, =USART2_SR_ADDR
loop_check_initial_frame:
 ldr r1, [r0]
 // if TC=0, usart is busy in Tx
 ands r1, (0b1 << 6)
 beq loop_check_initial_frame

 bx lr
/*--------------*/
rcc_config:
 ldr r0, =RCC_AHB1ENR_ADDR
 ldr r1, [r0]

 //enable GPIOA
 orr r1, (0b1 << 0)
 str r1, [r0]

 ldr r0, =RCC_APB1ENR_ADDR
 ldr r1, [r0]

 //enable USART2 clock
 orr r1, (0b1 << 17)
 str r1, [r0]

 bx lr
/*--------------*/
moder_config:
 ldr r0, =GPIOA_MODER_ADDR
 ldr r1, [r0]

 bfc r1, 4, 2
 //set AF mode
 orr r1, (0b10 << 4)
 str r1, [r0]

 ldr r0, =GPIOA_AFRL_ADDR
 ldr r1, [r0]

 bfc r1, 8, 4
 //set AF7 mode (USART2TX)
 orr r1, (0b0111 << 8)
 str r1, [r0]

 bx lr
/*--------------*/
