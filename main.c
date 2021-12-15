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
unsigned int pulses;


unsigned int tmp;
unsigned char stateMachineSensor = START_MEASURE_2SENSOR;

unsigned long totalTicks;
tDistances distanze;
unsigned char priorita;



uint8_t statoPulsante_prec = 0;
uint8_t oneShotDrive = 0;
tFrequenza buzzer;
unsigned char inizioCarica;
unsigned char fineCarica;
unsigned char flagBatteriaScarica = 0;
unsigned char inizioCaricaSignalled;
unsigned char fineCaricaSignalled;
unsigned char batteriaScaricaSignalled = 0;
unsigned char countInputB = 0; // debounce tasto
unsigned char countInputIC = 0; // debounce inizio carica
unsigned char countInputFC = 0; // debounce fine carica
unsigned char countInputBS = 0; // debounce batt scarica
unsigned char statoPulsante = 0;

unsigned long supportoDelayBloccante;
unsigned int contatoreLunghezzaPressione;

uint8_t __flaggami;
unsigned char statoDispositivo = ACCESO;
unsigned char oneShotPulsante = 0;
extern unsigned char debugToggle;
static volatile int i = 0;

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
	

	GPIOD->ODR |= DRIVE_ON;
	segnalazioneAccensione();
						
			/*	while(1)
				{
					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
					GPIOC->ODR |= SENSOR2_TRIGGER_ON;
					GPIOC->ODR |= SENSOR3_TRIGGER_ON;
					
					aspetta(1); // 400 MICRO
					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
					GPIOC->ODR &= (~SENSOR2_TRIGGER_ON);
					GPIOC->ODR &= (~SENSOR3_TRIGGER_ON);
					
				}*/
				
				
	while (1)
	{
		
		
			
			// 8 count sono 38cm (2.2ms) l'ho provato 
		if(flagElapsed)
		{
			flagElapsed = 0;
			
			//if(!debugToggle)
			//{
			//	debugToggle = 0xFF;
		//		GPIOC->ODR |= SENSOR1_TRIGGER_ON;
			//	GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
			//}
			//else
			//{
			//	debugToggle = 0x00;
			//	GPIOC->ODR &= ~SENSOR1_TRIGGER_ON;
			//	GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
				
		//	}
			
			
			switch(stateMachineSensor)
			{
				case START_MEASURE_1SENSOR: // impulso 
				// start
				pulses = 0;
				startCountPulses = 1;
					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
					for(i = 0;i < 15;i++);
					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
					
				stateMachineSensor = 1;
					break;
				case START_MEASURE_2SENSOR: // impulso
				// start
					pulses = 0;
					startCountPulses = 1;
					GPIOC->ODR |= SENSOR2_TRIGGER_ON;
					for(i = 0;i < 15;i++);
					GPIOC->ODR &= (~SENSOR2_TRIGGER_ON);
					
					
					break;
				case START_MEASURE_3SENSOR: // impulso
				// start
					pulses = 0;
					startCountPulses = 1;
					GPIOC->ODR |= SENSOR3_TRIGGER_ON;
					for(i = 0;i < 15;i++);
					GPIOC->ODR &= (~SENSOR3_TRIGGER_ON);
					
				break;
				// con questi case potrei gestirmi
				// l'inizio d una nuova acquisizione
				// dopo tot secondi che decido io
				case END_MEASURE_1SENSOR:
				case END_MEASURE_2SENSOR:
				case END_MEASURE_3SENSOR:
				
				if(stateMachineSensor == END_MEASURE_2SENSOR)
				{
					stateMachineSensor = START_MEASURE_2SENSOR;
					
				}
				//stateMachineSensor++;
					break;
				
				default:break;
				
				
			}
						
			
			if((inizioCarica) && (!inizioCaricaSignalled))
			{
				inizioCaricaSignalled = 0xFF;
				segnalazioneInizioCarica();
			}
			else if (inizioCarica == 0)
			{
				inizioCaricaSignalled = 0;
			}
		
			if((fineCarica) && (!fineCaricaSignalled))
			{
			
				fineCaricaSignalled = 0xFF;
				segnalazioneFineCarica();
			}
			else if (fineCarica == 0)
			{
				fineCaricaSignalled = 0;
			}
		
		
			if((flagBatteriaScarica) && (!batteriaScaricaSignalled))
			{
				batteriaScaricaSignalled = 0xFF;
			//	segnalazioneBatteriaScarica();
				
				
			}
			else if(flagBatteriaScarica == 0)
			{
				
					batteriaScaricaSignalled = 0;
				
			}
		
			//analogRead();
			//setPoint = checkSetPoint();
			statoPulsante_prec = statoPulsante;
			debounceTasto();
		//	debounceInizioCarica();
		//	debounceFineCarica();
		//	debounceBatteriaScarica();
				
				if((!statoPulsante_prec) && (statoPulsante))
				{
					
					contatoreLunghezzaPressione = 0;
					
				}
				else if((statoPulsante_prec) && (!statoPulsante))
				{
					
					if(statoDispositivo == ACCESO) // da acceso lo spengo
					{
						if(contatoreLunghezzaPressione > 100)
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
				
			
			
			
			
			
			if((distanze.d1 < distanze.d2) &&
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
				
				priorita = 0; // così non vado là
				
				priorita = PRIORITA_SENSORE_2;
				
				if(priorita != 0)
				{
					
					switch(priorita)
					{
						case PRIORITA_SENSORE_1:
						if(distanze.d1 >= SOGLIA_ALLARME_SENSORE_ALTO)
						{
							buzzer.distanceMonitoring.countHigh = COUNT_HIGH_1_FREQ;
							buzzer.distanceMonitoring.countLow = COUNT_LOW_1_FREQ;
						}
						else
						{
							// formula inventata ma ragionata!
							// al diminuire della distanza, suona più velocemente
							
							buzzer.distanceMonitoring.countHigh = (distanze.d1 * 5);
							buzzer.distanceMonitoring.countLow = buzzer.distanceMonitoring.countHigh;
						}
						break;
						case PRIORITA_SENSORE_2:
						
						if((distanze.d2 < SOGLIA_ALLARME_SENSORE_MEDIO) // maggiore di 30cm
						&& (distanze.d2 >= SOGLIA_ALLARME_SENSORE_MEDIO_TH1))
						{
						buzzer.distanceMonitoring.enabled = 1;
						buzzer.distanceMonitoring.countHigh = 800;
						buzzer.distanceMonitoring.countLow = 800;
							
						}
						else if((distanze.d2 < SOGLIA_ALLARME_SENSORE_MEDIO_TH1) // maggiore di 30cm
						&& (distanze.d2 >= SOGLIA_ALLARME_SENSORE_MEDIO_TH2))
						{
							buzzer.distanceMonitoring.enabled = 1;
							buzzer.distanceMonitoring.countHigh = 450;
							buzzer.distanceMonitoring.countLow = 450;
						
						}
						else if((distanze.d2 < SOGLIA_ALLARME_SENSORE_MEDIO_TH2) // maggiore di 30cm
						&& (distanze.d2 >= MIN_DIST_SENS_MEDIO))
						{
							buzzer.distanceMonitoring.enabled = 1;
							buzzer.distanceMonitoring.countHigh = 250;
							buzzer.distanceMonitoring.countLow = 250;
						
						}
						else
						{
							buzzer.distanceMonitoring.enabled = 0;
						}
						break;
						case PRIORITA_SENSORE_3:
						if(distanze.d3 >= SOGLIA_ALLARME_SENSORE_BASSO)
						{
							buzzer.distanceMonitoring.countHigh = COUNT_HIGH_3_FREQ;
							buzzer.distanceMonitoring.countLow = COUNT_LOW_3_FREQ;
						}
						else
						{
							buzzer.distanceMonitoring.countHigh = (distanze.d3 * 5);
							buzzer.distanceMonitoring.countLow = buzzer.distanceMonitoring.countHigh;
						}
						break;
					}
					
					
				}
				else
				{
					buzzer.distanceMonitoring.enabled = 0;
				}
			
			
		}
				
				
				
			
	}

}