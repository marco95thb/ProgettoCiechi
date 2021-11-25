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
  58                     ; 21 	ADC1->CR1 |= 0x01; // wake up
  60  000c 72105401      	bset	21505,#0
  61                     ; 24 }
  64  0010 81            	ret
 110                     ; 26 void analogRead(void)
 110                     ; 27 {
 111                     	switch	.text
 112  0011               _analogRead:
 114  0011 89            	pushw	x
 115       00000002      OFST:	set	2
 118                     ; 28 	unsigned char tmp = 0x00;
 120  0012 0f02          	clr	(OFST+0,sp)
 122                     ; 29 	unsigned char tmp1 = 0x00;
 124                     ; 30 	ADC1->CR1 |= 0x01; // start conversion
 126  0014 72105401      	bset	21505,#0
 128  0018 2007          	jra	L54
 129  001a               L34:
 130                     ; 34 		tmp = (ADC1->CSR & 0x80); // EOC
 132  001a c65400        	ld	a,21504
 133  001d a480          	and	a,#128
 134  001f 6b02          	ld	(OFST+0,sp),a
 136  0021               L54:
 137                     ; 32 	while(!tmp)
 139  0021 0d02          	tnz	(OFST+0,sp)
 140  0023 27f5          	jreq	L34
 141                     ; 37 	disableInterrupts(); // mi assicuro che nessuno disturbi la lettura
 144  0025 9b            sim
 146                     ; 38 	adcValues.distanceSetPoint = ((ADC1->DB2RH << 8) | 
 146                     ; 39 	ADC1->DB2RL);
 149  0026 c653e4        	ld	a,21476
 150  0029 5f            	clrw	x
 151  002a 97            	ld	xl,a
 152  002b c653e5        	ld	a,21477
 153  002e 02            	rlwa	x,a
 154  002f bf02          	ldw	_adcValues+2,x
 155                     ; 40 	enableInterrupts();
 158  0031 9a            rim
 160                     ; 41 	if((ADC1->CR3 & 0x40)==0x40)// CHECK OVR FLAG
 163  0032 c65403        	ld	a,21507
 164  0035 a440          	and	a,#64
 165  0037 a140          	cp	a,#64
 166  0039 2607          	jrne	L15
 167                     ; 43 		ADC1->CR3 &= ~(0x40);
 169  003b 721d5403      	bres	21507,#6
 170                     ; 44 		adcValues.distanceSetPoint = 0; // not valid
 172  003f 5f            	clrw	x
 173  0040 bf02          	ldw	_adcValues+2,x
 174  0042               L15:
 175                     ; 47 	ADC1->CSR &= 0x7F; // bit7 --> eoc
 177  0042 721f5400      	bres	21504,#7
 178                     ; 49 }
 181  0046 85            	popw	x
 182  0047 81            	ret
 206                     ; 50 unsigned long checkSetPoint(void)
 206                     ; 51 {
 207                     	switch	.text
 208  0048               _checkSetPoint:
 212                     ; 52 	if(adcValues.distanceSetPoint < SP_TH1_COUNT)
 214  0048 be02          	ldw	x,_adcValues+2
 215  004a a30100        	cpw	x,#256
 216  004d 240b          	jruge	L36
 217                     ; 54 				return 1400000; // micrometri
 219  004f ae5cc0        	ldw	x,#23744
 220  0052 bf02          	ldw	c_lreg+2,x
 221  0054 ae0015        	ldw	x,#21
 222  0057 bf00          	ldw	c_lreg,x
 225  0059 81            	ret
 226  005a               L36:
 227                     ; 56 			else if (adcValues.distanceSetPoint < SP_TH2_COUNT)
 229  005a be02          	ldw	x,_adcValues+2
 230  005c a30200        	cpw	x,#512
 231  005f 240b          	jruge	L76
 232                     ; 59 				return 2000000; // micrometri
 234  0061 ae8480        	ldw	x,#33920
 235  0064 bf02          	ldw	c_lreg+2,x
 236  0066 ae001e        	ldw	x,#30
 237  0069 bf00          	ldw	c_lreg,x
 240  006b 81            	ret
 241  006c               L76:
 242                     ; 62 			else if (adcValues.distanceSetPoint < SP_TH3_COUNT)
 244  006c be02          	ldw	x,_adcValues+2
 245  006e a303ff        	cpw	x,#1023
 246  0071 240b          	jruge	L37
 247                     ; 65 				return 3000000; // micrometri
 249  0073 aec6c0        	ldw	x,#50880
 250  0076 bf02          	ldw	c_lreg+2,x
 251  0078 ae002d        	ldw	x,#45
 252  007b bf00          	ldw	c_lreg,x
 255  007d 81            	ret
 256  007e               L37:
 257                     ; 69 				return 4000000; // micrometri
 259  007e ae0900        	ldw	x,#2304
 260  0081 bf02          	ldw	c_lreg+2,x
 261  0083 ae003d        	ldw	x,#61
 262  0086 bf00          	ldw	c_lreg,x
 265  0088 81            	ret
 278                     	xref.b	_adcValues
 279                     	xdef	_checkSetPoint
 280                     	xdef	_analogRead
 281                     	xdef	_analogInit
 282                     	xref.b	c_lreg
 301                     	end
