/* analog.h file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#ifndef _ANALOG_H
#define _ANALOG_H
#include "common.h"

#define SP_TH1_COUNT 256 // TBD
#define SP_TH2_COUNT 512 // TBD
#define SP_TH3_COUNT 1023 // TBD


typedef struct
{
	
	unsigned short correnteCarica;
	unsigned short distanceSetPoint;
} tAnalog;

void analogInit(void);
void analogRead(void);
unsigned long checkSetPoint(void);
#endif