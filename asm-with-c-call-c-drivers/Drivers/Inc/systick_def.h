/*
 * systick.h
 *
 *  Created on: Mar 2, 2025
 *      Author: Karol
 */

#ifndef INC_SYSTICK_DEF_H_
#define INC_SYSTICK_DEF_H_


//systick
#define STK_CTRL_ADDR  0xE000E010
#define STK_LOAD_ADDR  0xE000E014
#define STK_VAL_ADDR   0xE000E018
#define STK_CALIB_ADDR 0xE000E01C
// period of timer SysTick
#define PERIOD_BLINK_IN_MS 50


#endif /* INC_SYSTICK_DEF_H_ */
