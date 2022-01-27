/* spi.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "tim.h"
#include "buzzer.h"
#include "common.h"
#include "gpio.h"


extern unsigned char startCountPulses;
extern unsigned int pulses;
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

extern unsigned char debugToggle;

void timInit(void)
{
	TIM1->CR1 = 0b00000100; // interrupt only on overflow
	TIM1->IER = 0x01; // update interrupt enable
	
	TIM1->PSCRH = 0;
	TIM1->PSCRL = 15; // timer @1Mhz 
	
	// scrivere prima High poi Low (da datashhet)
	TIM1->ARRH = 0x01;
	TIM1->ARRL = 0xF4; // sarebbero 500 tick a 1Mhz
	// -->  interrupt ogni mezzo ms --> tempo verificato
	
	
	
	TIM1->CR1 |= 0x01; // start the counter
	
	
	
	
}

@far @interrupt void tim1Elapsed (void)
{
	TIM1->SR1 &= ~(0x01); // clear the flag
	totalTicks++; // @ 500 microsecond
	
	supportoDelayBloccante++;
	
	
	
	if(totalTicks >= 150) // era 200. Proviamo a mettere 150
	{
		totalTicks = 0;
		flagElapsed = 1;
		
	}


	if(startCountPulses)
	{
		pulses++; // pulses è in base 500 microS
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
	
	
	

}





void aspetta(unsigned int count)
{
	deviAspettare = 1;
	quantoDeviAspettare = count; // un tick sono 100 micro
	
	while(deviAspettare);
	
}