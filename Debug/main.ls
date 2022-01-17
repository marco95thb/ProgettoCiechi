   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  14                     	bsct
  15  0000               _pulsante:
  16  0000 00            	dc.b	0
  17  0001               _countPulsante:
  18  0001 0000          	dc.w	0
  19  0003               _stateMachineSensor:
  20  0003 01            	dc.b	1
  21  0004               _statoPulsante_prec:
  22  0004 00            	dc.b	0
  23  0005               _oneShotDrive:
  24  0005 00            	dc.b	0
  25  0006               _flagBatteriaScarica:
  26  0006 00            	dc.b	0
  27  0007               _batteriaScaricaSignalled:
  28  0007 00            	dc.b	0
  29  0008               _countInputB:
  30  0008 00            	dc.b	0
  31  0009               _countInputIC:
  32  0009 00            	dc.b	0
  33  000a               _countInputFC:
  34  000a 00            	dc.b	0
  35  000b               _countInputBS:
  36  000b 00            	dc.b	0
  37  000c               _statoPulsante:
  38  000c 00            	dc.b	0
  39  000d               _statoDispositivo:
  40  000d 01            	dc.b	1
  41  000e               _oneShotPulsante:
  42  000e 00            	dc.b	0
  43  000f               L3_i:
  44  000f 0000          	dc.w	0
  45  0011               _sensoreAttivo:
  46  0011 0000          	dc.w	0
  47  0013               _nonConsiderare:
  48  0013 00            	dc.b	0
 131                     ; 56 main()
 131                     ; 57 {
 133                     	switch	.text
 134  0000               _main:
 136  0000 520a          	subw	sp,#10
 137       0000000a      OFST:	set	10
 140                     ; 60 	disableInterrupts();
 143  0002 9b            sim
 145                     ; 62 	clockInit();
 148  0003 cd0000        	call	_clockInit
 150                     ; 63 	gpioInit();
 152  0006 cd0000        	call	_gpioInit
 154                     ; 64 	analogInit();
 156  0009 cd0000        	call	_analogInit
 158                     ; 65 	timInit();
 160  000c cd0000        	call	_timInit
 162                     ; 66 	buzzerInit();
 164  000f cd0000        	call	_buzzerInit
 166                     ; 69 	enableInterrupts();
 169  0012 9a            rim
 171                     ; 72 	GPIOD->ODR |= DRIVE_ON;
 174  0013 7216500f      	bset	20495,#3
 175                     ; 73 	segnalazioneAccensione();
 177  0017 cd0000        	call	_segnalazioneAccensione
 179  001a               L55:
 180                     ; 95 		if(flagElapsed)
 182  001a 3d4d          	tnz	_flagElapsed
 183  001c 27fc          	jreq	L55
 184                     ; 97 			flagElapsed = 0;
 186  001e 3f4d          	clr	_flagElapsed
 187                     ; 99 			switch(stateMachineSensor)
 189  0020 b603          	ld	a,_stateMachineSensor
 191                     ; 229 				default:break;
 192  0022 4a            	dec	a
 193  0023 2716          	jreq	L5
 194  0025 4a            	dec	a
 195  0026 2603cc00aa    	jreq	L31
 196  002b 4a            	dec	a
 197  002c 2732          	jreq	L7
 198  002e 4a            	dec	a
 199  002f 2779          	jreq	L31
 200  0031 4a            	dec	a
 201  0032 2751          	jreq	L11
 202  0034 4a            	dec	a
 203  0035 2773          	jreq	L31
 204  0037 ac1a021a      	jpf	L56
 205  003b               L5:
 206                     ; 101 				case START_MEASURE_1SENSOR: // impulso 
 206                     ; 102 				// start
 206                     ; 103 				pulses = 0;
 208  003b 5f            	clrw	x
 209  003c bf48          	ldw	_pulses,x
 210                     ; 104 				startCountPulses = 1;
 212  003e 3501004a      	mov	_startCountPulses,#1
 213                     ; 105 					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
 215  0042 7216500a      	bset	20490,#3
 216                     ; 106 					for(i = 0;i < 15;i++);
 218  0046 5f            	clrw	x
 219  0047 1f09          	ldw	(OFST-1,sp),x
 221  0049               L76:
 225  0049 1e09          	ldw	x,(OFST-1,sp)
 226  004b 1c0001        	addw	x,#1
 227  004e 1f09          	ldw	(OFST-1,sp),x
 231  0050 9c            	rvf
 232  0051 1e09          	ldw	x,(OFST-1,sp)
 233  0053 a3000f        	cpw	x,#15
 234  0056 2ff1          	jrslt	L76
 235                     ; 107 					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
 237  0058 7217500a      	bres	20490,#3
 238                     ; 108 					break;
 240  005c ac1a021a      	jpf	L56
 241  0060               L7:
 242                     ; 109 				case START_MEASURE_2SENSOR: // impulso
 242                     ; 110 				// start
 242                     ; 111 					pulses = 0;
 244  0060 5f            	clrw	x
 245  0061 bf48          	ldw	_pulses,x
 246                     ; 112 					startCountPulses = 1;
 248  0063 3501004a      	mov	_startCountPulses,#1
 249                     ; 113 					GPIOC->ODR |= SENSOR2_TRIGGER_ON;
 251  0067 721a500a      	bset	20490,#5
 252                     ; 114 					for(i = 0;i < 15;i++);
 254  006b 5f            	clrw	x
 255  006c 1f09          	ldw	(OFST-1,sp),x
 257  006e               L57:
 261  006e 1e09          	ldw	x,(OFST-1,sp)
 262  0070 1c0001        	addw	x,#1
 263  0073 1f09          	ldw	(OFST-1,sp),x
 267  0075 9c            	rvf
 268  0076 1e09          	ldw	x,(OFST-1,sp)
 269  0078 a3000f        	cpw	x,#15
 270  007b 2ff1          	jrslt	L57
 271                     ; 115 					GPIOC->ODR &= (~SENSOR2_TRIGGER_ON);
 273  007d 721b500a      	bres	20490,#5
 274                     ; 118 					break;
 276  0081 ac1a021a      	jpf	L56
 277  0085               L11:
 278                     ; 119 				case START_MEASURE_3SENSOR: // impulso
 278                     ; 120 				// start
 278                     ; 121 					pulses = 0;
 280  0085 5f            	clrw	x
 281  0086 bf48          	ldw	_pulses,x
 282                     ; 122 					startCountPulses = 1;
 284  0088 3501004a      	mov	_startCountPulses,#1
 285                     ; 123 					GPIOC->ODR |= SENSOR3_TRIGGER_ON;
 287  008c 721c500a      	bset	20490,#6
 288                     ; 124 					for(i = 0;i < 15;i++);
 290  0090 5f            	clrw	x
 291  0091 1f09          	ldw	(OFST-1,sp),x
 293  0093               L301:
 297  0093 1e09          	ldw	x,(OFST-1,sp)
 298  0095 1c0001        	addw	x,#1
 299  0098 1f09          	ldw	(OFST-1,sp),x
 303  009a 9c            	rvf
 304  009b 1e09          	ldw	x,(OFST-1,sp)
 305  009d a3000f        	cpw	x,#15
 306  00a0 2ff1          	jrslt	L301
 307                     ; 125 					GPIOC->ODR &= (~SENSOR3_TRIGGER_ON);
 309  00a2 721d500a      	bres	20490,#6
 310                     ; 127 				break;
 312  00a6 ac1a021a      	jpf	L56
 313  00aa               L31:
 314                     ; 131 				case END_MEASURE_1SENSOR:
 314                     ; 132 				case END_MEASURE_2SENSOR:
 314                     ; 133 				case END_MEASURE_3SENSOR:
 314                     ; 134 				
 314                     ; 135 				if(stateMachineSensor == END_MEASURE_3SENSOR)
 316  00aa b603          	ld	a,_stateMachineSensor
 317  00ac a106          	cp	a,#6
 318  00ae 2703          	jreq	L6
 319  00b0 cc0218        	jp	L111
 320  00b3               L6:
 321                     ; 137 					analogRead();
 323  00b3 cd0000        	call	_analogRead
 325                     ; 138 					setPoint = checkSetPoint();
 327  00b6 cd0000        	call	_checkSetPoint
 329  00b9 bf4b          	ldw	_setPoint,x
 330                     ; 139 					stateMachineSensor = START_MEASURE_1SENSOR;
 332  00bb 35010003      	mov	_stateMachineSensor,#1
 333                     ; 140 					distanze.minima = 9999;
 335  00bf ae270f        	ldw	x,#9999
 336  00c2 bf40          	ldw	_distanze+6,x
 337                     ; 141 					sensoreAttivo = 0;
 339  00c4 5f            	clrw	x
 340  00c5 bf11          	ldw	_sensoreAttivo,x
 341                     ; 142 					if((distanze.d1 < setPoint) && (distanze.d1 >= MINIMA_DISTANZA_SENSORI	)) // legge solo se < 1.4m
 343  00c7 be3a          	ldw	x,_distanze
 344  00c9 b34b          	cpw	x,_setPoint
 345  00cb 240d          	jruge	L311
 347  00cd be3a          	ldw	x,_distanze
 348  00cf a30007        	cpw	x,#7
 349  00d2 2506          	jrult	L311
 350                     ; 144 						distanzeArray[0] = distanze.d1;
 352  00d4 be3a          	ldw	x,_distanze
 353  00d6 1f03          	ldw	(OFST-7,sp),x
 356  00d8 2005          	jra	L511
 357  00da               L311:
 358                     ; 147 						distanzeArray[0] = 9999;
 360  00da ae270f        	ldw	x,#9999
 361  00dd 1f03          	ldw	(OFST-7,sp),x
 363  00df               L511:
 364                     ; 149 					if((distanze.d2 < DISTANZA_1_4_METRI) && (distanze.d2 >= MINIMA_DISTANZA_SENSORI)) // legge solo se < 1.4m
 366  00df be3c          	ldw	x,_distanze+2
 367  00e1 a30014        	cpw	x,#20
 368  00e4 240d          	jruge	L711
 370  00e6 be3c          	ldw	x,_distanze+2
 371  00e8 a30007        	cpw	x,#7
 372  00eb 2506          	jrult	L711
 373                     ; 151 						distanzeArray[1] = distanze.d2;
 375  00ed be3c          	ldw	x,_distanze+2
 376  00ef 1f05          	ldw	(OFST-5,sp),x
 379  00f1 2005          	jra	L121
 380  00f3               L711:
 381                     ; 154 						distanzeArray[1] = 9999;
 383  00f3 ae270f        	ldw	x,#9999
 384  00f6 1f05          	ldw	(OFST-5,sp),x
 386  00f8               L121:
 387                     ; 156 						if((distanze.d3 < DISTANZA_1_4_METRI) && (distanze.d3 >= MINIMA_DISTANZA_SENSORI)) // legge solo se < soglia
 389  00f8 be3e          	ldw	x,_distanze+4
 390  00fa a30014        	cpw	x,#20
 391  00fd 240d          	jruge	L321
 393  00ff be3e          	ldw	x,_distanze+4
 394  0101 a30007        	cpw	x,#7
 395  0104 2506          	jrult	L321
 396                     ; 158 						distanzeArray[2] = distanze.d3;
 398  0106 be3e          	ldw	x,_distanze+4
 399  0108 1f07          	ldw	(OFST-3,sp),x
 402  010a 2005          	jra	L521
 403  010c               L321:
 404                     ; 161 						distanzeArray[2] = 9999;
 406  010c ae270f        	ldw	x,#9999
 407  010f 1f07          	ldw	(OFST-3,sp),x
 409  0111               L521:
 410                     ; 164 					for(i=0;i<3;i++)
 412  0111 5f            	clrw	x
 413  0112 1f09          	ldw	(OFST-1,sp),x
 415  0114               L721:
 416                     ; 166 						if((distanzeArray[i] < distanze.minima) && (distanzeArray[i] >= MINIMA_DISTANZA_SENSORI))
 418  0114 96            	ldw	x,sp
 419  0115 1c0003        	addw	x,#OFST-7
 420  0118 1f01          	ldw	(OFST-9,sp),x
 422  011a 1e09          	ldw	x,(OFST-1,sp)
 423  011c 58            	sllw	x
 424  011d 72fb01        	addw	x,(OFST-9,sp)
 425  0120 9093          	ldw	y,x
 426  0122 90fe          	ldw	y,(y)
 427  0124 90b340        	cpw	y,_distanze+6
 428  0127 242a          	jruge	L531
 430  0129 96            	ldw	x,sp
 431  012a 1c0003        	addw	x,#OFST-7
 432  012d 1f01          	ldw	(OFST-9,sp),x
 434  012f 1e09          	ldw	x,(OFST-1,sp)
 435  0131 58            	sllw	x
 436  0132 72fb01        	addw	x,(OFST-9,sp)
 437  0135 9093          	ldw	y,x
 438  0137 90fe          	ldw	y,(y)
 439  0139 90a30007      	cpw	y,#7
 440  013d 2514          	jrult	L531
 441                     ; 168 							distanze.minima = distanzeArray[i];
 443  013f 96            	ldw	x,sp
 444  0140 1c0003        	addw	x,#OFST-7
 445  0143 1f01          	ldw	(OFST-9,sp),x
 447  0145 1e09          	ldw	x,(OFST-1,sp)
 448  0147 58            	sllw	x
 449  0148 72fb01        	addw	x,(OFST-9,sp)
 450  014b fe            	ldw	x,(x)
 451  014c bf40          	ldw	_distanze+6,x
 452                     ; 169 							sensoreAttivo = i + 1;
 454  014e 1e09          	ldw	x,(OFST-1,sp)
 455  0150 5c            	incw	x
 456  0151 bf11          	ldw	_sensoreAttivo,x
 457  0153               L531:
 458                     ; 164 					for(i=0;i<3;i++)
 460  0153 1e09          	ldw	x,(OFST-1,sp)
 461  0155 1c0001        	addw	x,#1
 462  0158 1f09          	ldw	(OFST-1,sp),x
 466  015a 9c            	rvf
 467  015b 1e09          	ldw	x,(OFST-1,sp)
 468  015d a30003        	cpw	x,#3
 469  0160 2fb2          	jrslt	L721
 470                     ; 173 					switch(sensoreAttivo)
 472  0162 be11          	ldw	x,_sensoreAttivo
 474                     ; 211 						default:
 474                     ; 212 						break;
 475  0164 5a            	decw	x
 476  0165 2766          	jreq	L71
 477  0167 5a            	decw	x
 478  0168 2706          	jreq	L51
 479  016a 5a            	decw	x
 480  016b 2703          	jreq	L01
 481  016d cc021a        	jp	L56
 482  0170               L01:
 483  0170               L51:
 484                     ; 175 						case 2:
 484                     ; 176 						case 3:
 484                     ; 177 							if((distanze.minima < SOGLIA_ALLARME_SENSORE) // tra  1mt e un po meno
 484                     ; 178 							&& (distanze.minima >= SOGLIA_ALLARME_SENSORE_TH1))
 486  0170 be40          	ldw	x,_distanze+6
 487  0172 a30017        	cpw	x,#23
 488  0175 243a          	jruge	L341
 490  0177 be40          	ldw	x,_distanze+6
 491  0179 a30011        	cpw	x,#17
 492  017c 2533          	jrult	L341
 493                     ; 180 								if(sensoreAttivo == 3) // è un esterno
 495  017e be11          	ldw	x,_sensoreAttivo
 496  0180 a30003        	cpw	x,#3
 497  0183 2613          	jrne	L541
 498                     ; 181 									segnalazioneOstacolo(200,1,3);
 500  0185 ae0003        	ldw	x,#3
 501  0188 89            	pushw	x
 502  0189 ae0001        	ldw	x,#1
 503  018c 89            	pushw	x
 504  018d ae00c8        	ldw	x,#200
 505  0190 cd0000        	call	_segnalazioneOstacolo
 507  0193 5b04          	addw	sp,#4
 509  0195 cc021a        	jra	L56
 510  0198               L541:
 511                     ; 182 								else if(sensoreAttivo == 2) // è l'altro esterno
 513  0198 be11          	ldw	x,_sensoreAttivo
 514  019a a30002        	cpw	x,#2
 515  019d 267b          	jrne	L56
 516                     ; 184 									segnalazioneOstacolo(200,1,5);
 518  019f ae0005        	ldw	x,#5
 519  01a2 89            	pushw	x
 520  01a3 ae0001        	ldw	x,#1
 521  01a6 89            	pushw	x
 522  01a7 ae00c8        	ldw	x,#200
 523  01aa cd0000        	call	_segnalazioneOstacolo
 525  01ad 5b04          	addw	sp,#4
 526  01af 2069          	jra	L56
 527  01b1               L341:
 528                     ; 188 						else if((distanze.minima < SOGLIA_ALLARME_SENSORE_TH1) // tra un po mend di un mt e un altro po meno
 528                     ; 189 						&& (distanze.minima >= MINIMA_DISTANZA_SENSORI))
 530  01b1 be40          	ldw	x,_distanze+6
 531  01b3 a30011        	cpw	x,#17
 532  01b6 2462          	jruge	L56
 534  01b8 be40          	ldw	x,_distanze+6
 535  01ba a30007        	cpw	x,#7
 536  01bd 255b          	jrult	L56
 537                     ; 192 							segnalazioneOstacolo(1200,0,0);
 539  01bf 5f            	clrw	x
 540  01c0 89            	pushw	x
 541  01c1 5f            	clrw	x
 542  01c2 89            	pushw	x
 543  01c3 ae04b0        	ldw	x,#1200
 544  01c6 cd0000        	call	_segnalazioneOstacolo
 546  01c9 5b04          	addw	sp,#4
 547  01cb 204d          	jra	L56
 548  01cd               L71:
 549                     ; 197 						case 1:
 549                     ; 198 						if((distanze.minima < SOGLIA_ALLARME_SENSORE_TH1) &&						
 549                     ; 199 						(distanze.minima >= MINIMA_DISTANZA_SENSORI))
 551  01cd be40          	ldw	x,_distanze+6
 552  01cf a30011        	cpw	x,#17
 553  01d2 2415          	jruge	L751
 555  01d4 be40          	ldw	x,_distanze+6
 556  01d6 a30007        	cpw	x,#7
 557  01d9 250e          	jrult	L751
 558                     ; 201 							segnalazioneOstacolo(1200,0,0);
 560  01db 5f            	clrw	x
 561  01dc 89            	pushw	x
 562  01dd 5f            	clrw	x
 563  01de 89            	pushw	x
 564  01df ae04b0        	ldw	x,#1200
 565  01e2 cd0000        	call	_segnalazioneOstacolo
 567  01e5 5b04          	addw	sp,#4
 569  01e7 2031          	jra	L56
 570  01e9               L751:
 571                     ; 204 						else if((distanze.minima < setPoint) &&
 571                     ; 205 						(distanze.minima >= SOGLIA_ALLARME_SENSORE_TH1))
 573  01e9 be40          	ldw	x,_distanze+6
 574  01eb b34b          	cpw	x,_setPoint
 575  01ed 242b          	jruge	L56
 577  01ef be40          	ldw	x,_distanze+6
 578  01f1 a30011        	cpw	x,#17
 579  01f4 2524          	jrult	L56
 580                     ; 207 							segnalazioneOstacolo(100,1,7);
 582  01f6 ae0007        	ldw	x,#7
 583  01f9 89            	pushw	x
 584  01fa ae0001        	ldw	x,#1
 585  01fd 89            	pushw	x
 586  01fe ae0064        	ldw	x,#100
 587  0201 cd0000        	call	_segnalazioneOstacolo
 589  0204 5b04          	addw	sp,#4
 590                     ; 208 							segnalazioneOstacolo(500,0,0);
 592  0206 5f            	clrw	x
 593  0207 89            	pushw	x
 594  0208 5f            	clrw	x
 595  0209 89            	pushw	x
 596  020a ae01f4        	ldw	x,#500
 597  020d cd0000        	call	_segnalazioneOstacolo
 599  0210 5b04          	addw	sp,#4
 600  0212 2006          	jra	L56
 601  0214               L12:
 602                     ; 211 						default:
 602                     ; 212 						break;
 604  0214 2004          	jra	L56
 605  0216               L141:
 607  0216 2002          	jra	L56
 608  0218               L111:
 609                     ; 226 					stateMachineSensor++;
 611  0218 3c03          	inc	_stateMachineSensor
 612  021a               L32:
 613                     ; 229 				default:break;
 615  021a               L56:
 616                     ; 234 			statoPulsante_prec = statoPulsante;
 618  021a 450c04        	mov	_statoPulsante_prec,_statoPulsante
 619                     ; 235 			debounceTasto();
 621  021d cd0000        	call	_debounceTasto
 623                     ; 236 			debounceInizioCarica();
 625  0220 cd0000        	call	_debounceInizioCarica
 627                     ; 237 			debounceFineCarica();
 629  0223 cd0000        	call	_debounceFineCarica
 631                     ; 238 			debounceBatteriaScarica();
 633  0226 cd0000        	call	_debounceBatteriaScarica
 635                     ; 242 			if((inizioCarica) && (!inizioCaricaSignalled))
 637  0229 3d0a          	tnz	_inizioCarica
 638  022b 270a          	jreq	L761
 640  022d 3d08          	tnz	_inizioCaricaSignalled
 641  022f 2606          	jrne	L761
 642                     ; 244 				inizioCaricaSignalled = 0xFF;
 644  0231 35ff0008      	mov	_inizioCaricaSignalled,#255
 646  0235 2006          	jra	L171
 647  0237               L761:
 648                     ; 247 			else if (inizioCarica == 0)
 650  0237 3d0a          	tnz	_inizioCarica
 651  0239 2602          	jrne	L171
 652                     ; 249 				inizioCaricaSignalled = 0;
 654  023b 3f08          	clr	_inizioCaricaSignalled
 655  023d               L171:
 656                     ; 252 			if((fineCarica) && (!fineCaricaSignalled))
 658  023d 3d09          	tnz	_fineCarica
 659  023f 270a          	jreq	L571
 661  0241 3d07          	tnz	_fineCaricaSignalled
 662  0243 2606          	jrne	L571
 663                     ; 255 				fineCaricaSignalled = 0xFF;
 665  0245 35ff0007      	mov	_fineCaricaSignalled,#255
 667  0249 2006          	jra	L771
 668  024b               L571:
 669                     ; 258 			else if (fineCarica == 0)
 671  024b 3d09          	tnz	_fineCarica
 672  024d 2602          	jrne	L771
 673                     ; 260 				fineCaricaSignalled = 0;
 675  024f 3f07          	clr	_fineCaricaSignalled
 676  0251               L771:
 677                     ; 264 			if((flagBatteriaScarica) && (!batteriaScaricaSignalled))
 679  0251 3d06          	tnz	_flagBatteriaScarica
 680  0253 270a          	jreq	L302
 682  0255 3d07          	tnz	_batteriaScaricaSignalled
 683  0257 2606          	jrne	L302
 684                     ; 266 				batteriaScaricaSignalled = 0xFF;
 686  0259 35ff0007      	mov	_batteriaScaricaSignalled,#255
 688  025d 2006          	jra	L502
 689  025f               L302:
 690                     ; 271 			else if(flagBatteriaScarica == 0)
 692  025f 3d06          	tnz	_flagBatteriaScarica
 693  0261 2602          	jrne	L502
 694                     ; 274 					batteriaScaricaSignalled = 0;
 696  0263 3f07          	clr	_batteriaScaricaSignalled
 697  0265               L502:
 698                     ; 281 				if((!statoPulsante_prec) && (statoPulsante))
 700  0265 3d04          	tnz	_statoPulsante_prec
 701  0267 260b          	jrne	L112
 703  0269 3d0c          	tnz	_statoPulsante
 704  026b 2707          	jreq	L112
 705                     ; 284 					contatoreLunghezzaPressione = 0;
 707  026d 5f            	clrw	x
 708  026e bf01          	ldw	_contatoreLunghezzaPressione,x
 710  0270 ac1a001a      	jpf	L55
 711  0274               L112:
 712                     ; 287 				else if((statoPulsante_prec) && (!statoPulsante))
 714  0274 3d04          	tnz	_statoPulsante_prec
 715  0276 2603          	jrne	L21
 716  0278 cc001a        	jp	L55
 717  027b               L21:
 719  027b 3d0c          	tnz	_statoPulsante
 720  027d 2703          	jreq	L41
 721  027f cc001a        	jp	L55
 722  0282               L41:
 723                     ; 290 					if(statoDispositivo == ACCESO) // da acceso lo spengo
 725  0282 b60d          	ld	a,_statoDispositivo
 726  0284 a101          	cp	a,#1
 727  0286 2612          	jrne	L712
 728                     ; 292 						if(contatoreLunghezzaPressione > 100)
 730  0288 be01          	ldw	x,_contatoreLunghezzaPressione
 731  028a a30065        	cpw	x,#101
 732  028d 2516          	jrult	L322
 733                     ; 294 							statoDispositivo = SPENTO;
 735  028f 3f0d          	clr	_statoDispositivo
 736                     ; 295 							segnalazioneSpegnimento();
 738  0291 cd0000        	call	_segnalazioneSpegnimento
 740                     ; 296 							GPIOD->ODR &= ~DRIVE_ON;
 742  0294 7217500f      	bres	20495,#3
 743  0298 200b          	jra	L322
 744  029a               L712:
 745                     ; 301 												GPIOD->ODR |= DRIVE_ON;
 747  029a 7216500f      	bset	20495,#3
 748                     ; 302 						segnalazioneAccensione();
 750  029e cd0000        	call	_segnalazioneAccensione
 752                     ; 303 						statoDispositivo = ACCESO;
 754  02a1 3501000d      	mov	_statoDispositivo,#1
 755  02a5               L322:
 756                     ; 305 					contatoreLunghezzaPressione = 0;
 758  02a5 5f            	clrw	x
 759  02a6 bf01          	ldw	_contatoreLunghezzaPressione,x
 760  02a8 ac1a001a      	jpf	L55
1257                     	xdef	_main
1258                     	xdef	_nonConsiderare
1259                     	xdef	_sensoreAttivo
1260                     	xdef	_oneShotPulsante
1261                     	xdef	_statoDispositivo
1262                     	switch	.ubsct
1263  0000               ___flaggami:
1264  0000 00            	ds.b	1
1265                     	xdef	___flaggami
1266  0001               _contatoreLunghezzaPressione:
1267  0001 0000          	ds.b	2
1268                     	xdef	_contatoreLunghezzaPressione
1269  0003               _supportoDelayBloccante:
1270  0003 00000000      	ds.b	4
1271                     	xdef	_supportoDelayBloccante
1272                     	xdef	_statoPulsante
1273                     	xdef	_countInputBS
1274                     	xdef	_countInputFC
1275                     	xdef	_countInputIC
1276                     	xdef	_countInputB
1277                     	xdef	_batteriaScaricaSignalled
1278  0007               _fineCaricaSignalled:
1279  0007 00            	ds.b	1
1280                     	xdef	_fineCaricaSignalled
1281  0008               _inizioCaricaSignalled:
1282  0008 00            	ds.b	1
1283                     	xdef	_inizioCaricaSignalled
1284                     	xdef	_flagBatteriaScarica
1285  0009               _fineCarica:
1286  0009 00            	ds.b	1
1287                     	xdef	_fineCarica
1288  000a               _inizioCarica:
1289  000a 00            	ds.b	1
1290                     	xdef	_inizioCarica
1291  000b               _buzzer:
1292  000b 000000000000  	ds.b	46
1293                     	xdef	_buzzer
1294                     	xdef	_oneShotDrive
1295                     	xdef	_statoPulsante_prec
1296  0039               _priorita:
1297  0039 00            	ds.b	1
1298                     	xdef	_priorita
1299  003a               _distanze:
1300  003a 000000000000  	ds.b	8
1301                     	xdef	_distanze
1302  0042               _totalTicks:
1303  0042 00000000      	ds.b	4
1304                     	xdef	_totalTicks
1305                     	xdef	_stateMachineSensor
1306  0046               _tmp:
1307  0046 0000          	ds.b	2
1308                     	xdef	_tmp
1309  0048               _pulses:
1310  0048 0000          	ds.b	2
1311                     	xdef	_pulses
1312  004a               _startCountPulses:
1313  004a 00            	ds.b	1
1314                     	xdef	_startCountPulses
1315                     	xdef	_countPulsante
1316                     	xdef	_pulsante
1317  004b               _setPoint:
1318  004b 0000          	ds.b	2
1319                     	xdef	_setPoint
1320  004d               _flagElapsed:
1321  004d 00            	ds.b	1
1322                     	xdef	_flagElapsed
1323  004e               _adcValues:
1324  004e 00000000      	ds.b	4
1325                     	xdef	_adcValues
1326                     	xref	_buzzerInit
1327                     	xref	_timInit
1328                     	xref	_clockInit
1329                     	xref	_checkSetPoint
1330                     	xref	_analogRead
1331                     	xref	_analogInit
1332                     	xref	_segnalazioneOstacolo
1333                     	xref	_debounceTasto
1334                     	xref	_debounceBatteriaScarica
1335                     	xref	_debounceFineCarica
1336                     	xref	_debounceInizioCarica
1337                     	xref	_segnalazioneAccensione
1338                     	xref	_segnalazioneSpegnimento
1339                     	xref	_gpioInit
1359                     	end
