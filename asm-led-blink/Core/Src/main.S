  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main

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
//bsrr
.equ GPIOD_BSRR_OFFSET, 0x18
.equ GPIOD_BSRR_ADDR, (GPIOD_ADDR + GPIOD_BSRR_OFFSET)
.equ GPIOD_BSRR_12_ON, (0x1 << 12)
.equ GPIOD_BSRR_12_OFF, (0x1 << 28)

.text

main:

 bl rcc_config
 bl moder_config

 bl inf_blink_led

/*--------------*/
inf_blink_led:
 bl set_led_on
 mov r0, 1
 bl wait
 bl set_led_off
 mov r0, 1
 bl wait
 b inf_blink_led
/*--------------*/
wait:
 cmp r0, (0x1B << 16 + 0x1B)
 add r0, 1
 nop
 bne wait
 bx lr
/*--------------*/
set_led_on:
 movw r0, :lower16:GPIOD_BSRR_ADDR
 movt r0, :upper16:GPIOD_BSRR_ADDR

 movw r1, :lower16:GPIOD_BSRR_12_ON
 movt r1, 0

 str r1, [r0]
 bx lr
/*--------------*/
set_led_off:
 movw r0, :lower16:GPIOD_BSRR_ADDR
 movt r0, :upper16:GPIOD_BSRR_ADDR

 movw r1, 0
 movt r1, :upper16:GPIOD_BSRR_12_OFF

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
