/* buzzer.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "buzzer.h"

void buzzerInit(void)
{
		BEEP->CSR &= ~((unsigned char)0x1F);
    BEEP->CSR |= 0x0B; // default calibration
		
		/* Select the output frequency */
		BEEP->CSR &= (unsigned char)(~0xC0); // clear
		BEEP->CSR |= (unsigned char)(0x40); // 2KHz freq
	
	
}

void driveBuzzer(unsigned char sts)
{
	if(sts)
		BEEP->CSR |= 0x20; // on
	else
		BEEP->CSR &= ~(0x20); // off
		
}
void Buzzer_Calibration(unsigned int LSIFreqHz)
{
  unsigned short lsifreqkhz;
  unsigned short A;
  
  
  
  lsifreqkhz = (unsigned short)(LSIFreqHz / 1000); /* Converts value in kHz */
  
  /* Calculation of BEEPER calibration value */
  
  BEEP->CSR &= (unsigned char)(~0x1F); /* Clear bits */
  
  A = (unsigned short)(lsifreqkhz >> 3U); /* Division by 8, keep integer part only */
  
  if ((8U * A) >= ((lsifreqkhz - (8U * A)) * (1U + (2U * A))))
  {
    BEEP->CSR |= (unsigned char)(A - 2U);
  }
  else
  {
    BEEP->CSR |= (unsigned char)(A - 1U);
  }
}
void Buzzer_Init(uint8_t BEEP_Frequency)
{
  /* Set a default calibration value if no calibration is done */
  if ((BEEP->CSR & 0x1F) == 0x1F)
  {
    BEEP->CSR &= (uint8_t)(~0x1F); /* Clear bits */
    BEEP->CSR |= BEEP_CALIBRATION_DEFAULT;
  }
  
  /* Select the output frequency */
  BEEP->CSR &= (uint8_t)(~0xC0);
  BEEP->CSR |= (uint8_t)(BEEP_Frequency);
}