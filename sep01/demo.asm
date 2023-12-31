;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
msg	BYTE "DOS Rocks!", 0

.code

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...
	mov	cx, 1000
top:	
	mov	dx, OFFSET msg
	call	WriteString
	call	NewLine

	;; if cx = 990 jump out
	
	cmp	cx, 990		; (cx - 990)
	jle	done


	loop	top

done:	

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
