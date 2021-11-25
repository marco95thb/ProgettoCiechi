/* spi.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "clock.h"

void clockInit(void)
{
	// @16MHz
	CLK->CKDIVR = 0x00; // internal clock with no prescaler
	CLK->PCKENR1 |= 0b10000000; // tim1 active
	CLK->PCKENR2 |= 0b00001000; // adc active
	CLK->SWIMCCR |= 0x01; // clock swwim not divided
	
	
	
	
}
