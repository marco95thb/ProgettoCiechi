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

/* Questi cunt sono espressi in 100micro alla volta */
/* Sensore 1 */
#define COUNT_HIGH_1_FREQ 10000 // sarebbero 1000ms
#define COUNT_LOW_1_FREQ 10000 // sarebbero 1000ms
/* Sensore 2 */
#define COUNT_HIGH_2_FREQ 7000 // sarebbero 700ms era 7000
#define COUNT_LOW_2_FREQ 7000 // sarebbero 700ms era 7000
/* Sensore 3 */
#define COUNT_HIGH_3_FREQ 5000 // sarebbero 500ms
#define COUNT_LOW_3_FREQ 5000 // sarebbero 500ms
/* Batteria scarica */
#define COUNT_HIGH_4_FREQ 20000 // sarebbero 2000ms
#define COUNT_LOW_4_FREQ 20000 // sarebbero 2000ms



#define PRIORITA_SENSORE_1 1
#define PRIORITA_SENSORE_2 2
#define PRIORITA_SENSORE_3 3

#define START_MEASURE_1SENSOR 1
#define END_MEASURE_1SENSOR		2
#define START_MEASURE_2SENSOR 3
#define END_MEASURE_2SENSOR		4
#define START_MEASURE_3SENSOR 5
#define END_MEASURE_3SENSOR		6

#define MAX_DIST_SENS_ALTO 1400000 // 1.4m espresso in microM
#define MIN_DIST_SENS_ALTO 300000 // 30cm

#define MAX_DIST_SENS_BASSO 1400000 // 1.4m espresso in microM
#define MIN_DIST_SENS_BASSO 300000 // 30cm

#define MIN_DIST_SENS_MEDIO 300000 // 30cm

/* Al di sotto di un metro, la frequenza del suono e della
   vibrazione si fa piu insistente */
#define SOGLIA_ALLARME_SENSORE_ALTO 1000000 // 1mt
#define SOGLIA_ALLARME_SENSORE_BASSO 1000000 // 1mt
#define SOGLIA_ALLARME_SENSORE_MEDIO 1000000 // 1mt


#define MAX_DIST_SENS_BASSO 1400000 // 1.4m espresso in microM
#define MIN_DIST_SENS_BASSO 300000 // 30cm

#define SENSOR1_TRIGGER_ON (uint8_t) (0x10)
#define SENSOR2_TRIGGER_ON (uint8_t) (0x20)
#define SENSOR3_TRIGGER_ON (uint8_t) (0x40)




#define VEL_SUONO 34300 // micrometri ogni 100 micro


typedef struct  {
	unsigned short d1;
	unsigned short d2;
	unsigned short d3;
} tDistances;



#endif