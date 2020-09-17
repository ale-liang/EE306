; Main.asm
; Name(s): Alex Liang, Zach Chin
; UTEid(s): all3344, zhc94
; Continuously reads from x3600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x3000
; initialize the stack pointer (Needed in the old Simulator)
    LD R6, stackPointer
; set up the keyboard interrupt vector table entry
    LD R0, KBISR
    STI R0, KBIVT
; enable keyboard interrupts
    LDI R0, KBISR
    LD R1, KBIEN
    NOT R0, R0
    NOT R1, R1
    AND R0, R0, R1
    NOT R0, R0
    STI R0, KBSR
; start of actual program
    AND R0, R0, #0
    STI R0, inputLoc
    AND R2, R2, #0
    ST R2, startLoc
    AND R4, R4, #0
    ST R4, endLoc
loop
    LDI R0, inputLoc
    BRz loop
    OUT
    LD R2, startLoc
    ADD R2, R2, #-3
    BRz skipStart
    JSR START_CHECK
    BR done
skipStart
    JSR END_CHECK
done
    AND R0, R0, #0
    STI R0, inputLoc
    BR loop
    HALT
stackPointer    .FILL x3000
KBIVT           .FILL x0180
KBISR           .FILL x2600
KBSR            .FILL xFE00
KBIEN           .FILL x4000
inputLoc        .FILL x3600
negA            .FILL #-65
negC            .FILL #-67
negG            .FILL #-71
negU            .FILL #-85
startLoc        .BLKW #1
endLoc          .BLKW #1

;********************************************************************
;   START_CHECK
;   Checks the startLoc to see if the start codon has been found yet
;   If not, will check for AUG and increment the startLoc for each
;   Resets counter if a different letter is read (or wrong order)
;   Inputs: none, Outputs: none
;*********************************************************************
START_CHECK
    ST  R0, scSaveR0
    ST  R1, scSaveR1
    ST  R2, scSaveR2
    ST  R3, scSaveR3
    ST  R4, scSaveR4
    ST  R5, scSaveR5
    ST  R6, scSaveR6
    ST  R7, scSaveR7
    LD  R2, startLoc
    ADD R3, R2, #0
    BRz scNone
    ADD R3, R3, #-1
    BRz scOne
    ADD R3, R3, #-1
    BRz scTwo
    ADD R3, R3, #-1
    BR scExit
scNone
    LD  R1, negA
    ADD R1, R0, R1
    BRnp scClear
    ADD R2, R2, #1
    BR scExit
scOne 
    LD  R1, negU
    ADD R1, R0, R1
    BRnp scClear
    ADD R2, R2, #1
    BR scExit
scTwo
    LD  R1, negG
    ADD R1, R0, R1
    BRnp scClear
    ADD R2, R2, #1
    LD  R0, pipe
    OUT
    BR scExit
scClear
    AND R2, R2, #0
scExit
    ST  R2, startLoc
    LD  R0, scSaveR0
    LD  R1, scSaveR1
    LD  R2, scSaveR2
    LD  R3, scSaveR3
    LD  R4, scSaveR4
    LD  R5, scSaveR5
    LD  R6, scSaveR6
    LD  R7, scSaveR7
    RET
scSaveR0    .BLKW #1 
scSaveR1    .BLKW #1
scSaveR2    .BLKW #1
scSaveR3    .BLKW #1
scSaveR4    .BLKW #1
scSaveR5    .BLKW #1
scSaveR6    .BLKW #1
scSaveR7    .BLKW #1
pipe        .FILL #124

;********************************************************************
;   END_CHECK
;   Checks the startLoc to see if the start codon has been found yet
;   If not, will check for AUG and increment the startLoc for each
;   Resets counter if a different letter is read (or wrong order)
;   Inputs: none
;   Output: none
;
;********************************************************************

END_CHECK
    ST  R0, ecSaveR0
    ST  R1, ecSaveR1
    ST  R2, ecSaveR2
    ST  R3, ecSaveR3
    ST  R4, ecSaveR4
    ST  R5, ecSaveR5
    ST  R6, ecSaveR6
    ST  R7, ecSaveR7
    LD  R4, endLoc
    ADD R3, R4, #0
    BRz ecNone
    ADD R3, R3, #-1
    BRz ecOne
    ADD R3, R3, #-1
    BRz ecTwo
    BR ecThree
ecNone
    LD  R1, negU
    ADD R1, R0, R1
    BRnp ecExit
    ADD R4, R4, #1
    BR ecExit
ecOne
    LD  R1, negA
    ADD R1, R0, R1
    BRnp #2
    ADD R4, R4, #1
    BR ecExit
    LD  R1, negG
    ADD R1, R0, R1
    BRnp ecClear
    ADD R4, R4, #2
    BR ecExit
ecTwo
    LD  R1, negA
    ADD R1, R0, R1
    BRz ecHalt
    LD  R1, negG
    ADD R1, R0, R1
    BRz ecHalt
    BR ecClear
ecThree
    LD  R1, negA
    ADD R1, R0, R1
    BRz ecHalt
    BR ecClear
ecHalt
    HALT
ecClear
    AND R4, R4, #0
ecExit 
    ST  R4, endLoc
    LD  R0, ecSaveR0
    LD  R1, ecSaveR1
    LD  R2, ecSaveR2
    LD  R3, ecSaveR3
    ST  R4, ecSaveR4
    LD  R5, ecSaveR5
    LD  R6, ecSaveR6
    LD  R7, ecSaveR7
    RET
ecSaveR0      .BLKW #1 
ecSaveR1      .BLKW #1
ecSaveR2      .BLKW #1
ecSaveR3      .BLKW #1
ecSaveR4      .BLKW #1
ecSaveR5      .BLKW #1
ecSaveR6      .BLKW #1
ecSaveR7      .BLKW #1
		.END

		.END

