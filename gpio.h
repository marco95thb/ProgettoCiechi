/* gpio.h file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#ifndef _GPIO_H
#define _GPIO_H
#include "common.h"

#define DRIVE_ON 0x08


void gpioInit(void);
uint8_t gestionePulsante(void);
@far @interrupt void startStopTriggersPORTB(void);
@far @interrupt void startStopTriggersPORTA(void);
uint8_t checkDecharge(void);
void segnalazioneSpegnimento(void);
void segnalazioneAccensione(void);
void segnalazioneInizioCarica(void);
void segnalazioneFineCarica(void);
void segnalazioneBatteriaScarica(void);
void debounceInizioCarica(void);
void debounceFineCarica(void);
void debounceBatteriaScarica(void);
void debounceTasto(void);
void gestisciBuzzerEVibrazione(void);
#endif