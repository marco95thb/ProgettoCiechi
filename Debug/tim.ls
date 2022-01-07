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
 110                     .const:	section	.text
 111  0000               L01:
 112  0000 000000c8      	dc.l	200
 113                     ; 52 @far @interrupt void tim1Elapsed (void)
 113                     ; 53 {
 114                     	scross	on
 115                     	switch	.text
 116  001d               f_tim1Elapsed:
 118  001d be02          	ldw	x,c_lreg+2
 119  001f 89            	pushw	x
 120  0020 be00          	ldw	x,c_lreg
 121  0022 89            	pushw	x
 124                     ; 54 	TIM1->SR1 &= ~(0x01); // clear the flag
 126  0023 72115255      	bres	21077,#0
 127                     ; 55 	totalTicks++; // @ 500 microsecond
 129  0027 ae0000        	ldw	x,#_totalTicks
 130  002a a601          	ld	a,#1
 131  002c cd0000        	call	c_lgadc
 133                     ; 57 	supportoDelayBloccante++;
 135  002f ae0000        	ldw	x,#_supportoDelayBloccante
 136  0032 a601          	ld	a,#1
 137  0034 cd0000        	call	c_lgadc
 139                     ; 61 	if(totalTicks >= 200) // in teoria dovrebbero essere 100ms
 141  0037 ae0000        	ldw	x,#_totalTicks
 142  003a cd0000        	call	c_ltor
 144  003d ae0000        	ldw	x,#L01
 145  0040 cd0000        	call	c_lcmp
 147  0043 250e          	jrult	L13
 148                     ; 63 		totalTicks = 0;
 150  0045 ae0000        	ldw	x,#0
 151  0048 bf02          	ldw	_totalTicks+2,x
 152  004a ae0000        	ldw	x,#0
 153  004d bf00          	ldw	_totalTicks,x
 154                     ; 64 		flagElapsed = 1;
 156  004f 35010000      	mov	_flagElapsed,#1
 157  0053               L13:
 158                     ; 69 	if(startCountPulses)
 160  0053 3d00          	tnz	_startCountPulses
 161  0055 2707          	jreq	L33
 162                     ; 71 		pulses++; // pulses è in base 500 microS
 164  0057 be00          	ldw	x,_pulses
 165  0059 1c0001        	addw	x,#1
 166  005c bf00          	ldw	_pulses,x
 167  005e               L33:
 168                     ; 75 			contatoreLunghezzaPressione++; //tiene il conto
 170  005e be00          	ldw	x,_contatoreLunghezzaPressione
 171  0060 1c0001        	addw	x,#1
 172  0063 bf00          	ldw	_contatoreLunghezzaPressione,x
 173                     ; 77 	if(deviAspettare)
 175  0065 3d02          	tnz	_deviAspettare
 176  0067 2712          	jreq	L53
 177                     ; 79 		contatoreAttesa++;
 179  0069 be02          	ldw	x,_contatoreAttesa
 180  006b 1c0001        	addw	x,#1
 181  006e bf02          	ldw	_contatoreAttesa,x
 182                     ; 80 		if(contatoreAttesa >= quantoDeviAspettare)
 184  0070 be02          	ldw	x,_contatoreAttesa
 185  0072 b300          	cpw	x,_quantoDeviAspettare
 186  0074 2505          	jrult	L53
 187                     ; 82 			contatoreAttesa = 0;
 189  0076 5f            	clrw	x
 190  0077 bf02          	ldw	_contatoreAttesa,x
 191                     ; 83 			deviAspettare = 0;
 193  0079 3f02          	clr	_deviAspettare
 194  007b               L53:
 195                     ; 91 }
 198  007b 85            	popw	x
 199  007c bf00          	ldw	c_lreg,x
 200  007e 85            	popw	x
 201  007f bf02          	ldw	c_lreg+2,x
 202  0081 80            	iret
 237                     ; 97 void aspetta(unsigned int count)
 237                     ; 98 {
 239                     	switch	.text
 240  0082               _aspetta:
 244                     ; 99 	deviAspettare = 1;
 246  0082 35010002      	mov	_deviAspettare,#1
 247                     ; 100 	quantoDeviAspettare = count; // un tick sono 100 micro
 249  0086 bf00          	ldw	_quantoDeviAspettare,x
 251  0088               L36:
 252                     ; 102 	while(deviAspettare);
 254  0088 3d02          	tnz	_deviAspettare
 255  008a 26fc          	jrne	L36
 256                     ; 104 }
 259  008c 81            	ret
 311                     	xdef	_contatoreAttesa
 312                     	switch	.ubsct
 313  0000               _quantoDeviAspettare:
 314  0000 0000          	ds.b	2
 315                     	xdef	_quantoDeviAspettare
 316  0002               _deviAspettare:
 317  0002 00            	ds.b	1
 318                     	xdef	_deviAspettare
 319                     	xdef	_countDebug
 320                     	xref.b	_contatoreLunghezzaPressione
 321                     	xref.b	_supportoDelayBloccante
 322                     	xref.b	_flagElapsed
 323                     	xref.b	_totalTicks
 324                     	xref.b	_pulses
 325                     	xref.b	_startCountPulses
 326                     	xdef	_aspetta
 327                     	xdef	f_tim1Elapsed
 328                     	xdef	_timInit
 329                     	xref.b	c_lreg
 349                     	xref	c_lcmp
 350                     	xref	c_ltor
 351                     	xref	c_lgadc
 352                     	end
