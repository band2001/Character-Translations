Ben Anderson - Extra Features 

1. Instead of substituting a single character, you now  substitute ranges of characters as long as the range between the substitution and translation is the same. For the program to work, you need to enter the range to substitute and the range to replace with as follows:
        a-z A-Z
If it is not entered as such, the program will not run. You can enter the range in either ascending or descending order as long as both the characters to substitute and characters to substitute with are in the same order (i.e. it does not matter if a-z A-Z or z-a Z-A is entered, the result will be the same). The ranges also do not need to be the same characters just in uppercase/lowercase form. Entering:
        a-m n-z
is valid as well, just so long as length of the range between both the to change and to change to input is the same. Here are some test cases:
- a-m A-M with "hello, world" entered will print "HELLo, worLD"
- a-m n-z with "hello, world" entered will print "uryyo, woryq"
- a-k !-+ with "hello, world" entered will print "(%llo, worl$"

2. Print summary also now includes a statement documenting the number of translations made
