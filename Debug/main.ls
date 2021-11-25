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
  21  0004               _flagBatteriaScarica:
  22  0004 00            	dc.b	0
  23  0005               _statoPulsante:
  24  0005 00            	dc.b	0
  25  0006               _statoPulsante_prec:
  26  0006 00            	dc.b	0
  27  0007               _oneShotDrive:
  28  0007 00            	dc.b	0
  29  0008               _countInput:
  30  0008 00            	dc.b	0
  31  0009               _statoDispositivo:
  32  0009 00            	dc.b	0
  33  000a               _oneShotPulsante:
  34  000a 00            	dc.b	0
  82                     ; 47 main()
  82                     ; 48 {
  84                     	switch	.text
  85  0000               _main:
  89                     ; 50 	disableInterrupts();
  92  0000 9b            sim
  94                     ; 52 	clockInit();
  97  0001 cd0000        	call	_clockInit
  99                     ; 53 	gpioInit();
 101  0004 cd0000        	call	_gpioInit
 103                     ; 54 	analogInit();
 105  0007 cd0000        	call	_analogInit
 107                     ; 55 	timInit();
 109  000a cd0000        	call	_timInit
 111                     ; 56 	buzzerInit();
 113  000d cd0000        	call	_buzzerInit
 115                     ; 59 	enableInterrupts();
 118  0010 9a            rim
 120                     ; 61 	buzzer.countHigh = COUNT_HIGH_2_FREQ; // debug
 123  0011 ae1b58        	ldw	x,#7000
 124  0014 bf0d          	ldw	_buzzer+2,x
 125                     ; 62 	buzzer.countLow = COUNT_LOW_2_FREQ; // debug
 127  0016 ae1b58        	ldw	x,#7000
 128  0019 bf0f          	ldw	_buzzer+4,x
 129                     ; 63 	buzzer.distanceMonitoring = 0; // debug
 131  001b 3f0b          	clr	_buzzer
 132  001d               L33:
 133                     ; 108 		if(flagElapsed)
 135  001d 3d28          	tnz	_flagElapsed
 136  001f 27fc          	jreq	L33
 137                     ; 114 			statoPulsante_prec = statoPulsante;
 139  0021 450506        	mov	_statoPulsante_prec,_statoPulsante
 140                     ; 115 			if((GPIOD->IDR >> 2) & 0x01)
 142  0024 c65010        	ld	a,20496
 143  0027 44            	srl	a
 144  0028 44            	srl	a
 145  0029 5f            	clrw	x
 146  002a a401          	and	a,#1
 147  002c 5f            	clrw	x
 148  002d 5f            	clrw	x
 149  002e 97            	ld	xl,a
 150  002f a30000        	cpw	x,#0
 151  0032 2710          	jreq	L14
 152                     ; 117 				if(countInput < 3)
 154  0034 b608          	ld	a,_countInput
 155  0036 a103          	cp	a,#3
 156  0038 2404          	jruge	L34
 157                     ; 118 					countInput++;
 159  003a 3c08          	inc	_countInput
 161  003c 2010          	jra	L74
 162  003e               L34:
 163                     ; 120 					statoPulsante = 1;
 165  003e 35010005      	mov	_statoPulsante,#1
 166  0042 200a          	jra	L74
 167  0044               L14:
 168                     ; 126 				if(countInput > 0)
 170  0044 3d08          	tnz	_countInput
 171  0046 2704          	jreq	L15
 172                     ; 127 					countInput--;
 174  0048 3a08          	dec	_countInput
 176  004a 2002          	jra	L74
 177  004c               L15:
 178                     ; 129 					statoPulsante = 0;
 180  004c 3f05          	clr	_statoPulsante
 181  004e               L74:
 182                     ; 135 				if((!statoPulsante_prec) && (statoPulsante))
 184  004e 3d06          	tnz	_statoPulsante_prec
 185  0050 2609          	jrne	L55
 187  0052 3d05          	tnz	_statoPulsante
 188  0054 2705          	jreq	L55
 189                     ; 138 					contatoreLunghezzaPressione = 0;
 191  0056 5f            	clrw	x
 192  0057 bf01          	ldw	_contatoreLunghezzaPressione,x
 194  0059 202e          	jra	L75
 195  005b               L55:
 196                     ; 141 				else if((statoPulsante_prec) && (!statoPulsante))
 198  005b 3d06          	tnz	_statoPulsante_prec
 199  005d 272a          	jreq	L75
 201  005f 3d05          	tnz	_statoPulsante
 202  0061 2626          	jrne	L75
 203                     ; 144 					if(statoDispositivo == ACCESO) // da acceso lo spengo
 205  0063 b609          	ld	a,_statoDispositivo
 206  0065 a101          	cp	a,#1
 207  0067 2612          	jrne	L36
 208                     ; 146 						if(contatoreLunghezzaPressione > 10)// questi sono 1 sec
 210  0069 be01          	ldw	x,_contatoreLunghezzaPressione
 211  006b a3000b        	cpw	x,#11
 212  006e 2516          	jrult	L76
 213                     ; 148 							statoDispositivo = SPENTO;
 215  0070 3f09          	clr	_statoDispositivo
 216                     ; 149 							segnalazioneSpegnimento();
 218  0072 cd0000        	call	_segnalazioneSpegnimento
 220                     ; 150 							GPIOD->ODR &= ~DRIVE_ON;
 222  0075 7217500f      	bres	20495,#3
 223  0079 200b          	jra	L76
 224  007b               L36:
 225                     ; 156 						GPIOD->ODR |= DRIVE_ON;
 227  007b 7216500f      	bset	20495,#3
 228                     ; 157 						segnalazioneAccensione();
 230  007f cd0000        	call	_segnalazioneAccensione
 232                     ; 158 						statoDispositivo = ACCESO;
 234  0082 35010009      	mov	_statoDispositivo,#1
 235  0086               L76:
 236                     ; 160 					contatoreLunghezzaPressione = 0;
 238  0086 5f            	clrw	x
 239  0087 bf01          	ldw	_contatoreLunghezzaPressione,x
 240  0089               L75:
 241                     ; 166 			switch(stateMachineSensor)
 243  0089 b603          	ld	a,_stateMachineSensor
 245                     ; 202 				default:break;
 246  008b 4a            	dec	a
 247  008c 2711          	jreq	L3
 248  008e 4a            	dec	a
 249  008f 274a          	jreq	L11
 250  0091 4a            	dec	a
 251  0092 271f          	jreq	L5
 252  0094 4a            	dec	a
 253  0095 2744          	jreq	L11
 254  0097 4a            	dec	a
 255  0098 272d          	jreq	L7
 256  009a 4a            	dec	a
 257  009b 273e          	jreq	L11
 258  009d 2048          	jra	L37
 259  009f               L3:
 260                     ; 168 				case START_MEASURE_1SENSOR: // impulso da 10 micro
 260                     ; 169 					GPIOC->ODR |= SENSOR1_TRIGGER_ON;
 262  009f 7218500a      	bset	20490,#4
 263                     ; 170 				aspetta(1);
 265  00a3 ae0001        	ldw	x,#1
 266  00a6 cd0000        	call	_aspetta
 268                     ; 171 					GPIOC->ODR &= (~SENSOR1_TRIGGER_ON);
 270  00a9 7219500a      	bres	20490,#4
 271                     ; 172 					stateMachineSensor = START_MEASURE_1SENSOR; // debug
 273  00ad 35010003      	mov	_stateMachineSensor,#1
 274                     ; 173 					break; // debug
 276  00b1 2034          	jra	L37
 277  00b3               L5:
 278                     ; 177 				case START_MEASURE_2SENSOR: // impulso da 10 micro
 278                     ; 178 					GPIOC->ODR |= SENSOR2_TRIGGER_ON;
 281  00b3 721a500a      	bset	20490,#5
 282                     ; 179 					aspetta(1);
 284  00b7 ae0001        	ldw	x,#1
 285  00ba cd0000        	call	_aspetta
 287                     ; 180 					GPIOC->ODR &= (~SENSOR2_TRIGGER_ON);
 289  00bd 721b500a      	bres	20490,#5
 290                     ; 182 					startCountPulses = 1;
 292  00c1 35010026      	mov	_startCountPulses,#1
 293                     ; 183 					break;
 295  00c5 2020          	jra	L37
 296  00c7               L7:
 297                     ; 184 				case START_MEASURE_3SENSOR: // impulso da 10 micro
 297                     ; 185 					GPIOC->ODR |= SENSOR3_TRIGGER_ON;
 299  00c7 721c500a      	bset	20490,#6
 300                     ; 186 					aspetta(1);
 302  00cb ae0001        	ldw	x,#1
 303  00ce cd0000        	call	_aspetta
 305                     ; 187 					GPIOC->ODR &= (~SENSOR3_TRIGGER_ON);
 307  00d1 721d500a      	bres	20490,#6
 308                     ; 189 					startCountPulses = 1;
 310  00d5 35010026      	mov	_startCountPulses,#1
 311                     ; 190 				break;
 313  00d9 200c          	jra	L37
 314  00db               L11:
 315                     ; 194 				case END_MEASURE_1SENSOR:
 315                     ; 195 				case END_MEASURE_2SENSOR:
 315                     ; 196 				case END_MEASURE_3SENSOR:
 315                     ; 197 				stateMachineSensor++;
 317  00db 3c03          	inc	_stateMachineSensor
 318                     ; 198 				if(stateMachineSensor > END_MEASURE_3SENSOR)
 320  00dd b603          	ld	a,_stateMachineSensor
 321  00df a107          	cp	a,#7
 322  00e1 2504          	jrult	L37
 323                     ; 199 					stateMachineSensor = START_MEASURE_1SENSOR;
 325  00e3 35010003      	mov	_stateMachineSensor,#1
 326  00e7               L31:
 327                     ; 202 				default:break;
 329  00e7               L37:
 330                     ; 303 			flagElapsed = 0; 
 332  00e7 3f28          	clr	_flagElapsed
 333  00e9 ac1d001d      	jpf	L33
 704                     	xdef	_main
 705                     	xdef	_oneShotPulsante
 706                     	xdef	_statoDispositivo
 707                     	switch	.ubsct
 708  0000               ___flaggami:
 709  0000 00            	ds.b	1
 710                     	xdef	___flaggami
 711                     	xdef	_countInput
 712  0001               _contatoreLunghezzaPressione:
 713  0001 0000          	ds.b	2
 714                     	xdef	_contatoreLunghezzaPressione
 715  0003               _supportoDelayBloccante:
 716  0003 00000000      	ds.b	4
 717                     	xdef	_supportoDelayBloccante
 718  0007               _fineCaricaSignalled:
 719  0007 00            	ds.b	1
 720                     	xdef	_fineCaricaSignalled
 721  0008               _inizioCaricaSignalled:
 722  0008 00            	ds.b	1
 723                     	xdef	_inizioCaricaSignalled
 724  0009               _fineCarica:
 725  0009 00            	ds.b	1
 726                     	xdef	_fineCarica
 727  000a               _inizioCarica:
 728  000a 00            	ds.b	1
 729                     	xdef	_inizioCarica
 730  000b               _buzzer:
 731  000b 000000000000  	ds.b	10
 732                     	xdef	_buzzer
 733                     	xdef	_oneShotDrive
 734                     	xdef	_statoPulsante_prec
 735                     	xdef	_statoPulsante
 736                     	xdef	_flagBatteriaScarica
 737  0015               _priorita:
 738  0015 00            	ds.b	1
 739                     	xdef	_priorita
 740  0016               _distanze:
 741  0016 000000000000  	ds.b	6
 742                     	xdef	_distanze
 743  001c               _totalTicks:
 744  001c 00000000      	ds.b	4
 745                     	xdef	_totalTicks
 746                     	xdef	_stateMachineSensor
 747  0020               _tmp:
 748  0020 0000          	ds.b	2
 749                     	xdef	_tmp
 750  0022               _pulses:
 751  0022 00000000      	ds.b	4
 752                     	xdef	_pulses
 753  0026               _startCountPulses:
 754  0026 00            	ds.b	1
 755                     	xdef	_startCountPulses
 756                     	xdef	_countPulsante
 757                     	xdef	_pulsante
 758  0027               _setPoint:
 759  0027 00            	ds.b	1
 760                     	xdef	_setPoint
 761  0028               _flagElapsed:
 762  0028 00            	ds.b	1
 763                     	xdef	_flagElapsed
 764  0029               _adcValues:
 765  0029 00000000      	ds.b	4
 766                     	xdef	_adcValues
 767                     	xref	_buzzerInit
 768                     	xref	_aspetta
 769                     	xref	_timInit
 770                     	xref	_clockInit
 771                     	xref	_analogInit
 772                     	xref	_segnalazioneAccensione
 773                     	xref	_segnalazioneSpegnimento
 774                     	xref	_gpioInit
 794                     	end
