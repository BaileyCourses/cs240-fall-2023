;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
.code

sum PROTO

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	
	call	DumpRegs
	call	Sum
	call	DumpRegs
	mov	dx, ax
	call	WriteInt
	call	NewLine

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
