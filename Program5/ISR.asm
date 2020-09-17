; ISR.asm
; Name(s): Alex Liang, Zach Chin
; UTEid(s): all3344, zhc94
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x3600
        .ORIG x2600
    ;ST R0, intSaveR0
    ST R1, intSaveR1

    LDI R0, KBDR ;reads the KBDR first to prevent more interrupts
    LD R1, negA
    ADD R1, R0, R1
    BRz is_valid
    LD R1, negC
    ADD R1, R0, R1
    BRz is_valid
    LD R1, negG
    ADD R1, R0, R1
    BRz is_valid
    LD R1, negU
    ADD R1, R0, R1
    BRz is_valid
    BR exit
is_valid
    STI R0, input
exit
    LD R0, intSaveR0
    LD R1, intSaveR1
    RTI

intSaveR0   .BLKW #1
intSaveR1   .BLKW #1

KBDR        .FILL xFE02
DSR         .FILL xFE04
DDR         .FILL xFE06
DSIEN       .FILL x8000
negA        .FILL #-65
negC        .FILL #-67
negG        .FILL #-71
negU        .FILL #-85
input       .FILL x3600
		.END
;start codon is AUG
;end codons are UAG, UAA, UGA