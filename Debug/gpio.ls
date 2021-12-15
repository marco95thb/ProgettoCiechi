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
 332  00cf 2617          	jrne	L57
 333                     ; 131 		if((startCountPulses) && 
 333                     ; 132 			(stateMachineSensor == START_MEASURE_1SENSOR))
 335  00d1 3d00          	tnz	_startCountPulses
 336  00d3 2713          	jreq	L57
 338  00d5 b600          	ld	a,_stateMachineSensor
 339  00d7 a101          	cp	a,#1
 340  00d9 260d          	jrne	L57
 341                     ; 150 			distanze.d1 = pulses; 
 343  00db be00          	ldw	x,_pulses
 344  00dd bf00          	ldw	_distanze,x
 345                     ; 152 			pulses = 0;
 347  00df 5f            	clrw	x
 348  00e0 bf00          	ldw	_pulses,x
 349                     ; 153 			startCountPulses = 0;
 351  00e2 3f00          	clr	_startCountPulses
 352                     ; 154 			stateMachineSensor = END_MEASURE_1SENSOR;
 354  00e4 35020000      	mov	_stateMachineSensor,#2
 355  00e8               L57:
 356                     ; 160 }
 359  00e8 80            	iret
 381                     ; 161 uint8_t checkDecharge(void)
 381                     ; 162 {
 383                     	switch	.text
 384  00e9               _checkDecharge:
 388                     ; 163 	return ~((GPIOD->IDR >> 6) & 0x01);
 390  00e9 c65010        	ld	a,20496
 391  00ec 4e            	swap	a
 392  00ed 44            	srl	a
 393  00ee 44            	srl	a
 394  00ef a403          	and	a,#3
 395  00f1 a401          	and	a,#1
 396  00f3 43            	cpl	a
 399  00f4 81            	ret
 444                     ; 165 void segnalazioneSpegnimento(void)
 444                     ; 166 {
 445                     	switch	.text
 446  00f5               _segnalazioneSpegnimento:
 448  00f5 5204          	subw	sp,#4
 449       00000004      OFST:	set	4
 452                     ; 167 	volatile int blink = 3;
 454  00f7 ae0003        	ldw	x,#3
 455  00fa 1f01          	ldw	(OFST-3,sp),x
 457                     ; 168 	volatile int i = 0;
 459  00fc 5f            	clrw	x
 460  00fd 1f03          	ldw	(OFST-1,sp),x
 462                     ; 169 	for(i=0;i<blink;i++)
 464  00ff 5f            	clrw	x
 465  0100 1f03          	ldw	(OFST-1,sp),x
 468  0102 201b          	jra	L731
 469  0104               L331:
 470                     ; 171 		GPIOD->ODR |= BUZZER_ON;
 472  0104 7218500f      	bset	20495,#4
 473                     ; 172 		aspetta(10000);
 475  0108 ae2710        	ldw	x,#10000
 476  010b cd0000        	call	_aspetta
 478                     ; 173 		GPIOD->ODR &= ~BUZZER_ON;
 480  010e 7219500f      	bres	20495,#4
 481                     ; 174 		aspetta(10000);
 483  0112 ae2710        	ldw	x,#10000
 484  0115 cd0000        	call	_aspetta
 486                     ; 169 	for(i=0;i<blink;i++)
 488  0118 1e03          	ldw	x,(OFST-1,sp)
 489  011a 1c0001        	addw	x,#1
 490  011d 1f03          	ldw	(OFST-1,sp),x
 492  011f               L731:
 495  011f 9c            	rvf
 496  0120 1e03          	ldw	x,(OFST-1,sp)
 497  0122 1301          	cpw	x,(OFST-3,sp)
 498  0124 2fde          	jrslt	L331
 499                     ; 177 }
 502  0126 5b04          	addw	sp,#4
 503  0128 81            	ret
 528                     ; 178 void segnalazioneAccensione(void)
 528                     ; 179 {
 529                     	switch	.text
 530  0129               _segnalazioneAccensione:
 534                     ; 180 		GPIOD->ODR |= BUZZER_E_VIBRATORE_ON;
 536  0129 c6500f        	ld	a,20495
 537  012c aa30          	or	a,#48
 538  012e c7500f        	ld	20495,a
 539                     ; 181 		aspetta(800); 
 541  0131 ae0320        	ldw	x,#800
 542  0134 cd0000        	call	_aspetta
 544                     ; 182 		GPIOD->ODR &= ~BUZZER_E_VIBRATORE_ON;
 546  0137 c6500f        	ld	a,20495
 547  013a a4cf          	and	a,#207
 548  013c c7500f        	ld	20495,a
 549                     ; 183 		aspetta(800); 
 551  013f ae0320        	ldw	x,#800
 552  0142 cd0000        	call	_aspetta
 554                     ; 185 }
 557  0145 81            	ret
 582                     ; 186 void segnalazioneInizioCarica(void)
 582                     ; 187 {
 583                     	switch	.text
 584  0146               _segnalazioneInizioCarica:
 588                     ; 188 	buzzer.batteriaInizioCarica.countHigh = 10000;
 590  0146 ae2710        	ldw	x,#10000
 591  0149 bf0c          	ldw	_buzzer+12,x
 592                     ; 189 	buzzer.batteriaInizioCarica.countLow = 10000;
 594  014b ae2710        	ldw	x,#10000
 595  014e bf0e          	ldw	_buzzer+14,x
 596                     ; 190 	buzzer.batteriaInizioCarica.durata = 100000;
 598  0150 ae86a0        	ldw	x,#34464
 599  0153 bf14          	ldw	_buzzer+20,x
 600                     ; 191 	buzzer.batteriaInizioCarica.enabled = 1;
 602  0155 3501000b      	mov	_buzzer+11,#1
 603                     ; 194 }
 606  0159 81            	ret
 631                     ; 196 void segnalazioneFineCarica(void)
 631                     ; 197 {
 632                     	switch	.text
 633  015a               _segnalazioneFineCarica:
 637                     ; 198 	buzzer.batteriaFineCarica.countHigh = 50000;
 639  015a aec350        	ldw	x,#50000
 640  015d bf17          	ldw	_buzzer+23,x
 641                     ; 199 	buzzer.batteriaFineCarica.countLow = 50000;
 643  015f aec350        	ldw	x,#50000
 644  0162 bf19          	ldw	_buzzer+25,x
 645                     ; 200 	buzzer.batteriaFineCarica.durata = 400000;
 647  0164 ae1a80        	ldw	x,#6784
 648  0167 bf1f          	ldw	_buzzer+31,x
 649                     ; 201 	buzzer.batteriaFineCarica.enabled = 1;
 651  0169 35010016      	mov	_buzzer+22,#1
 652                     ; 204 }
 655  016d 81            	ret
 680                     ; 205 void segnalazioneBatteriaScarica(void)
 680                     ; 206 {
 681                     	switch	.text
 682  016e               _segnalazioneBatteriaScarica:
 686                     ; 207 	buzzer.batteriaScarica.countHigh = 50000;
 688  016e aec350        	ldw	x,#50000
 689  0171 bf01          	ldw	_buzzer+1,x
 690                     ; 208 	buzzer.batteriaScarica.countLow = 100;
 692  0173 ae0064        	ldw	x,#100
 693  0176 bf03          	ldw	_buzzer+3,x
 694                     ; 209 	buzzer.batteriaScarica.durata = 500000;
 696  0178 aea120        	ldw	x,#41248
 697  017b bf09          	ldw	_buzzer+9,x
 698                     ; 210 }
 701  017d 81            	ret
 727                     ; 211 void debounceInizioCarica(void)
 727                     ; 212 {
 728                     	switch	.text
 729  017e               _debounceInizioCarica:
 733                     ; 213 	if((GPIOC->IDR >> 7) & 0x01) // inizio carica
 735  017e c6500b        	ld	a,20491
 736  0181 49            	rlc	a
 737  0182 4f            	clr	a
 738  0183 49            	rlc	a
 739  0184 5f            	clrw	x
 740  0185 97            	ld	xl,a
 741  0186 a30000        	cpw	x,#0
 742  0189 2710          	jreq	L312
 743                     ; 215 				if(countInputIC < 3)
 745  018b b600          	ld	a,_countInputIC
 746  018d a103          	cp	a,#3
 747  018f 2404          	jruge	L512
 748                     ; 216 					countInputIC++;
 750  0191 3c00          	inc	_countInputIC
 752  0193 2010          	jra	L122
 753  0195               L512:
 754                     ; 218 					inizioCarica = 1;
 756  0195 35010000      	mov	_inizioCarica,#1
 757  0199 200a          	jra	L122
 758  019b               L312:
 759                     ; 224 				if(countInputIC > 0)
 761  019b 3d00          	tnz	_countInputIC
 762  019d 2704          	jreq	L322
 763                     ; 225 					countInputIC--;
 765  019f 3a00          	dec	_countInputIC
 767  01a1 2002          	jra	L122
 768  01a3               L322:
 769                     ; 227 					inizioCarica = 0;
 771  01a3 3f00          	clr	_inizioCarica
 772  01a5               L122:
 773                     ; 229 }
 776  01a5 81            	ret
 801                     ; 230 void debounceFineCarica(void)
 801                     ; 231 {
 802                     	switch	.text
 803  01a6               _debounceFineCarica:
 807                     ; 232 	if((GPIOA->IDR >> 1) & 0x01) // fine carica
 809  01a6 c65001        	ld	a,20481
 810  01a9 44            	srl	a
 811  01aa 5f            	clrw	x
 812  01ab a401          	and	a,#1
 813  01ad 5f            	clrw	x
 814  01ae 5f            	clrw	x
 815  01af 97            	ld	xl,a
 816  01b0 a30000        	cpw	x,#0
 817  01b3 2710          	jreq	L732
 818                     ; 234 				if(countInputFC < 3)
 820  01b5 b600          	ld	a,_countInputFC
 821  01b7 a103          	cp	a,#3
 822  01b9 2404          	jruge	L142
 823                     ; 235 					countInputFC++;
 825  01bb 3c00          	inc	_countInputFC
 827  01bd 2010          	jra	L542
 828  01bf               L142:
 829                     ; 237 					fineCarica = 1;
 831  01bf 35010000      	mov	_fineCarica,#1
 832  01c3 200a          	jra	L542
 833  01c5               L732:
 834                     ; 243 				if(countInputFC > 0)
 836  01c5 3d00          	tnz	_countInputFC
 837  01c7 2704          	jreq	L742
 838                     ; 244 					countInputFC--;
 840  01c9 3a00          	dec	_countInputFC
 842  01cb 2002          	jra	L542
 843  01cd               L742:
 844                     ; 246 					fineCarica = 0;
 846  01cd 3f00          	clr	_fineCarica
 847  01cf               L542:
 848                     ; 248 }
 851  01cf 81            	ret
 877                     ; 249 void debounceBatteriaScarica(void)
 877                     ; 250 {
 878                     	switch	.text
 879  01d0               _debounceBatteriaScarica:
 883                     ; 251 	if(((GPIOD->IDR >> 6) & 0x01) == 0)// batteria scarica
 885  01d0 c65010        	ld	a,20496
 886  01d3 4e            	swap	a
 887  01d4 44            	srl	a
 888  01d5 44            	srl	a
 889  01d6 a403          	and	a,#3
 890  01d8 5f            	clrw	x
 891  01d9 a401          	and	a,#1
 892  01db 5f            	clrw	x
 893  01dc 5f            	clrw	x
 894  01dd 97            	ld	xl,a
 895  01de a30000        	cpw	x,#0
 896  01e1 2610          	jrne	L362
 897                     ; 253 				if(countInputBS < 3)
 899  01e3 b600          	ld	a,_countInputBS
 900  01e5 a103          	cp	a,#3
 901  01e7 2404          	jruge	L562
 902                     ; 254 					countInputBS++;
 904  01e9 3c00          	inc	_countInputBS
 906  01eb 2010          	jra	L172
 907  01ed               L562:
 908                     ; 256 					flagBatteriaScarica = 1;
 910  01ed 35010000      	mov	_flagBatteriaScarica,#1
 911  01f1 200a          	jra	L172
 912  01f3               L362:
 913                     ; 262 				if(countInputBS > 0)
 915  01f3 3d00          	tnz	_countInputBS
 916  01f5 2704          	jreq	L372
 917                     ; 263 					countInputBS--;
 919  01f7 3a00          	dec	_countInputBS
 921  01f9 2002          	jra	L172
 922  01fb               L372:
 923                     ; 265 					flagBatteriaScarica = 0;
 925  01fb 3f00          	clr	_flagBatteriaScarica
 926  01fd               L172:
 927                     ; 267 }
 930  01fd 81            	ret
 955                     ; 268 void debounceTasto(void)
 955                     ; 269 {
 956                     	switch	.text
 957  01fe               _debounceTasto:
 961                     ; 270 	if((GPIOD->IDR >> 2) & 0x01)
 963  01fe c65010        	ld	a,20496
 964  0201 44            	srl	a
 965  0202 44            	srl	a
 966  0203 5f            	clrw	x
 967  0204 a401          	and	a,#1
 968  0206 5f            	clrw	x
 969  0207 5f            	clrw	x
 970  0208 97            	ld	xl,a
 971  0209 a30000        	cpw	x,#0
 972  020c 2710          	jreq	L703
 973                     ; 272 				if(countInputB < 3)
 975  020e b600          	ld	a,_countInputB
 976  0210 a103          	cp	a,#3
 977  0212 2404          	jruge	L113
 978                     ; 273 					countInputB++;
 980  0214 3c00          	inc	_countInputB
 982  0216 2010          	jra	L513
 983  0218               L113:
 984                     ; 275 					statoPulsante = 1;
 986  0218 35010000      	mov	_statoPulsante,#1
 987  021c 200a          	jra	L513
 988  021e               L703:
 989                     ; 281 				if(countInputB > 0)
 991  021e 3d00          	tnz	_countInputB
 992  0220 2704          	jreq	L713
 993                     ; 282 					countInputB--;
 995  0222 3a00          	dec	_countInputB
 997  0224 2002          	jra	L513
 998  0226               L713:
 999                     ; 284 					statoPulsante = 0;
1001  0226 3f00          	clr	_statoPulsante
1002  0228               L513:
1003                     ; 286 }
1006  0228 81            	ret
1031                     ; 287 void gestisciBuzzerEVibrazione(void)
1031                     ; 288 {
1032                     	switch	.text
1033  0229               _gestisciBuzzerEVibrazione:
1037                     ; 289 	if(buzzer.distanceMonitoring.enabled)
1039  0229 3d21          	tnz	_buzzer+33
1040  022b 2736          	jreq	L333
1041                     ; 292 			buzzer.distanceMonitoring.counterDurata++;
1043  022d be28          	ldw	x,_buzzer+40
1044  022f 1c0001        	addw	x,#1
1045  0232 bf28          	ldw	_buzzer+40,x
1046                     ; 293 		buzzer.distanceMonitoring.counter++;
1048  0234 be26          	ldw	x,_buzzer+38
1049  0236 1c0001        	addw	x,#1
1050  0239 bf26          	ldw	_buzzer+38,x
1051                     ; 294 		if(buzzer.drive)
1053  023b 3d2d          	tnz	_buzzer+45
1054  023d 2711          	jreq	L533
1055                     ; 297 			if(buzzer.distanceMonitoring.counter >= buzzer.distanceMonitoring.countHigh)
1057  023f be26          	ldw	x,_buzzer+38
1058  0241 b322          	cpw	x,_buzzer+34
1059  0243 2522          	jrult	L543
1060                     ; 300 				GPIOD->ODR &= ~BUZZER_ON;
1062  0245 7219500f      	bres	20495,#4
1063                     ; 301 				buzzer.distanceMonitoring.counter = 0;
1065  0249 5f            	clrw	x
1066  024a bf26          	ldw	_buzzer+38,x
1067                     ; 302 				buzzer.drive = 0;
1069  024c 3f2d          	clr	_buzzer+45
1070  024e 2017          	jra	L543
1071  0250               L533:
1072                     ; 309 			if(buzzer.distanceMonitoring.counter >= buzzer.distanceMonitoring.countLow)
1074  0250 be26          	ldw	x,_buzzer+38
1075  0252 b324          	cpw	x,_buzzer+36
1076  0254 2511          	jrult	L543
1077                     ; 312 				GPIOD->ODR |= BUZZER_ON;
1079  0256 7218500f      	bset	20495,#4
1080                     ; 313 				buzzer.distanceMonitoring.counter = 0;
1082  025a 5f            	clrw	x
1083  025b bf26          	ldw	_buzzer+38,x
1084                     ; 314 				buzzer.drive = 1;
1086  025d 3501002d      	mov	_buzzer+45,#1
1087  0261 2004          	jra	L543
1088  0263               L333:
1089                     ; 324 		GPIOD->ODR &= ~BUZZER_ON;
1091  0263 7219500f      	bres	20495,#4
1092  0267               L543:
1093                     ; 327 }
1096  0267 81            	ret
1120                     	xdef	_debugToggle
1121                     	xref.b	_buzzer
1122                     	xref.b	_statoPulsante
1123                     	xref.b	_countInputBS
1124                     	xref.b	_countInputFC
1125                     	xref.b	_countInputIC
1126                     	xref.b	_countInputB
1127                     	xref.b	_flagBatteriaScarica
1128                     	xref.b	_fineCarica
1129                     	xref.b	_inizioCarica
1130                     	xref.b	_distanze
1131                     	xref.b	_stateMachineSensor
1132                     	xref.b	_pulses
1133                     	xref.b	_startCountPulses
1134                     	xref.b	_countPulsante
1135                     	xref.b	_pulsante
1136                     	xref	_aspetta
1137                     	xdef	_gestisciBuzzerEVibrazione
1138                     	xdef	_debounceTasto
1139                     	xdef	_debounceBatteriaScarica
1140                     	xdef	_debounceFineCarica
1141                     	xdef	_debounceInizioCarica
1142                     	xdef	_segnalazioneBatteriaScarica
1143                     	xdef	_segnalazioneFineCarica
1144                     	xdef	_segnalazioneInizioCarica
1145                     	xdef	_segnalazioneAccensione
1146                     	xdef	_segnalazioneSpegnimento
1147                     	xdef	_checkDecharge
1148                     	xdef	f_startStopTriggersPORTA
1149                     	xdef	f_startStopTriggersPORTB
1150                     	xdef	_gestionePulsante
1151                     	xdef	_gpioInit
1170                     	end
