;;; Professor Bailey
;;; Fall 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
.code

Sum PROC
	pushf
	push	dx

	mov	ax, bx
	mov	dx, cx
	add	ax, dx

	pop	dx
	popf
	ret
Sum ENDP

END
