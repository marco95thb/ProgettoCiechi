   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  42                     ; 16 void gpioInit(void)
  42                     ; 17 {
  44                     	switch	.text
  45  0000               _gpioInit:
  49                     ; 18 	EXTI->CR1 |= (0x02 << 2) | (0x02 << 0); // PortA/B falling edge
  51  0000 c650a0        	ld	a,20640
  52  0003 aa0a          	or	a,#10
  53  0005 c750a0        	ld	20640,a
  54                     ; 20 	GPIOD->DDR = 0b00111000;
  56  0008 35385011      	mov	20497,#56
  57                     ; 21 	GPIOC->DDR = 0b01101000;
  59  000c 3568500c      	mov	20492,#104
  60                     ; 22 	GPIOB->DDR = 0b00000000;
  62  0010 725f5007      	clr	20487
  63                     ; 23 	GPIOA->DDR = 0b00000000;
  65  0014 725f5002      	clr	20482
  66                     ; 29 	GPIOD->CR1 = 0b00111000;
  68  0018 35385012      	mov	20498,#56
  69                     ; 30 	GPIOC->CR1 = 0b01110000;
  71  001c 3570500d      	mov	20493,#112
  72                     ; 31 	GPIOB->CR1 = 0b00000000;
  74  0020 725f5008      	clr	20488
  75                     ; 32 	GPIOA->CR1 = 0b00000000;
  77  0024 725f5003      	clr	20483
  78                     ; 35 	GPIOB->CR2 |= 0b00110000;
  80  0028 c65009        	ld	a,20489
  81  002b aa30          	or	a,#48
  82  002d c75009        	ld	20489,a
  83                     ; 37 	GPIOA->CR2 |= 0b00000010;
  85  0030 72125004      	bset	20484,#1
  86                     ; 38 }
  89  0034 81            	ret
 114                     ; 39 uint8_t gestionePulsante(void)
 114                     ; 40 {
 115                     	switch	.text
 116  0035               _gestionePulsante:
 120                     ; 41 			pulsante = (GPIOD->IDR >> 2) & 0x01; // PD2
 122  0035 c65010        	ld	a,20496
 123  0038 44            	srl	a
 124  0039 44            	srl	a
 125  003a a401          	and	a,#1
 126  003c b700          	ld	_pulsante,a
 127                     ; 42 		if(!pulsante)
 129  003e 3d00          	tnz	_pulsante
 130  0040 260f          	jrne	L13
 131                     ; 44 			if(countPulsante > 0)
 133  0042 be00          	ldw	x,_countPulsante
 134  0044 2709          	jreq	L33
 135                     ; 45 				countPulsante--;	
 137  0046 be00          	ldw	x,_countPulsante
 138  0048 1d0001        	subw	x,#1
 139  004b bf00          	ldw	_countPulsante,x
 141  004d 201a          	jra	L73
 142  004f               L33:
 143                     ; 47 				return 0;
 145  004f 4f            	clr	a
 148  0050 81            	ret
 149  0051               L13:
 150                     ; 51 			if(countPulsante < 0xFFFF) // evito overflow
 152  0051 be00          	ldw	x,_countPulsante
 153  0053 a3ffff        	cpw	x,#65535
 154  0056 2407          	jruge	L14
 155                     ; 52 				countPulsante++;
 157  0058 be00          	ldw	x,_countPulsante
 158  005a 1c0001        	addw	x,#1
 159  005d bf00          	ldw	_countPulsante,x
 160  005f               L14:
 161                     ; 53 			if(countPulsante >= 5) // numero a caso
 163  005f be00          	ldw	x,_countPulsante
 164  0061 a30005        	cpw	x,#5
 165  0064 2503          	jrult	L73
 166                     ; 55 				return 1;
 168  0066 a601          	ld	a,#1
 171  0068 81            	ret
 172  0069               L73:
 173                     ; 60 		return 2;
 175  0069 a602          	ld	a,#2
 178  006b 81            	ret
 206                     .const:	section	.text
 207  0000               L21:
 208  0000 000085fc      	dc.l	34300
 209                     ; 64 @far @interrupt void startStopTriggersPORTB(void)
 209                     ; 65 {
 210                     	scross	on
 211                     	switch	.text
 212  006c               f_startStopTriggersPORTB:
 214  006c be00          	ldw	x,c_x
 215  006e 89            	pushw	x
 216  006f be02          	ldw	x,c_lreg+2
 217  0071 89            	pushw	x
 218  0072 be00          	ldw	x,c_lreg
 219  0074 89            	pushw	x
 222                     ; 67 	if((GPIOB->IDR >> 5) & 0x01) // interrupt sul PB5 (echo 2)
 224  0075 c65006        	ld	a,20486
 225  0078 4e            	swap	a
 226  0079 44            	srl	a
 227  007a a407          	and	a,#7
 228  007c 5f            	clrw	x
 229  007d a401          	and	a,#1
 230  007f 5f            	clrw	x
 231  0080 5f            	clrw	x
 232  0081 97            	ld	xl,a
 233  0082 a30000        	cpw	x,#0
 234  0085 2732          	jreq	L55
 235                     ; 70 		if((startCountPulses) && 
 235                     ; 71 		(stateMachineSensor == START_MEASURE_2SENSOR))
 237  0087 3d00          	tnz	_startCountPulses
 238  0089 276f          	jreq	L16
 240  008b b600          	ld	a,_stateMachineSensor
 241  008d a103          	cp	a,#3
 242  008f 2669          	jrne	L16
 243                     ; 77 			distanze.d2 = (VEL_SUONO * pulses) >> 1; 
 245  0091 ae0000        	ldw	x,#_pulses
 246  0094 cd0000        	call	c_ltor
 248  0097 ae0000        	ldw	x,#L21
 249  009a cd0000        	call	c_lmul
 251  009d 3400          	srl	c_lreg
 252  009f 3601          	rrc	c_lreg+1
 253  00a1 3602          	rrc	c_lreg+2
 254  00a3 3603          	rrc	c_lreg+3
 255  00a5 be02          	ldw	x,c_lreg+2
 256  00a7 bf02          	ldw	_distanze+2,x
 257                     ; 78 			pulses = 0;
 259  00a9 ae0000        	ldw	x,#0
 260  00ac bf02          	ldw	_pulses+2,x
 261  00ae ae0000        	ldw	x,#0
 262  00b1 bf00          	ldw	_pulses,x
 263                     ; 79 			stateMachineSensor = END_MEASURE_2SENSOR; 
 265  00b3 35040000      	mov	_stateMachineSensor,#4
 266  00b7 2041          	jra	L16
 267  00b9               L55:
 268                     ; 82 	else if((GPIOB->IDR >> 4) & 0x01) // interrupt sul PB4 (echo3)
 270  00b9 c65006        	ld	a,20486
 271  00bc 4e            	swap	a
 272  00bd a40f          	and	a,#15
 273  00bf 5f            	clrw	x
 274  00c0 a401          	and	a,#1
 275  00c2 5f            	clrw	x
 276  00c3 5f            	clrw	x
 277  00c4 97            	ld	xl,a
 278  00c5 a30000        	cpw	x,#0
 279  00c8 2730          	jreq	L16
 280                     ; 84 		if((startCountPulses) && 
 280                     ; 85 			(stateMachineSensor == START_MEASURE_3SENSOR))
 282  00ca 3d00          	tnz	_startCountPulses
 283  00cc 272c          	jreq	L16
 285  00ce b600          	ld	a,_stateMachineSensor
 286  00d0 a105          	cp	a,#5
 287  00d2 2626          	jrne	L16
 288                     ; 87 			distanze.d3 = (VEL_SUONO * pulses) >> 1; 
 290  00d4 ae0000        	ldw	x,#_pulses
 291  00d7 cd0000        	call	c_ltor
 293  00da ae0000        	ldw	x,#L21
 294  00dd cd0000        	call	c_lmul
 296  00e0 3400          	srl	c_lreg
 297  00e2 3601          	rrc	c_lreg+1
 298  00e4 3602          	rrc	c_lreg+2
 299  00e6 3603          	rrc	c_lreg+3
 300  00e8 be02          	ldw	x,c_lreg+2
 301  00ea bf04          	ldw	_distanze+4,x
 302                     ; 88 			pulses = 0;
 304  00ec ae0000        	ldw	x,#0
 305  00ef bf02          	ldw	_pulses+2,x
 306  00f1 ae0000        	ldw	x,#0
 307  00f4 bf00          	ldw	_pulses,x
 308                     ; 89 			stateMachineSensor = END_MEASURE_3SENSOR;
 310  00f6 35060000      	mov	_stateMachineSensor,#6
 311  00fa               L16:
 312                     ; 93 }
 315  00fa 85            	popw	x
 316  00fb bf00          	ldw	c_lreg,x
 317  00fd 85            	popw	x
 318  00fe bf02          	ldw	c_lreg+2,x
 319  0100 85            	popw	x
 320  0101 bf00          	ldw	c_x,x
 321  0103 80            	iret
 348                     ; 94 @far @interrupt void startStopTriggersPORTA(void)
 348                     ; 95 {
 349                     	switch	.text
 350  0104               f_startStopTriggersPORTA:
 352  0104 be00          	ldw	x,c_x
 353  0106 89            	pushw	x
 354  0107 be02          	ldw	x,c_lreg+2
 355  0109 89            	pushw	x
 356  010a be00          	ldw	x,c_lreg
 357  010c 89            	pushw	x
 360                     ; 97 	if((GPIOA->IDR >> 1) & 0x01) // interrupt sul PA1 (echo 1)
 362  010d c65001        	ld	a,20481
 363  0110 44            	srl	a
 364  0111 5f            	clrw	x
 365  0112 a401          	and	a,#1
 366  0114 5f            	clrw	x
 367  0115 5f            	clrw	x
 368  0116 97            	ld	xl,a
 369  0117 a30000        	cpw	x,#0
 370  011a 2730          	jreq	L77
 371                     ; 99 		if((startCountPulses) && 
 371                     ; 100 			(stateMachineSensor == START_MEASURE_1SENSOR))
 373  011c 3d00          	tnz	_startCountPulses
 374  011e 272c          	jreq	L77
 376  0120 b600          	ld	a,_stateMachineSensor
 377  0122 a101          	cp	a,#1
 378  0124 2626          	jrne	L77
 379                     ; 103 			distanze.d1 = (VEL_SUONO * pulses) >> 1; 
 381  0126 ae0000        	ldw	x,#_pulses
 382  0129 cd0000        	call	c_ltor
 384  012c ae0000        	ldw	x,#L21
 385  012f cd0000        	call	c_lmul
 387  0132 3400          	srl	c_lreg
 388  0134 3601          	rrc	c_lreg+1
 389  0136 3602          	rrc	c_lreg+2
 390  0138 3603          	rrc	c_lreg+3
 391  013a be02          	ldw	x,c_lreg+2
 392  013c bf00          	ldw	_distanze,x
 393                     ; 104 			pulses = 0;
 395  013e ae0000        	ldw	x,#0
 396  0141 bf02          	ldw	_pulses+2,x
 397  0143 ae0000        	ldw	x,#0
 398  0146 bf00          	ldw	_pulses,x
 399                     ; 105 			stateMachineSensor = END_MEASURE_1SENSOR;
 401  0148 35020000      	mov	_stateMachineSensor,#2
 402  014c               L77:
 403                     ; 108 }
 406  014c 85            	popw	x
 407  014d bf00          	ldw	c_lreg,x
 408  014f 85            	popw	x
 409  0150 bf02          	ldw	c_lreg+2,x
 410  0152 85            	popw	x
 411  0153 bf00          	ldw	c_x,x
 412  0155 80            	iret
 434                     ; 109 uint8_t checkDecharge(void)
 434                     ; 110 {
 436                     	switch	.text
 437  0156               _checkDecharge:
 441                     ; 111 	return ~((GPIOD->IDR >> 6) & 0x01);
 443  0156 c65010        	ld	a,20496
 444  0159 4e            	swap	a
 445  015a 44            	srl	a
 446  015b 44            	srl	a
 447  015c a403          	and	a,#3
 448  015e a401          	and	a,#1
 449  0160 43            	cpl	a
 452  0161 81            	ret
 497                     ; 113 void segnalazioneSpegnimento(void)
 497                     ; 114 {
 498                     	switch	.text
 499  0162               _segnalazioneSpegnimento:
 501  0162 5204          	subw	sp,#4
 502       00000004      OFST:	set	4
 505                     ; 115 	volatile int blink = 3;
 507  0164 ae0003        	ldw	x,#3
 508  0167 1f01          	ldw	(OFST-3,sp),x
 510                     ; 116 	volatile int i = 0;
 512  0169 5f            	clrw	x
 513  016a 1f03          	ldw	(OFST-1,sp),x
 515                     ; 117 	for(i=0;i<blink;i++)
 517  016c 5f            	clrw	x
 518  016d 1f03          	ldw	(OFST-1,sp),x
 521  016f 2023          	jra	L141
 522  0171               L531:
 523                     ; 119 		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
 525  0171 c6500f        	ld	a,20495
 526  0174 aa30          	or	a,#48
 527  0176 c7500f        	ld	20495,a
 528                     ; 120 		aspetta(1000);
 530  0179 ae03e8        	ldw	x,#1000
 531  017c cd0000        	call	_aspetta
 533                     ; 121 		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
 535  017f c6500f        	ld	a,20495
 536  0182 a4cf          	and	a,#207
 537  0184 c7500f        	ld	20495,a
 538                     ; 122 		aspetta(1000);
 540  0187 ae03e8        	ldw	x,#1000
 541  018a cd0000        	call	_aspetta
 543                     ; 117 	for(i=0;i<blink;i++)
 545  018d 1e03          	ldw	x,(OFST-1,sp)
 546  018f 1c0001        	addw	x,#1
 547  0192 1f03          	ldw	(OFST-1,sp),x
 549  0194               L141:
 552  0194 9c            	rvf
 553  0195 1e03          	ldw	x,(OFST-1,sp)
 554  0197 1301          	cpw	x,(OFST-3,sp)
 555  0199 2fd6          	jrslt	L531
 556                     ; 125 }
 559  019b 5b04          	addw	sp,#4
 560  019d 81            	ret
 585                     ; 126 void segnalazioneAccensione(void)
 585                     ; 127 {
 586                     	switch	.text
 587  019e               _segnalazioneAccensione:
 591                     ; 128 		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
 593  019e c6500f        	ld	a,20495
 594  01a1 aa30          	or	a,#48
 595  01a3 c7500f        	ld	20495,a
 596                     ; 129 		aspetta(10000); // un sec
 598  01a6 ae2710        	ldw	x,#10000
 599  01a9 cd0000        	call	_aspetta
 601                     ; 130 		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
 603  01ac c6500f        	ld	a,20495
 604  01af a4cf          	and	a,#207
 605  01b1 c7500f        	ld	20495,a
 606                     ; 131 		aspetta(10000); // un sec
 608  01b4 ae2710        	ldw	x,#10000
 609  01b7 cd0000        	call	_aspetta
 611                     ; 133 }
 614  01ba 81            	ret
 627                     	xref.b	_distanze
 628                     	xref.b	_stateMachineSensor
 629                     	xref.b	_pulses
 630                     	xref.b	_startCountPulses
 631                     	xref.b	_countPulsante
 632                     	xref.b	_pulsante
 633                     	xref	_aspetta
 634                     	xdef	_segnalazioneAccensione
 635                     	xdef	_segnalazioneSpegnimento
 636                     	xdef	_checkDecharge
 637                     	xdef	f_startStopTriggersPORTA
 638                     	xdef	f_startStopTriggersPORTB
 639                     	xdef	_gestionePulsante
 640                     	xdef	_gpioInit
 641                     	xref.b	c_lreg
 642                     	xref.b	c_x
 661                     	xref	c_lmul
 662                     	xref	c_ltor
 663                     	end
