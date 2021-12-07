/* example of using a global struct */

	.data
/* global variables */
	.align 2
dat:				@ global variable dat of type  struct try
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


/* function mod
      1 arg - pointer to a variable of type  struct try
      state change - add 1 to arg1->val and assign 'X' to arg1->str[1]
      return - integer, value of arg1->val */
	.text
mod:
	push	{fp, lr}		@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8		@ one local variable
	@ [fp, #-8] holds dp, pointer to variable of type  struct try
	@ r4 holds copy of the pointer dp

	str	r0, [fp, #-8]		@ initialize argument dp
	
	push	{r4}			@ save and initialize r4
	ldr	r4, [fp, #-8]		

	ldr	r1, [r4, #_inchar]		@ add 100 to dp->inchar
	add	r1, r1, #100
	str	r1, [r4, #_inchar]

	ldr	r1, [r4, #_outchar]		@ add 100 to dp->outchar
	add	r1, r1, #100
	str	r1, [r4, #_outchar]

    ldr	r1, [r4, #_charct]		@ add 100 to dp->charct
	add	r1, r1, #100
	str	r1, [r4, #_charct]

	ldr	r1, [r4, #_wordct]		@ add 100 to dp->wordct
	add	r1, r1, #100
	str	r1, [r4, #_wordct]

	ldr	r1, [r4, #_linect]		@ add 100 to dp->linect
	add	r1, r1, #100
	str	r1, [r4, #_linect]

	ldr	r0, [r4, #_inchar]		@ return dp->inchar
	pop	{r4}			@ restore value of r4
	sub	sp, fp, #4		@ tear down stack frame
	pop	{fp, pc}

/* format strings */
	.section .rodata
	.align 2
return:					@ format string for return value
	.asciz "mod(dp) returned %d\n"
	.align 2
dump:					@ format string for dat members
	.asciz "dat holds inchar: %d, outchar: %d, charct: %d, "
    .align 2
dumpa:
    .asciz "wordct: %d, linect: %d\n"

/* function main */
	.text
	.global main
	.align 4
main:	
	push	{fp, lr}		@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8		@ two local variables
	@ [fp, #-8] holds dp, pointer to variable of type  struct try
	@ [fp, #-12] holds dp, pointer to variable of type  struct try
	@ r4 holds copy of the pointer dp

	push	{r4}			@ save and initialize r4
	ldr	r4, datP		@ assign address of dat to r4

	str	r4, [fp, #-8]		@ initialize local variable dp
	mov	r1, #10			@ store 10 in dp->inchar
	str	r1, [r4, #_inchar]
	mov	r1, #11		@ store address buff in dp->outchar
	str	r1, [r4, #_outchar]
	mov	r1, #12		@ store address buff in dp->charct
	str	r1, [r4, #_charct]
	mov	r1, #13		@ store address buff in dp->wordct
	str	r1, [r4, #_wordct]
	mov	r1, #14		@ store address buff in dp->linect
	str	r1, [r4, #_linect]

	ldr	r0, dumpP		@ print labelled members of dp
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
    ldr r3, [r4, #_charct]
	bl	printf
    ldr r0, dumpaP
    ldr r1, [r4, #_wordct]
    ldr r2, [r4, #_linect]
    bl printf

	ldr	r0, [fp, #-8]		@ call mod(dp)
	bl	mod
	str	r0, [fp, #-12]		@ store return value in ret

	ldr	r0, returnP		@ print labelled return value
	ldr	r1, [fp, #-12]
	bl	printf

	ldr	r0, dumpP		@ print labelled members of dp
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
    ldr r3, [r4, #_charct]
	bl	printf
    ldr r0, dumpaP
    ldr r1, [r4, #_wordct]
    ldr r2, [r4, #_linect]
    bl printf

	mov	r0, #0			@ return 0
	pop	{r4}			@ restore value of r4
	sub	sp, fp, #4		@ tear down stack frame
	pop	{fp, pc}

/* pointer variables */

	.align 2
datP:	.word dat
returnP:
	.word return
dumpP:	.word dump
dumpaP: .word dumpa
	
