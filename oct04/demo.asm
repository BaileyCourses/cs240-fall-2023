;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
.code

DOS_SetInterruptVector PROC
	;; AL = interrupt number
	;; ES:DX = new interrupt handler
	
	push	ax
	push	bx
	push	ds
	
	mov	bx, es		; DS = ES
	mov	ds, bx
	mov	ah, 25h		; DOS function to set vector
	int	DOS		; Call DOS
	
	pop	ds
	pop	bx
	pop	ax
	ret
DOS_SetInterruptVector ENDP

DOS_GetInterruptVector PROC
	;; AL = interrupt number
	;; Returns:
	;; ES:BX = current interrupt handler
	
	push	ax
	
	mov	ah, 35h		; DOS function to get vector
	int	DOS		; Call DOS
	;; Returns:
	;; ES:BX = current interrupt handler
	
	pop	ax
	ret
DOS_GetInterruptVector ENDP

PrintInterruptVectorFromIVT PROC


	mov	bh, 0
	mov	bl, al

	shl	bx, 1
	shl	bx, 1
	add	bx, 2
	
	mov	ax, 0
	mov	es, ax
;	mov	bx, 38
	mov	ax, es:[bx]
	mov	dx, ax
	call	WriteHexWord
	mov	dl, ':'
	call	WriteChar

	sub	bx, 2
	mov	ax, es:[bx]
	mov	dx, ax
	call	WriteHexWord

	ret
PrintInterruptVectorFromIVT ENDP

PrintInterruptVector PROC
	;; AL = interrupt number to print

	push	bx
	push	dx
	push	es

	call	DOS_GetInterruptVector ;ES:BX contains vector
	
	mov	dx, es
	call	WriteHexWord
	mov	dl, ':'
	call	WriteChar
	mov	dx, bx
	call	WriteHexWord

	pop	es
	pop	dx
	pop	bx

	ret
PrintInterruptVector ENDP

.data
crumb	BYTE 0
.code

ClockInterruptHandler PROC
	inc	crumb
	iret
ClockInterruptHandler ENDP

.data
	OldOffset	WORD 0
	OldSegment	WORD 0
	
.code
;;; Entry point for the program

TIMER_HANDLER = 1Ch

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	al, TIMER_HANDLER      ; Timer Handler Interrrupt
	call	DOS_GetInterruptVector ; Returns in  ES:BX
	mov	OldSegment, ES
	mov	OldOffset, BX
	
	mov	al, TIMER_HANDLER      		; Timer Handler Interrrupt
;	call	PrintInterruptVector
;	call	NewLine

	mov	ax, cs				; ES = CS
	mov	es, ax				; ES = segment of handler
	mov	dx, ClockInterruptHandler 	; DX = offset of handler
	mov	al, TIMER_HANDLER      		; Timer Handler Interrrupt
	call	DOS_SetInterruptVector

	mov	al, TIMER_HANDLER      		; Timer Handler Interrrupt
;	call	PrintInterruptVector
;	call	NewLine

;	call	DumpRegs

top:
	cmp	crumb, 0
	je	top

	call	DumpRegs

	mov	al, TIMER_HANDLER      		; Timer Handler Interrrupt
	mov	es, OldSegment			; ES = handler segment
	mov	dx, OldOffset			; DX = handler offset
	call	DOS_SetInterruptVector

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
