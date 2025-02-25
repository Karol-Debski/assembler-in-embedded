  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

 //rcc
.equ RCC_BASE_ADDR, 0x40023800
.equ RCC_AHB1ENR_OFFSET, 0x30
.equ RCC_AHB1ENR_ADDR, (RCC_BASE_ADDR + RCC_AHB1ENR_OFFSET)
.equ GPIOD_CLK_EN, (1 << 3)
//moder
.equ GPIOD_ADDR, 0x40020C00
.equ GPIOD_MODER_OFFSET, 0x0
.equ GPIOD_MODER_ADDR, (GPIOD_ADDR + GPIOD_MODER_OFFSET)
.equ GPIOD_MODER_12_OUTPUT_MODE, (0x01 << 24)
//odr
.equ GPIOD_ODR_OFFSET, 0x14
.equ GPIOD_ODR_ADDR, (GPIOD_ADDR + GPIOD_ODR_OFFSET)

.global rcc_config
.global moder_config
.global flip_led_state

.text

/*--------------*/
flip_led_state:
 movw r0, :lower16:GPIOD_ODR_ADDR
 movt r0, :upper16:GPIOD_ODR_ADDR
 ldr r1, [r0]
 mov r2, 0x1 << 12
 eor r1, r2

 str r1, [r0]
 bx lr
/*--------------*/
rcc_config:
 movw r0, :lower16:RCC_AHB1ENR_ADDR
 movt r0, :upper16:RCC_AHB1ENR_ADDR

 movw r1, :lower16:GPIOD_CLK_EN

 str r1, [r0]
 bx lr
/*--------------*/
moder_config:
 movw r0, :lower16:GPIOD_MODER_ADDR
 movt r0, :upper16:GPIOD_MODER_ADDR

 movw r1, :lower16:GPIOD_MODER_12_OUTPUT_MODE
 movt r1, :upper16:GPIOD_MODER_12_OUTPUT_MODE

 str r1, [r0]
 bx lr
/*--------------*/
