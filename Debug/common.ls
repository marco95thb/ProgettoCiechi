   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  53                     ; 3 void delay(unsigned short count)
  53                     ; 4 {
  55                     	switch	.text
  56  0000               _delay:
  58  0000 89            	pushw	x
  59       00000000      OFST:	set	0
  62  0001               L13:
  63                     ; 5 	while(--count > 0)
  65  0001 1e01          	ldw	x,(OFST+1,sp)
  66  0003 1d0001        	subw	x,#1
  67  0006 1f01          	ldw	(OFST+1,sp),x
  68  0008 26f7          	jrne	L13
  69                     ; 9 }
  72  000a 85            	popw	x
  73  000b 81            	ret
  86                     	xdef	_delay
 105                     	end
