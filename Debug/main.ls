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
 132                     ; 56 main()
 132                     ; 57 {
 134                     	switch	.text
 135  0000               _main:
 137  0000 520a          	subw	sp,#10
 138       0000000a      OFST:	set	10
 141                     ; 60 	disableInterrupts();
 144  0002 9b            sim
 146                     ; 62 	clockInit();
 149  0003 cd0000        	call	_clockInit
 151                     ; 63 	gpioInit();
 153  0006 cd0000        	call	_gpioInit
 155                     ; 64 	analogInit();
 157  0009 cd0000        	call	_analogInit
 159                     ; 65 	timInit();
 161  000c cd0000        	call	_timInit
 163                     ; 66 	buzzerInit();
 165  000f cd0000        	call	_buzzerInit
 167                     ; 69 	enableInterrupts();
 170  0012 9a            rim
 172                     ; 72 	GPIOD->ODR |= DRIVE_ON;
 175  0013 7216500f      	bset	20495,#3
 176                     ; 73 	segnalazioneAccensione();
 178  0017 cd0000        	call	_segnalazioneAccensione
 180  001a               L74:
 181                     ; 95 		if(flagElapsed)
 183  001a 3d4f          	tnz	_flagElapsed
 184  001c 27fc          	jreq	L74
 185                     ; 97 			flagElapsed = 0;
 187  001e 3f4f          	clr	_flagElapsed
 188                     ; 99 			analogRead();
 190  0020 cd0000        	call	_analogRead
 192                     ; 100 			setPoint = checkSetPoint();
 194  0023 cd0000        	call	_checkSetPoint
 196  0026 bf4d          	ldw	_setPoint,x
 197                     ; 105 			switch(stateMachineSensor)
 199  0028 b603          	ld	a,_stateMachineSensor
 201                     ; 235 				default:break;
 202  002a 4a            	dec	a
 203  002b 2716          	jreq	L5
 204  002d 4a            	dec	a
 205  002e 2603cc00b2    	jreq	L31
 206  0033 4a            	dec	a
 207  0034 2732          	jreq	L7
 208  0036 4a            	dec	a
 209  0037 2779          	jreq	L31
 210  0039 4a            	dec	a
 211  003a 2751          	jreq	L11
 212  003c 4a            	dec	a
 213  003d 2773          	jreq	L31
 214  003f ac460246      	jpf	L75
 215  0043               L5:
 216                     ; 107 				case START_MEASURE_1SENSOR: // impulso 
 216                     ; 108 				// start
 216                     ; 109 				pulses = 0;
 218  0043 5f            	clrw	x
 219  0044 bf4a          	ldw	_pulses,x
 220                     ; 110 				startCountPulses = 1;
 222  0046 3501004c      	mov	_startCountPulses,#1
 223                     ; 111 					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
 225  004a 7216500a      	bset	20490,#3
 226                     ; 112 					for(i = 0;i < 15;i++);
 228  004e 5f            	clrw	x
 229  004f 1f09          	ldw	(OFST-1,sp),x
 231  0051               L16:
 235  0051 1e09          	ldw	x,(OFST-1,sp)
 236  0053 1c0001        	addw	x,#1
 237  0056 1f09          	ldw	(OFST-1,sp),x
 241  0058 9c            	rvf
 242  0059 1e09          	ldw	x,(OFST-1,sp)
 243  005b a3000f        	cpw	x,#15
 244  005e 2ff1          	jrslt	L16
 245                     ; 113 					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
 247  0060 7217500a      	bres	20490,#3
 248                     ; 114 					break;
 250  0064 ac460246      	jpf	L75
 251  0068               L7:
 252                     ; 115 				case START_MEASURE_2SENSOR: // impulso
 252                     ; 116 				// start
 252                     ; 117 					pulses = 0;
 254  0068 5f            	clrw	x
 255  0069 bf4a          	ldw	_pulses,x
 256                     ; 118 					startCountPulses = 1;
 258  006b 3501004c      	mov	_startCountPulses,#1
 259                     ; 119 					GPIOC->ODR |= SENSOR2_TRIGGER_ON;
 261  006f 721a500a      	bset	20490,#5
 262                     ; 120 					for(i = 0;i < 15;i++);
 264  0073 5f            	clrw	x
 265  0074 1f09          	ldw	(OFST-1,sp),x
 267  0076               L76:
 271  0076 1e09          	ldw	x,(OFST-1,sp)
 272  0078 1c0001        	addw	x,#1
 273  007b 1f09          	ldw	(OFST-1,sp),x
 277  007d 9c            	rvf
 278  007e 1e09          	ldw	x,(OFST-1,sp)
 279  0080 a3000f        	cpw	x,#15
 280  0083 2ff1          	jrslt	L76
 281                     ; 121 					GPIOC->ODR &= (~SENSOR2_TRIGGER_ON);
 283  0085 721b500a      	bres	20490,#5
 284                     ; 124 					break;
 286  0089 ac460246      	jpf	L75
 287  008d               L11:
 288                     ; 125 				case START_MEASURE_3SENSOR: // impulso
 288                     ; 126 				// start
 288                     ; 127 					pulses = 0;
 290  008d 5f            	clrw	x
 291  008e bf4a          	ldw	_pulses,x
 292                     ; 128 					startCountPulses = 1;
 294  0090 3501004c      	mov	_startCountPulses,#1
 295                     ; 129 					GPIOC->ODR |= SENSOR3_TRIGGER_ON;
 297  0094 721c500a      	bset	20490,#6
 298                     ; 130 					for(i = 0;i < 15;i++);
 300  0098 5f            	clrw	x
 301  0099 1f09          	ldw	(OFST-1,sp),x
 303  009b               L57:
 307  009b 1e09          	ldw	x,(OFST-1,sp)
 308  009d 1c0001        	addw	x,#1
 309  00a0 1f09          	ldw	(OFST-1,sp),x
 313  00a2 9c            	rvf
 314  00a3 1e09          	ldw	x,(OFST-1,sp)
 315  00a5 a3000f        	cpw	x,#15
 316  00a8 2ff1          	jrslt	L57
 317                     ; 131 					GPIOC->ODR &= (~SENSOR3_TRIGGER_ON);
 319  00aa 721d500a      	bres	20490,#6
 320                     ; 133 				break;
 322  00ae ac460246      	jpf	L75
 323  00b2               L31:
 324                     ; 137 				case END_MEASURE_1SENSOR:
 324                     ; 138 				case END_MEASURE_2SENSOR:
 324                     ; 139 				case END_MEASURE_3SENSOR:
 324                     ; 140 				
 324                     ; 141 				if(stateMachineSensor == END_MEASURE_3SENSOR)
 326  00b2 b603          	ld	a,_stateMachineSensor
 327  00b4 a106          	cp	a,#6
 328  00b6 2703          	jreq	L6
 329  00b8 cc0244        	jp	L301
 330  00bb               L6:
 331                     ; 143 					stateMachineSensor = START_MEASURE_1SENSOR;
 333  00bb 35010003      	mov	_stateMachineSensor,#1
 334                     ; 144 					distanze.minima = 9999;
 336  00bf ae270f        	ldw	x,#9999
 337  00c2 bf42          	ldw	_distanze+8,x
 338                     ; 145 					distanze.massima = 0;
 340  00c4 5f            	clrw	x
 341  00c5 bf40          	ldw	_distanze+6,x
 342                     ; 146 					sensoreAttivo = 0;
 344  00c7 5f            	clrw	x
 345  00c8 bf11          	ldw	_sensoreAttivo,x
 346                     ; 147 					if((distanze.d1 < setPoint) && (distanze.d1 >= MIN_DIST_SENS_ALTO	)) // legge solo se < 1.4m
 348  00ca be3a          	ldw	x,_distanze
 349  00cc b34d          	cpw	x,_setPoint
 350  00ce 2412          	jruge	L501
 352  00d0 be3a          	ldw	x,_distanze
 353  00d2 a30007        	cpw	x,#7
 354  00d5 250b          	jrult	L501
 355                     ; 149 						distanzeArray[0] = distanze.d1;
 357  00d7 be3a          	ldw	x,_distanze
 358  00d9 1f03          	ldw	(OFST-7,sp),x
 360                     ; 150 						sensoreAttivo = 1;
 362  00db ae0001        	ldw	x,#1
 363  00de bf11          	ldw	_sensoreAttivo,x
 365  00e0 2005          	jra	L701
 366  00e2               L501:
 367                     ; 153 						distanzeArray[0] = 9999;
 369  00e2 ae270f        	ldw	x,#9999
 370  00e5 1f03          	ldw	(OFST-7,sp),x
 372  00e7               L701:
 373                     ; 155 					if(distanze.d2 < 20) // legge solo se < 1.4m
 375  00e7 be3c          	ldw	x,_distanze+2
 376  00e9 a30014        	cpw	x,#20
 377  00ec 240b          	jruge	L111
 378                     ; 157 						distanzeArray[1] = distanze.d2;
 380  00ee be3c          	ldw	x,_distanze+2
 381  00f0 1f05          	ldw	(OFST-5,sp),x
 383                     ; 158 						sensoreAttivo = 2;
 385  00f2 ae0002        	ldw	x,#2
 386  00f5 bf11          	ldw	_sensoreAttivo,x
 388  00f7 2005          	jra	L311
 389  00f9               L111:
 390                     ; 161 						distanzeArray[1] = 9999;
 392  00f9 ae270f        	ldw	x,#9999
 393  00fc 1f05          	ldw	(OFST-5,sp),x
 395  00fe               L311:
 396                     ; 163 						if(distanze.d3 < 20) // legge solo se < soglia
 398  00fe be3e          	ldw	x,_distanze+4
 399  0100 a30014        	cpw	x,#20
 400  0103 240b          	jruge	L511
 401                     ; 165 						distanzeArray[2] = distanze.d3;
 403  0105 be3e          	ldw	x,_distanze+4
 404  0107 1f07          	ldw	(OFST-3,sp),x
 406                     ; 166 						sensoreAttivo = 3;
 408  0109 ae0003        	ldw	x,#3
 409  010c bf11          	ldw	_sensoreAttivo,x
 411  010e 2005          	jra	L711
 412  0110               L511:
 413                     ; 169 						distanzeArray[2] = 9999;
 415  0110 ae270f        	ldw	x,#9999
 416  0113 1f07          	ldw	(OFST-3,sp),x
 418  0115               L711:
 419                     ; 172 					for(i=0;i<3;i++)
 421  0115 5f            	clrw	x
 422  0116 1f09          	ldw	(OFST-1,sp),x
 424  0118               L121:
 425                     ; 174 						if((distanzeArray[i] < distanze.minima) && (distanzeArray[i] >= MIN_DIST_SENS_ALTO))
 427  0118 96            	ldw	x,sp
 428  0119 1c0003        	addw	x,#OFST-7
 429  011c 1f01          	ldw	(OFST-9,sp),x
 431  011e 1e09          	ldw	x,(OFST-1,sp)
 432  0120 58            	sllw	x
 433  0121 72fb01        	addw	x,(OFST-9,sp)
 434  0124 9093          	ldw	y,x
 435  0126 90fe          	ldw	y,(y)
 436  0128 90b342        	cpw	y,_distanze+8
 437  012b 2425          	jruge	L721
 439  012d 96            	ldw	x,sp
 440  012e 1c0003        	addw	x,#OFST-7
 441  0131 1f01          	ldw	(OFST-9,sp),x
 443  0133 1e09          	ldw	x,(OFST-1,sp)
 444  0135 58            	sllw	x
 445  0136 72fb01        	addw	x,(OFST-9,sp)
 446  0139 9093          	ldw	y,x
 447  013b 90fe          	ldw	y,(y)
 448  013d 90a30007      	cpw	y,#7
 449  0141 250f          	jrult	L721
 450                     ; 175 							distanze.minima = distanzeArray[i];
 452  0143 96            	ldw	x,sp
 453  0144 1c0003        	addw	x,#OFST-7
 454  0147 1f01          	ldw	(OFST-9,sp),x
 456  0149 1e09          	ldw	x,(OFST-1,sp)
 457  014b 58            	sllw	x
 458  014c 72fb01        	addw	x,(OFST-9,sp)
 459  014f fe            	ldw	x,(x)
 460  0150 bf42          	ldw	_distanze+8,x
 461  0152               L721:
 462                     ; 177 						if(distanzeArray[i] > distanze.massima)
 464  0152 96            	ldw	x,sp
 465  0153 1c0003        	addw	x,#OFST-7
 466  0156 1f01          	ldw	(OFST-9,sp),x
 468  0158 1e09          	ldw	x,(OFST-1,sp)
 469  015a 58            	sllw	x
 470  015b 72fb01        	addw	x,(OFST-9,sp)
 471  015e 9093          	ldw	y,x
 472  0160 90fe          	ldw	y,(y)
 473  0162 90b340        	cpw	y,_distanze+6
 474  0165 230f          	jrule	L131
 475                     ; 178 							distanze.massima = distanzeArray[i];
 477  0167 96            	ldw	x,sp
 478  0168 1c0003        	addw	x,#OFST-7
 479  016b 1f01          	ldw	(OFST-9,sp),x
 481  016d 1e09          	ldw	x,(OFST-1,sp)
 482  016f 58            	sllw	x
 483  0170 72fb01        	addw	x,(OFST-9,sp)
 484  0173 fe            	ldw	x,(x)
 485  0174 bf40          	ldw	_distanze+6,x
 486  0176               L131:
 487                     ; 172 					for(i=0;i<3;i++)
 489  0176 1e09          	ldw	x,(OFST-1,sp)
 490  0178 1c0001        	addw	x,#1
 491  017b 1f09          	ldw	(OFST-1,sp),x
 495  017d 9c            	rvf
 496  017e 1e09          	ldw	x,(OFST-1,sp)
 497  0180 a30003        	cpw	x,#3
 498  0183 2f93          	jrslt	L121
 499                     ; 180 				nonConsiderare = 0;
 501  0185 3f13          	clr	_nonConsiderare
 502                     ; 181 							if((distanze.minima < SOGLIA_ALLARME_SENSORE_ALTO) // maggiore di 30cm
 502                     ; 182 							&& (distanze.minima >= SOGLIA_ALLARME_SENSORE_ALTO_TH1))
 504  0187 be42          	ldw	x,_distanze+8
 505  0189 a30017        	cpw	x,#23
 506  018c 2442          	jruge	L331
 508  018e be42          	ldw	x,_distanze+8
 509  0190 a30011        	cpw	x,#17
 510  0193 253b          	jrult	L331
 511                     ; 184 								if(sensoreAttivo == 3) // è un esterno
 513  0195 be11          	ldw	x,_sensoreAttivo
 514  0197 a30003        	cpw	x,#3
 515  019a 2612          	jrne	L531
 516                     ; 185 									segnalazioneOstacolo(200,1,3);
 518  019c ae0003        	ldw	x,#3
 519  019f 89            	pushw	x
 520  01a0 ae0001        	ldw	x,#1
 521  01a3 89            	pushw	x
 522  01a4 ae00c8        	ldw	x,#200
 523  01a7 cd0000        	call	_segnalazioneOstacolo
 525  01aa 5b04          	addw	sp,#4
 527  01ac 2060          	jra	L741
 528  01ae               L531:
 529                     ; 186 						else if(sensoreAttivo == 2) // è l'altro esterno
 531  01ae be11          	ldw	x,_sensoreAttivo
 532  01b0 a30002        	cpw	x,#2
 533  01b3 2612          	jrne	L141
 534                     ; 188 								segnalazioneOstacolo(200,1,5);
 536  01b5 ae0005        	ldw	x,#5
 537  01b8 89            	pushw	x
 538  01b9 ae0001        	ldw	x,#1
 539  01bc 89            	pushw	x
 540  01bd ae00c8        	ldw	x,#200
 541  01c0 cd0000        	call	_segnalazioneOstacolo
 543  01c3 5b04          	addw	sp,#4
 545  01c5 2047          	jra	L741
 546  01c7               L141:
 547                     ; 190 						else if(sensoreAttivo == 1) 
 549  01c7 be11          	ldw	x,_sensoreAttivo
 550  01c9 a30001        	cpw	x,#1
 551  01cc 2640          	jrne	L741
 552  01ce 203e          	jra	L741
 553  01d0               L331:
 554                     ; 199 						else if((distanze.minima < SOGLIA_ALLARME_SENSORE_ALTO_TH1) // maggiore di 30cm
 554                     ; 200 						&& (distanze.minima >= SOGLIA_ALLARME_SENSORE_ALTO_TH2))
 556  01d0 be42          	ldw	x,_distanze+8
 557  01d2 a30011        	cpw	x,#17
 558  01d5 2419          	jruge	L151
 560  01d7 be42          	ldw	x,_distanze+8
 561  01d9 a3000c        	cpw	x,#12
 562  01dc 2512          	jrult	L151
 563                     ; 202 							nonConsiderare = 1;
 565  01de 35010013      	mov	_nonConsiderare,#1
 566                     ; 203 							segnalazioneOstacolo(1200,0,0);
 568  01e2 5f            	clrw	x
 569  01e3 89            	pushw	x
 570  01e4 5f            	clrw	x
 571  01e5 89            	pushw	x
 572  01e6 ae04b0        	ldw	x,#1200
 573  01e9 cd0000        	call	_segnalazioneOstacolo
 575  01ec 5b04          	addw	sp,#4
 577  01ee 201e          	jra	L741
 578  01f0               L151:
 579                     ; 206 						else if((distanze.minima < SOGLIA_ALLARME_SENSORE_ALTO_TH2) // maggiore di 30cm
 579                     ; 207 						&& (distanze.minima >= MIN_DIST_SENS_ALTO))
 581  01f0 be42          	ldw	x,_distanze+8
 582  01f2 a3000c        	cpw	x,#12
 583  01f5 2417          	jruge	L741
 585  01f7 be42          	ldw	x,_distanze+8
 586  01f9 a30007        	cpw	x,#7
 587  01fc 2510          	jrult	L741
 588                     ; 209 							nonConsiderare = 1;
 590  01fe 35010013      	mov	_nonConsiderare,#1
 591                     ; 210 							segnalazioneOstacolo(1200,0,0);
 593  0202 5f            	clrw	x
 594  0203 89            	pushw	x
 595  0204 5f            	clrw	x
 596  0205 89            	pushw	x
 597  0206 ae04b0        	ldw	x,#1200
 598  0209 cd0000        	call	_segnalazioneOstacolo
 600  020c 5b04          	addw	sp,#4
 601  020e               L741:
 602                     ; 214 						if((sensoreAttivo == 1) && 
 602                     ; 215 						(distanze.minima > MIN_DIST_SENS_ALTO) && 
 602                     ; 216 						(distanze.minima < setPoint) &&
 602                     ; 217 						(nonConsiderare == 0))
 604  020e be11          	ldw	x,_sensoreAttivo
 605  0210 a30001        	cpw	x,#1
 606  0213 2631          	jrne	L75
 608  0215 be42          	ldw	x,_distanze+8
 609  0217 a30008        	cpw	x,#8
 610  021a 252a          	jrult	L75
 612  021c be42          	ldw	x,_distanze+8
 613  021e b34d          	cpw	x,_setPoint
 614  0220 2424          	jruge	L75
 616  0222 3d13          	tnz	_nonConsiderare
 617  0224 2620          	jrne	L75
 618                     ; 219 							segnalazioneOstacolo(100,1,7);
 620  0226 ae0007        	ldw	x,#7
 621  0229 89            	pushw	x
 622  022a ae0001        	ldw	x,#1
 623  022d 89            	pushw	x
 624  022e ae0064        	ldw	x,#100
 625  0231 cd0000        	call	_segnalazioneOstacolo
 627  0234 5b04          	addw	sp,#4
 628                     ; 220 							segnalazioneOstacolo(500,0,0);
 630  0236 5f            	clrw	x
 631  0237 89            	pushw	x
 632  0238 5f            	clrw	x
 633  0239 89            	pushw	x
 634  023a ae01f4        	ldw	x,#500
 635  023d cd0000        	call	_segnalazioneOstacolo
 637  0240 5b04          	addw	sp,#4
 638  0242 2002          	jra	L75
 639  0244               L301:
 640                     ; 232 					stateMachineSensor++;
 642  0244 3c03          	inc	_stateMachineSensor
 643  0246               L51:
 644                     ; 235 				default:break;
 646  0246               L75:
 647                     ; 240 			statoPulsante_prec = statoPulsante;
 649  0246 450c04        	mov	_statoPulsante_prec,_statoPulsante
 650                     ; 241 			debounceTasto();
 652  0249 cd0000        	call	_debounceTasto
 654                     ; 242 			debounceInizioCarica();
 656  024c cd0000        	call	_debounceInizioCarica
 658                     ; 243 			debounceFineCarica();
 660  024f cd0000        	call	_debounceFineCarica
 662                     ; 244 			debounceBatteriaScarica();
 664  0252 cd0000        	call	_debounceBatteriaScarica
 666                     ; 248 			if((inizioCarica) && (!inizioCaricaSignalled))
 668  0255 3d0a          	tnz	_inizioCarica
 669  0257 270a          	jreq	L361
 671  0259 3d08          	tnz	_inizioCaricaSignalled
 672  025b 2606          	jrne	L361
 673                     ; 250 				inizioCaricaSignalled = 0xFF;
 675  025d 35ff0008      	mov	_inizioCaricaSignalled,#255
 677  0261 2006          	jra	L561
 678  0263               L361:
 679                     ; 253 			else if (inizioCarica == 0)
 681  0263 3d0a          	tnz	_inizioCarica
 682  0265 2602          	jrne	L561
 683                     ; 255 				inizioCaricaSignalled = 0;
 685  0267 3f08          	clr	_inizioCaricaSignalled
 686  0269               L561:
 687                     ; 258 			if((fineCarica) && (!fineCaricaSignalled))
 689  0269 3d09          	tnz	_fineCarica
 690  026b 270a          	jreq	L171
 692  026d 3d07          	tnz	_fineCaricaSignalled
 693  026f 2606          	jrne	L171
 694                     ; 261 				fineCaricaSignalled = 0xFF;
 696  0271 35ff0007      	mov	_fineCaricaSignalled,#255
 698  0275 2006          	jra	L371
 699  0277               L171:
 700                     ; 264 			else if (fineCarica == 0)
 702  0277 3d09          	tnz	_fineCarica
 703  0279 2602          	jrne	L371
 704                     ; 266 				fineCaricaSignalled = 0;
 706  027b 3f07          	clr	_fineCaricaSignalled
 707  027d               L371:
 708                     ; 270 			if((flagBatteriaScarica) && (!batteriaScaricaSignalled))
 710  027d 3d06          	tnz	_flagBatteriaScarica
 711  027f 270a          	jreq	L771
 713  0281 3d07          	tnz	_batteriaScaricaSignalled
 714  0283 2606          	jrne	L771
 715                     ; 272 				batteriaScaricaSignalled = 0xFF;
 717  0285 35ff0007      	mov	_batteriaScaricaSignalled,#255
 719  0289 2006          	jra	L102
 720  028b               L771:
 721                     ; 277 			else if(flagBatteriaScarica == 0)
 723  028b 3d06          	tnz	_flagBatteriaScarica
 724  028d 2602          	jrne	L102
 725                     ; 280 					batteriaScaricaSignalled = 0;
 727  028f 3f07          	clr	_batteriaScaricaSignalled
 728  0291               L102:
 729                     ; 287 				if((!statoPulsante_prec) && (statoPulsante))
 731  0291 3d04          	tnz	_statoPulsante_prec
 732  0293 260b          	jrne	L502
 734  0295 3d0c          	tnz	_statoPulsante
 735  0297 2707          	jreq	L502
 736                     ; 290 					contatoreLunghezzaPressione = 0;
 738  0299 5f            	clrw	x
 739  029a bf01          	ldw	_contatoreLunghezzaPressione,x
 741  029c ac1a001a      	jpf	L74
 742  02a0               L502:
 743                     ; 293 				else if((statoPulsante_prec) && (!statoPulsante))
 745  02a0 3d04          	tnz	_statoPulsante_prec
 746  02a2 2603          	jrne	L01
 747  02a4 cc001a        	jp	L74
 748  02a7               L01:
 750  02a7 3d0c          	tnz	_statoPulsante
 751  02a9 2703          	jreq	L21
 752  02ab cc001a        	jp	L74
 753  02ae               L21:
 754                     ; 296 					if(statoDispositivo == ACCESO) // da acceso lo spengo
 756  02ae b60d          	ld	a,_statoDispositivo
 757  02b0 a101          	cp	a,#1
 758  02b2 2612          	jrne	L312
 759                     ; 298 						if(contatoreLunghezzaPressione > 100)
 761  02b4 be01          	ldw	x,_contatoreLunghezzaPressione
 762  02b6 a30065        	cpw	x,#101
 763  02b9 2516          	jrult	L712
 764                     ; 300 							statoDispositivo = SPENTO;
 766  02bb 3f0d          	clr	_statoDispositivo
 767                     ; 301 							segnalazioneSpegnimento();
 769  02bd cd0000        	call	_segnalazioneSpegnimento
 771                     ; 302 							GPIOD->ODR &= ~DRIVE_ON;
 773  02c0 7217500f      	bres	20495,#3
 774  02c4 200b          	jra	L712
 775  02c6               L312:
 776                     ; 307 												GPIOD->ODR |= DRIVE_ON;
 778  02c6 7216500f      	bset	20495,#3
 779                     ; 308 						segnalazioneAccensione();
 781  02ca cd0000        	call	_segnalazioneAccensione
 783                     ; 309 						statoDispositivo = ACCESO;
 785  02cd 3501000d      	mov	_statoDispositivo,#1
 786  02d1               L712:
 787                     ; 311 					contatoreLunghezzaPressione = 0;
 789  02d1 5f            	clrw	x
 790  02d2 bf01          	ldw	_contatoreLunghezzaPressione,x
 791  02d4 ac1a001a      	jpf	L74
1295                     	xdef	_main
1296                     	xdef	_nonConsiderare
1297                     	xdef	_sensoreAttivo
1298                     	xdef	_oneShotPulsante
1299                     	xdef	_statoDispositivo
1300                     	switch	.ubsct
1301  0000               ___flaggami:
1302  0000 00            	ds.b	1
1303                     	xdef	___flaggami
1304  0001               _contatoreLunghezzaPressione:
1305  0001 0000          	ds.b	2
1306                     	xdef	_contatoreLunghezzaPressione
1307  0003               _supportoDelayBloccante:
1308  0003 00000000      	ds.b	4
1309                     	xdef	_supportoDelayBloccante
1310                     	xdef	_statoPulsante
1311                     	xdef	_countInputBS
1312                     	xdef	_countInputFC
1313                     	xdef	_countInputIC
1314                     	xdef	_countInputB
1315                     	xdef	_batteriaScaricaSignalled
1316  0007               _fineCaricaSignalled:
1317  0007 00            	ds.b	1
1318                     	xdef	_fineCaricaSignalled
1319  0008               _inizioCaricaSignalled:
1320  0008 00            	ds.b	1
1321                     	xdef	_inizioCaricaSignalled
1322                     	xdef	_flagBatteriaScarica
1323  0009               _fineCarica:
1324  0009 00            	ds.b	1
1325                     	xdef	_fineCarica
1326  000a               _inizioCarica:
1327  000a 00            	ds.b	1
1328                     	xdef	_inizioCarica
1329  000b               _buzzer:
1330  000b 000000000000  	ds.b	46
1331                     	xdef	_buzzer
1332                     	xdef	_oneShotDrive
1333                     	xdef	_statoPulsante_prec
1334  0039               _priorita:
1335  0039 00            	ds.b	1
1336                     	xdef	_priorita
1337  003a               _distanze:
1338  003a 000000000000  	ds.b	10
1339                     	xdef	_distanze
1340  0044               _totalTicks:
1341  0044 00000000      	ds.b	4
1342                     	xdef	_totalTicks
1343                     	xdef	_stateMachineSensor
1344  0048               _tmp:
1345  0048 0000          	ds.b	2
1346                     	xdef	_tmp
1347  004a               _pulses:
1348  004a 0000          	ds.b	2
1349                     	xdef	_pulses
1350  004c               _startCountPulses:
1351  004c 00            	ds.b	1
1352                     	xdef	_startCountPulses
1353                     	xdef	_countPulsante
1354                     	xdef	_pulsante
1355  004d               _setPoint:
1356  004d 0000          	ds.b	2
1357                     	xdef	_setPoint
1358  004f               _flagElapsed:
1359  004f 00            	ds.b	1
1360                     	xdef	_flagElapsed
1361  0050               _adcValues:
1362  0050 00000000      	ds.b	4
1363                     	xdef	_adcValues
1364                     	xref	_buzzerInit
1365                     	xref	_timInit
1366                     	xref	_clockInit
1367                     	xref	_checkSetPoint
1368                     	xref	_analogRead
1369                     	xref	_analogInit
1370                     	xref	_segnalazioneOstacolo
1371                     	xref	_debounceTasto
1372                     	xref	_debounceBatteriaScarica
1373                     	xref	_debounceFineCarica
1374                     	xref	_debounceInizioCarica
1375                     	xref	_segnalazioneAccensione
1376                     	xref	_segnalazioneSpegnimento
1377                     	xref	_gpioInit
1397                     	end
