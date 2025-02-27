/*
 * This file is part of the MicroPython project, http://micropython.org/
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2017 Scott Shawcroft for Adafruit Industries
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "supervisor/board.h"
#include "mpconfigboard.h"

#include "stm32l4xx.h"
#include "stm32l4r5xx.h"

#include "shared-bindings/microcontroller/Pin.h"
#include "shared-bindings/digitalio/DigitalInOut.h"
#include "shared-bindings/digitalio/Direction.h"
#include "shared-bindings/digitalio/DriveMode.h"
#include "board.h"

digitalio_digitalinout_obj_t power_pin = { .base.type = &digitalio_digitalinout_type };
digitalio_digitalinout_obj_t discharge_pin = { .base.type = &digitalio_digitalinout_type };

void initialize_discharge_pin(void) {

    /* Initialize the 3V3 discharge to be OFF and the output power to be ON */
    __HAL_RCC_GPIOE_CLK_ENABLE();
    __HAL_RCC_GPIOC_CLK_ENABLE();


    common_hal_digitalio_digitalinout_construct(&power_pin, &pin_PE04);
    common_hal_digitalio_digitalinout_construct(&discharge_pin, &pin_PE06);
    common_hal_digitalio_digitalinout_never_reset(&power_pin);
    common_hal_digitalio_digitalinout_never_reset(&discharge_pin);

    GPIO_InitTypeDef GPIO_InitStruct;
    /* Set the DISCHARGE pin and the USB_DETECT pin to FLOAT */
    GPIO_InitStruct.Mode = GPIO_MODE_ANALOG;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Pin = GPIO_PIN_6;
    HAL_GPIO_Init(GPIOE, &GPIO_InitStruct); /* PE6 DISCHRG */
    HAL_GPIO_Init(GPIOC, &GPIO_InitStruct); /* PC6 is USB_DETECT */

    /* Turn on the 3V3 regulator */
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Speed = GPIO_SPEED_LOW;
    GPIO_InitStruct.Pin = GPIO_PIN_4;
    HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);
    HAL_GPIO_WritePin(GPIOE, GPIO_PIN_4, GPIO_PIN_SET);

}

void board_init(void) {
    // enable the debugger while sleeping. Todo move somewhere more central (kind of generally useful in a debug build)
    SET_BIT(DBGMCU->CR, DBGMCU_CR_DBG_SLEEP);

    //  Set tick interrupt priority, default HAL value is intentionally invalid
    //  Without this, USB does not function.
    HAL_InitTick((1UL << __NVIC_PRIO_BITS) - 1UL);

    __HAL_RCC_GPIOE_CLK_ENABLE();
    GPIO_InitTypeDef GPIO_InitStruct;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_LOW;
    GPIO_InitStruct.Pin = GPIO_PIN_2;
    HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);
    HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_SET);
    HAL_Delay(50);
    HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_RESET);
}

bool board_requests_safe_mode(void) {
    return false;
}

void reset_board(void) {
    initialize_discharge_pin();
}

void board_deinit(void) {
}
