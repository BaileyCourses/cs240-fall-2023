;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data

start	LABEL	BYTE


name2	BYTE	"RYAN!", 0
value	WORD	0102h, 0304h, 0506h



len = $ - start
.code

;;; Entry point for the program


main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	dx, OFFSET start
	mov	cx, len

	call	DumpMem
	call	NewLine

	mov	dx, DWORD PTR start
	call	DumpRegs

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
