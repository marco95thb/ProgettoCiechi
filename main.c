/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
 #include "gpio.h"
#include "analog.h"
#include "clock.h"
#include "tim.h"
#include "buzzer.h"
#include "common.h"
tAnalog adcValues;
unsigned char flagElapsed;
unsigned char setPoint;
unsigned char pulsante = 0;
unsigned short countPulsante = 0;
//del timer deve abbassarmelo

unsigned char startCountPulses;
unsigned long pulses;


unsigned int tmp;
unsigned char stateMachineSensor = 1;

unsigned long totalTicks;
tDistances distanze;
unsigned char priorita;

uint8_t flagBatteriaScarica = 0;
uint8_t statoPulsante = 0;
uint8_t statoPulsante_prec = 0;
uint8_t oneShotDrive = 0;
tFrequenza buzzer;
unsigned char inizioCarica;
unsigned char fineCarica;
unsigned char inizioCaricaSignalled;
unsigned char fineCaricaSignalled;



unsigned long supportoDelayBloccante;
unsigned int contatoreLunghezzaPressione;
unsigned char countInput = 0;
uint8_t __flaggami;
unsigned char statoDispositivo = SPENTO;
unsigned char oneShotPulsante = 0;
main()
{
	
	disableInterrupts();
	
	clockInit();
	gpioInit();
	analogInit();
	timInit();
	buzzerInit();
	
	// enabling all cpu interrupts
	enableInterrupts();
	
	buzzer.countHigh = COUNT_HIGH_2_FREQ; // debug
	buzzer.countLow = COUNT_LOW_2_FREQ; // debug
	buzzer.distanceMonitoring = 0; // debug
	
				
	
				
	while (1)
	{
		//GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
	//	inizioCarica = (GPIOC->IDR >> 7) & 0x01; // PC7
	//	fineCarica   = (GPIOA->IDR >> 1) & 0x01; // PA1
		
	/*	if((inizioCarica) && (!inizioCaricaSignalled))
		{
			disableInterrupts(); // non voglio che gli interrupt deil timer mi disturbino
			inizioCaricaSignalled = 0xFF;
			GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
			delay(10000);
			GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
			TIM1->SR1 &= ~(0x01); // clear the flag solo per sicurezza
			TIM1->CNTRH = 0;
			TIM1->CNTRL = 0;
			enableInterrupts();
		}
		else if (inizioCarica == 0)
		{
			inizioCaricaSignalled = 0;
		}
		
		if((fineCarica) && (!fineCaricaSignalled))
		{
			disableInterrupts(); // non voglio che gli interrupt deil timer mi disturbino
			fineCaricaSignalled = 0xFF;
			GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
			delay(10000);
			GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
			TIM1->SR1 &= ~(0x01); // clear the flag solo per sicurezza
			TIM1->CNTRH = 0;
			TIM1->CNTRL = 0;
			enableInterrupts();
		}
		else if (fineCarica == 0)
		{
			fineCaricaSignalled = 0;
		}*/
			
		if(flagElapsed)
		{
			
		//	buzzer.soundStat = 1;
		//	analogRead();
		//	setPoint = checkSetPoint();
			statoPulsante_prec = statoPulsante;
			if((GPIOD->IDR >> 2) & 0x01)
			{
				if(countInput < 3)
					countInput++;
				else{
					statoPulsante = 1;

				}
			}
			else
			{
				if(countInput > 0)
					countInput--;
				else
					statoPulsante = 0;
			}
				
				
				
				
				if((!statoPulsante_prec) && (statoPulsante))
				{
					
					contatoreLunghezzaPressione = 0;
					
				}
				else if((statoPulsante_prec) && (!statoPulsante))
				{
					
					if(statoDispositivo == ACCESO) // da acceso lo spengo
					{
						if(contatoreLunghezzaPressione > 10)// questi sono 1 sec
						{
							statoDispositivo = SPENTO;
							segnalazioneSpegnimento();
							GPIOD->ODR &= ~DRIVE_ON;
						}
					}
					else // da spento lo accendo
					{
						
						GPIOD->ODR |= DRIVE_ON;
						segnalazioneAccensione();
						statoDispositivo = ACCESO;
					}
					contatoreLunghezzaPressione = 0;
				}
				
			
			//flagBatteriaScarica = checkDecharge();
			
			switch(stateMachineSensor)
			{
				case START_MEASURE_1SENSOR: // impulso da 10 micro
					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
				aspetta(1);
					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
					stateMachineSensor = START_MEASURE_1SENSOR; // debug
					break; // debug
				// start
					startCountPulses = 1;
					break;
				case START_MEASURE_2SENSOR: // impulso da 10 micro
					GPIOC->ODR |= SENSOR2_TRIGGER_ON;
					aspetta(1);
					GPIOC->ODR &= (~SENSOR2_TRIGGER_ON);
					// start
					startCountPulses = 1;
					break;
				case START_MEASURE_3SENSOR: // impulso da 10 micro
					GPIOC->ODR |= SENSOR3_TRIGGER_ON;
					aspetta(1);
					GPIOC->ODR &= (~SENSOR3_TRIGGER_ON);
					// start
					startCountPulses = 1;
				break;
				// con questi case potrei gestirmi
				// l'inizio d una nuova acquisizione
				// dopo tot secondi che decido io
				case END_MEASURE_1SENSOR:
				case END_MEASURE_2SENSOR:
				case END_MEASURE_3SENSOR:
				stateMachineSensor++;
				if(stateMachineSensor > END_MEASURE_3SENSOR)
					stateMachineSensor = START_MEASURE_1SENSOR;
					break;
				
				default:break;
				
				
			}
			
			
			
	/*		if((distanze.d1 < distanze.d2) &&
			(distanze.d1 < distanze.d3) &&
			(distanze.d1 >= MIN_DIST_SENS_ALTO))
				priorita = PRIORITA_SENSORE_1; // set priority
			else if((distanze.d3 < distanze.d1) &&
			(distanze.d3 < distanze.d2) &&
			(distanze.d3 >= MIN_DIST_SENS_BASSO))
				priorita = PRIORITA_SENSORE_3;// set priority
			else if((distanze.d2 < distanze.d1) &&
			(distanze.d2 < distanze.d3) &&
			(distanze.d2 >= MIN_DIST_SENS_MEDIO) &&
			(distanze.d2 < setPoint))
				priorita = PRIORITA_SENSORE_2;// set priority
			else
				priorita = 0;// set priority
				
				
				if(priorita != 0)
				{
					buzzer.distanceMonitoring = 1;
					switch(priorita)
					{
						case PRIORITA_SENSORE_1:
						if(distanze.d1 >= SOGLIA_ALLARME_SENSORE_ALTO)
						{
							buzzer.countHigh = COUNT_HIGH_1_FREQ;
							buzzer.countLow = COUNT_LOW_1_FREQ;
						}
						else
						{
							// formula inventata ma ragionata!
							// al diminuire della distanza, suona più velocemente
							buzzer.countHigh = (0.007 * distanze.d1) - 2114;
							buzzer.countLow = buzzer.countHigh;
						}
						break;
						case PRIORITA_SENSORE_2:
						if(distanze.d2 >= SOGLIA_ALLARME_SENSORE_MEDIO)
						{
							buzzer.countHigh = COUNT_HIGH_2_FREQ;
							buzzer.countLow = COUNT_LOW_2_FREQ;
						}
						else
						{
							buzzer.countHigh = (0.007 * distanze.d2) - 2114;
							buzzer.countLow = buzzer.countHigh;
						}
						break;
						case PRIORITA_SENSORE_3:
						if(distanze.d3 >= SOGLIA_ALLARME_SENSORE_BASSO)
						{
							buzzer.countHigh = COUNT_HIGH_3_FREQ;
							buzzer.countLow = COUNT_LOW_3_FREQ;
						}
						else
						{
							buzzer.countHigh = (0.007 * distanze.d3) - 2114;
							buzzer.countLow = buzzer.countHigh;
						}
						break;
					}
				}
				else
				{
					buzzer.distanceMonitoring = 0;
				}
			
			if(!buzzer.distanceMonitoring) // se non
			{
				if(flagBatteriaScarica)
				{
					buzzer.batteryMonitoring = 1;
					buzzer.countHigh = COUNT_HIGH_1_FREQ;
					buzzer.countLow = COUNT_LOW_4_FREQ;
				}
				else
				{
					buzzer.soundStat = 0;
				}
			}*/
			 
			
			
		
		
			
			
	
			
			
				
				
				
			
			flagElapsed = 0; 
			
		}
				
				
				
			
	}

}