/* BUZZER.h file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#ifndef _BUZZER_H
#define _BUZZER_H
#include "common.h"
#define BEEP_FREQUENCY_1KHZ (uint8_t)0x00  /*!< Beep signal output frequency equals to 1 KHz */
#define BEEP_FREQUENCY_2KHZ (uint8_t)0x40  /*!< Beep signal output frequency equals to 2 KHz */
#define BEEP_FREQUENCY_4KHZ (uint8_t)0x80   /*!< Beep signal output frequency equals to 4 KHz */
#define BEEP_CALIBRATION_DEFAULT ((uint8_t)0x0B) /*!< Default value when calibration is not done */
void buzzerInit(void);
void driveBuzzer(unsigned char sts);
void Buzzer_Calibration(unsigned int LSIFreqHz);
void Buzzer_Init(uint8_t BEEP_Frequency);
#endif