#include "gpio.h"
#include "tim.h"
extern unsigned char pulsante;
extern unsigned short countPulsante;
extern unsigned char triggerStatus;
extern unsigned char countTriggerStatus;
extern unsigned int distanceMeasuredAlto;
extern unsigned int distanceMeasuredBasso;

extern unsigned char startCountPulses;
extern unsigned long pulses;
extern unsigned char stateMachineSensor;
extern tDistances distanze;
extern unsigned long supportoDelayBloccante;

void gpioInit(void)
{
	EXTI->CR1 |= (0x02 << 2) | (0x02 << 0); // PortA/B falling edge
	
	GPIOD->DDR = 0b00111000;
	GPIOC->DDR = 0b01101000;
	GPIOB->DDR = 0b00000000;
	GPIOA->DDR = 0b00000000;




	// all the inputs in floating and all the outputs in p/p
	GPIOD->CR1 = 0b00111000;
	GPIOC->CR1 = 0b01110000;
	GPIOB->CR1 = 0b00000000;
	GPIOA->CR1 = 0b00000000;
	
	// enable external interrupt for PB4/5
	GPIOB->CR2 |= 0b00110000;
	// enable external interrupt for PA1
	GPIOA->CR2 |= 0b00000010;
}
uint8_t gestionePulsante(void)
{
			pulsante = (GPIOD->IDR >> 2) & 0x01; // PD2
		if(!pulsante)
		{
			if(countPulsante > 0)
				countPulsante--;	
			else
				return 0;
		}
		else
		{
			if(countPulsante < 0xFFFF) // evito overflow
				countPulsante++;
			if(countPulsante >= 5) // numero a caso
			{
				return 1;
			}
		}
		 
		 // vuol dire che non ha fatto cambiamento di stato
		return 2;
}


@far @interrupt void startStopTriggersPORTB(void)
{
	// clear interrupt flag sembrerebbe non ce ne sia bisogno
	if((GPIOB->IDR >> 5) & 0x01) // interrupt sul PB5 (echo 2)
	{
		 // doppia protezione
		if((startCountPulses) && 
		(stateMachineSensor == START_MEASURE_2SENSOR))
		{
			// ottengo i micrometri
			// nota che pulses deve essere espresso in
			// count ogni 100 microsecondi
			// quindi il timer deve scattare ogni 100 micro
			distanze.d2 = (VEL_SUONO * pulses) >> 1; 
			pulses = 0;
			stateMachineSensor = END_MEASURE_2SENSOR; 
		}
	}
	else if((GPIOB->IDR >> 4) & 0x01) // interrupt sul PB4 (echo3)
	{
		if((startCountPulses) && 
			(stateMachineSensor == START_MEASURE_3SENSOR))
		{
			distanze.d3 = (VEL_SUONO * pulses) >> 1; 
			pulses = 0;
			stateMachineSensor = END_MEASURE_3SENSOR;
		}
	}
	
}
@far @interrupt void startStopTriggersPORTA(void)
{
	// clear interrupt flag sembrerebbe non ce ne sia bisogno
	if((GPIOA->IDR >> 1) & 0x01) // interrupt sul PA1 (echo 1)
	{
		if((startCountPulses) && 
			(stateMachineSensor == START_MEASURE_1SENSOR))
		{
		
			distanze.d1 = (VEL_SUONO * pulses) >> 1; 
			pulses = 0;
			stateMachineSensor = END_MEASURE_1SENSOR;
		}
	}
}
uint8_t checkDecharge(void)
{
	return ~((GPIOD->IDR >> 6) & 0x01);
}
void segnalazioneSpegnimento(void)
{
	volatile int blink = 3;
	volatile int i = 0;
	for(i=0;i<blink;i++)
	{
		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
		aspetta(1000);
		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
		aspetta(1000);
	}
	
}
void segnalazioneAccensione(void)
{
		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
		aspetta(10000); // un sec
		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
		aspetta(10000); // un sec
	
}