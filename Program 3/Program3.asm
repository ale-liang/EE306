;;***********************************************************
; Programming Assignment 3
; Student Name: Alex Liang
; UT Eid: all3344
; Simba in the Jungle
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.
; Note: Remember "Callee-Saves" (Cleans its own mess)

;***********************************************************

.ORIG x4000

;***********************************************************
; Main Program
;***********************************************************
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_INITIAL
    TRAP  x22 
    LDI   R0,BLOCKS
    JSR   LOAD_JUNGLE
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_LOADED
    TRAP  x22                        ; output end message
    TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
BLOCKS          .FILL x5000



;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
                   

;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE 
    ST R7, returnToPC   ;save R7 value for the PC
    ST R0, saveR0one    ;create R0 variable to hold R0 value (continuously switch out for OUT and PUTS)
    ST R1, saveR1one    ;create R1 variable to hold R1 value (hold R0 value and trade it out)
    ST R2, saveR2one    ;create R2 variable to hold R2 value (for ASCII value)
    ST R3, saveR3one    ;create R3 variable to hold R3 value (keep R3 as a counter)
    ST R4, saveR4one    ;create R4 variable to hold R4 value (to hold value of NOT x415D + 1 to prevent DISPLAY_JUNGLE from going to far)
    AND R1, R1, #0      ;Clear R1
    AND R2, R2, #0      ;Clear R2
    AND R3, R3, #0      ;Clear R3
    LD R2, ASCII        ;Set R2 to ASCII start
    LD R4, endOfGrid    ;LD the address of the end of the grid (which is where CURRENT_ROW is at)
    NOT R4, R4          ;turn the address negative
    ADD R4, R4, #1
    LEA R0, ColNums     ;Load STRINGZ of column numbers
    LEA R3, RowNums     ;Load STRINGZ of row numbers
    TRAP x22            ;Print STRINGZ of column numbers
    LD R0, myGridLoc    ; Load address of Grid with all the strings of the jungle
    TRAP x22            ;Print first STRINGZ of the Grid
printNextLine
    JSR PRINT_NEW_LINE  ;Print new line
    ;ROW NUMBER PORTION
    ADD R1, R0, #0      ;Store R0 value into R0
    AND R0, R0, #0      ;Clear R0
    LDR R0, R3, #0      ;Load current character of R3 to print out to console
    OUT                 ;Print out character to console
    ADD R3, R3, #1      ;increment the RowNums string
    ;ROW NUMBER PORTION 
    AND R0, R0, #0      ;Clear R0
    ADD R0, R1, #0      ;Put R1 value of the original location back into R0
    ADD R0, R0, #15     ;Push R0 past a row
    ADD R0, R0, #3      ;Need to go past 18 memory addresses to go down to the row where characters can be inputted into the empty spaces
    LD R4, endOfGrid    ;LD the end of Grid
    NOT R4, R4          ;Make the end of Grid negative
    ADD R4, R4, #1
    ADD R4, R0, R4      ;Check if R0 value has gone past the GRID
    BRz finish
    TRAP x22            ;continuously print out the rows
    LDR R2, R0, #0
    BRz finish
    BR printNextLine
finish     
    LD R7, returnToPC
    LD R0, saveR0one
    LD R1, saveR1one
    LD R2, saveR2one
    LD R3, saveR3one
    LD R4, saveR4one
    JMP R7
    
returnToPC  .FILL #0 ;  
saveR0one   .FILL #0
saveR1one   .FILL #0
saveR2one   .FILL #0
saveR3one   .FILL #0
saveR4one   .FILL #0
ASCII       .FILL x30
myGridLoc   .FILL GRID
ColNums     .STRINGZ "\n  0 1 2 3 4 5 6 7 \n "    ;holds the column number string and adds a space to the next column to adjust the grid
RowNums     .STRINGZ "0 1 2 3 4 5 6 7 "         ;holds the row number string
endOfGrid   .FILL CURRENT_ROW                   ;CURRENT_ROW address is the address of the last spot after grid ends



;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
    ST R7, returnToPCTwo    ;Save R7 value to jump back to initial PC
    ST R0, saveR0two        ;Save R0 which is the address of the linked list
nextObject
    JSR CAT_SYMBOL          ;categorize the given symbol at that point in the linked list
    JSR PLACE_IN_GRID       ;place the given symbol into the grid
    LDR R0, R0, #0          ;go to the next part in the linked list
    BRp nextObject          ;loop back to nextObject until linkedList hits null
    LD R7, returnToPCTwo
    LD R0, saveR0two
    JMP  R7
returnToPCTwo   .FILL #0
saveR0two       .FILL #0
;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS   
    ST R1, saveR1three
    ST R2, saveR2three
    ST R7, saveR7three

    LD R0, startOfGridOne ;start R0 at the start of the grid
    ADD R0, R0, #15
    ADD R0, R0, #3      ;Start the memory address location of R0 at the first row where symbols can be inputted
nextRowCheck
    ADD R1, R1, #0      ;check value of R1 for PSR to see if R0 needs to be moved any rows
    BRz moveToColumnCheck
    ADD R0, R0, #15
    ADD R0, R0, #15
    ADD R0, R0, #6      ;Add 36 to R0 each time that the R0 has to go to the next row so it skips over the row borderlines and row of spaces
    ADD R1, R1, #-1     ;decrement the row counter
    BRp nextRowCheck
moveToColumnCheck
    ADD R0, R0, #1      ;place R0 into the first space of the row it's on in the grid
    ADD R2, R2, #0      ;check the PSR value of R2 so need to know if should be in a column or not
    BRz finishGridAddress
nextColumnCheck    
    ADD R0, R0, #2      ;Add 2 to R0 to put into the next space (for the column)
    ADD R2, R2, #-1     ;decrement the counter for column numbers
    BRp nextColumnCheck
    finishGridAddress

    LD R1, saveR1three
    LD R2, saveR2three
    LD R7, saveR7three    
    JMP R7
startOfGridOne      .FILL GRID      ;fill the start of the GRID in order to get R0 ready 

saveR1three         .FILL #0
saveR2three         .FILL #0
saveR7three         .FILL #0

;***********************************************************************************************
;IS_INPUT_VALID subroutine
; This subroutine validates the player move to make sure it is one of the movement characters. All it does is check if a valid character is entered.
; Inputs: R0 - a move represented by ‘i’, ‘j’, ‘k’, or ‘l’
; Outputs: R2 - 0 = valid; -1 = invalid
;***********************************************************************************************
; IS_INPUT_VALID
;     ST R0, saveR0InputValid
;     ST R1, saveR1InputValid
;     ST R7, saveR7InputValid

;     JMP R7
; saveR0InputValid    .FILL #0
; saveR1InputValid    .FILL #0
; saveR7InputValid    .FILL #0
; enterMoveString     .STRINGZ	"Enter Move\n       (up(i) left(j),down(k),right(l)): "
; unsafeMoveString    .STRINGZ    "UnSafe Move"
;print a new line
PRINT_NEW_LINE
    ST R0, keepR0NewLine
    LEA R0, newLine
    TRAP x22
    LD R0, keepR0NewLine
    JMP R7
newLine     .STRINGZ "\n"
keepR0NewLine   .FILL #0   
;Just a subroutine meant to print a new line to the console each time it's called
CAT_SYMBOL  ;subroutine meant to categorize the given symbols 
    ST R0, keepR0Symbol
    ST R1, keepR1Symbol
    ST R2, keepR2Symbol
    ST R3, keepR3Symbol
    ST R7, keepR7Symbol
    AND R1, R1, #0      ;clear R1
    AND R2, R2, #0      ;clear R2
    LDR R1, R0, #3      ;load the symbol
    ADD R2, R1, #0      ;place value of symbol into R2
    LD R7, asterixCharVal       ;hold the char value of asterix
    LD R3, homeCharVal  ;hold the negative char value of H
    ADD R1,R1,R3        ;check if symbol is H
    BRz fillHome
    ADD R1, R2, #0      ;reput R2 back into R1
    LD R3, initCharVal  ;hold the negative char value of I
    ADD R1, R1, R3      ;check if symbol is I
    BRz fillInit    
    BR  finishCat       ;else, just finish categorizing and go back to LOAD_JUNGLE
fillHome
    LDR R3, R0, #1      ;load ROW value
    ST R3, HOME_ROW     ;place into HOME_ROW
    LDR R3, R0, #2      ;load COL value
    ST R3, HOME_COL     ;place into HOME_COL
    BR finishCat
fillInit
    LDR R3, R0, #1      ;load ROW value
    ST R3, CURRENT_ROW  ;place into CURRENT_ROW
    LDR R3, R0, #2      ;load COL value
    ST R3, CURRENT_COL  ;place into CURRENT_COL
    STR R7, R0, #3          ;place the asterix in instead of I
finishCat
    LD R0, keepR0Symbol
    LD R1, keepR1Symbol
    LD R2, keepR2Symbol
    LD R3, keepR3Symbol
    LD R7, keepR7Symbol
    JMP R7

keepR0Symbol    .FILL #0
keepR1Symbol    .FILL #0
keepR2Symbol    .FILL #0
keepR3Symbol    .FILL #0
keepR7Symbol    .FILL #0
homeCharVal     .FILL xFFB8 ;negative value of home (NOT 48 + 1)
initCharVal     .FILL xFFB7 ;negative value of init (NOT 49 + 1)
hyenaCharVal    .FILL xFFDD ;negative value of hyena (NOT 23 + 1)
asterixCharVal  .FILL x2A   ;holds char value of asterix to use for Simba

PLACE_IN_GRID           ;subroutine to place symbols into the grid
    ST R7, keepR7Place  ;keep PC value
    ST R0, keepR0Place  ;holds spot in the linked list
    ST R1, keepR1Place  
    ST R2, keepR2Place
    ST R3, keepR3Place  ;R3 needs to hold the start of the list
    LD R3, startOfGrid  ;LD the start of the grid
    ADD R3, R3, #15     ; Same as below
    ADD R3, R3, #3      ;Add row length to R3 to start it into placeable character row length
    AND R2, R2, #0      ;check PSR value to see if any rows need to be moved
    LD R2, rowLength    ;LD value of how long a row is
    LDR R1, R0, #1      ;check the value of row of the current symbol
    BRz nextStep
nextRow
    ADD R3, R3, R2      ;Add row length value to R3
    ADD R1, R1, #-1     ;decrement the row counter
    BRp nextRow
nextStep
    ADD R3, R3, #1      ;ADD 1 to address so that character can be placed into the spaces between lines    
    LDR R1, R0, #2      ;check the value of the column the symbol needs to be
    BRz spotFound
nextColumn
    ADD R3, R3, #2      ;Add 2 each time to move into the next column
    ADD R1, R1, #-1     ;decrement the column counter
    BRp nextColumn
spotFound    
    LDR R1, R0, #3      ;load the symbol value
    STR R1, R3, #0      ;Store the symbol into that spot in the grid
    LD R0, keepR0Place
    LD R1, keepR1Place
    LD R2, keepR2Place
    LD R3, keepR3Place
    LD R7, keepR7Place
    JMP R7
keepR0Place     .FILL #0
keepR1Place     .FILL #0
keepR2Place     .FILL #0
keepR3Place     .FILL #0
keepR7Place     .FILL #0  
rowLength       .FILL #36       ;value of the length of an entire row
startOfGrid     .FILL GRID      ;load the start of the grid  
          .END




