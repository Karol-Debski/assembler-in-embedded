  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

//systick
.equ STK_CTRL_ADDR, 0xE000E010
.equ STK_LOAD_ADDR, 0xE000E014
.equ STK_VAL_ADDR, 0xE000E018
.equ STK_CALIB_ADDR, 0xE000E01C
// period of timer SysTick
.equ PERIOD_BLINK_IN_MS, 50

.global SysTickTimerConfig
.global EnalbeCounter

.text


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
