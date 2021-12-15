   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  14                     	bsct
  15  0000               _countDebug:
  16  0000 0000          	dc.w	0
  17  0002               _contatoreAttesa:
  18  0002 0000          	dc.w	0
  47                     ; 30 void timInit(void)
  47                     ; 31 {
  49                     	switch	.text
  50  0000               _timInit:
  54                     ; 32 	TIM1->CR1 = 0b00000100; // interrupt only on overflow
  56  0000 35045250      	mov	21072,#4
  57                     ; 33 	TIM1->IER = 0x01; // update interrupt enable
  59  0004 35015254      	mov	21076,#1
  60                     ; 35 	TIM1->PSCRH = 0;
  62  0008 725f5260      	clr	21088
  63                     ; 36 	TIM1->PSCRL = 15; // timer @1Mhz 
  65  000c 350f5261      	mov	21089,#15
  66                     ; 39 	TIM1->ARRH = 0x01;
  68  0010 35015262      	mov	21090,#1
  69                     ; 40 	TIM1->ARRL = 0xF4; // sarebbero 500 tick a 1Mhz
  71  0014 35f45263      	mov	21091,#244
  72                     ; 45 	TIM1->CR1 |= 0x01; // start the counter
  74  0018 72105250      	bset	21072,#0
  75                     ; 50 }
  78  001c 81            	ret
 112                     .const:	section	.text
 113  0000               L01:
 114  0000 000000c8      	dc.l	200
 115                     ; 52 @far @interrupt void tim1Elapsed (void)
 115                     ; 53 {
 116                     	scross	on
 117                     	switch	.text
 118  001d               f_tim1Elapsed:
 120  001d 8a            	push	cc
 121  001e 84            	pop	a
 122  001f a4bf          	and	a,#191
 123  0021 88            	push	a
 124  0022 86            	pop	cc
 125  0023 3b0002        	push	c_x+2
 126  0026 be00          	ldw	x,c_x
 127  0028 89            	pushw	x
 128  0029 3b0002        	push	c_y+2
 129  002c be00          	ldw	x,c_y
 130  002e 89            	pushw	x
 131  002f be02          	ldw	x,c_lreg+2
 132  0031 89            	pushw	x
 133  0032 be00          	ldw	x,c_lreg
 134  0034 89            	pushw	x
 137                     ; 54 	TIM1->SR1 &= ~(0x01); // clear the flag
 139  0035 72115255      	bres	21077,#0
 140                     ; 55 	totalTicks++; // @ 500 microsecond
 142  0039 ae0000        	ldw	x,#_totalTicks
 143  003c a601          	ld	a,#1
 144  003e cd0000        	call	c_lgadc
 146                     ; 57 	supportoDelayBloccante++;
 148  0041 ae0000        	ldw	x,#_supportoDelayBloccante
 149  0044 a601          	ld	a,#1
 150  0046 cd0000        	call	c_lgadc
 152                     ; 61 	if(totalTicks >= 200) // 1 secondo
 154  0049 ae0000        	ldw	x,#_totalTicks
 155  004c cd0000        	call	c_ltor
 157  004f ae0000        	ldw	x,#L01
 158  0052 cd0000        	call	c_lcmp
 160  0055 250e          	jrult	L13
 161                     ; 63 		totalTicks = 0;
 163  0057 ae0000        	ldw	x,#0
 164  005a bf02          	ldw	_totalTicks+2,x
 165  005c ae0000        	ldw	x,#0
 166  005f bf00          	ldw	_totalTicks,x
 167                     ; 64 		flagElapsed = 1;
 169  0061 35010000      	mov	_flagElapsed,#1
 170  0065               L13:
 171                     ; 68 	if(!debugToggle)
 173  0065 3d00          	tnz	_debugToggle
 174  0067 260a          	jrne	L33
 175                     ; 70 		debugToggle = 1;
 177  0069 35010000      	mov	_debugToggle,#1
 178                     ; 71 		GPIOC->ODR |= SENSOR1_TRIGGER_ON;
 180  006d 7216500a      	bset	20490,#3
 182  0071 2006          	jra	L53
 183  0073               L33:
 184                     ; 75 		debugToggle = 0;
 186  0073 3f00          	clr	_debugToggle
 187                     ; 76 		GPIOC->ODR &= ~SENSOR1_TRIGGER_ON;
 189  0075 7217500a      	bres	20490,#3
 190  0079               L53:
 191                     ; 78 	if(startCountPulses)
 193  0079 3d00          	tnz	_startCountPulses
 194  007b 2707          	jreq	L73
 195                     ; 80 		pulses++; // pulses è in base 500 microS
 197  007d be00          	ldw	x,_pulses
 198  007f 1c0001        	addw	x,#1
 199  0082 bf00          	ldw	_pulses,x
 200  0084               L73:
 201                     ; 84 			contatoreLunghezzaPressione++; //tiene il conto
 203  0084 be00          	ldw	x,_contatoreLunghezzaPressione
 204  0086 1c0001        	addw	x,#1
 205  0089 bf00          	ldw	_contatoreLunghezzaPressione,x
 206                     ; 86 	if(deviAspettare)
 208  008b 3d02          	tnz	_deviAspettare
 209  008d 2712          	jreq	L14
 210                     ; 88 		contatoreAttesa++;
 212  008f be02          	ldw	x,_contatoreAttesa
 213  0091 1c0001        	addw	x,#1
 214  0094 bf02          	ldw	_contatoreAttesa,x
 215                     ; 89 		if(contatoreAttesa >= quantoDeviAspettare)
 217  0096 be02          	ldw	x,_contatoreAttesa
 218  0098 b300          	cpw	x,_quantoDeviAspettare
 219  009a 2505          	jrult	L14
 220                     ; 91 			contatoreAttesa = 0;
 222  009c 5f            	clrw	x
 223  009d bf02          	ldw	_contatoreAttesa,x
 224                     ; 92 			deviAspettare = 0;
 226  009f 3f02          	clr	_deviAspettare
 227  00a1               L14:
 228                     ; 96 	gestisciBuzzerEVibrazione();
 230  00a1 cd0000        	call	_gestisciBuzzerEVibrazione
 232                     ; 100 }
 235  00a4 85            	popw	x
 236  00a5 bf00          	ldw	c_lreg,x
 237  00a7 85            	popw	x
 238  00a8 bf02          	ldw	c_lreg+2,x
 239  00aa 85            	popw	x
 240  00ab bf00          	ldw	c_y,x
 241  00ad 320002        	pop	c_y+2
 242  00b0 85            	popw	x
 243  00b1 bf00          	ldw	c_x,x
 244  00b3 320002        	pop	c_x+2
 245  00b6 80            	iret
 280                     ; 106 void aspetta(unsigned int count)
 280                     ; 107 {
 282                     	switch	.text
 283  00b7               _aspetta:
 287                     ; 108 	deviAspettare = 1;
 289  00b7 35010002      	mov	_deviAspettare,#1
 290                     ; 109 	quantoDeviAspettare = count; // un tick sono 100 micro
 292  00bb bf00          	ldw	_quantoDeviAspettare,x
 294  00bd               L76:
 295                     ; 111 	while(deviAspettare);
 297  00bd 3d02          	tnz	_deviAspettare
 298  00bf 26fc          	jrne	L76
 299                     ; 113 }
 302  00c1 81            	ret
 354                     	xref.b	_debugToggle
 355                     	xdef	_contatoreAttesa
 356                     	switch	.ubsct
 357  0000               _quantoDeviAspettare:
 358  0000 0000          	ds.b	2
 359                     	xdef	_quantoDeviAspettare
 360  0002               _deviAspettare:
 361  0002 00            	ds.b	1
 362                     	xdef	_deviAspettare
 363                     	xdef	_countDebug
 364                     	xref.b	_contatoreLunghezzaPressione
 365                     	xref.b	_supportoDelayBloccante
 366                     	xref.b	_flagElapsed
 367                     	xref.b	_totalTicks
 368                     	xref.b	_pulses
 369                     	xref.b	_startCountPulses
 370                     	xref	_gestisciBuzzerEVibrazione
 371                     	xdef	_aspetta
 372                     	xdef	f_tim1Elapsed
 373                     	xdef	_timInit
 374                     	xref.b	c_lreg
 375                     	xref.b	c_x
 376                     	xref.b	c_y
 396                     	xref	c_lcmp
 397                     	xref	c_ltor
 398                     	xref	c_lgadc
 399                     	end
