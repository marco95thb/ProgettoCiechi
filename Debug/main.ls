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
  25  0006               _fineCarica_prec:
  26  0006 03            	dc.b	3
  27  0007               _fineCarica:
  28  0007 03            	dc.b	3
  29  0008               _flagBatteriaScarica:
  30  0008 03            	dc.b	3
  31  0009               _flagBatteriaScarica_prec:
  32  0009 03            	dc.b	3
  33  000a               _batteriaScaricaSignalled:
  34  000a 00            	dc.b	0
  35  000b               _countInputB:
  36  000b 00            	dc.b	0
  37  000c               _countInputIC:
  38  000c 00            	dc.b	0
  39  000d               _countInputFC:
  40  000d 00            	dc.b	0
  41  000e               _countInputBS:
  42  000e 00            	dc.b	0
  43  000f               _statoPulsante:
  44  000f 00            	dc.b	0
  45  0010               _statoDispositivo:
  46  0010 01            	dc.b	1
  47  0011               _oneShotPulsante:
  48  0011 00            	dc.b	0
  49  0012               L3_i:
  50  0012 0000          	dc.w	0
  51  0014               _sensoreAttivo:
  52  0014 0000          	dc.w	0
  53  0016               _nonConsiderare:
  54  0016 00            	dc.b	0
 142                     ; 58 main()
 142                     ; 59 {
 144                     	switch	.text
 145  0000               _main:
 147  0000 520a          	subw	sp,#10
 148       0000000a      OFST:	set	10
 151                     ; 62 	disableInterrupts();
 154  0002 9b            sim
 156                     ; 64 	clockInit();
 159  0003 cd0000        	call	_clockInit
 161                     ; 65 	gpioInit();
 163  0006 cd0000        	call	_gpioInit
 165                     ; 66 	analogInit();
 167  0009 cd0000        	call	_analogInit
 169                     ; 67 	timInit();
 171  000c cd0000        	call	_timInit
 173                     ; 68 	buzzerInit();
 175  000f cd0000        	call	_buzzerInit
 177                     ; 71 	enableInterrupts();
 180  0012 9a            rim
 182                     ; 74 	GPIOD->ODR |= DRIVE_ON;
 185  0013 7216500f      	bset	20495,#3
 186                     ; 75 	segnalazioneAccensione();
 188  0017 cd0000        	call	_segnalazioneAccensione
 190  001a               L55:
 191                     ; 97 		if(flagElapsed)
 193  001a 3d4c          	tnz	_flagElapsed
 194  001c 27fc          	jreq	L55
 195                     ; 99 			flagElapsed = 0;
 197  001e 3f4c          	clr	_flagElapsed
 198                     ; 101 			switch(stateMachineSensor)
 200  0020 b603          	ld	a,_stateMachineSensor
 202                     ; 246 				default:break;
 203  0022 4a            	dec	a
 204  0023 2716          	jreq	L5
 205  0025 4a            	dec	a
 206  0026 2603cc00aa    	jreq	L31
 207  002b 4a            	dec	a
 208  002c 2732          	jreq	L7
 209  002e 4a            	dec	a
 210  002f 2779          	jreq	L31
 211  0031 4a            	dec	a
 212  0032 2751          	jreq	L11
 213  0034 4a            	dec	a
 214  0035 2773          	jreq	L31
 215  0037 ac2b022b      	jpf	L56
 216  003b               L5:
 217                     ; 103 				case START_MEASURE_1SENSOR: // impulso 
 217                     ; 104 				// start
 217                     ; 105 				pulses = 0;
 219  003b 5f            	clrw	x
 220  003c bf47          	ldw	_pulses,x
 221                     ; 106 				startCountPulses = 1;
 223  003e 35010049      	mov	_startCountPulses,#1
 224                     ; 107 					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
 226  0042 7216500a      	bset	20490,#3
 227                     ; 108 					for(i = 0;i < 15;i++);
 229  0046 5f            	clrw	x
 230  0047 1f09          	ldw	(OFST-1,sp),x
 232  0049               L76:
 236  0049 1e09          	ldw	x,(OFST-1,sp)
 237  004b 1c0001        	addw	x,#1
 238  004e 1f09          	ldw	(OFST-1,sp),x
 242  0050 9c            	rvf
 243  0051 1e09          	ldw	x,(OFST-1,sp)
 244  0053 a3000f        	cpw	x,#15
 245  0056 2ff1          	jrslt	L76
 246                     ; 109 					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
 248  0058 7217500a      	bres	20490,#3
 249                     ; 110 					break;
 251  005c ac2b022b      	jpf	L56
 252  0060               L7:
 253                     ; 111 				case START_MEASURE_2SENSOR: // impulso
 253                     ; 112 				// start
 253                     ; 113 					pulses = 0;
 255  0060 5f            	clrw	x
 256  0061 bf47          	ldw	_pulses,x
 257                     ; 114 					startCountPulses = 1;
 259  0063 35010049      	mov	_startCountPulses,#1
 260                     ; 115 					GPIOC->ODR |= SENSOR2_TRIGGER_ON;
 262  0067 721a500a      	bset	20490,#5
 263                     ; 116 					for(i = 0;i < 15;i++);
 265  006b 5f            	clrw	x
 266  006c 1f09          	ldw	(OFST-1,sp),x
 268  006e               L57:
 272  006e 1e09          	ldw	x,(OFST-1,sp)
 273  0070 1c0001        	addw	x,#1
 274  0073 1f09          	ldw	(OFST-1,sp),x
 278  0075 9c            	rvf
 279  0076 1e09          	ldw	x,(OFST-1,sp)
 280  0078 a3000f        	cpw	x,#15
 281  007b 2ff1          	jrslt	L57
 282                     ; 117 					GPIOC->ODR &= (~SENSOR2_TRIGGER_ON);
 284  007d 721b500a      	bres	20490,#5
 285                     ; 120 					break;
 287  0081 ac2b022b      	jpf	L56
 288  0085               L11:
 289                     ; 121 				case START_MEASURE_3SENSOR: // impulso
 289                     ; 122 				// start
 289                     ; 123 					pulses = 0;
 291  0085 5f            	clrw	x
 292  0086 bf47          	ldw	_pulses,x
 293                     ; 124 					startCountPulses = 1;
 295  0088 35010049      	mov	_startCountPulses,#1
 296                     ; 125 					GPIOC->ODR |= SENSOR3_TRIGGER_ON;
 298  008c 721c500a      	bset	20490,#6
 299                     ; 126 					for(i = 0;i < 15;i++);
 301  0090 5f            	clrw	x
 302  0091 1f09          	ldw	(OFST-1,sp),x
 304  0093               L301:
 308  0093 1e09          	ldw	x,(OFST-1,sp)
 309  0095 1c0001        	addw	x,#1
 310  0098 1f09          	ldw	(OFST-1,sp),x
 314  009a 9c            	rvf
 315  009b 1e09          	ldw	x,(OFST-1,sp)
 316  009d a3000f        	cpw	x,#15
 317  00a0 2ff1          	jrslt	L301
 318                     ; 127 					GPIOC->ODR &= (~SENSOR3_TRIGGER_ON);
 320  00a2 721d500a      	bres	20490,#6
 321                     ; 129 				break;
 323  00a6 ac2b022b      	jpf	L56
 324  00aa               L31:
 325                     ; 133 				case END_MEASURE_1SENSOR:
 325                     ; 134 				case END_MEASURE_2SENSOR:
 325                     ; 135 				case END_MEASURE_3SENSOR:
 325                     ; 136 				
 325                     ; 137 				if(stateMachineSensor == END_MEASURE_3SENSOR)
 327  00aa b603          	ld	a,_stateMachineSensor
 328  00ac a106          	cp	a,#6
 329  00ae 2703          	jreq	L6
 330  00b0 cc0229        	jp	L111
 331  00b3               L6:
 332                     ; 139 					analogRead();
 334  00b3 cd0000        	call	_analogRead
 336                     ; 140 					if(adcValues.distanceSetPoint < SP_TH1_COUNT)
 338  00b6 be4f          	ldw	x,_adcValues+2
 339  00b8 a30100        	cpw	x,#256
 340  00bb 2407          	jruge	L311
 341                     ; 142 						setPoint =  DISTANZA_4_0METRI;
 343  00bd ae0031        	ldw	x,#49
 344  00c0 bf4a          	ldw	_setPoint,x
 346  00c2 2013          	jra	L511
 347  00c4               L311:
 348                     ; 144 					else if (adcValues.distanceSetPoint < SP_TH2_COUNT)
 350  00c4 be4f          	ldw	x,_adcValues+2
 351  00c6 a30200        	cpw	x,#512
 352  00c9 2407          	jruge	L711
 353                     ; 146 						setPoint =  DISTANZA_3_0METRI;
 355  00cb ae002a        	ldw	x,#42
 356  00ce bf4a          	ldw	_setPoint,x
 358  00d0 2005          	jra	L511
 359  00d2               L711:
 360                     ; 151 						setPoint =  DISTANZA_1_4_METRI;
 362  00d2 ae0014        	ldw	x,#20
 363  00d5 bf4a          	ldw	_setPoint,x
 364  00d7               L511:
 365                     ; 155 					stateMachineSensor = START_MEASURE_1SENSOR;
 367  00d7 35010003      	mov	_stateMachineSensor,#1
 368                     ; 156 					distanze.minima = 9999;
 370  00db ae270f        	ldw	x,#9999
 371  00de bf3f          	ldw	_distanze+6,x
 372                     ; 157 					sensoreAttivo = 0;
 374  00e0 5f            	clrw	x
 375  00e1 bf14          	ldw	_sensoreAttivo,x
 376                     ; 158 					if((distanze.d1 <= setPoint) && (distanze.d1 >= MINIMA_DISTANZA_SENSORI	)) // legge solo se < 1.4m
 378  00e3 be39          	ldw	x,_distanze
 379  00e5 b34a          	cpw	x,_setPoint
 380  00e7 220d          	jrugt	L321
 382  00e9 be39          	ldw	x,_distanze
 383  00eb a30007        	cpw	x,#7
 384  00ee 2506          	jrult	L321
 385                     ; 160 						distanzeArray[0] = distanze.d1;
 387  00f0 be39          	ldw	x,_distanze
 388  00f2 1f03          	ldw	(OFST-7,sp),x
 391  00f4 2005          	jra	L521
 392  00f6               L321:
 393                     ; 163 						distanzeArray[0] = 9999;
 395  00f6 ae270f        	ldw	x,#9999
 396  00f9 1f03          	ldw	(OFST-7,sp),x
 398  00fb               L521:
 399                     ; 165 					if((distanze.d2 < DISTANZA_1_4_METRI) && (distanze.d2 >= MINIMA_DISTANZA_SENSORI)) // legge solo se < 1.4m
 401  00fb be3b          	ldw	x,_distanze+2
 402  00fd a30014        	cpw	x,#20
 403  0100 240d          	jruge	L721
 405  0102 be3b          	ldw	x,_distanze+2
 406  0104 a30007        	cpw	x,#7
 407  0107 2506          	jrult	L721
 408                     ; 167 						distanzeArray[1] = distanze.d2;
 410  0109 be3b          	ldw	x,_distanze+2
 411  010b 1f05          	ldw	(OFST-5,sp),x
 414  010d 2005          	jra	L131
 415  010f               L721:
 416                     ; 170 						distanzeArray[1] = 9999;
 418  010f ae270f        	ldw	x,#9999
 419  0112 1f05          	ldw	(OFST-5,sp),x
 421  0114               L131:
 422                     ; 172 						if((distanze.d3 < DISTANZA_1_4_METRI) && (distanze.d3 >= MINIMA_DISTANZA_SENSORI)) // legge solo se < soglia
 424  0114 be3d          	ldw	x,_distanze+4
 425  0116 a30014        	cpw	x,#20
 426  0119 240d          	jruge	L331
 428  011b be3d          	ldw	x,_distanze+4
 429  011d a30007        	cpw	x,#7
 430  0120 2506          	jrult	L331
 431                     ; 174 						distanzeArray[2] = distanze.d3;
 433  0122 be3d          	ldw	x,_distanze+4
 434  0124 1f07          	ldw	(OFST-3,sp),x
 437  0126 2005          	jra	L531
 438  0128               L331:
 439                     ; 177 						distanzeArray[2] = 9999;
 441  0128 ae270f        	ldw	x,#9999
 442  012b 1f07          	ldw	(OFST-3,sp),x
 444  012d               L531:
 445                     ; 180 					for(i=0;i<3;i++)
 447  012d 5f            	clrw	x
 448  012e 1f09          	ldw	(OFST-1,sp),x
 450  0130               L731:
 451                     ; 182 						if((distanzeArray[i] < distanze.minima) && (distanzeArray[i] >= MINIMA_DISTANZA_SENSORI))
 453  0130 96            	ldw	x,sp
 454  0131 1c0003        	addw	x,#OFST-7
 455  0134 1f01          	ldw	(OFST-9,sp),x
 457  0136 1e09          	ldw	x,(OFST-1,sp)
 458  0138 58            	sllw	x
 459  0139 72fb01        	addw	x,(OFST-9,sp)
 460  013c 9093          	ldw	y,x
 461  013e 90fe          	ldw	y,(y)
 462  0140 90b33f        	cpw	y,_distanze+6
 463  0143 242c          	jruge	L541
 465  0145 96            	ldw	x,sp
 466  0146 1c0003        	addw	x,#OFST-7
 467  0149 1f01          	ldw	(OFST-9,sp),x
 469  014b 1e09          	ldw	x,(OFST-1,sp)
 470  014d 58            	sllw	x
 471  014e 72fb01        	addw	x,(OFST-9,sp)
 472  0151 9093          	ldw	y,x
 473  0153 90fe          	ldw	y,(y)
 474  0155 90a30007      	cpw	y,#7
 475  0159 2516          	jrult	L541
 476                     ; 184 							distanze.minima = distanzeArray[i];
 478  015b 96            	ldw	x,sp
 479  015c 1c0003        	addw	x,#OFST-7
 480  015f 1f01          	ldw	(OFST-9,sp),x
 482  0161 1e09          	ldw	x,(OFST-1,sp)
 483  0163 58            	sllw	x
 484  0164 72fb01        	addw	x,(OFST-9,sp)
 485  0167 fe            	ldw	x,(x)
 486  0168 bf3f          	ldw	_distanze+6,x
 487                     ; 185 							sensoreAttivo = i + 1;
 489  016a 1e09          	ldw	x,(OFST-1,sp)
 490  016c 5c            	incw	x
 491  016d bf14          	ldw	_sensoreAttivo,x
 492                     ; 186 							break;
 494  016f 200f          	jra	L341
 495  0171               L541:
 496                     ; 180 					for(i=0;i<3;i++)
 498  0171 1e09          	ldw	x,(OFST-1,sp)
 499  0173 1c0001        	addw	x,#1
 500  0176 1f09          	ldw	(OFST-1,sp),x
 504  0178 9c            	rvf
 505  0179 1e09          	ldw	x,(OFST-1,sp)
 506  017b a30003        	cpw	x,#3
 507  017e 2fb0          	jrslt	L731
 508  0180               L341:
 509                     ; 190 					switch(sensoreAttivo)
 511  0180 be14          	ldw	x,_sensoreAttivo
 513                     ; 228 						default:
 513                     ; 229 						break;
 514  0182 5a            	decw	x
 515  0183 2765          	jreq	L71
 516  0185 5a            	decw	x
 517  0186 2706          	jreq	L51
 518  0188 5a            	decw	x
 519  0189 2703          	jreq	L01
 520  018b cc022b        	jp	L56
 521  018e               L01:
 522  018e               L51:
 523                     ; 192 						case 2:
 523                     ; 193 						case 3:
 523                     ; 194 							if((distanze.minima < SOGLIA_ALLARME_SENSORE) // tra  1mt e un po meno
 523                     ; 195 							&& (distanze.minima >= SOGLIA_ALLARME_SENSORE_TH1))
 525  018e be3f          	ldw	x,_distanze+6
 526  0190 a30017        	cpw	x,#23
 527  0193 2439          	jruge	L351
 529  0195 be3f          	ldw	x,_distanze+6
 530  0197 a30011        	cpw	x,#17
 531  019a 2532          	jrult	L351
 532                     ; 197 								if(sensoreAttivo == 3) // è un esterno
 534  019c be14          	ldw	x,_sensoreAttivo
 535  019e a30003        	cpw	x,#3
 536  01a1 2612          	jrne	L551
 537                     ; 198 									segnalazioneOstacolo(200,1,3);
 539  01a3 ae0003        	ldw	x,#3
 540  01a6 89            	pushw	x
 541  01a7 ae0001        	ldw	x,#1
 542  01aa 89            	pushw	x
 543  01ab ae00c8        	ldw	x,#200
 544  01ae cd0000        	call	_segnalazioneOstacolo
 546  01b1 5b04          	addw	sp,#4
 548  01b3 2076          	jra	L56
 549  01b5               L551:
 550                     ; 199 								else if(sensoreAttivo == 2) // è l'altro esterno
 552  01b5 be14          	ldw	x,_sensoreAttivo
 553  01b7 a30002        	cpw	x,#2
 554  01ba 266f          	jrne	L56
 555                     ; 201 									segnalazioneOstacolo(200,1,5);
 557  01bc ae0005        	ldw	x,#5
 558  01bf 89            	pushw	x
 559  01c0 ae0001        	ldw	x,#1
 560  01c3 89            	pushw	x
 561  01c4 ae00c8        	ldw	x,#200
 562  01c7 cd0000        	call	_segnalazioneOstacolo
 564  01ca 5b04          	addw	sp,#4
 565  01cc 205d          	jra	L56
 566  01ce               L351:
 567                     ; 205 						else if((distanze.minima < SOGLIA_ALLARME_SENSORE_TH1) // tra un po mend di un mt e un altro po meno
 567                     ; 206 						&& (distanze.minima >= MINIMA_DISTANZA_SENSORI))
 569  01ce be3f          	ldw	x,_distanze+6
 570  01d0 a30011        	cpw	x,#17
 571  01d3 2456          	jruge	L56
 573  01d5 be3f          	ldw	x,_distanze+6
 574  01d7 a30007        	cpw	x,#7
 575  01da 254f          	jrult	L56
 576                     ; 209 							segnalazioneOstacolo(1200,0,0);
 578  01dc 5f            	clrw	x
 579  01dd 89            	pushw	x
 580  01de 5f            	clrw	x
 581  01df 89            	pushw	x
 582  01e0 ae04b0        	ldw	x,#1200
 583  01e3 cd0000        	call	_segnalazioneOstacolo
 585  01e6 5b04          	addw	sp,#4
 586  01e8 2041          	jra	L56
 587  01ea               L71:
 588                     ; 214 						case 1:
 588                     ; 215 						if((distanze.minima < SOGLIA_ALLARME_SENSORE_TH1) &&						
 588                     ; 216 						(distanze.minima >= MINIMA_DISTANZA_SENSORI))
 590  01ea be3f          	ldw	x,_distanze+6
 591  01ec a30011        	cpw	x,#17
 592  01ef 2415          	jruge	L761
 594  01f1 be3f          	ldw	x,_distanze+6
 595  01f3 a30007        	cpw	x,#7
 596  01f6 250e          	jrult	L761
 597                     ; 218 							segnalazioneOstacolo(1200,0,0);
 599  01f8 5f            	clrw	x
 600  01f9 89            	pushw	x
 601  01fa 5f            	clrw	x
 602  01fb 89            	pushw	x
 603  01fc ae04b0        	ldw	x,#1200
 604  01ff cd0000        	call	_segnalazioneOstacolo
 606  0202 5b04          	addw	sp,#4
 608  0204 2025          	jra	L56
 609  0206               L761:
 610                     ; 221 						else if((distanze.minima < setPoint) &&
 610                     ; 222 						(distanze.minima >= SOGLIA_ALLARME_SENSORE_TH1))
 612  0206 be3f          	ldw	x,_distanze+6
 613  0208 b34a          	cpw	x,_setPoint
 614  020a 241f          	jruge	L56
 616  020c be3f          	ldw	x,_distanze+6
 617  020e a30011        	cpw	x,#17
 618  0211 2518          	jrult	L56
 619                     ; 224 							segnalazioneOstacolo(200,1,3);
 621  0213 ae0003        	ldw	x,#3
 622  0216 89            	pushw	x
 623  0217 ae0001        	ldw	x,#1
 624  021a 89            	pushw	x
 625  021b ae00c8        	ldw	x,#200
 626  021e cd0000        	call	_segnalazioneOstacolo
 628  0221 5b04          	addw	sp,#4
 629  0223 2006          	jra	L56
 630  0225               L12:
 631                     ; 228 						default:
 631                     ; 229 						break;
 633  0225 2004          	jra	L56
 634  0227               L151:
 636  0227 2002          	jra	L56
 637  0229               L111:
 638                     ; 243 					stateMachineSensor++;
 640  0229 3c03          	inc	_stateMachineSensor
 641  022b               L32:
 642                     ; 246 				default:break;
 644  022b               L56:
 645                     ; 251 			statoPulsante_prec = statoPulsante;
 647  022b 450f04        	mov	_statoPulsante_prec,_statoPulsante
 648                     ; 252 			debounceTasto();
 650  022e cd0000        	call	_debounceTasto
 652                     ; 253 			debounceInizioCarica();
 654  0231 cd0000        	call	_debounceInizioCarica
 656                     ; 254 			debounceFineCarica();
 658  0234 cd0000        	call	_debounceFineCarica
 660                     ; 255 			debounceBatteriaScarica();
 662  0237 cd0000        	call	_debounceBatteriaScarica
 664                     ; 259 			if((inizioCarica) && (!inizioCaricaSignalled))
 666  023a 3d09          	tnz	_inizioCarica
 667  023c 270d          	jreq	L771
 669  023e 3d08          	tnz	_inizioCaricaSignalled
 670  0240 2609          	jrne	L771
 671                     ; 261 				inizioCaricaSignalled = 0xFF;
 673  0242 35ff0008      	mov	_inizioCaricaSignalled,#255
 674                     ; 262 				segnalazioneInizioCarica();
 676  0246 cd0000        	call	_segnalazioneInizioCarica
 679  0249 2006          	jra	L102
 680  024b               L771:
 681                     ; 264 			else if (inizioCarica == 0)
 683  024b 3d09          	tnz	_inizioCarica
 684  024d 2602          	jrne	L102
 685                     ; 266 				inizioCaricaSignalled = 0;
 687  024f 3f08          	clr	_inizioCaricaSignalled
 688  0251               L102:
 689                     ; 269 			if((fineCarica == 1) && (fineCarica_prec == 0) && (!fineCaricaSignalled))
 691  0251 b607          	ld	a,_fineCarica
 692  0253 a101          	cp	a,#1
 693  0255 2611          	jrne	L502
 695  0257 3d06          	tnz	_fineCarica_prec
 696  0259 260d          	jrne	L502
 698  025b 3d07          	tnz	_fineCaricaSignalled
 699  025d 2609          	jrne	L502
 700                     ; 272 				fineCaricaSignalled = 0xFF;
 702  025f 35ff0007      	mov	_fineCaricaSignalled,#255
 703                     ; 273 				segnalazioneFineCarica();
 705  0263 cd0000        	call	_segnalazioneFineCarica
 708  0266 2006          	jra	L702
 709  0268               L502:
 710                     ; 275 			else if (fineCarica == 0)
 712  0268 3d07          	tnz	_fineCarica
 713  026a 2602          	jrne	L702
 714                     ; 277 				fineCaricaSignalled = 0;
 716  026c 3f07          	clr	_fineCaricaSignalled
 717  026e               L702:
 718                     ; 281 			if((flagBatteriaScarica == 1) && (flagBatteriaScarica_prec == 0) && (!batteriaScaricaSignalled))
 720  026e b608          	ld	a,_flagBatteriaScarica
 721  0270 a101          	cp	a,#1
 722  0272 2611          	jrne	L312
 724  0274 3d09          	tnz	_flagBatteriaScarica_prec
 725  0276 260d          	jrne	L312
 727  0278 3d0a          	tnz	_batteriaScaricaSignalled
 728  027a 2609          	jrne	L312
 729                     ; 283 				batteriaScaricaSignalled = 0xFF;
 731  027c 35ff000a      	mov	_batteriaScaricaSignalled,#255
 732                     ; 284 				segnalazioneBatteriaScarica();
 734  0280 cd0000        	call	_segnalazioneBatteriaScarica
 737  0283 2006          	jra	L512
 738  0285               L312:
 739                     ; 288 			else if(flagBatteriaScarica == 0)
 741  0285 3d08          	tnz	_flagBatteriaScarica
 742  0287 2602          	jrne	L512
 743                     ; 291 					batteriaScaricaSignalled = 0;
 745  0289 3f0a          	clr	_batteriaScaricaSignalled
 746  028b               L512:
 747                     ; 298 				if((!statoPulsante_prec) && (statoPulsante))
 749  028b 3d04          	tnz	_statoPulsante_prec
 750  028d 260b          	jrne	L122
 752  028f 3d0f          	tnz	_statoPulsante
 753  0291 2707          	jreq	L122
 754                     ; 301 					contatoreLunghezzaPressione = 0;
 756  0293 5f            	clrw	x
 757  0294 bf01          	ldw	_contatoreLunghezzaPressione,x
 759  0296 ac1a001a      	jpf	L55
 760  029a               L122:
 761                     ; 304 				else if((statoPulsante_prec) && (!statoPulsante))
 763  029a 3d04          	tnz	_statoPulsante_prec
 764  029c 2603          	jrne	L21
 765  029e cc001a        	jp	L55
 766  02a1               L21:
 768  02a1 3d0f          	tnz	_statoPulsante
 769  02a3 2703          	jreq	L41
 770  02a5 cc001a        	jp	L55
 771  02a8               L41:
 772                     ; 307 					if(statoDispositivo == ACCESO) // da acceso lo spengo
 774  02a8 b610          	ld	a,_statoDispositivo
 775  02aa a101          	cp	a,#1
 776  02ac 2612          	jrne	L722
 777                     ; 309 						if(contatoreLunghezzaPressione > 100)
 779  02ae be01          	ldw	x,_contatoreLunghezzaPressione
 780  02b0 a30065        	cpw	x,#101
 781  02b3 2516          	jrult	L332
 782                     ; 311 							statoDispositivo = SPENTO;
 784  02b5 3f10          	clr	_statoDispositivo
 785                     ; 312 							segnalazioneSpegnimento();
 787  02b7 cd0000        	call	_segnalazioneSpegnimento
 789                     ; 313 							GPIOD->ODR &= ~DRIVE_ON;
 791  02ba 7217500f      	bres	20495,#3
 792  02be 200b          	jra	L332
 793  02c0               L722:
 794                     ; 318 												GPIOD->ODR |= DRIVE_ON;
 796  02c0 7216500f      	bset	20495,#3
 797                     ; 319 						segnalazioneAccensione();
 799  02c4 cd0000        	call	_segnalazioneAccensione
 801                     ; 320 						statoDispositivo = ACCESO;
 803  02c7 35010010      	mov	_statoDispositivo,#1
 804  02cb               L332:
 805                     ; 322 					contatoreLunghezzaPressione = 0;
 807  02cb 5f            	clrw	x
 808  02cc bf01          	ldw	_contatoreLunghezzaPressione,x
 809  02ce ac1a001a      	jpf	L55
1325                     	xdef	_main
1326                     	xdef	_nonConsiderare
1327                     	xdef	_sensoreAttivo
1328                     	xdef	_oneShotPulsante
1329                     	xdef	_statoDispositivo
1330                     	switch	.ubsct
1331  0000               ___flaggami:
1332  0000 00            	ds.b	1
1333                     	xdef	___flaggami
1334  0001               _contatoreLunghezzaPressione:
1335  0001 0000          	ds.b	2
1336                     	xdef	_contatoreLunghezzaPressione
1337  0003               _supportoDelayBloccante:
1338  0003 00000000      	ds.b	4
1339                     	xdef	_supportoDelayBloccante
1340                     	xdef	_statoPulsante
1341                     	xdef	_countInputBS
1342                     	xdef	_countInputFC
1343                     	xdef	_countInputIC
1344                     	xdef	_countInputB
1345                     	xdef	_batteriaScaricaSignalled
1346  0007               _fineCaricaSignalled:
1347  0007 00            	ds.b	1
1348                     	xdef	_fineCaricaSignalled
1349  0008               _inizioCaricaSignalled:
1350  0008 00            	ds.b	1
1351                     	xdef	_inizioCaricaSignalled
1352                     	xdef	_flagBatteriaScarica_prec
1353                     	xdef	_flagBatteriaScarica
1354                     	xdef	_fineCarica
1355                     	xdef	_fineCarica_prec
1356  0009               _inizioCarica:
1357  0009 00            	ds.b	1
1358                     	xdef	_inizioCarica
1359  000a               _buzzer:
1360  000a 000000000000  	ds.b	46
1361                     	xdef	_buzzer
1362                     	xdef	_oneShotDrive
1363                     	xdef	_statoPulsante_prec
1364  0038               _priorita:
1365  0038 00            	ds.b	1
1366                     	xdef	_priorita
1367  0039               _distanze:
1368  0039 000000000000  	ds.b	8
1369                     	xdef	_distanze
1370  0041               _totalTicks:
1371  0041 00000000      	ds.b	4
1372                     	xdef	_totalTicks
1373                     	xdef	_stateMachineSensor
1374  0045               _tmp:
1375  0045 0000          	ds.b	2
1376                     	xdef	_tmp
1377  0047               _pulses:
1378  0047 0000          	ds.b	2
1379                     	xdef	_pulses
1380  0049               _startCountPulses:
1381  0049 00            	ds.b	1
1382                     	xdef	_startCountPulses
1383                     	xdef	_countPulsante
1384                     	xdef	_pulsante
1385  004a               _setPoint:
1386  004a 0000          	ds.b	2
1387                     	xdef	_setPoint
1388  004c               _flagElapsed:
1389  004c 00            	ds.b	1
1390                     	xdef	_flagElapsed
1391  004d               _adcValues:
1392  004d 00000000      	ds.b	4
1393                     	xdef	_adcValues
1394                     	xref	_buzzerInit
1395                     	xref	_timInit
1396                     	xref	_clockInit
1397                     	xref	_analogRead
1398                     	xref	_analogInit
1399                     	xref	_segnalazioneOstacolo
1400                     	xref	_debounceTasto
1401                     	xref	_debounceBatteriaScarica
1402                     	xref	_debounceFineCarica
1403                     	xref	_debounceInizioCarica
1404                     	xref	_segnalazioneBatteriaScarica
1405                     	xref	_segnalazioneFineCarica
1406                     	xref	_segnalazioneInizioCarica
1407                     	xref	_segnalazioneAccensione
1408                     	xref	_segnalazioneSpegnimento
1409                     	xref	_gpioInit
1429                     	end
