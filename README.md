Use either trans.s or extra.s to run the full program. 

trans.s instructions:

When the program runs, you will be permitted to enter two single characters, separated by a space in the command line. The first character is the character you would like to substitute, the second is a character that you would like to replace the first character with. Once you hit enter, you will be allowed to enter a line of text (no longer than 100 chars). When you hit enter, all the characters you would like changed will be changed and printed back to you. You can keep entering lines for as long as you would like. To stop running the program, when you have the opportunity to type a newline, press CTRL+D. After pressing that, a summary will appear with the total number of chars, lines, and words entered over the course of the program. 

- Sample Cases:
- {user input} s S
- {user input} Red fish, blue fish
-     {output} Red FiSh, blue fiSh
- {user input}        One fish, two fish
-     {output}        One fiSh, two fiSh

extra.s instructions: 

1. Instead of substituting a single character, you now  substitute ranges of characters as long as the range between the substitution and translation is the same. For the program to work, you need to enter the range to substitute and the range to replace with as follows:
        a-z A-Z
If it is not entered as such, the program will not run. You can enter the range in either ascending or descending order as long as both the characters to substitute and characters to substitute with are in the same order (i.e. it does not matter if a-z A-Z or z-a Z-A is entered, the result will be the same). The ranges also do not need to be the same characters just in uppercase/lowercase form. Entering:
        a-m n-z
is valid as well, just so long as length of the range between both the to change and to change to input is the same. Here are some test cases:
- a-m A-M with "hello, world" entered will print "HELLo, worLD"
- a-m n-z with "hello, world" entered will print "uryyo, woryq"
- a-k !-+ with "hello, world" entered will print "(%llo, worl$"

2. Print summary also now includes a statement documenting the number of translations made
