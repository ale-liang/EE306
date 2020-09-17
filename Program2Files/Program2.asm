; Programming Assignment 2
; Student Name: Alex Liang
; UT Eid: all3344
; Linked List creation from array. Insertion into the list
; You are given an array of student records starting at location x3500.
; The array is terminated by a sentinel. Each student record in the array
; has two fields:
;      Score -  A value between 0 and 100
;      Address of Name  -  A value which is the address of a location in memory where
;                          this student's name is stored.
; The end of the array is indicated by the sentinel record whose Score is -1
; The array itself is unordered meaning that the student records dont follow
; any ordering by score or name.
; You are to perform two tasks:
; Task 1: Sort the array in decreasing order of Score. Highest score first.
; Task 2: You are given a name (string) at location x6000, You have to lookup this student 
;         in the linked list (post Task1) and put the student's score at x5FFF (i.e., in front of the name)
;         If the student is not in the list then a score of -1 must be written to x5FFF
; Notes:
;       * If two students have the same score then keep their relative order as
;         in the original array.
;       * Names are case-sensitive.



	.ORIG	x3000
; Your code goes here
;Task 1 start here
	LD R0, A ; register that holds all the items
RepeatSequence
	AND R4, R4, #0 	; R4 is the swap counter
					;  If R4 is zero, that means the entire list of items is in order
ILoop
	
		LDR	R1,	R0, #0 ; R1 -> first item to compare
		BRn checkSentinel
		LDR R2, R0, #2 ; R2 -> 2nd item to compare
		
		NOT R3, R1 ; Negate R1 
		ADD R3, R3, #1 ; Add 1 b/c 2's complement
		ADD R3, R3, R2 ; Add negative R1 with R2
		BRn noSwap ; If R1 > R2, skip swap step
			STR R2, R0, #0 ; swap R2 with mem location of R1
			STR R1, R0, #2 ; swap R1 with mem location of R2
			LDR R5, R0, #1 ; load address of student 1
			LDR R6, R0, #3 ; load address of student 2
			STR R6, R0, #1 ; swap address of student 1 with student 2 (location)
			STR R5, R0, #3 ; swap address of student 2 with student 1  (location)
			ADD R4, R4, #1
	noSwap
		ADD R0, R0, #2 ; Move the register location 2 over to check the next 2 items
		BR ILoop ; Innerloop to restart the checking process
checkSentinel
	ADD R4, R4, #0
	BRp RepeatSequence

; Task 2 start here
	
	LD R0, A ; reuse the register location of the items in actual array
RepeatSearch
	LD R7, B ; load the address of the student's name to search from B at x6000 
	LDR R6, R0, #0 ; grabbing score from item
		BRn checkSentinelTwo
	LDR R1, R0, #1 ; load the register of the first item's name
checkNext	
	LDR R3, R1, #0; load the name of the item at this location	
	LDR R2, R7, #0 ; load the name of the given person

	NOT R4, R3
	ADD R4, R4, #1 
	ADD R4, R4, R2
		BRnp noMatch ;
	ADD R2, R2, #0 ;	
		BRz endOfWord 
	ADD R1, R1, #1
	ADD R7, R7, #1
		BR checkNext	
noMatch
	ADD R0, R0, #2 ; since the sum of both registers is not 0, restart search starting with next location of the next 
		BR RepeatSearch
checkSentinelTwo

	AND R6, R6, #0
	ADD R6, R6, #-1 ; Set score to -1 when students name not found
	
endOfWord
	LD R7, B
	STR R6, R7, #-1 ; store score of Student into x5FFF
	TRAP	x25
; Your .FILLs go here
A   .FILL x3500 ; address of cases
B	.FILL x6000 ; address of search for student case 
	.END


