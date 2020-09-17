; Programming Project 1 starter file
; Student Name  : Alex Liang
; UTEid: all3344


	.ORIG	x3000
;---- Initialize
	LDI R1, numberOne
	LDI R2, numberTwo

	AND R3, R3, #0
start
	ADD R2, R2, #0
	ADD R1, R1, #0

	BRnp notzero
		AND R3, R3, #0
		STI R3, result
		BR fin
	notzero	

	BRn notpositiveNum1
		
		ADD	R3, R3, R2	; update cumulative sum
		ADD	R1, R1, #-1	; Decrement R1 cos we added the number one more time
		BRp #-3		    ; Branch back to Check if the decremented value in R1 is still positive
        STI R3, result
		BR fin
	notpositiveNum1

	ADD R2, R2, #0
	BRnp notzeroNum2
		AND R3, R3, #0
		STI R3, result
		BR fin
	notzeroNum2
	
	BRn notnegativeNum2
		ADD R3, R3, R1
		ADD R2, R2, #-1
		BRp #-3
		STI R3, result
		BR fin
	notnegativeNum2
		NOT R2, R2
		ADD R2, R2, #1
		ADD R3, R3, R2
		ADD R1, R1, #1
		BRn #-3
		STI R3, result
		BR	fin

fin


	HALT

numberOne	.FILL x2FF0
numberTwo	.FILL x2FF1
result 		.FILL x2FF2

	.END
				

