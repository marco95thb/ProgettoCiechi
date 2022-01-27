/* gpio.h file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#ifndef _COMMON_H
#define _COMMON_H
#include "registers.h"

#define SPENTO 0
#define ACCESO 1

#define enableInterrupts()    {_asm("rim\n");}  /* enable interrupts */
#define disableInterrupts()   {_asm("sim\n");}  /* disable interrupts */

#define FREQ_BUZZER_DEFAULT 5000 // TBD
#define FREQ_ALLARME_HW     3000 // TBD

#define BUZZER_E_VIBRATORE_ON (unsigned char)0x30
#define BUZZER_ON 0x10
#define VIBRATORE_ON 0x20
/* Questi cunt sono espressi in 100micro alla volta */
/* Sensore 1 */
#define COUNT_HIGH_1_FREQ 1000 // sarebbero 100ms
#define COUNT_LOW_1_FREQ 1000 // sarebbero 100ms
/* Sensore 2 */
#define COUNT_HIGH_2_FREQ 600 
#define COUNT_LOW_2_FREQ 600
/* Sensore 3 */
#define COUNT_HIGH_3_FREQ 50 // sarebbero 50ms
#define COUNT_LOW_3_FREQ 50 // sarebbero 50ms
/* Batteria scarica */
#define COUNT_HIGH_4_FREQ 200 // sarebbero 200ms
#define COUNT_LOW_4_FREQ 200 // sarebbero 200ms





#define START_MEASURE_1SENSOR 1
#define END_MEASURE_1SENSOR		2
#define START_MEASURE_2SENSOR 3
#define END_MEASURE_2SENSOR		4
#define START_MEASURE_3SENSOR 5
#define END_MEASURE_3SENSOR		6

#define MAX_DIST_SENS_ALTO 16 // 16 count corrisponde a 1.4m





#define SOGLIA_ALLARME_SENSORE 23 // 1mt circa
#define SOGLIA_ALLARME_SENSORE_TH1 17
#define SOGLIA_ALLARME_SENSORE_TH2 12






#define SENSOR1_TRIGGER_ON (uint8_t) (0b00001000)  
#define SENSOR2_TRIGGER_ON (uint8_t) (0b00100000)
#define SENSOR3_TRIGGER_ON (uint8_t) (0b01000000)

#define DISTANZA_4_0METRI 49
#define DISTANZA_3_0METRI 42
#define DISTANZA_1_4_METRI 20
#define MINIMA_DISTANZA_SENSORI 7 // sono 30 cm



typedef struct  {
	unsigned int d1;
	unsigned int d2;
	unsigned int d3;
	unsigned int minima;
} tDistances;



#endif