; ******************************************************************************************************************************************************************************************************************************************
; ******************************************************************************************************************************************************************************************************************************************
; ******************************************************************************************************************************************************************************************************************************************

		Seg	DATA_SEG
DataStart:
		db	1,2,3,4,5
STACKSTART	ds	256
VBlank		db	0
Shake		db	0				; Screen shake on?
ShakeX		db	0				; screen shake on X		*2 for fraction
ShakeY		db	0				; screen shake on Y		*2 for fraction
Seed		dw	$6a5c
Port123b	db	0				; mirror of port so we don't need to keep reading it
HexValue	db	0

Keys:		ds	40				; key presses
RawKeys		ds	8				; raw key rows



; ******************************************************************************
; Filesystem
; ******************************************************************************
DestOff		dw	0
DestBank	db	0
SrcBank		db	0
SrcOff		dw	0
File_Size	dw	0


; ******************************************************************************
; Writable DMA Program
; ******************************************************************************
DMACopyProg
		db	$C3				; R6-RESET DMA
		db	$C7				; R6-RESET PORT A Timing
        	db	$CB				; R6-SET PORT B Timing same as PORT A
		
        	db	$7D 				; R0-Transfer mode, A -> B
DMASrc  	dw	$1234				; R0-Port A, Start address		(source address)
DMALen		dw	240				; R0-Block length			(length in bytes)
		
        	db	$54 				; R1-Port A address incrementing, variable timing
        	db	$02				; R1-Cycle length port A
		  		
        	db	$50				; R2-Port B address fixed, variable timing
        	db	$02 				; R2-Cycle length port B
		  		
		db	$AD 				; R4-Continuous mode  (use this for block tansfer)
DMADest		dw	$4000				; R4-Dest address			(destination address)
		  		
		db	$82				; R5-Restart on end of block, RDY active LOW
	 		
		db	$CF				; R6-Load
		db	$B3				; R6-Force Ready
		db	$87				; R6-Enable DMA
ENDDMA

DMASIZE      	equ	ENDDMA-DMACOPY



; ******************************************************************************
; ALL sprites mirrored in memory
; ******************************************************************************
		align	256
Sprites:	db	0				; x
		db	0				; y
		db	0				; MSB
		db	$80				; Enable+Shape
		ds	127*4




; ******************************************************************************************************************************************************************************************************************************************
; ******************************************************************************************************************************************************************************************************************************************
; ******************************************************************************************************************************************************************************************************************************************


; ******************************************************************************
; STATIC data - should never change
; ******************************************************************************
		align	256
StaticData:

Files:
		FILE	ULAScreenFile,"../art/pyj.scr",ULAScreenPyj
		FILE	L2ScreenDemo,"../art/beastf.256",L2ScreenTest


RandomTable:	db   82,97,120,111,102,116,20,12

; random / shake (0-15)
shake0		db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
shake1		db	0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1
shake2		db	0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,2
shake3		db	0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3
shake4		db	0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3
shake5		db	0,0,1,1,1,2,2,2,3,3,3,4,4,5,5,5
shake6		db	0,0,1,1,2,2,2,3,3,4,4,4,5,5,6,6
shake7		db	0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7
shake8		db	0,1,1,2,2,3,3,4,5,5,6,6,7,7,8,8
shake9		db	0,1,1,2,2,3,4,4,5,5,6,7,7,8,8,9
shake10		db	0,1,2,2,3,3,4,5,5,6,7,7,8,9,9,10
shake11		db	0,1,2,2,3,4,4,5,6,6,7,8,8,9,10,11
shake12		db	0,1,2,2,3,4,4,5,6,7,8,8,9,10,11,12
shake13		db	0,1,2,3,4,4,5,6,7,8,9,9,10,11,12,13
shake14		db	0,1,2,3,4,5,6,7,8,8,9,10,11,12,13,14
shake15		db	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15


HexCharset:
		db %00000000	;char30  '0'
		db %00111100
		db %01000110
		db %01001010
		db %01010010
		db %01100010
		db %00111100
		db %00000000
		db %00000000	;char31	'1'
		db %00011000
		db %00101000
		db %00001000
		db %00001000
		db %00001000
		db %00111110
		db %00000000
		db %00000000	;char32	'2'
		db %00111100
		db %01000010
		db %00000010
		db %00111100
		db %01000000
		db %01111110
		db %00000000
		db %00000000	;char33	'3'
		db %00111100
		db %01000010
		db %00001100
		db %00000010
		db %01000010
		db %00111100
		db %00000000
		db %00000000	;char34	'4'
		db %00001000
		db %00011000
		db %00101000
		db %01001000
		db %01111110
		db %00001000
		db %00000000
		db %00000000	;char35	'5'
		db %01111110
		db %01000000
		db %01111100
		db %00000010
		db %01000010
		db %00111100
		db %00000000
		db %00000000	;char36	'6'
		db %00111100
		db %01000000
		db %01111100
		db %01000010
		db %01000010
		db %00111100
		db %00000000
		db %00000000	;char37	'7'
		db %01111110
		db %00000010
		db %00000100
		db %00001000
		db %00010000
		db %00010000
		db %00000000
		db %00000000	;char38	'8'
		db %00111100
		db %01000010
		db %00111100
		db %01000010
		db %01000010
		db %00111100
		db %00000000
		db %00000000	;char39	'9'
		db %00111100
		db %01000010
		db %01000010
		db %00111110
		db %00000010
		db %00111100
		db %00000000
		db %00000000	;char41	'A'
		db %00111100
		db %01000010
		db %01000010
		db %01111110
		db %01000010
		db %01000010
		db %00000000
		db %00000000	;char42	'B'
		db %01111100
		db %01000010
		db %01111100
		db %01000010
		db %01000010
		db %01111100
		db %00000000
		db %00000000	;char43	'C'
		db %00111100
		db %01000010
		db %01000000
		db %01000000
		db %01000010
		db %00111100
		db %00000000
		db %00000000	;char44	'D'
		db %01111000
		db %01000100
		db %01000010
		db %01000010
		db %01000100
		db %01111000
		db %00000000
		db %00000000	;char45	'E'
		db %01111110
		db %01000000
		db %01111100
		db %01000000
		db %01000000
		db %01111110
		db %00000000
		db %00000000	;char46	'F'
		db %01111110
		db %01000000
		db %01111100
		db %01000000
		db %01000000
		db %01000000
		db %00000000



;****************************************************************************************************
;****************************************************************************************************
;			File data
;****************************************************************************************************
;****************************************************************************************************

        seg     FILE_SEG
ULAScreenPyj:        	incbin	"../art/pyj.scr"
L2ScreenTest:        	incbin	"../art/beastf.256"


; ##################################################################################################







