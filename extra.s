    .text
    .align 2

    /* helper functions for gettrans and translate */
range_equal: @ checks that the ranges are equal between the inchars and outchars; returns 1 if true, 0 if false
    @ one parameter, pointer to data structure
    push {fp, lr} @ setting up stack frame for range_equal
    add fp, sp, #4
    sub sp, sp, #16 @ three local vars, pointer to dat, inchar range, outchar range

    str r0, [fp, #-8] @ pointer to data structure

    push {r4} @ setting up r4 to hold pointer to data structure
    ldr r4, [fp, #-8]

    ldr r0, [r4, #_inchar] @ r0 holds first inchar
    ldr r1, [r4, #_incharII] @ r1 holds second inchar

    cmp r0, r1 @ comparing the two to see whether range is in ascending or descending order
    bgt range_equal_else

    sub r1, r1, r0
    str r1, [fp, #-12] @ storing range of inchar in [fp, #-12]

    ldr r0, [r4, #_outchar] @ holds first outchar
    ldr r1, [r4, #_outcharII] @ holds second outchar

    sub r1, r1, r0
    str r1, [fp, #-16] @ storing range of outchar in [fp, #-16]

    ldr r0, [fp, #-12] @ comparing ranges of inchar and outchar
    ldr r1, [fp, #-16]
    cmp r0, r1
    bne range_equal_false

    ldr r0, [r4, #_inchar] @ calculating the difference (offset) between the first characters of each range
    ldr r1, [r4, #_outchar]
    sub r1, r1, r0
    str r1, [r4, #_offset] @ storing offset value in dp->offset

    mov r0, #1 @ returning 1

    b range_equal_next

range_equal_else:
    sub r0, r0, r1
    str r0, [fp, #-12] @ storing range of inchar in [fp, #-12]

    ldr r0, [r4, #_outchar] @ holds first outchar
    ldr r1, [r4, #_outcharII] @ holds second outchar

    sub r0, r0, r1
    str r0, [fp, #-16] @ storing range of outchar in [fp, #-16]

    ldr r0, [fp, #-12] @ comparing ranges of inchar and outchar
    ldr r1, [fp, #-16]
    cmp r0, r1
    bne range_equal_false

    ldr r0, [r4, #_inchar] @ calculating the difference (offset) between the first characters of each range
    ldr r1, [r4, #_outchar]
    sub r1, r1, r0
    str r1, [r4, #_offset] @ storing offset value in dp->offset

    mov r0, #1 @ returning 1

    b range_equal_next

range_equal_false:
    mov r0, #0 @ returning 0

range_equal_next:
    pop {r4} @ restoring r4
    sub sp, fp, #4 @ tearing down range_equal stack frame
    pop {fp, pc}

in_range: @ checks to see if a character is in the range or not; returns 1 if in range, 0 if not in range
    @ one parameter, the pointer to the data structure
    push {fp, lr} @ setting up stack frame for in_range
    add fp, sp, #4
    sub sp, sp, #8 @ two local variables

    str r0, [fp, #-8] @ store pointer to dat
    str r1, [fp, #-12] @ store character to compare

    push {r4} @ setting r4 to be pointer to dat
    ldr r4, [fp, #-8]

    ldr r0, [r4, #_inchar] @ figuring out whether range is ascending or descending
    ldr r1, [r4, #_incharII]
    cmp r0, r1
    bgt in_range_else

    ldr r2, [fp, #-12] @ checking lower bound of range
    cmp r2, r0
    blt in_range_false

    cmp r2, r1 @ checking upper bound of range
    bgt in_range_false

    mov r0, #1 @ returning 1

    b in_range_next

in_range_else:
    ldr r0, [r4, #_inchar] @ getting ready for comparisons by assigning values
    ldr r1, [r4, #_incharII]
    ldr r2, [fp, #-12]

    cmp r2, r0 @ checking upper bound
    bgt in_range_false

    cmp r2, r1 @ checking lower bound
    blt in_range_false

    mov r0, #1 @ returning 1

    b in_range_next

in_range_false:
    mov r0, #0

in_range_next:
    pop {r4} @ restoring r4
    sub sp, fp, #4
    pop {fp, pc}



     /* gettrans: 
        - This function should take two arguments, the address of data structure of program information dp, and 
          a string representing an input line.  
        - Extract the first and third characters from the buffer (using get_byte), and store them in dp->inchar and dp->outchar. 
        - Return 1.
    */
gettrans:
    /* [fp, #-8] - stores return values from get_byte for the comparisons
        [fp, #-12] - pointer to data struct
        [fp, #-16] - input string */

    push {fp, lr} @ setting up gettrans stack frame
    add fp, sp, #4
    sub sp, sp, #16 @ 3 local variables

    str r0, [fp, #-12] @ storing pointer to data struct
    str r1, [fp, #-16] @ storing input string
    
    push {r4} @ setting up r4 to point to struct dat
    ldr r4, [fp, #-12]

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 0)
    mov r1, #0
    bl get_byte
    str r0, [fp, #-8] @ storing byte at index 0
    
    ldr r0, [fp, #-8] @ comparing buffa[0] == 0
    mov r1, #0
    cmp r0, r1
    beq else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 1)
    mov r1, #1
    bl get_byte
    str r0, [fp, #-8] @ storing byte at index 1
    
    ldr r0, [fp, #-8] @ comparing buffa[1] != '-'
    mov r1, #'-'
    cmp r0, r1
    bne else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 2)
    mov r1, #2
    bl get_byte
    str r0, [fp, #-8] @ storing byte at index 2
    
    ldr r0, [fp, #-8] @ comparing buffa[2] == 0
    mov r1, #0
    cmp r0, r1
    beq else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 3)
    mov r1, #3
    bl get_byte
    str r0, [fp, #-8] @ storing byte at index 3
    
    ldr r0, [fp, #-8] @ comparing buffa[3] != ' '
    mov r1, #' '
    cmp r0, r1
    bne else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 4)
    mov r1, #4
    bl get_byte
    str r0, [fp, #-8] @ storing byte at index 4
    
    ldr r0, [fp, #-8] @ comparing buffa[4] == 0
    mov r1, #0
    cmp r0, r1
    beq else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 5)
    mov r1, #5
    bl get_byte
    str r0, [fp, #-8] @ storing byte at index 5
    
    ldr r0, [fp, #-8] @ comparing buffa[5] != '-'
    mov r1, #'-'
    cmp r0, r1
    bne else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 6)
    mov r1, #6
    bl get_byte
    str r0, [fp, #-8] @ storing byte at index 6
    
    ldr r0, [fp, #-8] @ comparing buffa[6] == 0
    mov r1, #0
    cmp r0, r1
    beq else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 7)
    mov r1, #7
    bl get_byte
    str r0, [fp, #-8]

    ldr r0, [fp, #-8] @ comparing buffa[7] != '\n'
    mov r1, #'\n'
    cmp r0, r1
    bne else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 8)
    mov r1, #8
    bl get_byte
    str r0, [fp, #-8]

    ldr r0, [fp, #-8] @ comparing buffa[8] != 0
    mov r1, #0
    cmp r0, r1
    bne else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 0); storing in inchar in dat
    mov r1, #0
    bl get_byte
    str r0, [r4, #_inchar]

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 2); storing in outchar in dat
    mov r1, #4
    bl get_byte
    str r0, [r4, #_outchar]

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 2); storing in incharII in dat
    mov r1, #2
    bl get_byte
    str r0, [r4, #_incharII]

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 2); storing in incharII in dat
    mov r1, #6
    bl get_byte
    str r0, [r4, #_outcharII]

    mov r0, r4 @ checking if the range between inchar is equal to outchar
    bl range_equal
    mov r1, #1
    cmp r0, r1
    bne else

    mov r0, #1 @ returns 1

    b next
    
else:
    mov r0, #0 @ returns 0
next:
    pop {r4} @ restore r4
    sub sp, fp, #4 @ tearing down stack frame
    pop {fp, pc}

    bx lr @ returning

    
    .align 2
gt_promptP: .word gt_prompt @ pointer to gt_prompt format string
buffaP: .word buffa @ pointer to buffa string

/* helper functions for translate: is_upper and is_lower */

is_upper: @ function to check if ascii code is for an uppercase letter; returns 1 if true, 0 if false
    push {fp, lr} @ setting up is_upper stack frame
    add fp, sp, #4
    sub sp, sp, #8 @ one local variable, the ascii character

    str r0, [fp, #-8] @ the ascii value to be examined

    ldr r0, [fp, #-8] @ checking the ascii character is greater than or equal to 'A'
    mov r1, #65
    cmp r0, r1
    blt iu_false

    mov r1, #90 @ checking the ascii character is less than or equal to 'Z'
    cmp r0, r1
    bgt iu_false

    mov r0, #1 @ returns 1 if both cases are true
    b iu_next

iu_false:
    mov r0, #0 @ returns 0 if either case is false

iu_next:
    sub sp, fp, #4 @ tearing down is_upper stack frame
    pop {fp, pc}

is_lower: @ function to check if ascii code is for a lowercase letter; returns 1 if true, 0 if false
    push {fp, lr} @ setting up is_lower stack frame
    add fp, sp, #4
    sub sp, sp, #8 @ one local variable, the ascii character

    str r0, [fp, #-8] @ the ascii value to be examined

    ldr r0, [fp, #-8] @ checking the ascii character is greater than or equal to 'a'
    mov r1, #97
    cmp r0, r1
    blt il_false

    mov r1, #122 @ checking the ascii character is less than or equal to 'z'
    cmp r0, r1
    bgt il_false

    mov r0, #1 @ returns 1 if both cases are true
    b il_next

il_false:
    mov r0, #0 @ returns 0 if either case is false

il_next:
    sub sp, fp, #4 @ tearing down is_lower stack frame
    pop {fp, pc}
    
    /* translate:
    This function should accept two arguments, the address of data structure of program information dp, and one 
    non-constant/non-empty string argument.  
    It should replace the first character of arg2 by the asterisk character *.
    Return the input buffer arg2 (after replacement).   */

translate:

    /* [fp, #-8] - pointer to dat 
        [fp, #-12] - pointer to buff
        [fp, #-16] - indx
        [fp, #-20] - in_word 
        [fp, #-24] - temporary byte storage */

    push {fp, lr} @ setting up translate stack frame
    add fp, sp, #4
    sub sp, sp, #24 @ 6 local vars

    str r0, [fp, #-8] @ storing dat
    str r1, [fp, #-12] @ storing buff

    push {r4, r5, r6, r7, r8} @ initializng r4, r5, r6, r7, r8
    ldr r4, [fp, #-8]

    ldr r5, [r4, #_inchar] @ r5 is dp->inchar
    ldr r6, [r4, #_outchar] @ r6 is dp->outchar
    ldr r7, [r4, #_charct] @ r7 is dp->charct

    ldr r8, [fp, #-16] @ r8 is indx

    mov r0, #0 @ assigning 0 to indx
    str r0, [fp, #-16]

    mov r0, #0 @ assigning 0 to in_word
    str r0, [fp, #-20]

    b t_next

t_loop: @ changes inchar to outchar
    ldr r0, [fp, #-12] @ calling get_byte(buff, indx)
    ldr r1, [fp, #-16]
    bl get_byte
    str r0, [fp, #-28] @ storing returned byte
    
    mov r0, r4 @ checking whether that byte is in range
    ldr r1, [fp, #-28]
    bl in_range

    cmp r0, #1 @ comparing the in_range return to #1
    bne t_ifElse @ branch if in_range != #1
    
    ldr r3, [r4, #_offset] @ incrementing the char by the offset for replacement
    ldr r2, [fp, #-28]
    add r2, r2, r3
    str r2, [fp, #-28]

    ldr r0, [fp, #-12] @ calling put_byte(buff, indx, dp->outchar)
    ldr r1, [fp, #-16]
    ldr r2, [fp, #-28]
    bl put_byte

    ldr r1, [r4, #_transct] @ increments translation counter in dat (dp->transct)
    add r1, r1, #1
    str r1, [r4, #_transct]

t_ifElse: @ checks for newline to keep track of lines
    ldr r0, [fp, #-12] @ calling get_byte(buff, indx)
    ldr r1, [fp, #-16]
    bl get_byte
    mov r1, #'\n'
    cmp r0, r1 @ comparing the byte to '\n'
    bne t_ifElse2 @ branch if byte != '\n'

    ldr r1, [r4, #_linect] @ incrementing dp->linect
    add r1, r1, #1
    str r1, [r4, #_linect]    

t_ifElse2: @ checks for space AND if in_word == 1 to change in_word to 0
    ldr r0, [fp, #-12] @ calling get_byte(buff, indx)
    ldr r1, [fp, #-16]
    bl get_byte
    mov r1, #32 @ comparing get_byte and space character
    cmp r0, r1
    bne t_ifElse3 @ if get_byte != 32, branches

    ldr r2, [fp, #-20] @ comparing in_word to 1
    mov r3, #1
    cmp r2, r3
    bne t_ifElse3 @ if in_word != 1, branches

    mov r2, #0 @ storing 0 in in_word
    str r2, [fp, #-20]

t_ifElse3: @ checks for an uppercase OR lowercase letter 
    ldr r0, [fp, #-12] @ calling get_byte(buff, indx)
    ldr r1, [fp, #-16]
    bl get_byte

    str r0, [fp, #-24] @ storing return from get_byte

    ldr r0, [fp, #-24] @ checking if the return value from get_byte is uppercase
    bl is_upper 

    mov r1, #1 @ comparing return value from is_upper to 1
    cmp r0, r1
    beq t_is_word @ branch if is uppercase letter

    ldr r0, [fp, #-24] @ checking if the return value from get_byte is lowercase
    bl is_lower

    mov r1, #1 @ checking if the return value from get_byte is lowercase
    cmp r0, r1
    bne t_else @ branch if not lowercase letter

t_is_word: @ checks in_word == 0, if so, increments dp->wordct
    ldr r1, [fp, #-20] @ comparing in_word to 0, branches if in_word not equal to 0
    mov r2, #0
    cmp r1, r2
    bne t_else @ branch if in_word != 0

    ldr r1, [r4, #_wordct] @ incrementing dp->wordct
    add r1, r1, #1
    str r1, [r4, #_wordct]

    mov r1, #1 @ assigning in_word to 1
    str r1, [fp, #-20]

t_else: @ increments charct and indx

    ldr r1, [r4, #_charct] @ incrementing dp->charct
    add r1, r1, #1
    str r1, [r4, #_charct] 

    ldr r1, [fp, #-16] @ incrementing indx
    add r1, r1, #1
    str r1, [fp, #-16]

t_next:
    ldr r0, [fp, #-12] @ calling get_byte(buff, indx)
    ldr r1, [fp, #-16]
    bl get_byte
    cmp r0, #0 @ comparing get_byte(buff, indx) == 0
    bne t_loop @ branches if get_byte is not a null byte

    ldr r0, [fp, #-12] @ returning buff
    pop {r4, r5, r6, r7, r8} @ restoring r4, r5, r6, r7, r8
    sub sp, fp, #4 @ tearing down translate stack frame
    pop {fp, pc}


    .section .rodata
    .align 2
printSummaryText: @ format string for print_summary when printf called
    .asciz "Print Summary: \n"
    .align 2
printNumChars: @ format string for the number of characters
    .asciz "  %d characters\n"
    .align 2
printNumLines: @ format string for the number of lines
    .asciz "  %d lines\n"
    .align 2
printNumWords: @ format string for the number of words
    .asciz "  %d words\n"
    .align 2
printNumTrans: @ format string for the number of translations
    .asciz "  %d translations\n"

    .text
    .align 2

    /* print_summary
        This program should  take one argument, the address of data structure of program information dp, and should 
        print only the header line of the specified print_summary output.
 */
print_summary:

    /* [fp, #-8] - pointer to dat */

    push {fp, lr} @ setting up print_summary stack frame
    add fp, sp, #4
    sub sp, sp, #8 @ 1 local variables

    str r0, [fp, #-8] @ storing dat

    push {r4} @ initializing r4 to hold dat
    ldr r4, [fp, #-8]

    ldr r0, printSummaryTextP @ printing header
    bl printf

    ldr r0, printNumCharsP @ printing number of characters
    ldr r1, [r4, #_charct]
    bl printf

    ldr r0, printNumWordsP @ printing number of words
    ldr r1, [r4, #_wordct]
    bl printf

    ldr r0, printNumLinesP @ printing number of lines
    ldr r1, [r4, #_linect]
    bl printf

    ldr r0, printNumTransP @ printing number of translations
    ldr r1, [r4, #_transct]
    bl printf

    pop {r4} @ restoring r4

    sub sp, fp, #4 @ tearing down print_summary stack frame
    pop {fp, pc}


    .align 2
printSummaryTextP: .word printSummaryText @ pointer to printSummaryText format string
printNumCharsP: .word printNumChars @ pointer to printNumChars format string
printNumLinesP: .word printNumLines @ pointer to printNumLines format string
printNumWordsP: .word printNumWords @ pointer to printNumWords format string
printNumTransP: .word printNumTrans @ pointer to printNumTrans format string


    .section .rodata
    .align 2
prompt: @ format string for the prompt to enter a line of text
    .asciz "%d\n"
    .align 2
printBuff: @ format string for printing buff
    .asciz "%s"
    .align 2
printInOutChar: @ format string for printing inchar and outchar
    .asciz "inchar: %c, outchar: %c\n"
    .align 2
gt_prompt: @ format string for the gettrans prompt when printf is called
    .asciz "Enter the character to replace followed by a space and the character to replace with:\n"
    .align 2
gt_error: @ format string if gettrans used incorrectly
    .asciz "Input not correct, please try again\n"
    
    .data
    .align 2
buffa: .skip 10 @ string for character substitution
buff: .skip 100 @ setting up buff string
dat:				@ global variable dat of type struct trans
	.word   0		 @ member inchar of type int
	.word   0		 @ member outchar of type int
    .word   0        @ member charct of type int
    .word   0        @ member wordct of type int
    .word   0        @ member linect of type int
    .word   0        @ member transct of type int
    .word   0        @ member incharII of type int
    .word   0        @ member outcharII of type int
    .word   0        @ member offset of type int
	_inchar = 0		@ _inchar is offset for member inchar
	_outchar = 4		@ _outchar is offset for member outchar
    _charct = 8     @ _charct is offset for memeber charct
    _wordct = 12    @ _wordct is offset for member wordct
    _linect = 16    @ _linect is offset for member linect
    _transct = 20   @_transct is offset for member transct
    _incharII = 24  @_incharII is offest for member incharII
    _outcharII = 28 @_outcharII is offset for member outcharII
    _offset = 32    @_offset is offset for member offset

    .text
    .align 2
    .global main

main:

    /* [fp, #-8] - return value from gettrans */

    push {fp, lr} @ setting up main stack frame
    add fp, sp, #4
    sub sp, sp, #8 @ 1 local variables

    push {r4} @ set up r4 to work with dat struct
    ldr r4, datP

    ldr r0, buffaP @ calling get_line(buff, 4)
    mov r1, #10
    bl get_line

    ldr r0, datP @ calling gettrans(dat, buffa)
    ldr r1, buffaP
    bl gettrans

    str r0, [fp, #-8] @ storing return value from gettrans
    ldr r0, [fp, #-8]
    cmp r0, #0
    beq invalid @ if gettrans returned zero, stop running the rest of the program
    b main_next

main_loop:
    ldr r0, datP @ calling translate(dat, buff)
    ldr r1, buffP
    bl translate

    ldr r0, printBuffP @ calling printf with printBuff format string
    ldr r1, buffP
    bl printf

main_next:
    ldr r0, buffP @ calling get_line(buff, 100)
    mov r1, #100
    bl get_line

    mov r1, #0 @ comparing return value from get_byte to 1
    cmp r0, r1
    bgt main_loop

    ldr r0, datP @ prints print summary
    bl print_summary

    b closeMain

invalid:
    @ldr r0, gt_errorP @ gettrans error, called in gettrans returns 0
    @bl printf

closeMain:
    pop {r4} @ restore r4
    sub sp, fp, #4 @ tearing down stack frame
    pop {fp, pc}


    .align 2
datP:	.word dat @ pointer to struct dat
promptP: .word prompt @ pointer to prompt format string
printBuffP: .word printBuff @ pointer to printBuff format string
printInOutCharP: .word printInOutChar @ pointer to printInOutChar format string
buffP: .word buff @ pointer to buff string
gt_errorP: .word gt_error @ pointer to gt_error format string
