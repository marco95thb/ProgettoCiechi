   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  14                     	bsct
  15  0000               _debugToggle:
  16  0000 00            	dc.b	0
  45                     ; 32 void gpioInit(void)
  45                     ; 33 {
  47                     	switch	.text
  48  0000               _gpioInit:
  52                     ; 36 	GPIOD->DDR = 0b00111000;
  54  0000 35385011      	mov	20497,#56
  55                     ; 37 	GPIOC->DDR = 0b01101000;
  57  0004 3568500c      	mov	20492,#104
  58                     ; 38 	GPIOB->DDR = 0b00000000;
  60  0008 725f5007      	clr	20487
  61                     ; 39 	GPIOA->DDR = 0b00000000;
  63  000c 725f5002      	clr	20482
  64                     ; 45 	GPIOD->CR1 = 0b00111000;
  66  0010 35385012      	mov	20498,#56
  67                     ; 46 	GPIOC->CR1 = 0b01101000;
  69  0014 3568500d      	mov	20493,#104
  70                     ; 47 	GPIOB->CR1 = 0b00000000;
  72  0018 725f5008      	clr	20488
  73                     ; 48 	GPIOA->CR1 = 0b00000000;
  75  001c 725f5003      	clr	20483
  76                     ; 51 	GPIOB->CR2 |= 0b00110000;
  78  0020 c65009        	ld	a,20489
  79  0023 aa30          	or	a,#48
  80  0025 c75009        	ld	20489,a
  81                     ; 53 	GPIOA->CR2 |= 0b00001000;
  83  0028 72165004      	bset	20484,#3
  84                     ; 55 	GPIOC->CR2 |= 0b01101000;
  86  002c c6500e        	ld	a,20494
  87  002f aa68          	or	a,#104
  88  0031 c7500e        	ld	20494,a
  89                     ; 56 	EXTI->CR1 |= (0x02 << 2) | (0x02 << 0); // PortA/B falling edge
  91  0034 c650a0        	ld	a,20640
  92  0037 aa0a          	or	a,#10
  93  0039 c750a0        	ld	20640,a
  94                     ; 57 }
  97  003c 81            	ret
 122                     ; 58 uint8_t gestionePulsante(void)
 122                     ; 59 {
 123                     	switch	.text
 124  003d               _gestionePulsante:
 128                     ; 60 			pulsante = (GPIOD->IDR >> 2) & 0x01; // PD2
 130  003d c65010        	ld	a,20496
 131  0040 44            	srl	a
 132  0041 44            	srl	a
 133  0042 a401          	and	a,#1
 134  0044 b700          	ld	_pulsante,a
 135                     ; 61 		if(!pulsante)
 137  0046 3d00          	tnz	_pulsante
 138  0048 260f          	jrne	L13
 139                     ; 63 			if(countPulsante > 0)
 141  004a be00          	ldw	x,_countPulsante
 142  004c 2709          	jreq	L33
 143                     ; 64 				countPulsante--;	
 145  004e be00          	ldw	x,_countPulsante
 146  0050 1d0001        	subw	x,#1
 147  0053 bf00          	ldw	_countPulsante,x
 149  0055 201a          	jra	L73
 150  0057               L33:
 151                     ; 66 				return 0;
 153  0057 4f            	clr	a
 156  0058 81            	ret
 157  0059               L13:
 158                     ; 70 			if(countPulsante < 0xFFFF) // evito overflow
 160  0059 be00          	ldw	x,_countPulsante
 161  005b a3ffff        	cpw	x,#65535
 162  005e 2407          	jruge	L14
 163                     ; 71 				countPulsante++;
 165  0060 be00          	ldw	x,_countPulsante
 166  0062 1c0001        	addw	x,#1
 167  0065 bf00          	ldw	_countPulsante,x
 168  0067               L14:
 169                     ; 72 			if(countPulsante >= 5) // numero a caso
 171  0067 be00          	ldw	x,_countPulsante
 172  0069 a30005        	cpw	x,#5
 173  006c 2503          	jrult	L73
 174                     ; 74 				return 1;
 176  006e a601          	ld	a,#1
 179  0070 81            	ret
 180  0071               L73:
 181                     ; 79 		return 2;
 183  0071 a602          	ld	a,#2
 186  0073 81            	ret
 214                     ; 83 @far @interrupt void startStopTriggersPORTB(void)
 214                     ; 84 {
 216                     	switch	.text
 217  0074               f_startStopTriggersPORTB:
 221                     ; 86 	if(((GPIOB->IDR >> 5) & 0x01) == 0x00) // interrupt sul PB5 (echo 2)
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
 234                     ; 89 		if((startCountPulses) && 
 234                     ; 90 		(stateMachineSensor == START_MEASURE_2SENSOR))
 236  0086 3d00          	tnz	_startCountPulses
 237  0088 2710          	jreq	L55
 239  008a b600          	ld	a,_stateMachineSensor
 240  008c a103          	cp	a,#3
 241  008e 260a          	jrne	L55
 242                     ; 92 			startCountPulses = 0;
 244  0090 3f00          	clr	_startCountPulses
 245                     ; 97 			distanze.d2 = pulses; 
 247  0092 be00          	ldw	x,_pulses
 248  0094 bf02          	ldw	_distanze+2,x
 249                     ; 98 			stateMachineSensor = END_MEASURE_2SENSOR;
 251  0096 35040000      	mov	_stateMachineSensor,#4
 252  009a               L55:
 253                     ; 110 	if(((GPIOB->IDR >> 4) & 0x01) == 0x00) // interrupt sul PB4 (echo3)
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
 265                     ; 112 		if((startCountPulses) && 
 265                     ; 113 			(stateMachineSensor == START_MEASURE_3SENSOR))
 267  00ab 3d00          	tnz	_startCountPulses
 268  00ad 2710          	jreq	L16
 270  00af b600          	ld	a,_stateMachineSensor
 271  00b1 a105          	cp	a,#5
 272  00b3 260a          	jrne	L16
 273                     ; 115 			stateMachineSensor = END_MEASURE_3SENSOR;
 275  00b5 35060000      	mov	_stateMachineSensor,#6
 276                     ; 116 			distanze.d3 = pulses; 
 278  00b9 be00          	ldw	x,_pulses
 279  00bb bf04          	ldw	_distanze+4,x
 280                     ; 117 			startCountPulses = 0;
 282  00bd 3f00          	clr	_startCountPulses
 283  00bf               L16:
 284                     ; 122 }
 287  00bf 80            	iret
 314                     ; 124 @far @interrupt void startStopTriggersPORTA(void) // sembra che non ci vada
 314                     ; 125 {
 315                     	switch	.text
 316  00c0               f_startStopTriggersPORTA:
 320                     ; 128 	if(((GPIOA->IDR >> 3) & 0x01) == 0x00) // interrupt sul PA3 (echo 1)
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
 333                     ; 131 		if((startCountPulses) && 
 333                     ; 132 			(stateMachineSensor == START_MEASURE_1SENSOR))
 335  00d1 3d00          	tnz	_startCountPulses
 336  00d3 2710          	jreq	L57
 338  00d5 b600          	ld	a,_stateMachineSensor
 339  00d7 a101          	cp	a,#1
 340  00d9 260a          	jrne	L57
 341                     ; 135 		stateMachineSensor = END_MEASURE_1SENSOR;
 343  00db 35020000      	mov	_stateMachineSensor,#2
 344                     ; 136 			distanze.d1 = pulses; 
 346  00df be00          	ldw	x,_pulses
 347  00e1 bf00          	ldw	_distanze,x
 348                     ; 137 			startCountPulses = 0;
 350  00e3 3f00          	clr	_startCountPulses
 351  00e5               L57:
 352                     ; 144 }
 355  00e5 80            	iret
 377                     ; 145 uint8_t checkDecharge(void)
 377                     ; 146 {
 379                     	switch	.text
 380  00e6               _checkDecharge:
 384                     ; 147 	return ~((GPIOD->IDR >> 6) & 0x01);
 386  00e6 c65010        	ld	a,20496
 387  00e9 4e            	swap	a
 388  00ea 44            	srl	a
 389  00eb 44            	srl	a
 390  00ec a403          	and	a,#3
 391  00ee a401          	and	a,#1
 392  00f0 43            	cpl	a
 395  00f1 81            	ret
 440                     ; 149 void segnalazioneSpegnimento(void)
 440                     ; 150 {
 441                     	switch	.text
 442  00f2               _segnalazioneSpegnimento:
 444  00f2 5204          	subw	sp,#4
 445       00000004      OFST:	set	4
 448                     ; 151 	volatile int blink = 3;
 450  00f4 ae0003        	ldw	x,#3
 451  00f7 1f01          	ldw	(OFST-3,sp),x
 453                     ; 152 	volatile int i = 0;
 455  00f9 5f            	clrw	x
 456  00fa 1f03          	ldw	(OFST-1,sp),x
 458                     ; 153 	for(i=0;i<blink;i++)
 460  00fc 5f            	clrw	x
 461  00fd 1f03          	ldw	(OFST-1,sp),x
 464  00ff 201b          	jra	L731
 465  0101               L331:
 466                     ; 155 		GPIOD->ODR |= BUZZER_ON;
 468  0101 7218500f      	bset	20495,#4
 469                     ; 156 		aspetta(200);
 471  0105 ae00c8        	ldw	x,#200
 472  0108 cd0000        	call	_aspetta
 474                     ; 157 		GPIOD->ODR &= ~BUZZER_ON;
 476  010b 7219500f      	bres	20495,#4
 477                     ; 158 		aspetta(200);
 479  010f ae00c8        	ldw	x,#200
 480  0112 cd0000        	call	_aspetta
 482                     ; 153 	for(i=0;i<blink;i++)
 484  0115 1e03          	ldw	x,(OFST-1,sp)
 485  0117 1c0001        	addw	x,#1
 486  011a 1f03          	ldw	(OFST-1,sp),x
 488  011c               L731:
 491  011c 9c            	rvf
 492  011d 1e03          	ldw	x,(OFST-1,sp)
 493  011f 1301          	cpw	x,(OFST-3,sp)
 494  0121 2fde          	jrslt	L331
 495                     ; 161 }
 498  0123 5b04          	addw	sp,#4
 499  0125 81            	ret
 524                     ; 162 void segnalazioneAccensione(void)
 524                     ; 163 {
 525                     	switch	.text
 526  0126               _segnalazioneAccensione:
 530                     ; 164 		GPIOD->ODR |= BUZZER_ON;
 532  0126 7218500f      	bset	20495,#4
 533                     ; 165 		aspetta(800); 
 535  012a ae0320        	ldw	x,#800
 536  012d cd0000        	call	_aspetta
 538                     ; 166 		GPIOD->ODR &= ~BUZZER_ON;
 540  0130 7219500f      	bres	20495,#4
 541                     ; 167 		aspetta(800); 
 543  0134 ae0320        	ldw	x,#800
 544  0137 cd0000        	call	_aspetta
 546                     ; 169 }
 549  013a 81            	ret
 594                     ; 170 void segnalazioneInizioCarica(void)
 594                     ; 171 {
 595                     	switch	.text
 596  013b               _segnalazioneInizioCarica:
 598  013b 5204          	subw	sp,#4
 599       00000004      OFST:	set	4
 602                     ; 172 	volatile int blink = 3;
 604  013d ae0003        	ldw	x,#3
 605  0140 1f01          	ldw	(OFST-3,sp),x
 607                     ; 173 	volatile int i = 0;
 609  0142 5f            	clrw	x
 610  0143 1f03          	ldw	(OFST-1,sp),x
 612                     ; 174 	for(i=0;i<blink;i++)
 614  0145 5f            	clrw	x
 615  0146 1f03          	ldw	(OFST-1,sp),x
 618  0148 201b          	jra	L102
 619  014a               L571:
 620                     ; 176 		GPIOD->ODR |= BUZZER_ON;
 622  014a 7218500f      	bset	20495,#4
 623                     ; 177 		aspetta(300);
 625  014e ae012c        	ldw	x,#300
 626  0151 cd0000        	call	_aspetta
 628                     ; 178 		GPIOD->ODR &= ~BUZZER_ON;
 630  0154 7219500f      	bres	20495,#4
 631                     ; 179 		aspetta(300);
 633  0158 ae012c        	ldw	x,#300
 634  015b cd0000        	call	_aspetta
 636                     ; 174 	for(i=0;i<blink;i++)
 638  015e 1e03          	ldw	x,(OFST-1,sp)
 639  0160 1c0001        	addw	x,#1
 640  0163 1f03          	ldw	(OFST-1,sp),x
 642  0165               L102:
 645  0165 9c            	rvf
 646  0166 1e03          	ldw	x,(OFST-1,sp)
 647  0168 1301          	cpw	x,(OFST-3,sp)
 648  016a 2fde          	jrslt	L571
 649                     ; 183 }
 652  016c 5b04          	addw	sp,#4
 653  016e 81            	ret
 698                     ; 185 void segnalazioneFineCarica(void)
 698                     ; 186 {
 699                     	switch	.text
 700  016f               _segnalazioneFineCarica:
 702  016f 5204          	subw	sp,#4
 703       00000004      OFST:	set	4
 706                     ; 187 	volatile int blink = 3;
 708  0171 ae0003        	ldw	x,#3
 709  0174 1f01          	ldw	(OFST-3,sp),x
 711                     ; 188 	volatile int i = 0;
 713  0176 5f            	clrw	x
 714  0177 1f03          	ldw	(OFST-1,sp),x
 716                     ; 189 	for(i=0;i<blink;i++)
 718  0179 5f            	clrw	x
 719  017a 1f03          	ldw	(OFST-1,sp),x
 722  017c 201b          	jra	L332
 723  017e               L722:
 724                     ; 191 		GPIOD->ODR |= BUZZER_ON;
 726  017e 7218500f      	bset	20495,#4
 727                     ; 192 		aspetta(400);
 729  0182 ae0190        	ldw	x,#400
 730  0185 cd0000        	call	_aspetta
 732                     ; 193 		GPIOD->ODR &= ~BUZZER_ON;
 734  0188 7219500f      	bres	20495,#4
 735                     ; 194 		aspetta(400);
 737  018c ae0190        	ldw	x,#400
 738  018f cd0000        	call	_aspetta
 740                     ; 189 	for(i=0;i<blink;i++)
 742  0192 1e03          	ldw	x,(OFST-1,sp)
 743  0194 1c0001        	addw	x,#1
 744  0197 1f03          	ldw	(OFST-1,sp),x
 746  0199               L332:
 749  0199 9c            	rvf
 750  019a 1e03          	ldw	x,(OFST-1,sp)
 751  019c 1301          	cpw	x,(OFST-3,sp)
 752  019e 2fde          	jrslt	L722
 753                     ; 197 }
 756  01a0 5b04          	addw	sp,#4
 757  01a2 81            	ret
 802                     ; 198 void segnalazioneBatteriaScarica(void)
 802                     ; 199 {
 803                     	switch	.text
 804  01a3               _segnalazioneBatteriaScarica:
 806  01a3 5204          	subw	sp,#4
 807       00000004      OFST:	set	4
 810                     ; 200 	volatile int blink = 3;
 812  01a5 ae0003        	ldw	x,#3
 813  01a8 1f01          	ldw	(OFST-3,sp),x
 815                     ; 201 	volatile int i = 0;
 817  01aa 5f            	clrw	x
 818  01ab 1f03          	ldw	(OFST-1,sp),x
 820                     ; 202 	for(i=0;i<blink;i++)
 822  01ad 5f            	clrw	x
 823  01ae 1f03          	ldw	(OFST-1,sp),x
 826  01b0 201b          	jra	L562
 827  01b2               L162:
 828                     ; 204 		GPIOD->ODR |= BUZZER_ON;
 830  01b2 7218500f      	bset	20495,#4
 831                     ; 205 		aspetta(500);
 833  01b6 ae01f4        	ldw	x,#500
 834  01b9 cd0000        	call	_aspetta
 836                     ; 206 		GPIOD->ODR &= ~BUZZER_ON;
 838  01bc 7219500f      	bres	20495,#4
 839                     ; 207 		aspetta(500);
 841  01c0 ae01f4        	ldw	x,#500
 842  01c3 cd0000        	call	_aspetta
 844                     ; 202 	for(i=0;i<blink;i++)
 846  01c6 1e03          	ldw	x,(OFST-1,sp)
 847  01c8 1c0001        	addw	x,#1
 848  01cb 1f03          	ldw	(OFST-1,sp),x
 850  01cd               L562:
 853  01cd 9c            	rvf
 854  01ce 1e03          	ldw	x,(OFST-1,sp)
 855  01d0 1301          	cpw	x,(OFST-3,sp)
 856  01d2 2fde          	jrslt	L162
 857                     ; 209 }
 860  01d4 5b04          	addw	sp,#4
 861  01d6 81            	ret
 887                     ; 210 void debounceInizioCarica(void)
 887                     ; 211 {
 888                     	switch	.text
 889  01d7               _debounceInizioCarica:
 893                     ; 212 	if((GPIOC->IDR >> 7) & 0x01) // inizio carica
 895  01d7 c6500b        	ld	a,20491
 896  01da 49            	rlc	a
 897  01db 4f            	clr	a
 898  01dc 49            	rlc	a
 899  01dd 5f            	clrw	x
 900  01de 97            	ld	xl,a
 901  01df a30000        	cpw	x,#0
 902  01e2 2710          	jreq	L103
 903                     ; 214 				if(countInputIC < 3)
 905  01e4 b600          	ld	a,_countInputIC
 906  01e6 a103          	cp	a,#3
 907  01e8 2404          	jruge	L303
 908                     ; 215 					countInputIC++;
 910  01ea 3c00          	inc	_countInputIC
 912  01ec 2010          	jra	L703
 913  01ee               L303:
 914                     ; 217 					inizioCarica = 1;
 916  01ee 35010000      	mov	_inizioCarica,#1
 917  01f2 200a          	jra	L703
 918  01f4               L103:
 919                     ; 223 				if(countInputIC > 0)
 921  01f4 3d00          	tnz	_countInputIC
 922  01f6 2704          	jreq	L113
 923                     ; 224 					countInputIC--;
 925  01f8 3a00          	dec	_countInputIC
 927  01fa 2002          	jra	L703
 928  01fc               L113:
 929                     ; 226 					inizioCarica = 0;
 931  01fc 3f00          	clr	_inizioCarica
 932  01fe               L703:
 933                     ; 228 }
 936  01fe 81            	ret
 961                     ; 229 void debounceFineCarica(void)
 961                     ; 230 {
 962                     	switch	.text
 963  01ff               _debounceFineCarica:
 967                     ; 231 	if((GPIOA->IDR >> 1) & 0x01) // fine carica
 969  01ff c65001        	ld	a,20481
 970  0202 44            	srl	a
 971  0203 5f            	clrw	x
 972  0204 a401          	and	a,#1
 973  0206 5f            	clrw	x
 974  0207 5f            	clrw	x
 975  0208 97            	ld	xl,a
 976  0209 a30000        	cpw	x,#0
 977  020c 2710          	jreq	L523
 978                     ; 233 				if(countInputFC < 3)
 980  020e b600          	ld	a,_countInputFC
 981  0210 a103          	cp	a,#3
 982  0212 2404          	jruge	L723
 983                     ; 234 					countInputFC++;
 985  0214 3c00          	inc	_countInputFC
 987  0216 2010          	jra	L333
 988  0218               L723:
 989                     ; 236 					fineCarica = 1;
 991  0218 35010000      	mov	_fineCarica,#1
 992  021c 200a          	jra	L333
 993  021e               L523:
 994                     ; 242 				if(countInputFC > 0)
 996  021e 3d00          	tnz	_countInputFC
 997  0220 2704          	jreq	L533
 998                     ; 243 					countInputFC--;
1000  0222 3a00          	dec	_countInputFC
1002  0224 2002          	jra	L333
1003  0226               L533:
1004                     ; 245 					fineCarica = 0;
1006  0226 3f00          	clr	_fineCarica
1007  0228               L333:
1008                     ; 247 }
1011  0228 81            	ret
1037                     ; 248 void debounceBatteriaScarica(void)
1037                     ; 249 {
1038                     	switch	.text
1039  0229               _debounceBatteriaScarica:
1043                     ; 250 	if(((GPIOD->IDR >> 6) & 0x01) == 0)// batteria scarica
1045  0229 c65010        	ld	a,20496
1046  022c 4e            	swap	a
1047  022d 44            	srl	a
1048  022e 44            	srl	a
1049  022f a403          	and	a,#3
1050  0231 5f            	clrw	x
1051  0232 a401          	and	a,#1
1052  0234 5f            	clrw	x
1053  0235 5f            	clrw	x
1054  0236 97            	ld	xl,a
1055  0237 a30000        	cpw	x,#0
1056  023a 2610          	jrne	L153
1057                     ; 252 				if(countInputBS < 3)
1059  023c b600          	ld	a,_countInputBS
1060  023e a103          	cp	a,#3
1061  0240 2404          	jruge	L353
1062                     ; 253 					countInputBS++;
1064  0242 3c00          	inc	_countInputBS
1066  0244 2010          	jra	L753
1067  0246               L353:
1068                     ; 255 					flagBatteriaScarica = 1;
1070  0246 35010000      	mov	_flagBatteriaScarica,#1
1071  024a 200a          	jra	L753
1072  024c               L153:
1073                     ; 261 				if(countInputBS > 0)
1075  024c 3d00          	tnz	_countInputBS
1076  024e 2704          	jreq	L163
1077                     ; 262 					countInputBS--;
1079  0250 3a00          	dec	_countInputBS
1081  0252 2002          	jra	L753
1082  0254               L163:
1083                     ; 264 					flagBatteriaScarica = 0;
1085  0254 3f00          	clr	_flagBatteriaScarica
1086  0256               L753:
1087                     ; 266 }
1090  0256 81            	ret
1115                     ; 267 void debounceTasto(void)
1115                     ; 268 {
1116                     	switch	.text
1117  0257               _debounceTasto:
1121                     ; 269 	if((GPIOD->IDR >> 2) & 0x01)
1123  0257 c65010        	ld	a,20496
1124  025a 44            	srl	a
1125  025b 44            	srl	a
1126  025c 5f            	clrw	x
1127  025d a401          	and	a,#1
1128  025f 5f            	clrw	x
1129  0260 5f            	clrw	x
1130  0261 97            	ld	xl,a
1131  0262 a30000        	cpw	x,#0
1132  0265 2710          	jreq	L573
1133                     ; 273 				if(countInputB < 3)
1135  0267 b600          	ld	a,_countInputB
1136  0269 a103          	cp	a,#3
1137  026b 2404          	jruge	L773
1138                     ; 274 					countInputB++;
1140  026d 3c00          	inc	_countInputB
1142  026f 2010          	jra	L304
1143  0271               L773:
1144                     ; 276 					statoPulsante = 1;
1146  0271 35010000      	mov	_statoPulsante,#1
1147  0275 200a          	jra	L304
1148  0277               L573:
1149                     ; 284 				if(countInputB > 0)
1151  0277 3d00          	tnz	_countInputB
1152  0279 2704          	jreq	L504
1153                     ; 285 					countInputB--;
1155  027b 3a00          	dec	_countInputB
1157  027d 2002          	jra	L304
1158  027f               L504:
1159                     ; 288 					statoPulsante = 0;
1161  027f 3f00          	clr	_statoPulsante
1162  0281               L304:
1163                     ; 292 }
1166  0281 81            	ret
1191                     ; 293 void gestisciBuzzerEVibrazione(void)
1191                     ; 294 {
1192                     	switch	.text
1193  0282               _gestisciBuzzerEVibrazione:
1197                     ; 295 	if(buzzer.distanceMonitoring.enabled)
1199  0282 3d21          	tnz	_buzzer+33
1200  0284 2736          	jreq	L124
1201                     ; 298 			buzzer.distanceMonitoring.counterDurata++;
1203  0286 be28          	ldw	x,_buzzer+40
1204  0288 1c0001        	addw	x,#1
1205  028b bf28          	ldw	_buzzer+40,x
1206                     ; 299 		buzzer.distanceMonitoring.counter++;
1208  028d be26          	ldw	x,_buzzer+38
1209  028f 1c0001        	addw	x,#1
1210  0292 bf26          	ldw	_buzzer+38,x
1211                     ; 300 		if(buzzer.drive)
1213  0294 3d2d          	tnz	_buzzer+45
1214  0296 2711          	jreq	L324
1215                     ; 303 			if(buzzer.distanceMonitoring.counter >= buzzer.distanceMonitoring.countHigh)
1217  0298 be26          	ldw	x,_buzzer+38
1218  029a b322          	cpw	x,_buzzer+34
1219  029c 2522          	jrult	L334
1220                     ; 306 				GPIOD->ODR &= ~BUZZER_ON;
1222  029e 7219500f      	bres	20495,#4
1223                     ; 307 				buzzer.distanceMonitoring.counter = 0;
1225  02a2 5f            	clrw	x
1226  02a3 bf26          	ldw	_buzzer+38,x
1227                     ; 308 				buzzer.drive = 0;
1229  02a5 3f2d          	clr	_buzzer+45
1230  02a7 2017          	jra	L334
1231  02a9               L324:
1232                     ; 315 			if(buzzer.distanceMonitoring.counter >= buzzer.distanceMonitoring.countLow)
1234  02a9 be26          	ldw	x,_buzzer+38
1235  02ab b324          	cpw	x,_buzzer+36
1236  02ad 2511          	jrult	L334
1237                     ; 318 				GPIOD->ODR |= BUZZER_ON;
1239  02af 7218500f      	bset	20495,#4
1240                     ; 319 				buzzer.distanceMonitoring.counter = 0;
1242  02b3 5f            	clrw	x
1243  02b4 bf26          	ldw	_buzzer+38,x
1244                     ; 320 				buzzer.drive = 1;
1246  02b6 3501002d      	mov	_buzzer+45,#1
1247  02ba 2004          	jra	L334
1248  02bc               L124:
1249                     ; 330 		GPIOD->ODR &= ~BUZZER_ON;
1251  02bc 7219500f      	bres	20495,#4
1252  02c0               L334:
1253                     ; 333 }
1256  02c0 81            	ret
1319                     ; 334 void segnalazioneOstacolo(int counter,int type,int blink)
1319                     ; 335 {
1320                     	switch	.text
1321  02c1               _segnalazioneOstacolo:
1323  02c1 89            	pushw	x
1324  02c2 89            	pushw	x
1325       00000002      OFST:	set	2
1328                     ; 336 	volatile int i = 0;
1330  02c3 5f            	clrw	x
1331  02c4 1f01          	ldw	(OFST-1,sp),x
1333                     ; 337 	if(type)
1335  02c6 1e07          	ldw	x,(OFST+5,sp)
1336  02c8 272f          	jreq	L764
1337                     ; 339 		for(i=0;i<blink;i++)
1339  02ca 5f            	clrw	x
1340  02cb 1f01          	ldw	(OFST-1,sp),x
1343  02cd 2021          	jra	L574
1344  02cf               L174:
1345                     ; 341 		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
1347  02cf c6500f        	ld	a,20495
1348  02d2 aa30          	or	a,#48
1349  02d4 c7500f        	ld	20495,a
1350                     ; 342 		aspetta(counter);
1352  02d7 1e03          	ldw	x,(OFST+1,sp)
1353  02d9 cd0000        	call	_aspetta
1355                     ; 343 		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
1357  02dc c6500f        	ld	a,20495
1358  02df a4cf          	and	a,#207
1359  02e1 c7500f        	ld	20495,a
1360                     ; 344 		aspetta(counter);
1362  02e4 1e03          	ldw	x,(OFST+1,sp)
1363  02e6 cd0000        	call	_aspetta
1365                     ; 339 		for(i=0;i<blink;i++)
1367  02e9 1e01          	ldw	x,(OFST-1,sp)
1368  02eb 1c0001        	addw	x,#1
1369  02ee 1f01          	ldw	(OFST-1,sp),x
1371  02f0               L574:
1374  02f0 9c            	rvf
1375  02f1 1e01          	ldw	x,(OFST-1,sp)
1376  02f3 1309          	cpw	x,(OFST+7,sp)
1377  02f5 2fd8          	jrslt	L174
1379  02f7 2015          	jra	L105
1380  02f9               L764:
1381                     ; 349 		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
1383  02f9 c6500f        	ld	a,20495
1384  02fc aa30          	or	a,#48
1385  02fe c7500f        	ld	20495,a
1386                     ; 350 		aspetta(counter);
1388  0301 1e03          	ldw	x,(OFST+1,sp)
1389  0303 cd0000        	call	_aspetta
1391                     ; 351 		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
1393  0306 c6500f        	ld	a,20495
1394  0309 a4cf          	and	a,#207
1395  030b c7500f        	ld	20495,a
1396  030e               L105:
1397                     ; 355 }
1400  030e 5b04          	addw	sp,#4
1401  0310 81            	ret
1425                     	xdef	_debugToggle
1426                     	xref.b	_buzzer
1427                     	xref.b	_statoPulsante
1428                     	xref.b	_countInputBS
1429                     	xref.b	_countInputFC
1430                     	xref.b	_countInputIC
1431                     	xref.b	_countInputB
1432                     	xref.b	_flagBatteriaScarica
1433                     	xref.b	_fineCarica
1434                     	xref.b	_inizioCarica
1435                     	xref.b	_distanze
1436                     	xref.b	_stateMachineSensor
1437                     	xref.b	_pulses
1438                     	xref.b	_startCountPulses
1439                     	xref.b	_countPulsante
1440                     	xref.b	_pulsante
1441                     	xref	_aspetta
1442                     	xdef	_segnalazioneOstacolo
1443                     	xdef	_gestisciBuzzerEVibrazione
1444                     	xdef	_debounceTasto
1445                     	xdef	_debounceBatteriaScarica
1446                     	xdef	_debounceFineCarica
1447                     	xdef	_debounceInizioCarica
1448                     	xdef	_segnalazioneBatteriaScarica
1449                     	xdef	_segnalazioneFineCarica
1450                     	xdef	_segnalazioneInizioCarica
1451                     	xdef	_segnalazioneAccensione
1452                     	xdef	_segnalazioneSpegnimento
1453                     	xdef	_checkDecharge
1454                     	xdef	f_startStopTriggersPORTA
1455                     	xdef	f_startStopTriggersPORTB
1456                     	xdef	_gestionePulsante
1457                     	xdef	_gpioInit
1476                     	end
