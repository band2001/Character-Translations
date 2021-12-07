    .text
    .align 2

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

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 1)
    mov r1, #1
    bl get_byte
    str r0, [fp, #-8] @ storing byte at index 1
    
    ldr r0, [fp, #-8] @ comparing buffa[1] != ' '
    mov r1, #' '
    cmp r0, r1
    bne else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 3)
    mov r1, #3
    bl get_byte
    str r0, [fp, #-8]

    ldr r0, [fp, #-8] @ comparing buffa[3] != '\n'
    mov r1, #'\n'
    cmp r0, r1
    bne else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 4)
    mov r1, #4
    bl get_byte
    str r0, [fp, #-8]

    ldr r0, [fp, #-8] @ comparing buffa[4] != 0
    mov r1, #0
    cmp r0, r1
    bne else

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 0); storing in inchar in dat
    mov r1, #0
    bl get_byte
    str r0, [r4, #_inchar]

    ldr r0, [fp, #-16] @ calling get_byte(buffa, 2); storing in outchar in dat
    mov r1, #2
    bl get_byte
    str r0, [r4, #_outchar]

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

    /* translate:
    This function should accept two arguments, the address of data structure of program information dp, and one 
    non-constant/non-empty string argument.  
    It should replace the first character of arg2 by the asterisk character *.
    Return the input buffer arg2 (after replacement).   */

translate:

    /* [fp, #-8] - pointer to dat
        [fp, #-12] - pointer to buff */

    push {fp, lr} @ setting up translate stack frame
    add fp, sp, #4
    sub sp, sp, #8 @ 2 local vars

    str r0, [fp, #-8] @ storing dat
    str r1, [fp, #-12] @ storing buff

    ldr r0, [fp, #-12] @ calling put_byte(buff, 6, 'X')
    mov r1, #0
    mov r2, #'*'
    bl put_byte

    sub sp, fp, #4 @ tearing down translate stack frame
    pop {fp, pc}


    .section .rodata
    .align 2
printSummaryText: @ format string for print_summary when printf called
    .asciz "Print Summary: \n"

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
    sub sp, sp, #8 @ 1 local variable

    str r0, [fp, #-8] @ storing dat

    ldr r0, printSummaryTextP
    bl printf

    sub sp, fp, #4 @ tearing down print_summary stack frame
    pop {fp, pc}


    .align 2
printSummaryTextP: .word printSummaryText @ pointer to printSummaryText format string


    .section .rodata
    .align 2
prompt: @ format string for the prompt to enter a line of text
    .asciz "Enter a line of text: \n"
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
	.word			@ member val of type int
	.word			@ member val of type int
    .word           @ member val of type int
    .word           @ member val of type int
    .word           @ member val of type int
	_inchar = 0		@ _inchar is offset for member val
	_outchar = 4		@ _outchar is offset for member val
    _charct = 8     @ _charct is offset for memeber val
    _wordct = 12    @ _wordct is offset for member val
    _linect = 16    @ _linect is offset for member val

    .text
    .align 2
    .global main

main:
    push {fp, lr} @ setting up main stack frame
    add fp, sp, #4
    sub sp, sp, #8 @ 1 local variables

    push {r4} @ set up r4 to work with dat struct
    ldr r4, datP

    ldr r0, gt_promptP @ calling printf with gt_prompt format string
    bl printf

    ldr r0, buffaP @ calling get_line(buff, 4)
    mov r1, #10
    bl get_line

    ldr r0, datP @ calling gettrans(dat, buffa)
    ldr r1, buffaP
    bl gettrans

    str r0, [fp, #-8] @ storing return value from gettrans
    ldr r0, [fp, #-8]
    cmp r0, #0
    beq invalid

    ldr r0, printInOutCharP @ printing inchar, outchar
    ldr r1, [r4, #_inchar]
    ldr r2, [r4, #_outchar]
    bl printf

    ldr r0, promptP @ recalling prompt for new buff entry
    bl printf

    ldr r0, buffP @ calling get_line(buff, 100)
    mov r1, #100
    bl get_line

    ldr r0, datP @ calling translate(dat, buff)
    ldr r1, buffP
    bl translate

    ldr r0, printBuffP @ calling printf with printBuff format string
    ldr r1, buffP
    bl printf

    ldr r0, datP @ prints header for print summary
    bl print_summary

    b closeMain

invalid:
    ldr r0, gt_errorP @ gettrans error, called in gettrans returns 0
    bl printf

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
