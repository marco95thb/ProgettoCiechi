/* analog.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "analog.h"

extern tAnalog adcValues;
void analogInit(void)
{
	
	ADC1->CR1 = 0b00000000; // maximum speed + single conversion
	ADC1->CR2 = 0b00000000; // scan mode disabled
	// mode
	
	// SCAN = 1 + CONT = 0 --> 	single scan mode
	ADC1->CSR = 0x02; // AIN2
	
	
	// ADC_CSR per selezionare i canali
	// SPSEL DI CR1 PER CONTROLLARE IL CLOCK
	ADC1->CR1 |= 0x01; // wake up
	
	// per iniziare una conversione, scrivere un 1
}

void analogRead(void)
{
	unsigned char tmp = 0x00;
	unsigned char tmp1 = 0x00;
	ADC1->CR1 |= 0x01; // start conversion
	
	while(!tmp)
	{
		tmp = (ADC1->CSR & 0x80); // EOC
	}
		
	disableInterrupts(); // mi assicuro che nessuno disturbi la lettura
	adcValues.distanceSetPoint = ((ADC1->DB2RH << 8) | 
	ADC1->DB2RL);
	enableInterrupts();
	if((ADC1->CR3 & 0x40)==0x40)// CHECK OVR FLAG
	{
		ADC1->CR3 &= ~(0x40);
		adcValues.distanceSetPoint = 0; // not valid
	}
	/* clear the bit */
	ADC1->CSR &= 0x7F; // bit7 --> eoc
	
}
unsigned long checkSetPoint(void)
{
	if(adcValues.distanceSetPoint < SP_TH1_COUNT)
			{
				return 1400000; // micrometri
			}
			else if (adcValues.distanceSetPoint < SP_TH2_COUNT)
			{
				// SP_TH1_COUNT < X < SP_TH2_COUNT
				return 2000000; // micrometri
			
			}
			else if (adcValues.distanceSetPoint < SP_TH3_COUNT)
			{
				// SP_TH2_COUNT < X < SP_TH3_COUNT
				return 3000000; // micrometri
			}
			else
			{
				return 4000000; // micrometri
			}
}