;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
.code

func PROC
	pop	cx
	pop	dx
	call	WriteInt
	push	dx
	push	cx
	call	DumpRegs
	ret
func ENDP

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	dx, 42
	push	dx
	mov	dx, 10
	call	func

	pop	dx

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
