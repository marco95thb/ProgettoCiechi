   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  42                     ; 8 void analogInit(void)
  42                     ; 9 {
  44                     	switch	.text
  45  0000               _analogInit:
  49                     ; 11 	ADC1->CR1 = 0b00000000; // maximum speed + single conversion
  51  0000 725f5401      	clr	21505
  52                     ; 12 	ADC1->CR2 = 0b00000000; // scan mode disabled
  54  0004 725f5402      	clr	21506
  55                     ; 16 	ADC1->CSR = 0x02; // AIN2
  57  0008 35025400      	mov	21504,#2
  58                     ; 17 	ADC1->CR2 |= (0x01 << 3);
  60  000c 72165402      	bset	21506,#3
  61                     ; 21 	ADC1->CR1 |= 0x01; // wake up
  63  0010 72105401      	bset	21505,#0
  64                     ; 25 }
  67  0014 81            	ret
 113                     ; 27 void analogRead(void)
 113                     ; 28 {
 114                     	switch	.text
 115  0015               _analogRead:
 117  0015 5204          	subw	sp,#4
 118       00000004      OFST:	set	4
 121                     ; 29 	unsigned char tmp = 0x00;
 123  0017 0f04          	clr	(OFST+0,sp)
 125                     ; 30 	unsigned char tmp1 = 0x00;
 127                     ; 31 	ADC1->CR1 |= 0x01; // start conversion
 129  0019 72105401      	bset	21505,#0
 131  001d 2007          	jra	L54
 132  001f               L34:
 133                     ; 35 		tmp = (ADC1->CSR & 0x80); // EOC
 135  001f c65400        	ld	a,21504
 136  0022 a480          	and	a,#128
 137  0024 6b04          	ld	(OFST+0,sp),a
 139  0026               L54:
 140                     ; 33 	while(!tmp)
 142  0026 0d04          	tnz	(OFST+0,sp)
 143  0028 27f5          	jreq	L34
 144                     ; 38 	disableInterrupts(); // mi assicuro che nessuno disturbi la lettura
 147  002a 9b            sim
 149                     ; 39 	if((ADC1->CR2 & ADC1_CR2_ALIGN) != 0)
 152  002b c65402        	ld	a,21506
 153  002e a508          	bcp	a,#8
 154  0030 2715          	jreq	L15
 155                     ; 41 		tmp1 = ADC1->DRL;
 157  0032 c65405        	ld	a,21509
 158  0035 6b03          	ld	(OFST-1,sp),a
 160                     ; 42 		tmp =  ADC1->DRH;
 162  0037 c65404        	ld	a,21508
 163  003a 6b04          	ld	(OFST+0,sp),a
 165                     ; 43 		adcValues.distanceSetPoint = (tmp1 | (tmp << 8));
 167  003c 7b04          	ld	a,(OFST+0,sp)
 168  003e 5f            	clrw	x
 169  003f 97            	ld	xl,a
 170  0040 7b03          	ld	a,(OFST-1,sp)
 171  0042 02            	rlwa	x,a
 172  0043 bf02          	ldw	_adcValues+2,x
 174  0045 2021          	jra	L35
 175  0047               L15:
 176                     ; 47 		tmp =  ADC1->DRH;
 178  0047 c65404        	ld	a,21508
 179  004a 6b04          	ld	(OFST+0,sp),a
 181                     ; 48 		tmp1 = ADC1->DRL;
 183  004c c65405        	ld	a,21509
 184  004f 6b03          	ld	(OFST-1,sp),a
 186                     ; 50 		adcValues.distanceSetPoint = ((tmp1 << 6) | (tmp << 8));
 188  0051 7b04          	ld	a,(OFST+0,sp)
 189  0053 5f            	clrw	x
 190  0054 97            	ld	xl,a
 191  0055 4f            	clr	a
 192  0056 02            	rlwa	x,a
 193  0057 1f01          	ldw	(OFST-3,sp),x
 195  0059 7b03          	ld	a,(OFST-1,sp)
 196  005b 97            	ld	xl,a
 197  005c a640          	ld	a,#64
 198  005e 42            	mul	x,a
 199  005f 01            	rrwa	x,a
 200  0060 1a02          	or	a,(OFST-2,sp)
 201  0062 01            	rrwa	x,a
 202  0063 1a01          	or	a,(OFST-3,sp)
 203  0065 01            	rrwa	x,a
 204  0066 bf02          	ldw	_adcValues+2,x
 205  0068               L35:
 206                     ; 54 	enableInterrupts();
 209  0068 9a            rim
 211                     ; 57 	ADC1->CSR &= 0x7F; // bit7 --> eoc
 214  0069 721f5400      	bres	21504,#7
 215                     ; 59 }
 218  006d 5b04          	addw	sp,#4
 219  006f 81            	ret
 243                     ; 60 unsigned long checkSetPoint(void)
 243                     ; 61 {
 244                     	switch	.text
 245  0070               _checkSetPoint:
 249                     ; 62 	if(adcValues.distanceSetPoint < SP_TH1_COUNT)
 251  0070 be02          	ldw	x,_adcValues+2
 252  0072 a30100        	cpw	x,#256
 253  0075 240b          	jruge	L56
 254                     ; 64 				return 1400000; // micrometri
 256  0077 ae5cc0        	ldw	x,#23744
 257  007a bf02          	ldw	c_lreg+2,x
 258  007c ae0015        	ldw	x,#21
 259  007f bf00          	ldw	c_lreg,x
 262  0081 81            	ret
 263  0082               L56:
 264                     ; 66 			else if (adcValues.distanceSetPoint < SP_TH2_COUNT)
 266  0082 be02          	ldw	x,_adcValues+2
 267  0084 a30200        	cpw	x,#512
 268  0087 240b          	jruge	L17
 269                     ; 69 				return 3000000; // micrometri
 271  0089 aec6c0        	ldw	x,#50880
 272  008c bf02          	ldw	c_lreg+2,x
 273  008e ae002d        	ldw	x,#45
 274  0091 bf00          	ldw	c_lreg,x
 277  0093 81            	ret
 278  0094               L17:
 279                     ; 72 			else if (adcValues.distanceSetPoint < SP_TH3_COUNT)
 281  0094 be02          	ldw	x,_adcValues+2
 282  0096 a303ff        	cpw	x,#1023
 283  0099 240b          	jruge	L76
 284                     ; 75 				return 4000000; // micrometri
 286  009b ae0900        	ldw	x,#2304
 287  009e bf02          	ldw	c_lreg+2,x
 288  00a0 ae003d        	ldw	x,#61
 289  00a3 bf00          	ldw	c_lreg,x
 292  00a5 81            	ret
 293  00a6               L76:
 294                     ; 78 }
 297  00a6 81            	ret
 310                     	xref.b	_adcValues
 311                     	xdef	_checkSetPoint
 312                     	xdef	_analogRead
 313                     	xdef	_analogInit
 314                     	xref.b	c_lreg
 333                     	end
