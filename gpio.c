#include "gpio.h"
#include "tim.h"
extern unsigned char pulsante;
extern unsigned short countPulsante;
extern unsigned char triggerStatus;
extern unsigned char countTriggerStatus;
extern unsigned int distanceMeasuredAlto;
extern unsigned int distanceMeasuredBasso;

extern unsigned char startCountPulses;
extern unsigned int pulses;
extern unsigned char stateMachineSensor;
extern tDistances distanze;
extern unsigned long supportoDelayBloccante;

extern unsigned char inizioCarica;
extern unsigned char fineCarica;
extern unsigned char fineCarica_prec;
extern unsigned char flagBatteriaScarica;
extern unsigned char flagBatteriaScarica_prec;
extern unsigned char inizioCaricaSignalled;
extern unsigned char fineCaricaSignalled;
extern unsigned char batteriaScaricaSignalled;
extern unsigned char countInputB;
extern unsigned char countInputIC;
extern unsigned char countInputFC;
extern unsigned char countInputBS;
extern unsigned char statoPulsante;
extern tFrequenza buzzer;

unsigned char debugToggle = 0;


void gpioInit(void)
{
	
	
	GPIOD->DDR = 0b00111000;
	GPIOC->DDR = 0b01101000;
	GPIOB->DDR = 0b00000000;
	GPIOA->DDR = 0b00000000;




	// all the inputs in floating and all the outputs in p/p
	GPIOD->CR1 = 0b00111000;
	GPIOC->CR1 = 0b01101000;
	GPIOB->CR1 = 0b00000000;
	GPIOA->CR1 = 0b00000000;
	
	// enable external interrupt for PB4/5
	GPIOB->CR2 |= 0b00110000;
	// enable external interrupt for PA3
	GPIOA->CR2 |= 0b00001000;
	
	GPIOC->CR2 |= 0b01101000;
	EXTI->CR1 |= (0x02 << 2) | (0x02 << 0); // PortA/B falling edge
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
	if(((GPIOB->IDR >> 5) & 0x01) == 0x00) // interrupt sul PB5 (echo 2)
	{
		 // doppia protezione
		if((startCountPulses) && 
		(stateMachineSensor == START_MEASURE_2SENSOR))
		{
			startCountPulses = 0;
			// ottengo i micrometri
			// nota che pulses deve essere espresso in
			// count ogni 500 microsecondi
			// quindi il timer deve scattare ogni 500 micro
			distanze.d2 = pulses; 
			stateMachineSensor = END_MEASURE_2SENSOR;
			
			
		/*	if(distanze.d2 > 8)
				GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
			else
				GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON; */
		
			
		}
	}
	
	if(((GPIOB->IDR >> 4) & 0x01) == 0x00) // interrupt sul PB4 (echo3)
	{
		if((startCountPulses) && 
			(stateMachineSensor == START_MEASURE_3SENSOR))
		{
			stateMachineSensor = END_MEASURE_3SENSOR;
			distanze.d3 = pulses; 
			startCountPulses = 0;
			
		}
	}
	
}

@far @interrupt void startStopTriggersPORTA(void) // sembra che non ci vada
{
	// clear interrupt flag sembrerebbe non ce ne sia bisogno
	
	if(((GPIOA->IDR >> 3) & 0x01) == 0x00) // interrupt sul PA3 (echo 1)
	{
		
		if((startCountPulses) && 
			(stateMachineSensor == START_MEASURE_1SENSOR))
		{

		stateMachineSensor = END_MEASURE_1SENSOR;
			distanze.d1 = pulses; 
			startCountPulses = 0;
			
			
			
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
		GPIOD->ODR |= BUZZER_ON;
		aspetta(200);
		GPIOD->ODR &= ~BUZZER_ON;
		aspetta(200);
	}
	
}
void segnalazioneAccensione(void)
{
		GPIOD->ODR |= BUZZER_ON;
		aspetta(800); 
		GPIOD->ODR &= ~BUZZER_ON;
		aspetta(800); 
	
}
void segnalazioneInizioCarica(void)
{
	volatile int blink = 4;
	volatile int i = 0;
	for(i=0;i<blink;i++)
	{
		GPIOD->ODR |= BUZZER_ON;
		aspetta(300);
		GPIOD->ODR &= ~BUZZER_ON;
		aspetta(300);
	}
	
	
}

void segnalazioneFineCarica(void)
{
	volatile int blink = 3;
	volatile int i = 0;
	for(i=0;i<blink;i++)
	{
		GPIOD->ODR |= BUZZER_ON;
		aspetta(500);
		GPIOD->ODR &= ~BUZZER_ON;
		aspetta(500);
	}
	
}
void segnalazioneBatteriaScarica(void)
{
	volatile int blink = 5;
	volatile int i = 0;
	for(i=0;i<blink;i++)
	{
		GPIOD->ODR |= BUZZER_ON;
		aspetta(500);
		GPIOD->ODR &= ~BUZZER_ON;
		aspetta(500);
	}
}
void debounceInizioCarica(void)
{
	if((GPIOC->IDR >> 7) & 0x01) // inizio carica
			{
				if(countInputIC < 3)
					countInputIC++;
				else{
					inizioCarica = 1;

				}
			}
			else
			{
				if(countInputIC > 0)
					countInputIC--;
				else
					inizioCarica = 0;
			}
}
void debounceFineCarica(void)
{
	if(!((GPIOA->IDR >> 1) & 0x01)) // fine carica
			{
				if(countInputFC < 3)
					countInputFC++;
				else{
					fineCarica_prec = fineCarica;
					fineCarica = 1;

				}
			}
			else
			{
				if(countInputFC > 0)
					countInputFC--;
				else
				{
					fineCarica_prec = fineCarica;
					fineCarica = 0;
				}
			}
}
void debounceBatteriaScarica(void)
{
	if(((GPIOD->IDR >> 6) & 0x01) == 0)// batteria scarica
			{
				if(countInputBS < 3)
					countInputBS++;
				else{
					flagBatteriaScarica_prec = flagBatteriaScarica;
					flagBatteriaScarica = 1;

				}
			}
			else
			{
				if(countInputBS > 0)
					countInputBS--;
				else
				{
					flagBatteriaScarica_prec = flagBatteriaScarica;
					flagBatteriaScarica = 0;
				}
			}
}
void debounceTasto(void)
{
	if((GPIOD->IDR >> 2) & 0x01)
			{
				
					
				if(countInputB < 3)
					countInputB++;
				else{
					statoPulsante = 1;
					

				}
			}
			else
			{
				
				if(countInputB > 0)
					countInputB--;
				else
				{
					statoPulsante = 0;
					
				}
			}
}
void gestisciBuzzerEVibrazione(void)
{
	if(buzzer.distanceMonitoring.enabled)
	{
		
			buzzer.distanceMonitoring.counterDurata++;
		buzzer.distanceMonitoring.counter++;
		if(buzzer.drive)
		{
			
			if(buzzer.distanceMonitoring.counter >= buzzer.distanceMonitoring.countHigh)
			{
				
				GPIOD->ODR &= ~BUZZER_ON;
				buzzer.distanceMonitoring.counter = 0;
				buzzer.drive = 0;
				
			}
		}
		else
		{
			
			if(buzzer.distanceMonitoring.counter >= buzzer.distanceMonitoring.countLow)
			{
				
				GPIOD->ODR |= BUZZER_ON;
				buzzer.distanceMonitoring.counter = 0;
				buzzer.drive = 1;
				
				
			}
		}
		
	
	}
	else
	{
		GPIOD->ODR &= ~BUZZER_ON;
	}
	
}
void segnalazioneOstacolo(int counter,int type,int blink)
{
	volatile int i = 0;
	if(type)
	{
		for(i=0;i<blink;i++)
	{
		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
		aspetta(counter);
		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
		aspetta(counter);
	}
	}
	else
	{
		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
		aspetta(counter);
		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
		
	}
	
}