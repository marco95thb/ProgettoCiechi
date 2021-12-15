   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  14                     	bsct
  15  0000               _pulsante:
  16  0000 00            	dc.b	0
  17  0001               _countPulsante:
  18  0001 0000          	dc.w	0
  19  0003               _stateMachineSensor:
  20  0003 03            	dc.b	3
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
 104                     ; 55 main()
 104                     ; 56 {
 106                     	switch	.text
 107  0000               _main:
 111                     ; 57 	disableInterrupts();
 114  0000 9b            sim
 116                     ; 59 	clockInit();
 119  0001 cd0000        	call	_clockInit
 121                     ; 60 	gpioInit();
 123  0004 cd0000        	call	_gpioInit
 125                     ; 61 	analogInit();
 127  0007 cd0000        	call	_analogInit
 129                     ; 62 	timInit();
 131  000a cd0000        	call	_timInit
 133                     ; 63 	buzzerInit();
 135  000d cd0000        	call	_buzzerInit
 137                     ; 66 	enableInterrupts();
 140  0010 9a            rim
 142                     ; 69 	GPIOD->ODR |= DRIVE_ON;
 145  0011 7216500f      	bset	20495,#3
 146                     ; 70 	segnalazioneAccensione();
 148  0015 cd0000        	call	_segnalazioneAccensione
 150  0018               L34:
 151                     ; 92 		if(flagElapsed)
 153  0018 3d4a          	tnz	_flagElapsed
 154  001a 27fc          	jreq	L34
 155                     ; 94 			flagElapsed = 0;
 157  001c 3f4a          	clr	_flagElapsed
 158                     ; 111 			switch(stateMachineSensor)
 160  001e b603          	ld	a,_stateMachineSensor
 162                     ; 157 				default:break;
 163  0020 4a            	dec	a
 164  0021 2714          	jreq	L5
 165  0023 4a            	dec	a
 166  0024 2603cc00aa    	jreq	L31
 167  0029 4a            	dec	a
 168  002a 2734          	jreq	L7
 169  002c 4a            	dec	a
 170  002d 277b          	jreq	L31
 171  002f 4a            	dec	a
 172  0030 2753          	jreq	L11
 173  0032 4a            	dec	a
 174  0033 2775          	jreq	L31
 175  0035 207d          	jra	L35
 176  0037               L5:
 177                     ; 113 				case START_MEASURE_1SENSOR: // impulso 
 177                     ; 114 				// start
 177                     ; 115 				pulses = 0;
 179  0037 5f            	clrw	x
 180  0038 bf46          	ldw	_pulses,x
 181                     ; 116 				startCountPulses = 1;
 183  003a 35010048      	mov	_startCountPulses,#1
 184                     ; 117 					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
 186  003e 7216500a      	bset	20490,#3
 187                     ; 118 					for(i = 0;i < 15;i++);
 189  0042 5f            	clrw	x
 190  0043 bf0f          	ldw	L3_i,x
 192  0045 2007          	jra	L16
 193  0047               L55:
 197  0047 be0f          	ldw	x,L3_i
 198  0049 1c0001        	addw	x,#1
 199  004c bf0f          	ldw	L3_i,x
 200  004e               L16:
 203  004e 9c            	rvf
 204  004f be0f          	ldw	x,L3_i
 205  0051 a3000f        	cpw	x,#15
 206  0054 2ff1          	jrslt	L55
 207                     ; 119 					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
 209  0056 7217500a      	bres	20490,#3
 210                     ; 121 				stateMachineSensor = 1;
 212  005a 35010003      	mov	_stateMachineSensor,#1
 213                     ; 122 					break;
 215  005e 2054          	jra	L35
 216  0060               L7:
 217                     ; 123 				case START_MEASURE_2SENSOR: // impulso
 217                     ; 124 				// start
 217                     ; 125 					pulses = 0;
 219  0060 5f            	clrw	x
 220  0061 bf46          	ldw	_pulses,x
 221                     ; 126 					startCountPulses = 1;
 223  0063 35010048      	mov	_startCountPulses,#1
 224                     ; 127 					GPIOC->ODR |= SENSOR2_TRIGGER_ON;
 226  0067 721a500a      	bset	20490,#5
 227                     ; 128 					for(i = 0;i < 15;i++);
 229  006b 5f            	clrw	x
 230  006c bf0f          	ldw	L3_i,x
 232  006e 2007          	jra	L17
 233  0070               L56:
 237  0070 be0f          	ldw	x,L3_i
 238  0072 1c0001        	addw	x,#1
 239  0075 bf0f          	ldw	L3_i,x
 240  0077               L17:
 243  0077 9c            	rvf
 244  0078 be0f          	ldw	x,L3_i
 245  007a a3000f        	cpw	x,#15
 246  007d 2ff1          	jrslt	L56
 247                     ; 129 					GPIOC->ODR &= (~SENSOR2_TRIGGER_ON);
 249  007f 721b500a      	bres	20490,#5
 250                     ; 132 					break;
 252  0083 202f          	jra	L35
 253  0085               L11:
 254                     ; 133 				case START_MEASURE_3SENSOR: // impulso
 254                     ; 134 				// start
 254                     ; 135 					pulses = 0;
 256  0085 5f            	clrw	x
 257  0086 bf46          	ldw	_pulses,x
 258                     ; 136 					startCountPulses = 1;
 260  0088 35010048      	mov	_startCountPulses,#1
 261                     ; 137 					GPIOC->ODR |= SENSOR3_TRIGGER_ON;
 263  008c 721c500a      	bset	20490,#6
 264                     ; 138 					for(i = 0;i < 15;i++);
 266  0090 5f            	clrw	x
 267  0091 bf0f          	ldw	L3_i,x
 269  0093 2007          	jra	L101
 270  0095               L57:
 274  0095 be0f          	ldw	x,L3_i
 275  0097 1c0001        	addw	x,#1
 276  009a bf0f          	ldw	L3_i,x
 277  009c               L101:
 280  009c 9c            	rvf
 281  009d be0f          	ldw	x,L3_i
 282  009f a3000f        	cpw	x,#15
 283  00a2 2ff1          	jrslt	L57
 284                     ; 139 					GPIOC->ODR &= (~SENSOR3_TRIGGER_ON);
 286  00a4 721d500a      	bres	20490,#6
 287                     ; 141 				break;
 289  00a8 200a          	jra	L35
 290  00aa               L31:
 291                     ; 145 				case END_MEASURE_1SENSOR:
 291                     ; 146 				case END_MEASURE_2SENSOR:
 291                     ; 147 				case END_MEASURE_3SENSOR:
 291                     ; 148 				
 291                     ; 149 				if(stateMachineSensor == END_MEASURE_2SENSOR)
 293  00aa b603          	ld	a,_stateMachineSensor
 294  00ac a104          	cp	a,#4
 295  00ae 2604          	jrne	L35
 296                     ; 151 					stateMachineSensor = START_MEASURE_2SENSOR;
 298  00b0 35030003      	mov	_stateMachineSensor,#3
 299  00b4               L51:
 300                     ; 157 				default:break;
 302  00b4               L35:
 303                     ; 163 			if((inizioCarica) && (!inizioCaricaSignalled))
 305  00b4 3d0a          	tnz	_inizioCarica
 306  00b6 270d          	jreq	L701
 308  00b8 3d08          	tnz	_inizioCaricaSignalled
 309  00ba 2609          	jrne	L701
 310                     ; 165 				inizioCaricaSignalled = 0xFF;
 312  00bc 35ff0008      	mov	_inizioCaricaSignalled,#255
 313                     ; 166 				segnalazioneInizioCarica();
 315  00c0 cd0000        	call	_segnalazioneInizioCarica
 318  00c3 2006          	jra	L111
 319  00c5               L701:
 320                     ; 168 			else if (inizioCarica == 0)
 322  00c5 3d0a          	tnz	_inizioCarica
 323  00c7 2602          	jrne	L111
 324                     ; 170 				inizioCaricaSignalled = 0;
 326  00c9 3f08          	clr	_inizioCaricaSignalled
 327  00cb               L111:
 328                     ; 173 			if((fineCarica) && (!fineCaricaSignalled))
 330  00cb 3d09          	tnz	_fineCarica
 331  00cd 270d          	jreq	L511
 333  00cf 3d07          	tnz	_fineCaricaSignalled
 334  00d1 2609          	jrne	L511
 335                     ; 176 				fineCaricaSignalled = 0xFF;
 337  00d3 35ff0007      	mov	_fineCaricaSignalled,#255
 338                     ; 177 				segnalazioneFineCarica();
 340  00d7 cd0000        	call	_segnalazioneFineCarica
 343  00da 2006          	jra	L711
 344  00dc               L511:
 345                     ; 179 			else if (fineCarica == 0)
 347  00dc 3d09          	tnz	_fineCarica
 348  00de 2602          	jrne	L711
 349                     ; 181 				fineCaricaSignalled = 0;
 351  00e0 3f07          	clr	_fineCaricaSignalled
 352  00e2               L711:
 353                     ; 185 			if((flagBatteriaScarica) && (!batteriaScaricaSignalled))
 355  00e2 3d06          	tnz	_flagBatteriaScarica
 356  00e4 270a          	jreq	L321
 358  00e6 3d07          	tnz	_batteriaScaricaSignalled
 359  00e8 2606          	jrne	L321
 360                     ; 187 				batteriaScaricaSignalled = 0xFF;
 362  00ea 35ff0007      	mov	_batteriaScaricaSignalled,#255
 364  00ee 2006          	jra	L521
 365  00f0               L321:
 366                     ; 192 			else if(flagBatteriaScarica == 0)
 368  00f0 3d06          	tnz	_flagBatteriaScarica
 369  00f2 2602          	jrne	L521
 370                     ; 195 					batteriaScaricaSignalled = 0;
 372  00f4 3f07          	clr	_batteriaScaricaSignalled
 373  00f6               L521:
 374                     ; 201 			statoPulsante_prec = statoPulsante;
 376  00f6 450c04        	mov	_statoPulsante_prec,_statoPulsante
 377                     ; 202 			debounceTasto();
 379  00f9 cd0000        	call	_debounceTasto
 381                     ; 207 				if((!statoPulsante_prec) && (statoPulsante))
 383  00fc 3d04          	tnz	_statoPulsante_prec
 384  00fe 2609          	jrne	L131
 386  0100 3d0c          	tnz	_statoPulsante
 387  0102 2705          	jreq	L131
 388                     ; 210 					contatoreLunghezzaPressione = 0;
 390  0104 5f            	clrw	x
 391  0105 bf01          	ldw	_contatoreLunghezzaPressione,x
 393  0107 202e          	jra	L331
 394  0109               L131:
 395                     ; 213 				else if((statoPulsante_prec) && (!statoPulsante))
 397  0109 3d04          	tnz	_statoPulsante_prec
 398  010b 272a          	jreq	L331
 400  010d 3d0c          	tnz	_statoPulsante
 401  010f 2626          	jrne	L331
 402                     ; 216 					if(statoDispositivo == ACCESO) // da acceso lo spengo
 404  0111 b60d          	ld	a,_statoDispositivo
 405  0113 a101          	cp	a,#1
 406  0115 2612          	jrne	L731
 407                     ; 218 						if(contatoreLunghezzaPressione > 100)
 409  0117 be01          	ldw	x,_contatoreLunghezzaPressione
 410  0119 a30065        	cpw	x,#101
 411  011c 2516          	jrult	L341
 412                     ; 220 							statoDispositivo = SPENTO;
 414  011e 3f0d          	clr	_statoDispositivo
 415                     ; 221 							segnalazioneSpegnimento();
 417  0120 cd0000        	call	_segnalazioneSpegnimento
 419                     ; 222 							GPIOD->ODR &= ~DRIVE_ON;
 421  0123 7217500f      	bres	20495,#3
 422  0127 200b          	jra	L341
 423  0129               L731:
 424                     ; 227 												GPIOD->ODR |= DRIVE_ON;
 426  0129 7216500f      	bset	20495,#3
 427                     ; 228 						segnalazioneAccensione();
 429  012d cd0000        	call	_segnalazioneAccensione
 431                     ; 229 						statoDispositivo = ACCESO;
 433  0130 3501000d      	mov	_statoDispositivo,#1
 434  0134               L341:
 435                     ; 231 					contatoreLunghezzaPressione = 0;
 437  0134 5f            	clrw	x
 438  0135 bf01          	ldw	_contatoreLunghezzaPressione,x
 439  0137               L331:
 440                     ; 239 			if((distanze.d1 < distanze.d2) &&
 440                     ; 240 			(distanze.d1 < distanze.d3) &&
 440                     ; 241 			(distanze.d1 >= MIN_DIST_SENS_ALTO))
 442  0137 be3a          	ldw	x,_distanze
 443  0139 b33c          	cpw	x,_distanze+2
 444  013b 2413          	jruge	L541
 446  013d be3a          	ldw	x,_distanze
 447  013f b33e          	cpw	x,_distanze+4
 448  0141 240d          	jruge	L541
 450  0143 be3a          	ldw	x,_distanze
 451  0145 a30007        	cpw	x,#7
 452  0148 2506          	jrult	L541
 453                     ; 242 				priorita = PRIORITA_SENSORE_1; // set priority
 455  014a 35010039      	mov	_priorita,#1
 457  014e 2040          	jra	L741
 458  0150               L541:
 459                     ; 243 			else if((distanze.d3 < distanze.d1) &&
 459                     ; 244 			(distanze.d3 < distanze.d2) &&
 459                     ; 245 			(distanze.d3 >= MIN_DIST_SENS_BASSO))
 461  0150 be3e          	ldw	x,_distanze+4
 462  0152 b33a          	cpw	x,_distanze
 463  0154 2413          	jruge	L151
 465  0156 be3e          	ldw	x,_distanze+4
 466  0158 b33c          	cpw	x,_distanze+2
 467  015a 240d          	jruge	L151
 469  015c be3e          	ldw	x,_distanze+4
 470  015e a30007        	cpw	x,#7
 471  0161 2506          	jrult	L151
 472                     ; 246 				priorita = PRIORITA_SENSORE_3;// set priority
 474  0163 35030039      	mov	_priorita,#3
 476  0167 2027          	jra	L741
 477  0169               L151:
 478                     ; 247 			else if((distanze.d2 < distanze.d1) &&
 478                     ; 248 			(distanze.d2 < distanze.d3) &&
 478                     ; 249 			(distanze.d2 >= MIN_DIST_SENS_MEDIO) &&
 478                     ; 250 			(distanze.d2 < setPoint))
 480  0169 be3c          	ldw	x,_distanze+2
 481  016b b33a          	cpw	x,_distanze
 482  016d 241f          	jruge	L551
 484  016f be3c          	ldw	x,_distanze+2
 485  0171 b33e          	cpw	x,_distanze+4
 486  0173 2419          	jruge	L551
 488  0175 be3c          	ldw	x,_distanze+2
 489  0177 a30007        	cpw	x,#7
 490  017a 2512          	jrult	L551
 492  017c b649          	ld	a,_setPoint
 493  017e 5f            	clrw	x
 494  017f 97            	ld	xl,a
 495  0180 bf00          	ldw	c_x,x
 496  0182 be3c          	ldw	x,_distanze+2
 497  0184 b300          	cpw	x,c_x
 498  0186 2406          	jruge	L551
 499                     ; 251 				priorita = PRIORITA_SENSORE_2;// set priority
 501  0188 35020039      	mov	_priorita,#2
 503  018c 2002          	jra	L741
 504  018e               L551:
 505                     ; 253 				priorita = 0;// set priority
 507  018e 3f39          	clr	_priorita
 508  0190               L741:
 509                     ; 255 				priorita = 0; // così non vado là
 511  0190 3f39          	clr	_priorita
 512                     ; 257 				priorita = PRIORITA_SENSORE_2;
 514  0192 35020039      	mov	_priorita,#2
 515                     ; 262 					switch(priorita)
 517  0196               L12:
 518                     ; 279 						case PRIORITA_SENSORE_2:
 518                     ; 280 						
 518                     ; 281 						if((distanze.d2 < SOGLIA_ALLARME_SENSORE_MEDIO) // maggiore di 30cm
 518                     ; 282 						&& (distanze.d2 >= SOGLIA_ALLARME_SENSORE_MEDIO_TH1))
 520  0196 be3c          	ldw	x,_distanze+2
 521  0198 a30017        	cpw	x,#23
 522  019b 2419          	jruge	L361
 524  019d be3c          	ldw	x,_distanze+2
 525  019f a30011        	cpw	x,#17
 526  01a2 2512          	jrult	L361
 527                     ; 284 						buzzer.distanceMonitoring.enabled = 1;
 529  01a4 3501002c      	mov	_buzzer+33,#1
 530                     ; 285 						buzzer.distanceMonitoring.countHigh = 800;
 532  01a8 ae0320        	ldw	x,#800
 533  01ab bf2d          	ldw	_buzzer+34,x
 534                     ; 286 						buzzer.distanceMonitoring.countLow = 800;
 536  01ad ae0320        	ldw	x,#800
 537  01b0 bf2f          	ldw	_buzzer+36,x
 539  01b2 ac180018      	jpf	L34
 540  01b6               L361:
 541                     ; 289 						else if((distanze.d2 < SOGLIA_ALLARME_SENSORE_MEDIO_TH1) // maggiore di 30cm
 541                     ; 290 						&& (distanze.d2 >= SOGLIA_ALLARME_SENSORE_MEDIO_TH2))
 543  01b6 be3c          	ldw	x,_distanze+2
 544  01b8 a30011        	cpw	x,#17
 545  01bb 2419          	jruge	L761
 547  01bd be3c          	ldw	x,_distanze+2
 548  01bf a3000c        	cpw	x,#12
 549  01c2 2512          	jrult	L761
 550                     ; 292 							buzzer.distanceMonitoring.enabled = 1;
 552  01c4 3501002c      	mov	_buzzer+33,#1
 553                     ; 293 							buzzer.distanceMonitoring.countHigh = 450;
 555  01c8 ae01c2        	ldw	x,#450
 556  01cb bf2d          	ldw	_buzzer+34,x
 557                     ; 294 							buzzer.distanceMonitoring.countLow = 450;
 559  01cd ae01c2        	ldw	x,#450
 560  01d0 bf2f          	ldw	_buzzer+36,x
 562  01d2 ac180018      	jpf	L34
 563  01d6               L761:
 564                     ; 297 						else if((distanze.d2 < SOGLIA_ALLARME_SENSORE_MEDIO_TH2) // maggiore di 30cm
 564                     ; 298 						&& (distanze.d2 >= MIN_DIST_SENS_MEDIO))
 566  01d6 be3c          	ldw	x,_distanze+2
 567  01d8 a3000c        	cpw	x,#12
 568  01db 2419          	jruge	L371
 570  01dd be3c          	ldw	x,_distanze+2
 571  01df a30007        	cpw	x,#7
 572  01e2 2512          	jrult	L371
 573                     ; 300 							buzzer.distanceMonitoring.enabled = 1;
 575  01e4 3501002c      	mov	_buzzer+33,#1
 576                     ; 301 							buzzer.distanceMonitoring.countHigh = 250;
 578  01e8 ae00fa        	ldw	x,#250
 579  01eb bf2d          	ldw	_buzzer+34,x
 580                     ; 302 							buzzer.distanceMonitoring.countLow = 250;
 582  01ed ae00fa        	ldw	x,#250
 583  01f0 bf2f          	ldw	_buzzer+36,x
 585  01f2 ac180018      	jpf	L34
 586  01f6               L371:
 587                     ; 307 							buzzer.distanceMonitoring.enabled = 0;
 589  01f6 3f2c          	clr	_buzzer+33
 590  01f8 ac180018      	jpf	L34
1062                     	xdef	_main
1063                     	xdef	_oneShotPulsante
1064                     	xdef	_statoDispositivo
1065                     	switch	.ubsct
1066  0000               ___flaggami:
1067  0000 00            	ds.b	1
1068                     	xdef	___flaggami
1069  0001               _contatoreLunghezzaPressione:
1070  0001 0000          	ds.b	2
1071                     	xdef	_contatoreLunghezzaPressione
1072  0003               _supportoDelayBloccante:
1073  0003 00000000      	ds.b	4
1074                     	xdef	_supportoDelayBloccante
1075                     	xdef	_statoPulsante
1076                     	xdef	_countInputBS
1077                     	xdef	_countInputFC
1078                     	xdef	_countInputIC
1079                     	xdef	_countInputB
1080                     	xdef	_batteriaScaricaSignalled
1081  0007               _fineCaricaSignalled:
1082  0007 00            	ds.b	1
1083                     	xdef	_fineCaricaSignalled
1084  0008               _inizioCaricaSignalled:
1085  0008 00            	ds.b	1
1086                     	xdef	_inizioCaricaSignalled
1087                     	xdef	_flagBatteriaScarica
1088  0009               _fineCarica:
1089  0009 00            	ds.b	1
1090                     	xdef	_fineCarica
1091  000a               _inizioCarica:
1092  000a 00            	ds.b	1
1093                     	xdef	_inizioCarica
1094  000b               _buzzer:
1095  000b 000000000000  	ds.b	46
1096                     	xdef	_buzzer
1097                     	xdef	_oneShotDrive
1098                     	xdef	_statoPulsante_prec
1099  0039               _priorita:
1100  0039 00            	ds.b	1
1101                     	xdef	_priorita
1102  003a               _distanze:
1103  003a 000000000000  	ds.b	6
1104                     	xdef	_distanze
1105  0040               _totalTicks:
1106  0040 00000000      	ds.b	4
1107                     	xdef	_totalTicks
1108                     	xdef	_stateMachineSensor
1109  0044               _tmp:
1110  0044 0000          	ds.b	2
1111                     	xdef	_tmp
1112  0046               _pulses:
1113  0046 0000          	ds.b	2
1114                     	xdef	_pulses
1115  0048               _startCountPulses:
1116  0048 00            	ds.b	1
1117                     	xdef	_startCountPulses
1118                     	xdef	_countPulsante
1119                     	xdef	_pulsante
1120  0049               _setPoint:
1121  0049 00            	ds.b	1
1122                     	xdef	_setPoint
1123  004a               _flagElapsed:
1124  004a 00            	ds.b	1
1125                     	xdef	_flagElapsed
1126  004b               _adcValues:
1127  004b 00000000      	ds.b	4
1128                     	xdef	_adcValues
1129                     	xref	_buzzerInit
1130                     	xref	_timInit
1131                     	xref	_clockInit
1132                     	xref	_analogInit
1133                     	xref	_debounceTasto
1134                     	xref	_segnalazioneFineCarica
1135                     	xref	_segnalazioneInizioCarica
1136                     	xref	_segnalazioneAccensione
1137                     	xref	_segnalazioneSpegnimento
1138                     	xref	_gpioInit
1139                     	xref.b	c_x
1159                     	end
