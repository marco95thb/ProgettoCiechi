/* spi.h file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#ifndef _TIM_H
#define _TIM_H
#include "common.h"

#define TIM1_CCMR_CCxS   ((uint8_t)0x03) /*!< Capture/Compare x Selection mask. */
#define TIM1_CCMR_ICxF   ((uint8_t)0xF0) /*!< Input Capture x Filter mask. */
#define TIM1_CCER1_CC1P  ((uint8_t)0x02) /*!< Capture/Compare 1 output Polarity mask. */
#define TIM1_CCER1_CC1E  ((uint8_t)0x01) /*!< Capture/Compare 1 output enable mask. */
#define TIM1_CCMR_ICxPSC ((uint8_t)0x0C) /*!< Input Capture x Prescaler mask. */
#define TIM1_CR1_CEN     ((uint8_t)0x01) /*!< Counter Enable mask. */
#define TIM1_FLAG_CC1    ((uint16_t)0x0002)

typedef struct {
	unsigned char distanceMonitoring;
	unsigned char batteryMonitoring;
	unsigned short countHigh;
	unsigned short countLow;
	unsigned char soundStat;
	unsigned short counter;
	unsigned char drive; // mi aiuta a capire se sono nel
	//tHigh(1) oppure tLow(0)
} tFrequenza;


void timInit(void);
@far @interrupt void tim1Elapsed (void);
void resetCounterBuzzer(unsigned short counts);
void gestisciBuzzerEVibrazione(void);
void aspetta(unsigned int count);



#endif