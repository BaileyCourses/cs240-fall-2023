;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
include notes\gamelib.asm

DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
VideoOffset	WORD 0
VideoPage	Label BYTE
VideoPageWord	WORD 0
VideoRow	Label BYTE
VideoRowWord	WORD 0
VideoCol	Label BYTE
VideoColWord	WORD 0
VideoChar	BYTE 0
.code


WriteCharVideo PROC
	;; dl - character
	;; ch - row
	;; cl - col
	;; dh - page

	;; AX = page * 4096 + row * 160 + col * 2
	
	call	VideoAddress	; Returns in AX
	mov	di, ax
	mov	ax, 0B800h
	mov	es, ax
	mov	es:[di], dl

	ret
WriteCharVideo ENDP


;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	al, 1
	call	ChangeVideoPage

	mov	ch, 10
	mov	cl, 10
	mov	dh, 1
	mov	dl, 'X'
	call	WriteCharVideo

	call	ReadCharNoEcho

	mov	al, 0
	call	ChangeVideoPage

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main



















	call	CursorOff
	call	CursorOn

	
