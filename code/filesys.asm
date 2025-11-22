;
; Created on Sunday, 3rd of May 2025 at 11:39
; by Michael Dailly 2025
; Simple Platform Engine for the ZX Spectrum next
;
; 

; *******************************************************************************************************
;	Function:	Load bytes into RAM
;	In:		HL = file index
;			DE = dest bank offset
;			a  = dest bank
; *******************************************************************************************************
LoadFile:
	ld	(DestOff),de
	ld	(DestBank),a

	; multiply the file index by 5 (5 bytes per file)
	push	hl
	pop	de
	add	hl,hl
	add	hl,hl	
	add	hl,de
	add	hl,Files		; test

	; get src bank offset
	ld 	a,(hl)
	ld	(SrcOff),a
	inc 	hl
	ld	a,(hl)
	ld	(SrcOff+1),a
	inc 	hl

	; get src bank
	ld	a,(hl)
	ld	(SrcBank),a
	inc 	hl

	; get filesize
	ld	a,(hl)
	ld	(File_Size),a
	inc 	hl
	ld	a,(hl)
	ld	(File_Size+1),a
	inc 	hl




	; get size of file
	ld	bc,(File_Size)

	; set the banks up
	ld	a,(SrcBank)
	NextReg	SRC_BANK+$50,a
	ld	a,(DestBank)
	NextReg	DEST_BANK+$50,a

	ld	hl,(SrcOff)
	ld	a,h
	or	SRC_FILE_ADD>>8		;$c0
	ld	h,a
	ld	de,(DestOff)
	ld	a,d
	or	DEST_FILE_ADD>>8	;$e0
	ld	d,a
@CopyAll:
	; copy byte
	ld	a,(hl)
	ld	(de),a

	inc	hl
	ld	a,h
	and	SRC_FILE_OVERFLOW
	jr	z,@SkipBankSwitch_Src
	ld	h,SRC_FILE_ADD>>8

	ld	a,(SrcBank)
	inc	a
	ld	(SrcBank),a
	NextReg	SRC_BANK+$50,a
@SkipBankSwitch_Src:


	inc	de
	ld	a,d
	and	DEST_FILE_OVERFLOW
	jr	z,@SkipBankSwitch_Dest
	ld	d,DEST_FILE_ADD>>8

	ld	a,(DestBank)
	inc	a
	ld	(DestBank),a
	NextReg	DEST_BANK+$50,a
@SkipBankSwitch_Dest:

	add	bc,-1
	ld	a,b
	or	c
	and	a
	jr	nz,@CopyAll
	ret



; *******************************************************************************************************
;	Function:	Load a palette
;	In:		HL = file index
; *******************************************************************************************************
LoadPalette:
	; multiply the file index by 5 (5 bytes per file)
	push	hl
	pop	de
	add	hl,hl
	add	hl,hl	
	add	hl,de
	add	hl,Files

	; get src bank offset
	ld	a,(hl)
	ld	(SrcOff),a
	inc 	hl
	ld	a,(hl)
	ld	(SrcOff+1),a
	inc 	hl

	; get src bank
	ld	a,(hl)
	ld	(SrcBank),a
	inc 	hl

	; get filesize
	ld	a,(hl)
	ld	(File_Size),a
	inc 	hl
	ld	a,(hl)
	ld	(File_Size+1),a
	inc 	hl




	; get size of file
	ld	bc,(File_Size)

	; set the banks up
	ld	a,(SrcBank)
	NextReg	SRC_BANK+$50,a

	ld	hl,(SrcOff)
	ld	a,h
	or	$c0
	ld	h,a

@CopyAll:
	; copy byte
	ld	a,(hl)
	NextReg	$44,a

	inc	hl
	ld	a,h
	and	$20
	jr	z,@SkipBankSwitch_Src
	ld	a,h
	and	$1f
	or	$c0
	ld	h,a

	ld	a,(SrcBank)
	inc	a
	ld	(SrcBank),a
	NextReg	SRC_BANK+$50,a
@SkipBankSwitch_Src:


	add	bc,-1
	ld	a,b
	or	c
	and	a
	jr	nz,@CopyAll
	ret







