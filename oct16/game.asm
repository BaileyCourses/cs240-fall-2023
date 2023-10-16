;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
include notes\gamelib.asm
include alarms.asm

DOSEXIT = 4C00h
DOS = 21h

.data
	
GameOver	BYTE	0

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

UserAction PROC
	pushf
	push	ax
	
	call	KeyPress	; Character in AL (or 0 for no character)
	cmp	al, 0		; Was a key pressed?
	je	ignore		; No, return
	
	cmp	al, 27		; Is it the ESC key?
	je	endGame
	
	jmp	ignore
	
endGame:	
	mov	GameOver, 1
	
ignore:	
done:	
	pop	ax
	popf
	ret
UserAction ENDP

GameLoop PROC
	pushf
	push	ax
	
	jmp	cond
top:	
	call	CheckAlarms
	call	UserAction
cond:
	cmp	GameOver, 0
	je	top
	
	pop	ax
	popf
	ret
GameLoop ENDP

AnAlarm PROC
	WriteLn	"I'm an alarm!"
	mov	ax, 3
	mov	dx, OFFSET AnAlarm
	call	RegisterAlarm
	ret
AnAlarm ENDP

AnotherAlarm PROC
	WriteLn	"I'm another alarm!"
	mov	ax, 2
	mov	dx, OFFSET AnotherAlarm
	call	RegisterAlarm
	ret
AnotherAlarm ENDP

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	call	InstallTimerHandler

	mov	al, 1
;	call	ChangeVideoPage

	mov	ax, 3
	mov	dx, OFFSET AnAlarm
	call	RegisterAlarm

	mov	ax, 5
	mov	dx, OFFSET AnotherAlarm
	call	RegisterAlarm

	call	CursorOff
	call	SplashScreen

	call	GameLoop

	mov	al, 0
;	call	ChangeVideoPage

	call	RestoreTimerHandler
	call	CursorOn

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main



















	call	CursorOff
	call	CursorOn

	
