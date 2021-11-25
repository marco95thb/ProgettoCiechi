   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  42                     ; 7 void buzzerInit(void)
  42                     ; 8 {
  44                     	switch	.text
  45  0000               _buzzerInit:
  49                     ; 9 		BEEP->CSR &= ~((unsigned char)0x1F);
  51  0000 c650f3        	ld	a,20723
  52  0003 a4e0          	and	a,#224
  53  0005 c750f3        	ld	20723,a
  54                     ; 10     BEEP->CSR |= 0x0B; // default calibration
  56  0008 c650f3        	ld	a,20723
  57  000b aa0b          	or	a,#11
  58  000d c750f3        	ld	20723,a
  59                     ; 13 		BEEP->CSR &= (unsigned char)(~0xC0); // clear
  61  0010 c650f3        	ld	a,20723
  62  0013 a43f          	and	a,#63
  63  0015 c750f3        	ld	20723,a
  64                     ; 14 		BEEP->CSR |= (unsigned char)(0x40); // 2KHz freq
  66  0018 721c50f3      	bset	20723,#6
  67                     ; 17 }
  70  001c 81            	ret
 104                     ; 19 void driveBuzzer(unsigned char sts)
 104                     ; 20 {
 105                     	switch	.text
 106  001d               _driveBuzzer:
 110                     ; 21 	if(sts)
 112  001d 4d            	tnz	a
 113  001e 2706          	jreq	L73
 114                     ; 22 		BEEP->CSR |= 0x20; // on
 116  0020 721a50f3      	bset	20723,#5
 118  0024 2004          	jra	L14
 119  0026               L73:
 120                     ; 24 		BEEP->CSR &= ~(0x20); // off
 122  0026 721b50f3      	bres	20723,#5
 123  002a               L14:
 124                     ; 26 }
 127  002a 81            	ret
 179                     ; 27 void Buzzer_Calibration(unsigned int LSIFreqHz)
 179                     ; 28 {
 180                     	switch	.text
 181  002b               _Buzzer_Calibration:
 183  002b 5206          	subw	sp,#6
 184       00000006      OFST:	set	6
 187                     ; 34   lsifreqkhz = (unsigned short)(LSIFreqHz / 1000); /* Converts value in kHz */
 189  002d 90ae03e8      	ldw	y,#1000
 190  0031 65            	divw	x,y
 191  0032 1f03          	ldw	(OFST-3,sp),x
 193                     ; 38   BEEP->CSR &= (unsigned char)(~0x1F); /* Clear bits */
 195  0034 c650f3        	ld	a,20723
 196  0037 a4e0          	and	a,#224
 197  0039 c750f3        	ld	20723,a
 198                     ; 40   A = (unsigned short)(lsifreqkhz >> 3U); /* Division by 8, keep integer part only */
 200  003c 1e03          	ldw	x,(OFST-3,sp)
 201  003e 54            	srlw	x
 202  003f 54            	srlw	x
 203  0040 54            	srlw	x
 204  0041 1f05          	ldw	(OFST-1,sp),x
 206                     ; 42   if ((8U * A) >= ((lsifreqkhz - (8U * A)) * (1U + (2U * A))))
 208  0043 1e05          	ldw	x,(OFST-1,sp)
 209  0045 58            	sllw	x
 210  0046 58            	sllw	x
 211  0047 58            	sllw	x
 212  0048 1f01          	ldw	(OFST-5,sp),x
 214  004a 1e03          	ldw	x,(OFST-3,sp)
 215  004c 72f001        	subw	x,(OFST-5,sp)
 216  004f 1605          	ldw	y,(OFST-1,sp)
 217  0051 9058          	sllw	y
 218  0053 905c          	incw	y
 219  0055 cd0000        	call	c_imul
 221  0058 1605          	ldw	y,(OFST-1,sp)
 222  005a 9058          	sllw	y
 223  005c 9058          	sllw	y
 224  005e 9058          	sllw	y
 225  0060 bf00          	ldw	c_x,x
 226  0062 90b300        	cpw	y,c_x
 227  0065 250c          	jrult	L17
 228                     ; 44     BEEP->CSR |= (unsigned char)(A - 2U);
 230  0067 7b06          	ld	a,(OFST+0,sp)
 231  0069 a002          	sub	a,#2
 232  006b ca50f3        	or	a,20723
 233  006e c750f3        	ld	20723,a
 235  0071 2009          	jra	L37
 236  0073               L17:
 237                     ; 48     BEEP->CSR |= (unsigned char)(A - 1U);
 239  0073 7b06          	ld	a,(OFST+0,sp)
 240  0075 4a            	dec	a
 241  0076 ca50f3        	or	a,20723
 242  0079 c750f3        	ld	20723,a
 243  007c               L37:
 244                     ; 50 }
 247  007c 5b06          	addw	sp,#6
 248  007e 81            	ret
 282                     ; 51 void Buzzer_Init(uint8_t BEEP_Frequency)
 282                     ; 52 {
 283                     	switch	.text
 284  007f               _Buzzer_Init:
 286  007f 88            	push	a
 287       00000000      OFST:	set	0
 290                     ; 54   if ((BEEP->CSR & 0x1F) == 0x1F)
 292  0080 c650f3        	ld	a,20723
 293  0083 a41f          	and	a,#31
 294  0085 a11f          	cp	a,#31
 295  0087 2610          	jrne	L311
 296                     ; 56     BEEP->CSR &= (uint8_t)(~0x1F); /* Clear bits */
 298  0089 c650f3        	ld	a,20723
 299  008c a4e0          	and	a,#224
 300  008e c750f3        	ld	20723,a
 301                     ; 57     BEEP->CSR |= BEEP_CALIBRATION_DEFAULT;
 303  0091 c650f3        	ld	a,20723
 304  0094 aa0b          	or	a,#11
 305  0096 c750f3        	ld	20723,a
 306  0099               L311:
 307                     ; 61   BEEP->CSR &= (uint8_t)(~0xC0);
 309  0099 c650f3        	ld	a,20723
 310  009c a43f          	and	a,#63
 311  009e c750f3        	ld	20723,a
 312                     ; 62   BEEP->CSR |= (uint8_t)(BEEP_Frequency);
 314  00a1 c650f3        	ld	a,20723
 315  00a4 1a01          	or	a,(OFST+1,sp)
 316  00a6 c750f3        	ld	20723,a
 317                     ; 63 }
 320  00a9 84            	pop	a
 321  00aa 81            	ret
 334                     	xdef	_Buzzer_Init
 335                     	xdef	_Buzzer_Calibration
 336                     	xdef	_driveBuzzer
 337                     	xdef	_buzzerInit
 338                     	xref.b	c_x
 357                     	xref	c_imul
 358                     	end
