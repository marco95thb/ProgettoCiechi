   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  14                     	bsct
  15  0000               _countDebug:
  16  0000 0000          	dc.w	0
  17  0002               _contatoreAttesa:
  18  0002 0000          	dc.w	0
  47                     ; 28 void timInit(void)
  47                     ; 29 {
  49                     	switch	.text
  50  0000               _timInit:
  54                     ; 30 	TIM1->CR1 = 0b00000100; // interrupt only on overflow
  56  0000 35045250      	mov	21072,#4
  57                     ; 31 	TIM1->IER = 0x01; // update interrupt enable
  59  0004 35015254      	mov	21076,#1
  60                     ; 33 	TIM1->PSCRL = 15; // timer @1Mhz (da 16 di cpu clock a 1)
  62  0008 350f5261      	mov	21089,#15
  63                     ; 36 	TIM1->ARRH = 0x00;
  65  000c 725f5262      	clr	21090
  66                     ; 37 	TIM1->ARRL = 0x64; // sarebbero 100 micro
  68  0010 35645263      	mov	21091,#100
  69                     ; 42 	TIM1->CR1 |= 0x01; // start the counter
  71  0014 72105250      	bset	21072,#0
  72                     ; 47 }
  75  0018 81            	ret
 107                     .const:	section	.text
 108  0000               L01:
 109  0000 000003e8      	dc.l	1000
 110                     ; 49 @far @interrupt void tim1Elapsed (void)
 110                     ; 50 {
 111                     	scross	on
 112                     	switch	.text
 113  0019               f_tim1Elapsed:
 115  0019 be02          	ldw	x,c_lreg+2
 116  001b 89            	pushw	x
 117  001c be00          	ldw	x,c_lreg
 118  001e 89            	pushw	x
 121                     ; 51 	TIM1->SR1 &= ~(0x01); // clear the flag
 123  001f 72115255      	bres	21077,#0
 124                     ; 52 	totalTicks++; // @ 100 microsecond
 126  0023 ae0000        	ldw	x,#_totalTicks
 127  0026 a601          	ld	a,#1
 128  0028 cd0000        	call	c_lgadc
 130                     ; 54 	supportoDelayBloccante++;
 132  002b ae0000        	ldw	x,#_supportoDelayBloccante
 133  002e a601          	ld	a,#1
 134  0030 cd0000        	call	c_lgadc
 136                     ; 56 	if(totalTicks >= 1000) // 100ms
 138  0033 ae0000        	ldw	x,#_totalTicks
 139  0036 cd0000        	call	c_ltor
 141  0039 ae0000        	ldw	x,#L01
 142  003c cd0000        	call	c_lcmp
 144  003f 250e          	jrult	L13
 145                     ; 58 		totalTicks = 0;
 147  0041 ae0000        	ldw	x,#0
 148  0044 bf02          	ldw	_totalTicks+2,x
 149  0046 ae0000        	ldw	x,#0
 150  0049 bf00          	ldw	_totalTicks,x
 151                     ; 59 		flagElapsed = 1;
 153  004b 35010000      	mov	_flagElapsed,#1
 154  004f               L13:
 155                     ; 63 	if(startCountPulses)
 157  004f 3d00          	tnz	_startCountPulses
 158  0051 2708          	jreq	L33
 159                     ; 65 		pulses++; // pulses è in base 100 microS
 161  0053 ae0000        	ldw	x,#_pulses
 162  0056 a601          	ld	a,#1
 163  0058 cd0000        	call	c_lgadc
 165  005b               L33:
 166                     ; 69 			contatoreLunghezzaPressione++; //tiene il conto
 168  005b be00          	ldw	x,_contatoreLunghezzaPressione
 169  005d 1c0001        	addw	x,#1
 170  0060 bf00          	ldw	_contatoreLunghezzaPressione,x
 171                     ; 71 	if(deviAspettare)
 173  0062 3d02          	tnz	_deviAspettare
 174  0064 2712          	jreq	L53
 175                     ; 73 		contatoreAttesa++;
 177  0066 be02          	ldw	x,_contatoreAttesa
 178  0068 1c0001        	addw	x,#1
 179  006b bf02          	ldw	_contatoreAttesa,x
 180                     ; 74 		if(contatoreAttesa >= quantoDeviAspettare)
 182  006d be02          	ldw	x,_contatoreAttesa
 183  006f b300          	cpw	x,_quantoDeviAspettare
 184  0071 2505          	jrult	L53
 185                     ; 76 			contatoreAttesa = 0;
 187  0073 5f            	clrw	x
 188  0074 bf02          	ldw	_contatoreAttesa,x
 189                     ; 77 			deviAspettare = 0;
 191  0076 3f02          	clr	_deviAspettare
 192  0078               L53:
 193                     ; 85 }
 196  0078 85            	popw	x
 197  0079 bf00          	ldw	c_lreg,x
 198  007b 85            	popw	x
 199  007c bf02          	ldw	c_lreg+2,x
 200  007e 80            	iret
 224                     ; 90 void gestisciBuzzerEVibrazione(void)
 224                     ; 91 {
 226                     	switch	.text
 227  007f               _gestisciBuzzerEVibrazione:
 231                     ; 92 	if((buzzer.distanceMonitoring) || 
 231                     ; 93 		(buzzer.batteryMonitoring))
 233  007f 3d00          	tnz	_buzzer
 234  0081 2604          	jrne	L35
 236  0083 3d01          	tnz	_buzzer+1
 237  0085 2737          	jreq	L15
 238  0087               L35:
 239                     ; 95 		buzzer.counter++;
 241  0087 be07          	ldw	x,_buzzer+7
 242  0089 1c0001        	addw	x,#1
 243  008c bf07          	ldw	_buzzer+7,x
 244                     ; 96 		if(buzzer.drive)
 246  008e 3d09          	tnz	_buzzer+9
 247  0090 2715          	jreq	L55
 248                     ; 98 			GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
 250  0092 c6500f        	ld	a,20495
 251  0095 aa30          	or	a,#48
 252  0097 c7500f        	ld	20495,a
 253                     ; 99 			if(buzzer.counter >= buzzer.countHigh)
 255  009a be07          	ldw	x,_buzzer+7
 256  009c b302          	cpw	x,_buzzer+2
 257  009e 252b          	jrult	L56
 258                     ; 101 					buzzer.drive = 0; // toggle
 260  00a0 3f09          	clr	_buzzer+9
 261                     ; 102 					buzzer.counter = 0; // reset the counter
 263  00a2 5f            	clrw	x
 264  00a3 bf07          	ldw	_buzzer+7,x
 265  00a5 2024          	jra	L56
 266  00a7               L55:
 267                     ; 107 			GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
 269  00a7 c6500f        	ld	a,20495
 270  00aa a4cf          	and	a,#207
 271  00ac c7500f        	ld	20495,a
 272                     ; 108 			if(buzzer.counter >= buzzer.countLow)
 274  00af be07          	ldw	x,_buzzer+7
 275  00b1 b304          	cpw	x,_buzzer+4
 276  00b3 2516          	jrult	L56
 277                     ; 110 					buzzer.drive = 1; // toggle
 279  00b5 35010009      	mov	_buzzer+9,#1
 280                     ; 111 					buzzer.counter = 0; // reset the counter
 282  00b9 5f            	clrw	x
 283  00ba bf07          	ldw	_buzzer+7,x
 284  00bc 200d          	jra	L56
 285  00be               L15:
 286                     ; 117 		buzzer.drive = 0; // toggle
 288  00be 3f09          	clr	_buzzer+9
 289                     ; 118 		buzzer.counter = 0; // reset the counter
 291  00c0 5f            	clrw	x
 292  00c1 bf07          	ldw	_buzzer+7,x
 293                     ; 119 		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
 295  00c3 c6500f        	ld	a,20495
 296  00c6 a4cf          	and	a,#207
 297  00c8 c7500f        	ld	20495,a
 298  00cb               L56:
 299                     ; 121 }
 302  00cb 81            	ret
 338                     ; 122 void aspetta(unsigned int count)
 338                     ; 123 {
 339                     	switch	.text
 340  00cc               _aspetta:
 344                     ; 124 	deviAspettare = 1;
 346  00cc 35010002      	mov	_deviAspettare,#1
 347                     ; 125 	quantoDeviAspettare = count; // un tick sono 100 micro
 349  00d0 bf00          	ldw	_quantoDeviAspettare,x
 351  00d2               L111:
 352                     ; 127 	while(deviAspettare);
 354  00d2 3d02          	tnz	_deviAspettare
 355  00d4 26fc          	jrne	L111
 356                     ; 129 }
 359  00d6 81            	ret
 411                     	xdef	_contatoreAttesa
 412                     	switch	.ubsct
 413  0000               _quantoDeviAspettare:
 414  0000 0000          	ds.b	2
 415                     	xdef	_quantoDeviAspettare
 416  0002               _deviAspettare:
 417  0002 00            	ds.b	1
 418                     	xdef	_deviAspettare
 419                     	xdef	_countDebug
 420                     	xref.b	_contatoreLunghezzaPressione
 421                     	xref.b	_supportoDelayBloccante
 422                     	xref.b	_buzzer
 423                     	xref.b	_flagElapsed
 424                     	xref.b	_totalTicks
 425                     	xref.b	_pulses
 426                     	xref.b	_startCountPulses
 427                     	xdef	_aspetta
 428                     	xdef	_gestisciBuzzerEVibrazione
 429                     	xdef	f_tim1Elapsed
 430                     	xdef	_timInit
 431                     	xref.b	c_lreg
 451                     	xref	c_lcmp
 452                     	xref	c_ltor
 453                     	xref	c_lgadc
 454                     	end
