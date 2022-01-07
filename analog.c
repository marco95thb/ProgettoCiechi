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
	ADC1->CR2 |= (0x01 << 3);
	
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
	if((ADC1->CR2 & ADC1_CR2_ALIGN) != 0)
	{
		tmp1 = ADC1->DRL;
		tmp =  ADC1->DRH;
		adcValues.distanceSetPoint = (tmp1 | (tmp << 8));
	}
	else
	{
		tmp =  ADC1->DRH;
		tmp1 = ADC1->DRL;
		
		adcValues.distanceSetPoint = ((tmp1 << 6) | (tmp << 8));
	}
	
	
	enableInterrupts();
	
	/* clear the bit */
	ADC1->CSR &= 0x7F; // bit7 --> eoc
	
}
unsigned int checkSetPoint(void)
{
	if(adcValues.distanceSetPoint < SP_TH1_COUNT) // 1.4m
			{
				// il codice funziona
				return 51;
			}
			else if (adcValues.distanceSetPoint < SP_TH2_COUNT)
			{
				// il codice funziona
				// SP_TH1_COUNT < X < SP_TH2_COUNT
				return 42;
			
			}
			else// if (adcValues.distanceSetPoint < SP_TH3_COUNT)
			{
				// il codice funziona
				// SP_TH2_COUNT < X < SP_TH3_COUNT
				return 20;
			}
			
}