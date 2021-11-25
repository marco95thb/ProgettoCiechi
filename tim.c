/* spi.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "tim.h"
#include "buzzer.h"
#include "common.h"



extern unsigned char startCountPulses;
extern unsigned long pulses;
extern unsigned long totalTicks;
extern unsigned char flagElapsed;
extern unsigned char tipoPeriodicita;
extern unsigned char soundStat;
extern tFrequenza buzzer;
extern unsigned long supportoDelayBloccante;
extern unsigned int contatoreLunghezzaPressione;
extern unsigned char statoDispositivo;
extern uint8_t __flaggami;

unsigned int countDebug = 0;
unsigned char deviAspettare;
unsigned int quantoDeviAspettare;
unsigned int contatoreAttesa = 0;

void timInit(void)
{
	TIM1->CR1 = 0b00000100; // interrupt only on overflow
	TIM1->IER = 0x01; // update interrupt enable
	
	TIM1->PSCRL = 15; // timer @1Mhz (da 16 di cpu clock a 1)
	
	// scrivere prima High poi Low (da datashhet)
	TIM1->ARRH = 0x00;
	TIM1->ARRL = 0x64; // sarebbero 100 micro
	// -->  interrupt ogni 100microsecondi
	
	
	
	TIM1->CR1 |= 0x01; // start the counter
	
	
	
	
}

@far @interrupt void tim1Elapsed (void)
{
	TIM1->SR1 &= ~(0x01); // clear the flag
	totalTicks++; // @ 100 microsecond
	
	supportoDelayBloccante++;
	
	if(totalTicks >= 1000) // 100ms
	{
		totalTicks = 0;
		flagElapsed = 1;
	}

	
	if(startCountPulses)
	{
		pulses++; // pulses è in base 100 microS
	}
	
		if(contatoreLunghezzaPressione < 0xFFFFFFFF) // evito overflow
			contatoreLunghezzaPressione++; //tiene il conto
		
	if(deviAspettare)
	{
		contatoreAttesa++;
		if(contatoreAttesa >= quantoDeviAspettare)
		{
			contatoreAttesa = 0;
			deviAspettare = 0;
			
		}
	}
	//gestisciBuzzerEVibrazione();
	
	

}




void gestisciBuzzerEVibrazione(void)
{
	if((buzzer.distanceMonitoring) || 
		(buzzer.batteryMonitoring))
	{		
		buzzer.counter++;
		if(buzzer.drive)
		{
			GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
			if(buzzer.counter >= buzzer.countHigh)
				{
					buzzer.drive = 0; // toggle
					buzzer.counter = 0; // reset the counter
				}
		}
		else
		{
			GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
			if(buzzer.counter >= buzzer.countLow)
				{
					buzzer.drive = 1; // toggle
					buzzer.counter = 0; // reset the counter
				}
		}
	}
	else
	{
		buzzer.drive = 0; // toggle
		buzzer.counter = 0; // reset the counter
		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
	}
}
void aspetta(unsigned int count)
{
	deviAspettare = 1;
	quantoDeviAspettare = count; // un tick sono 100 micro
	
	while(deviAspettare);
	
}