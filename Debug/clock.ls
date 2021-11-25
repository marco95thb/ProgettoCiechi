   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  42                     ; 7 void clockInit(void)
  42                     ; 8 {
  44                     	switch	.text
  45  0000               _clockInit:
  49                     ; 10 	CLK->CKDIVR = 0x00; // internal clock with no prescaler
  51  0000 725f50c6      	clr	20678
  52                     ; 11 	CLK->PCKENR1 |= 0b10000000; // tim1 active
  54  0004 721e50c7      	bset	20679,#7
  55                     ; 12 	CLK->PCKENR2 |= 0b00001000; // adc active
  57  0008 721650ca      	bset	20682,#3
  58                     ; 13 	CLK->SWIMCCR |= 0x01; // clock swwim not divided
  60  000c 721050cd      	bset	20685,#0
  61                     ; 18 }
  64  0010 81            	ret
  77                     	xdef	_clockInit
  96                     	end
