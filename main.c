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
unsigned int setPoint;
unsigned char pulsante = 0;
unsigned short countPulsante = 0;
//del timer deve abbassarmelo

unsigned char startCountPulses;
unsigned int pulses;


unsigned int tmp;
unsigned char stateMachineSensor = START_MEASURE_1SENSOR;

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
int sensoreAttivo = 0;
unsigned char nonConsiderare = 0;
main()
{
	unsigned int distanzeArray[3];
	int i;
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
			
			analogRead();
			setPoint = checkSetPoint();
			
			
			
			
			switch(stateMachineSensor)
			{
				case START_MEASURE_1SENSOR: // impulso 
				// start
				pulses = 0;
				startCountPulses = 1;
					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
					for(i = 0;i < 15;i++);
					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
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
				
				if(stateMachineSensor == END_MEASURE_3SENSOR)
				{
					stateMachineSensor = START_MEASURE_1SENSOR;
					distanze.minima = 9999;
					distanze.massima = 0;
					sensoreAttivo = 0;
					if((distanze.d1 < setPoint) && (distanze.d1 >= MIN_DIST_SENS_ALTO	)) // legge solo se < 1.4m
					{
						distanzeArray[0] = distanze.d1;
						sensoreAttivo = 1;
					}
					else
						distanzeArray[0] = 9999;
						
					if(distanze.d2 < 20) // legge solo se < 1.4m
					{
						distanzeArray[1] = distanze.d2;
						sensoreAttivo = 2;
					}
					else
						distanzeArray[1] = 9999;
						
						if(distanze.d3 < 20) // legge solo se < soglia
						{
						distanzeArray[2] = distanze.d3;
						sensoreAttivo = 3;
						}
					else
						distanzeArray[2] = 9999;
						
					
					for(i=0;i<3;i++)
					{
						if((distanzeArray[i] < distanze.minima) && (distanzeArray[i] >= MIN_DIST_SENS_ALTO))
							distanze.minima = distanzeArray[i];
							
						if(distanzeArray[i] > distanze.massima)
							distanze.massima = distanzeArray[i];
					}
				nonConsiderare = 0;
							if((distanze.minima < SOGLIA_ALLARME_SENSORE_ALTO) // maggiore di 30cm
							&& (distanze.minima >= SOGLIA_ALLARME_SENSORE_ALTO_TH1))
							{
								if(sensoreAttivo == 3) // è un esterno
									segnalazioneOstacolo(200,1,3);
						else if(sensoreAttivo == 2) // è l'altro esterno
						{
								segnalazioneOstacolo(200,1,5);
							}
						else if(sensoreAttivo == 1) 
						{
						//	segnalazioneOstacolo(200,1,7);
						
						}
								
						
							
							}
						else if((distanze.minima < SOGLIA_ALLARME_SENSORE_ALTO_TH1) // maggiore di 30cm
						&& (distanze.minima >= SOGLIA_ALLARME_SENSORE_ALTO_TH2))
						{
							nonConsiderare = 1;
							segnalazioneOstacolo(1200,0,0);
						
						}
						else if((distanze.minima < SOGLIA_ALLARME_SENSORE_ALTO_TH2) // maggiore di 30cm
						&& (distanze.minima >= MIN_DIST_SENS_ALTO))
						{
							nonConsiderare = 1;
							segnalazioneOstacolo(1200,0,0);
						
						}
						
						if((sensoreAttivo == 1) && 
						(distanze.minima > MIN_DIST_SENS_ALTO) && 
						(distanze.minima < setPoint) &&
						(nonConsiderare == 0))
						{
							segnalazioneOstacolo(100,1,7);
							segnalazioneOstacolo(500,0,0);
						}
						
					
					
					
					
					
			
					
				}
				else
					stateMachineSensor++;
					break;
				
				default:break;
				
				
			}
			
			statoPulsante_prec = statoPulsante;
			debounceTasto();
			debounceInizioCarica();
			debounceFineCarica();
			debounceBatteriaScarica();
			
						
			
			if((inizioCarica) && (!inizioCaricaSignalled))
			{
				inizioCaricaSignalled = 0xFF;
				//segnalazioneInizioCarica();
			}
			else if (inizioCarica == 0)
			{
				inizioCaricaSignalled = 0;
			}
		
			if((fineCarica) && (!fineCaricaSignalled))
			{
			
				fineCaricaSignalled = 0xFF;
				//segnalazioneFineCarica();
			}
			else if (fineCarica == 0)
			{
				fineCaricaSignalled = 0;
			}
		
		
			if((flagBatteriaScarica) && (!batteriaScaricaSignalled))
			{
				batteriaScaricaSignalled = 0xFF;
				//segnalazioneBatteriaScarica();
				
				
			}
			else if(flagBatteriaScarica == 0)
			{
				
					batteriaScaricaSignalled = 0;
				
			}
		
			
			
				
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
				
			
			
			
			
			
	
			
		}
		
				
				
				
			
	}

}