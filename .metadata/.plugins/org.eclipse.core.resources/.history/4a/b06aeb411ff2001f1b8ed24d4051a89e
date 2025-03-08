  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  main
.global SysTick_Handler
.section .text.SysTick_Handler
.type SysTick_Handler, %function

//systick
.equ STK_CTRL_ADDR, 0xE000E010
.equ STK_LOAD_ADDR, 0xE000E014
.equ STK_VAL_ADDR, 0xE000E018
.equ STK_CALIB_ADDR, 0xE000E01C

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

// period of timer SysTick
.equ PERIOD_BLINK_IN_MS, 50

.text

main:

 bl rcc_config
 bl moder_config

 bl SysTickTimerConfig

 bl EnalbeCounter

 b inf_loop


/*--------------*/
SysTick_Handler:
 push {lr}
 bl flip_led_state
 pop {lr}

 bx lr
/*--------------*/
SysTickTimerConfig:
/* config control register */
 movw r0, :lower16:STK_CTRL_ADDR
 movt r0, :upper16:STK_CTRL_ADDR
 ldr r1, [r0]
 //set processor clock (16Mhz by default) as source
 orr r1, 0x1 << 2
 //enable exception request
 orr r1, 0x1 << 1
 //set config
 str r1, [r0]

/* config reload register */
 movw r0, :lower16:STK_LOAD_ADDR
 movt r0, :upper16:STK_LOAD_ADDR

 movw r1, :lower16:15999
 movt r1, :upper16:15999

 movw r2, :lower16:PERIOD_BLINK_IN_MS
 movt r2, :upper16:PERIOD_BLINK_IN_MS

 mul r1, r2
 // set reload value
 str r1, [r0]

 bx lr
/*--------------*/
EnalbeCounter:
 movw r0, :lower16:STK_CTRL_ADDR
 movt r0, :upper16:STK_CTRL_ADDR
 ldr r1, [r0]
 //enable counter
 orr r1, 0x1
 str r1, [r0]

 bx lr
/*--------------*/
inf_loop:
 b inf_loop
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
