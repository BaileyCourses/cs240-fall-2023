;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data

	;; Days: 1-31 (5 bits)
	;; Months: 1-12 (4 bits)
	;; Year: 0-99 (7 bits)

	;;  15           9 8      5 4        0
	;; +--------------+--------+----------+
	;; |     year     |  month |    day   |
	;; +--------------+--------+----------+

	;; Today's date
	;; 
	;; 23-09-13
	;; (0010111 1001 01101)
	;; (0010 1111 0010 1101)

today	WORD	2F2Dh

.code
	
getMonth PROC
	;; DX - packed date rep
	;; Returns:
	;; AL - month

	pushf
	push	cx
	push	dx
	;; Shift bits to low end of register

	mov	cl, 5
	shr	dx, cl

	;; Clear the high bits

	and	dx, 0Fh
	
	mov	al, dl

	pop	dx
	pop	cx
	popf
	ret
getMonth ENDP

setMonth PROC
	;; DX - packed date rep
	;; AL - new month value
	;; Returns:
	;; DX - new packed date rep

	pushf
	push	ax
	push	cx

	;; Clear the month field in dx

	and	dx, 0FE1Fh

	;; Clear the high bits of AX

	and	ax, 0Fh

	;; Shift AX to right location
	
	mov	cl, 5
	shl	ax, cl

	;; Insert AX bits into DX
	
	or	dx, ax

	pop	cx
	pop	ax
	popf
	ret
setMonth ENDP

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	dx, today

	mov	ax, 2

	call	setMonth

	call	getMonth
	
	mov	dl, al
	mov	dh, 0

	call	WriteInt
	call	Newline

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
