   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  14                     	bsct
  15  0000               _debugToggle:
  16  0000 00            	dc.b	0
  45                     ; 34 void gpioInit(void)
  45                     ; 35 {
  47                     	switch	.text
  48  0000               _gpioInit:
  52                     ; 38 	GPIOD->DDR = 0b00111000;
  54  0000 35385011      	mov	20497,#56
  55                     ; 39 	GPIOC->DDR = 0b01101000;
  57  0004 3568500c      	mov	20492,#104
  58                     ; 40 	GPIOB->DDR = 0b00000000;
  60  0008 725f5007      	clr	20487
  61                     ; 41 	GPIOA->DDR = 0b00000000;
  63  000c 725f5002      	clr	20482
  64                     ; 47 	GPIOD->CR1 = 0b00111000;
  66  0010 35385012      	mov	20498,#56
  67                     ; 48 	GPIOC->CR1 = 0b01101000;
  69  0014 3568500d      	mov	20493,#104
  70                     ; 49 	GPIOB->CR1 = 0b00000000;
  72  0018 725f5008      	clr	20488
  73                     ; 50 	GPIOA->CR1 = 0b00000000;
  75  001c 725f5003      	clr	20483
  76                     ; 53 	GPIOB->CR2 |= 0b00110000;
  78  0020 c65009        	ld	a,20489
  79  0023 aa30          	or	a,#48
  80  0025 c75009        	ld	20489,a
  81                     ; 55 	GPIOA->CR2 |= 0b00001000;
  83  0028 72165004      	bset	20484,#3
  84                     ; 57 	GPIOC->CR2 |= 0b01101000;
  86  002c c6500e        	ld	a,20494
  87  002f aa68          	or	a,#104
  88  0031 c7500e        	ld	20494,a
  89                     ; 58 	EXTI->CR1 |= (0x02 << 2) | (0x02 << 0); // PortA/B falling edge
  91  0034 c650a0        	ld	a,20640
  92  0037 aa0a          	or	a,#10
  93  0039 c750a0        	ld	20640,a
  94                     ; 59 }
  97  003c 81            	ret
 122                     ; 60 uint8_t gestionePulsante(void)
 122                     ; 61 {
 123                     	switch	.text
 124  003d               _gestionePulsante:
 128                     ; 62 			pulsante = (GPIOD->IDR >> 2) & 0x01; // PD2
 130  003d c65010        	ld	a,20496
 131  0040 44            	srl	a
 132  0041 44            	srl	a
 133  0042 a401          	and	a,#1
 134  0044 b700          	ld	_pulsante,a
 135                     ; 63 		if(!pulsante)
 137  0046 3d00          	tnz	_pulsante
 138  0048 260f          	jrne	L13
 139                     ; 65 			if(countPulsante > 0)
 141  004a be00          	ldw	x,_countPulsante
 142  004c 2709          	jreq	L33
 143                     ; 66 				countPulsante--;	
 145  004e be00          	ldw	x,_countPulsante
 146  0050 1d0001        	subw	x,#1
 147  0053 bf00          	ldw	_countPulsante,x
 149  0055 201a          	jra	L73
 150  0057               L33:
 151                     ; 68 				return 0;
 153  0057 4f            	clr	a
 156  0058 81            	ret
 157  0059               L13:
 158                     ; 72 			if(countPulsante < 0xFFFF) // evito overflow
 160  0059 be00          	ldw	x,_countPulsante
 161  005b a3ffff        	cpw	x,#65535
 162  005e 2407          	jruge	L14
 163                     ; 73 				countPulsante++;
 165  0060 be00          	ldw	x,_countPulsante
 166  0062 1c0001        	addw	x,#1
 167  0065 bf00          	ldw	_countPulsante,x
 168  0067               L14:
 169                     ; 74 			if(countPulsante >= 5) // numero a caso
 171  0067 be00          	ldw	x,_countPulsante
 172  0069 a30005        	cpw	x,#5
 173  006c 2503          	jrult	L73
 174                     ; 76 				return 1;
 176  006e a601          	ld	a,#1
 179  0070 81            	ret
 180  0071               L73:
 181                     ; 81 		return 2;
 183  0071 a602          	ld	a,#2
 186  0073 81            	ret
 214                     ; 85 @far @interrupt void startStopTriggersPORTB(void)
 214                     ; 86 {
 216                     	switch	.text
 217  0074               f_startStopTriggersPORTB:
 221                     ; 88 	if(((GPIOB->IDR >> 5) & 0x01) == 0x00) // interrupt sul PB5 (echo 2)
 223  0074 c65006        	ld	a,20486
 224  0077 4e            	swap	a
 225  0078 44            	srl	a
 226  0079 a407          	and	a,#7
 227  007b 5f            	clrw	x
 228  007c a401          	and	a,#1
 229  007e 5f            	clrw	x
 230  007f 5f            	clrw	x
 231  0080 97            	ld	xl,a
 232  0081 a30000        	cpw	x,#0
 233  0084 2614          	jrne	L55
 234                     ; 91 		if((startCountPulses) && 
 234                     ; 92 		(stateMachineSensor == START_MEASURE_2SENSOR))
 236  0086 3d00          	tnz	_startCountPulses
 237  0088 2710          	jreq	L55
 239  008a b600          	ld	a,_stateMachineSensor
 240  008c a103          	cp	a,#3
 241  008e 260a          	jrne	L55
 242                     ; 94 			startCountPulses = 0;
 244  0090 3f00          	clr	_startCountPulses
 245                     ; 99 			distanze.d2 = pulses; 
 247  0092 be00          	ldw	x,_pulses
 248  0094 bf02          	ldw	_distanze+2,x
 249                     ; 100 			stateMachineSensor = END_MEASURE_2SENSOR;
 251  0096 35040000      	mov	_stateMachineSensor,#4
 252  009a               L55:
 253                     ; 112 	if(((GPIOB->IDR >> 4) & 0x01) == 0x00) // interrupt sul PB4 (echo3)
 255  009a c65006        	ld	a,20486
 256  009d 4e            	swap	a
 257  009e a40f          	and	a,#15
 258  00a0 5f            	clrw	x
 259  00a1 a401          	and	a,#1
 260  00a3 5f            	clrw	x
 261  00a4 5f            	clrw	x
 262  00a5 97            	ld	xl,a
 263  00a6 a30000        	cpw	x,#0
 264  00a9 2614          	jrne	L16
 265                     ; 114 		if((startCountPulses) && 
 265                     ; 115 			(stateMachineSensor == START_MEASURE_3SENSOR))
 267  00ab 3d00          	tnz	_startCountPulses
 268  00ad 2710          	jreq	L16
 270  00af b600          	ld	a,_stateMachineSensor
 271  00b1 a105          	cp	a,#5
 272  00b3 260a          	jrne	L16
 273                     ; 117 			stateMachineSensor = END_MEASURE_3SENSOR;
 275  00b5 35060000      	mov	_stateMachineSensor,#6
 276                     ; 118 			distanze.d3 = pulses; 
 278  00b9 be00          	ldw	x,_pulses
 279  00bb bf04          	ldw	_distanze+4,x
 280                     ; 119 			startCountPulses = 0;
 282  00bd 3f00          	clr	_startCountPulses
 283  00bf               L16:
 284                     ; 124 }
 287  00bf 80            	iret
 314                     ; 126 @far @interrupt void startStopTriggersPORTA(void) // sembra che non ci vada
 314                     ; 127 {
 315                     	switch	.text
 316  00c0               f_startStopTriggersPORTA:
 320                     ; 130 	if(((GPIOA->IDR >> 3) & 0x01) == 0x00) // interrupt sul PA3 (echo 1)
 322  00c0 c65001        	ld	a,20481
 323  00c3 44            	srl	a
 324  00c4 44            	srl	a
 325  00c5 44            	srl	a
 326  00c6 5f            	clrw	x
 327  00c7 a401          	and	a,#1
 328  00c9 5f            	clrw	x
 329  00ca 5f            	clrw	x
 330  00cb 97            	ld	xl,a
 331  00cc a30000        	cpw	x,#0
 332  00cf 2614          	jrne	L57
 333                     ; 133 		if((startCountPulses) && 
 333                     ; 134 			(stateMachineSensor == START_MEASURE_1SENSOR))
 335  00d1 3d00          	tnz	_startCountPulses
 336  00d3 2710          	jreq	L57
 338  00d5 b600          	ld	a,_stateMachineSensor
 339  00d7 a101          	cp	a,#1
 340  00d9 260a          	jrne	L57
 341                     ; 137 		stateMachineSensor = END_MEASURE_1SENSOR;
 343  00db 35020000      	mov	_stateMachineSensor,#2
 344                     ; 138 			distanze.d1 = pulses; 
 346  00df be00          	ldw	x,_pulses
 347  00e1 bf00          	ldw	_distanze,x
 348                     ; 139 			startCountPulses = 0;
 350  00e3 3f00          	clr	_startCountPulses
 351  00e5               L57:
 352                     ; 146 }
 355  00e5 80            	iret
 377                     ; 147 uint8_t checkDecharge(void)
 377                     ; 148 {
 379                     	switch	.text
 380  00e6               _checkDecharge:
 384                     ; 149 	return ~((GPIOD->IDR >> 6) & 0x01);
 386  00e6 c65010        	ld	a,20496
 387  00e9 4e            	swap	a
 388  00ea 44            	srl	a
 389  00eb 44            	srl	a
 390  00ec a403          	and	a,#3
 391  00ee a401          	and	a,#1
 392  00f0 43            	cpl	a
 395  00f1 81            	ret
 440                     ; 151 void segnalazioneSpegnimento(void)
 440                     ; 152 {
 441                     	switch	.text
 442  00f2               _segnalazioneSpegnimento:
 444  00f2 5204          	subw	sp,#4
 445       00000004      OFST:	set	4
 448                     ; 153 	volatile int blink = 3;
 450  00f4 ae0003        	ldw	x,#3
 451  00f7 1f01          	ldw	(OFST-3,sp),x
 453                     ; 154 	volatile int i = 0;
 455  00f9 5f            	clrw	x
 456  00fa 1f03          	ldw	(OFST-1,sp),x
 458                     ; 155 	for(i=0;i<blink;i++)
 460  00fc 5f            	clrw	x
 461  00fd 1f03          	ldw	(OFST-1,sp),x
 464  00ff 201b          	jra	L731
 465  0101               L331:
 466                     ; 157 		GPIOD->ODR |= BUZZER_ON;
 468  0101 7218500f      	bset	20495,#4
 469                     ; 158 		aspetta(200);
 471  0105 ae00c8        	ldw	x,#200
 472  0108 cd0000        	call	_aspetta
 474                     ; 159 		GPIOD->ODR &= ~BUZZER_ON;
 476  010b 7219500f      	bres	20495,#4
 477                     ; 160 		aspetta(200);
 479  010f ae00c8        	ldw	x,#200
 480  0112 cd0000        	call	_aspetta
 482                     ; 155 	for(i=0;i<blink;i++)
 484  0115 1e03          	ldw	x,(OFST-1,sp)
 485  0117 1c0001        	addw	x,#1
 486  011a 1f03          	ldw	(OFST-1,sp),x
 488  011c               L731:
 491  011c 9c            	rvf
 492  011d 1e03          	ldw	x,(OFST-1,sp)
 493  011f 1301          	cpw	x,(OFST-3,sp)
 494  0121 2fde          	jrslt	L331
 495                     ; 163 }
 498  0123 5b04          	addw	sp,#4
 499  0125 81            	ret
 524                     ; 164 void segnalazioneAccensione(void)
 524                     ; 165 {
 525                     	switch	.text
 526  0126               _segnalazioneAccensione:
 530                     ; 166 		GPIOD->ODR |= BUZZER_ON;
 532  0126 7218500f      	bset	20495,#4
 533                     ; 167 		aspetta(800); 
 535  012a ae0320        	ldw	x,#800
 536  012d cd0000        	call	_aspetta
 538                     ; 168 		GPIOD->ODR &= ~BUZZER_ON;
 540  0130 7219500f      	bres	20495,#4
 541                     ; 169 		aspetta(800); 
 543  0134 ae0320        	ldw	x,#800
 544  0137 cd0000        	call	_aspetta
 546                     ; 171 }
 549  013a 81            	ret
 594                     ; 172 void segnalazioneInizioCarica(void)
 594                     ; 173 {
 595                     	switch	.text
 596  013b               _segnalazioneInizioCarica:
 598  013b 5204          	subw	sp,#4
 599       00000004      OFST:	set	4
 602                     ; 174 	volatile int blink = 4;
 604  013d ae0004        	ldw	x,#4
 605  0140 1f01          	ldw	(OFST-3,sp),x
 607                     ; 175 	volatile int i = 0;
 609  0142 5f            	clrw	x
 610  0143 1f03          	ldw	(OFST-1,sp),x
 612                     ; 176 	for(i=0;i<blink;i++)
 614  0145 5f            	clrw	x
 615  0146 1f03          	ldw	(OFST-1,sp),x
 618  0148 201b          	jra	L102
 619  014a               L571:
 620                     ; 178 		GPIOD->ODR |= BUZZER_ON;
 622  014a 7218500f      	bset	20495,#4
 623                     ; 179 		aspetta(300);
 625  014e ae012c        	ldw	x,#300
 626  0151 cd0000        	call	_aspetta
 628                     ; 180 		GPIOD->ODR &= ~BUZZER_ON;
 630  0154 7219500f      	bres	20495,#4
 631                     ; 181 		aspetta(300);
 633  0158 ae012c        	ldw	x,#300
 634  015b cd0000        	call	_aspetta
 636                     ; 176 	for(i=0;i<blink;i++)
 638  015e 1e03          	ldw	x,(OFST-1,sp)
 639  0160 1c0001        	addw	x,#1
 640  0163 1f03          	ldw	(OFST-1,sp),x
 642  0165               L102:
 645  0165 9c            	rvf
 646  0166 1e03          	ldw	x,(OFST-1,sp)
 647  0168 1301          	cpw	x,(OFST-3,sp)
 648  016a 2fde          	jrslt	L571
 649                     ; 185 }
 652  016c 5b04          	addw	sp,#4
 653  016e 81            	ret
 698                     ; 187 void segnalazioneFineCarica(void)
 698                     ; 188 {
 699                     	switch	.text
 700  016f               _segnalazioneFineCarica:
 702  016f 5204          	subw	sp,#4
 703       00000004      OFST:	set	4
 706                     ; 189 	volatile int blink = 3;
 708  0171 ae0003        	ldw	x,#3
 709  0174 1f01          	ldw	(OFST-3,sp),x
 711                     ; 190 	volatile int i = 0;
 713  0176 5f            	clrw	x
 714  0177 1f03          	ldw	(OFST-1,sp),x
 716                     ; 191 	for(i=0;i<blink;i++)
 718  0179 5f            	clrw	x
 719  017a 1f03          	ldw	(OFST-1,sp),x
 722  017c 201b          	jra	L332
 723  017e               L722:
 724                     ; 193 		GPIOD->ODR |= BUZZER_ON;
 726  017e 7218500f      	bset	20495,#4
 727                     ; 194 		aspetta(500);
 729  0182 ae01f4        	ldw	x,#500
 730  0185 cd0000        	call	_aspetta
 732                     ; 195 		GPIOD->ODR &= ~BUZZER_ON;
 734  0188 7219500f      	bres	20495,#4
 735                     ; 196 		aspetta(500);
 737  018c ae01f4        	ldw	x,#500
 738  018f cd0000        	call	_aspetta
 740                     ; 191 	for(i=0;i<blink;i++)
 742  0192 1e03          	ldw	x,(OFST-1,sp)
 743  0194 1c0001        	addw	x,#1
 744  0197 1f03          	ldw	(OFST-1,sp),x
 746  0199               L332:
 749  0199 9c            	rvf
 750  019a 1e03          	ldw	x,(OFST-1,sp)
 751  019c 1301          	cpw	x,(OFST-3,sp)
 752  019e 2fde          	jrslt	L722
 753                     ; 199 }
 756  01a0 5b04          	addw	sp,#4
 757  01a2 81            	ret
 802                     ; 200 void segnalazioneBatteriaScarica(void)
 802                     ; 201 {
 803                     	switch	.text
 804  01a3               _segnalazioneBatteriaScarica:
 806  01a3 5204          	subw	sp,#4
 807       00000004      OFST:	set	4
 810                     ; 202 	volatile int blink = 5;
 812  01a5 ae0005        	ldw	x,#5
 813  01a8 1f01          	ldw	(OFST-3,sp),x
 815                     ; 203 	volatile int i = 0;
 817  01aa 5f            	clrw	x
 818  01ab 1f03          	ldw	(OFST-1,sp),x
 820                     ; 204 	for(i=0;i<blink;i++)
 822  01ad 5f            	clrw	x
 823  01ae 1f03          	ldw	(OFST-1,sp),x
 826  01b0 201b          	jra	L562
 827  01b2               L162:
 828                     ; 206 		GPIOD->ODR |= BUZZER_ON;
 830  01b2 7218500f      	bset	20495,#4
 831                     ; 207 		aspetta(500);
 833  01b6 ae01f4        	ldw	x,#500
 834  01b9 cd0000        	call	_aspetta
 836                     ; 208 		GPIOD->ODR &= ~BUZZER_ON;
 838  01bc 7219500f      	bres	20495,#4
 839                     ; 209 		aspetta(500);
 841  01c0 ae01f4        	ldw	x,#500
 842  01c3 cd0000        	call	_aspetta
 844                     ; 204 	for(i=0;i<blink;i++)
 846  01c6 1e03          	ldw	x,(OFST-1,sp)
 847  01c8 1c0001        	addw	x,#1
 848  01cb 1f03          	ldw	(OFST-1,sp),x
 850  01cd               L562:
 853  01cd 9c            	rvf
 854  01ce 1e03          	ldw	x,(OFST-1,sp)
 855  01d0 1301          	cpw	x,(OFST-3,sp)
 856  01d2 2fde          	jrslt	L162
 857                     ; 211 }
 860  01d4 5b04          	addw	sp,#4
 861  01d6 81            	ret
 887                     ; 212 void debounceInizioCarica(void)
 887                     ; 213 {
 888                     	switch	.text
 889  01d7               _debounceInizioCarica:
 893                     ; 214 	if((GPIOC->IDR >> 7) & 0x01) // inizio carica
 895  01d7 c6500b        	ld	a,20491
 896  01da 49            	rlc	a
 897  01db 4f            	clr	a
 898  01dc 49            	rlc	a
 899  01dd 5f            	clrw	x
 900  01de 97            	ld	xl,a
 901  01df a30000        	cpw	x,#0
 902  01e2 2710          	jreq	L103
 903                     ; 216 				if(countInputIC < 3)
 905  01e4 b600          	ld	a,_countInputIC
 906  01e6 a103          	cp	a,#3
 907  01e8 2404          	jruge	L303
 908                     ; 217 					countInputIC++;
 910  01ea 3c00          	inc	_countInputIC
 912  01ec 2010          	jra	L703
 913  01ee               L303:
 914                     ; 219 					inizioCarica = 1;
 916  01ee 35010000      	mov	_inizioCarica,#1
 917  01f2 200a          	jra	L703
 918  01f4               L103:
 919                     ; 225 				if(countInputIC > 0)
 921  01f4 3d00          	tnz	_countInputIC
 922  01f6 2704          	jreq	L113
 923                     ; 226 					countInputIC--;
 925  01f8 3a00          	dec	_countInputIC
 927  01fa 2002          	jra	L703
 928  01fc               L113:
 929                     ; 228 					inizioCarica = 0;
 931  01fc 3f00          	clr	_inizioCarica
 932  01fe               L703:
 933                     ; 230 }
 936  01fe 81            	ret
 962                     ; 231 void debounceFineCarica(void)
 962                     ; 232 {
 963                     	switch	.text
 964  01ff               _debounceFineCarica:
 968                     ; 233 	if(!((GPIOA->IDR >> 1) & 0x01)) // fine carica
 970  01ff c65001        	ld	a,20481
 971  0202 44            	srl	a
 972  0203 5f            	clrw	x
 973  0204 a401          	and	a,#1
 974  0206 5f            	clrw	x
 975  0207 5f            	clrw	x
 976  0208 97            	ld	xl,a
 977  0209 a30000        	cpw	x,#0
 978  020c 2613          	jrne	L523
 979                     ; 235 				if(countInputFC < 3)
 981  020e b600          	ld	a,_countInputFC
 982  0210 a103          	cp	a,#3
 983  0212 2404          	jruge	L723
 984                     ; 236 					countInputFC++;
 986  0214 3c00          	inc	_countInputFC
 988  0216 2016          	jra	L333
 989  0218               L723:
 990                     ; 238 					fineCarica_prec = fineCarica;
 992  0218 450000        	mov	_fineCarica_prec,_fineCarica
 993                     ; 239 					fineCarica = 1;
 995  021b 35010000      	mov	_fineCarica,#1
 996  021f 200d          	jra	L333
 997  0221               L523:
 998                     ; 245 				if(countInputFC > 0)
1000  0221 3d00          	tnz	_countInputFC
1001  0223 2704          	jreq	L533
1002                     ; 246 					countInputFC--;
1004  0225 3a00          	dec	_countInputFC
1006  0227 2005          	jra	L333
1007  0229               L533:
1008                     ; 249 					fineCarica_prec = fineCarica;
1010  0229 450000        	mov	_fineCarica_prec,_fineCarica
1011                     ; 250 					fineCarica = 0;
1013  022c 3f00          	clr	_fineCarica
1014  022e               L333:
1015                     ; 253 }
1018  022e 81            	ret
1045                     ; 254 void debounceBatteriaScarica(void)
1045                     ; 255 {
1046                     	switch	.text
1047  022f               _debounceBatteriaScarica:
1051                     ; 256 	if(((GPIOD->IDR >> 6) & 0x01) == 0)// batteria scarica
1053  022f c65010        	ld	a,20496
1054  0232 4e            	swap	a
1055  0233 44            	srl	a
1056  0234 44            	srl	a
1057  0235 a403          	and	a,#3
1058  0237 5f            	clrw	x
1059  0238 a401          	and	a,#1
1060  023a 5f            	clrw	x
1061  023b 5f            	clrw	x
1062  023c 97            	ld	xl,a
1063  023d a30000        	cpw	x,#0
1064  0240 2613          	jrne	L153
1065                     ; 258 				if(countInputBS < 3)
1067  0242 b600          	ld	a,_countInputBS
1068  0244 a103          	cp	a,#3
1069  0246 2404          	jruge	L353
1070                     ; 259 					countInputBS++;
1072  0248 3c00          	inc	_countInputBS
1074  024a 2016          	jra	L753
1075  024c               L353:
1076                     ; 261 					flagBatteriaScarica_prec = flagBatteriaScarica;
1078  024c 450000        	mov	_flagBatteriaScarica_prec,_flagBatteriaScarica
1079                     ; 262 					flagBatteriaScarica = 1;
1081  024f 35010000      	mov	_flagBatteriaScarica,#1
1082  0253 200d          	jra	L753
1083  0255               L153:
1084                     ; 268 				if(countInputBS > 0)
1086  0255 3d00          	tnz	_countInputBS
1087  0257 2704          	jreq	L163
1088                     ; 269 					countInputBS--;
1090  0259 3a00          	dec	_countInputBS
1092  025b 2005          	jra	L753
1093  025d               L163:
1094                     ; 272 					flagBatteriaScarica_prec = flagBatteriaScarica;
1096  025d 450000        	mov	_flagBatteriaScarica_prec,_flagBatteriaScarica
1097                     ; 273 					flagBatteriaScarica = 0;
1099  0260 3f00          	clr	_flagBatteriaScarica
1100  0262               L753:
1101                     ; 276 }
1104  0262 81            	ret
1129                     ; 277 void debounceTasto(void)
1129                     ; 278 {
1130                     	switch	.text
1131  0263               _debounceTasto:
1135                     ; 279 	if((GPIOD->IDR >> 2) & 0x01)
1137  0263 c65010        	ld	a,20496
1138  0266 44            	srl	a
1139  0267 44            	srl	a
1140  0268 5f            	clrw	x
1141  0269 a401          	and	a,#1
1142  026b 5f            	clrw	x
1143  026c 5f            	clrw	x
1144  026d 97            	ld	xl,a
1145  026e a30000        	cpw	x,#0
1146  0271 2710          	jreq	L573
1147                     ; 283 				if(countInputB < 3)
1149  0273 b600          	ld	a,_countInputB
1150  0275 a103          	cp	a,#3
1151  0277 2404          	jruge	L773
1152                     ; 284 					countInputB++;
1154  0279 3c00          	inc	_countInputB
1156  027b 2010          	jra	L304
1157  027d               L773:
1158                     ; 286 					statoPulsante = 1;
1160  027d 35010000      	mov	_statoPulsante,#1
1161  0281 200a          	jra	L304
1162  0283               L573:
1163                     ; 294 				if(countInputB > 0)
1165  0283 3d00          	tnz	_countInputB
1166  0285 2704          	jreq	L504
1167                     ; 295 					countInputB--;
1169  0287 3a00          	dec	_countInputB
1171  0289 2002          	jra	L304
1172  028b               L504:
1173                     ; 298 					statoPulsante = 0;
1175  028b 3f00          	clr	_statoPulsante
1176  028d               L304:
1177                     ; 302 }
1180  028d 81            	ret
1205                     ; 303 void gestisciBuzzerEVibrazione(void)
1205                     ; 304 {
1206                     	switch	.text
1207  028e               _gestisciBuzzerEVibrazione:
1211                     ; 305 	if(buzzer.distanceMonitoring.enabled)
1213  028e 3d21          	tnz	_buzzer+33
1214  0290 2736          	jreq	L124
1215                     ; 308 			buzzer.distanceMonitoring.counterDurata++;
1217  0292 be28          	ldw	x,_buzzer+40
1218  0294 1c0001        	addw	x,#1
1219  0297 bf28          	ldw	_buzzer+40,x
1220                     ; 309 		buzzer.distanceMonitoring.counter++;
1222  0299 be26          	ldw	x,_buzzer+38
1223  029b 1c0001        	addw	x,#1
1224  029e bf26          	ldw	_buzzer+38,x
1225                     ; 310 		if(buzzer.drive)
1227  02a0 3d2d          	tnz	_buzzer+45
1228  02a2 2711          	jreq	L324
1229                     ; 313 			if(buzzer.distanceMonitoring.counter >= buzzer.distanceMonitoring.countHigh)
1231  02a4 be26          	ldw	x,_buzzer+38
1232  02a6 b322          	cpw	x,_buzzer+34
1233  02a8 2522          	jrult	L334
1234                     ; 316 				GPIOD->ODR &= ~BUZZER_ON;
1236  02aa 7219500f      	bres	20495,#4
1237                     ; 317 				buzzer.distanceMonitoring.counter = 0;
1239  02ae 5f            	clrw	x
1240  02af bf26          	ldw	_buzzer+38,x
1241                     ; 318 				buzzer.drive = 0;
1243  02b1 3f2d          	clr	_buzzer+45
1244  02b3 2017          	jra	L334
1245  02b5               L324:
1246                     ; 325 			if(buzzer.distanceMonitoring.counter >= buzzer.distanceMonitoring.countLow)
1248  02b5 be26          	ldw	x,_buzzer+38
1249  02b7 b324          	cpw	x,_buzzer+36
1250  02b9 2511          	jrult	L334
1251                     ; 328 				GPIOD->ODR |= BUZZER_ON;
1253  02bb 7218500f      	bset	20495,#4
1254                     ; 329 				buzzer.distanceMonitoring.counter = 0;
1256  02bf 5f            	clrw	x
1257  02c0 bf26          	ldw	_buzzer+38,x
1258                     ; 330 				buzzer.drive = 1;
1260  02c2 3501002d      	mov	_buzzer+45,#1
1261  02c6 2004          	jra	L334
1262  02c8               L124:
1263                     ; 340 		GPIOD->ODR &= ~BUZZER_ON;
1265  02c8 7219500f      	bres	20495,#4
1266  02cc               L334:
1267                     ; 343 }
1270  02cc 81            	ret
1333                     ; 344 void segnalazioneOstacolo(int counter,int type,int blink)
1333                     ; 345 {
1334                     	switch	.text
1335  02cd               _segnalazioneOstacolo:
1337  02cd 89            	pushw	x
1338  02ce 89            	pushw	x
1339       00000002      OFST:	set	2
1342                     ; 346 	volatile int i = 0;
1344  02cf 5f            	clrw	x
1345  02d0 1f01          	ldw	(OFST-1,sp),x
1347                     ; 347 	if(type)
1349  02d2 1e07          	ldw	x,(OFST+5,sp)
1350  02d4 272f          	jreq	L764
1351                     ; 349 		for(i=0;i<blink;i++)
1353  02d6 5f            	clrw	x
1354  02d7 1f01          	ldw	(OFST-1,sp),x
1357  02d9 2021          	jra	L574
1358  02db               L174:
1359                     ; 351 		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
1361  02db c6500f        	ld	a,20495
1362  02de aa30          	or	a,#48
1363  02e0 c7500f        	ld	20495,a
1364                     ; 352 		aspetta(counter);
1366  02e3 1e03          	ldw	x,(OFST+1,sp)
1367  02e5 cd0000        	call	_aspetta
1369                     ; 353 		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
1371  02e8 c6500f        	ld	a,20495
1372  02eb a4cf          	and	a,#207
1373  02ed c7500f        	ld	20495,a
1374                     ; 354 		aspetta(counter);
1376  02f0 1e03          	ldw	x,(OFST+1,sp)
1377  02f2 cd0000        	call	_aspetta
1379                     ; 349 		for(i=0;i<blink;i++)
1381  02f5 1e01          	ldw	x,(OFST-1,sp)
1382  02f7 1c0001        	addw	x,#1
1383  02fa 1f01          	ldw	(OFST-1,sp),x
1385  02fc               L574:
1388  02fc 9c            	rvf
1389  02fd 1e01          	ldw	x,(OFST-1,sp)
1390  02ff 1309          	cpw	x,(OFST+7,sp)
1391  0301 2fd8          	jrslt	L174
1393  0303 2015          	jra	L105
1394  0305               L764:
1395                     ; 359 		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
1397  0305 c6500f        	ld	a,20495
1398  0308 aa30          	or	a,#48
1399  030a c7500f        	ld	20495,a
1400                     ; 360 		aspetta(counter);
1402  030d 1e03          	ldw	x,(OFST+1,sp)
1403  030f cd0000        	call	_aspetta
1405                     ; 361 		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
1407  0312 c6500f        	ld	a,20495
1408  0315 a4cf          	and	a,#207
1409  0317 c7500f        	ld	20495,a
1410  031a               L105:
1411                     ; 365 }
1414  031a 5b04          	addw	sp,#4
1415  031c 81            	ret
1439                     	xdef	_debugToggle
1440                     	xref.b	_buzzer
1441                     	xref.b	_statoPulsante
1442                     	xref.b	_countInputBS
1443                     	xref.b	_countInputFC
1444                     	xref.b	_countInputIC
1445                     	xref.b	_countInputB
1446                     	xref.b	_flagBatteriaScarica_prec
1447                     	xref.b	_flagBatteriaScarica
1448                     	xref.b	_fineCarica_prec
1449                     	xref.b	_fineCarica
1450                     	xref.b	_inizioCarica
1451                     	xref.b	_distanze
1452                     	xref.b	_stateMachineSensor
1453                     	xref.b	_pulses
1454                     	xref.b	_startCountPulses
1455                     	xref.b	_countPulsante
1456                     	xref.b	_pulsante
1457                     	xref	_aspetta
1458                     	xdef	_segnalazioneOstacolo
1459                     	xdef	_gestisciBuzzerEVibrazione
1460                     	xdef	_debounceTasto
1461                     	xdef	_debounceBatteriaScarica
1462                     	xdef	_debounceFineCarica
1463                     	xdef	_debounceInizioCarica
1464                     	xdef	_segnalazioneBatteriaScarica
1465                     	xdef	_segnalazioneFineCarica
1466                     	xdef	_segnalazioneInizioCarica
1467                     	xdef	_segnalazioneAccensione
1468                     	xdef	_segnalazioneSpegnimento
1469                     	xdef	_checkDecharge
1470                     	xdef	f_startStopTriggersPORTA
1471                     	xdef	f_startStopTriggersPORTB
1472                     	xdef	_gestionePulsante
1473                     	xdef	_gpioInit
1492                     	end
