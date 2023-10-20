;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
include notes\gamelib.asm
include notes\musiclib.asm
include alarms.asm

DOSEXIT = 4C00h
DOS = 21h
TIMER_DATA_PORT		= 42h
TIMER_CONTROL_PORT	= 43h
SPEAKER_PORT		= 61h
READY_TIMER		= 0B6h

;CPU_FREQUENCY=1,193,180


.data
	
GameOver	BYTE	0

CE3K	BYTE	"4D 4E 4C 3C 3G 3Z 3Z", 0

MusicPointer	WORD	0
MusicScore	WORD	0

.data

gameLayout LABEL BYTE
BYTE "+------------------------------------------------------------------------------+"
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "|                                                                              |" 
BYTE "+------------------------------------------------------------------------------+"
BYTE "                                                                                " 
BYTE 0

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
	call	GameUserAction
;	call	UserAction
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

PlayScore PROC
	;; DX = OFFSET of location of score

	mov	MusicScore, dx
	mov	MusicPointer, dx
	ret
PlayScore ENDP

NOTE_TICKS = 8

PlayNextNote PROC
	push	ax
	push	dx
	
	mov	si, MusicPointer
	cmp	BYTE PTR [si], 0
	jne	cont

	;; Repeat tune
	
	mov	si, MusicScore
	mov	MusicPointer, si

cont:	
	call	GetNoteFrequency
	call	PlayFrequency

 	mov	ax, NOTE_TICKS
 	mov	dx, OFFSET StopNote
	call	RegisterAlarm

done:	
	pop	dx
	pop	ax
	ret
PlayNextNote ENDP

NOTE_GAP_TICKS = 1

StopNote PROC
	pushf
	push	ax
	push	dx

	call	SpeakerOff
	
 	mov	ax, NOTE_GAP_TICKS
 	mov	dx, OFFSET PlayNextNote
	call	RegisterAlarm

done:	
	pop	dx
	pop	ax
	popf
	ret
StopNote ENDP

PlayFrequency PROC
	;; Frequency is found in DX

	pushf
	push	ax
	
	cmp	dx, 0
	je	rest

	call	NoteFrequencyToTimerCount

	mov	al, READY_TIMER			; Get the timer ready
	out	TIMER_CONTROL_PORT, al

	mov	al, dl
	out	TIMER_DATA_PORT, al		; Send the count low byte
	
	mov	al, dh
	out	TIMER_DATA_PORT, al		; Send the count high byte
	
	call	SpeakerOn

done:	
	pop	ax
	popf
	ret
rest:
	call	SpeakerOff
	jmp	done
PlayFrequency ENDP

SpeakerOn PROC
	pushf
	push	ax
	
	test	SpeakerMuted, 1
	jnz	done
	
	in	al, SPEAKER_PORT		; Read the speaker register
	or	al, 03h				; Set the two low bits high
	out	SPEAKER_PORT, al		; Write the speaker register

done:	
	pop	ax
	popf
	ret
SpeakerOn ENDP
	
SpeakerOff PROC

	pushf
	push	ax
	
	in	al, SPEAKER_PORT		; Read the speaker register
	and	al, 0FCh			; Clear the two low bits high
	out	SPEAKER_PORT, al		; Write the speaker register

	pop	ax
	popf
	ret
SpeakerOff ENDP

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	call	InstallTimerHandler

	mov	dx, OFFSET CE3K
	call	PlayScore

 	mov	ax, 3
 	mov	dx, OFFSET PlayNextNote
	call	RegisterAlarm
	call	SpeakerMute

	call	CursorOff
	call	SplashScreen

 	mov	ax, CharacterSpeed
 	mov	dx, OFFSET MoveCharacter
 	call	RegisterAlarm

	call	GameScreen	

	mov	ax, 18*3
	mov	dx, ClearStatus
	call	RegisterAlarm

	call	GameLoop

	mov	al, 0
	call	ChangeVideoPage

	call	RestoreTimerHandler
	call	CursorOn

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main




	
