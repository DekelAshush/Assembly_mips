# Assembly_mips
There are 2 assignment here, The First assignment is:
For the input "Sarah Jessica Parker", the program should output:
Sarah Jessica Parker
Sarah Jessica Parke
Sarah Jessica Park
Sarah Jessica Par
Sarah Jessica Pa
Sarah Jessica P
Sarah Jessica 
Sarah Jessic
Sarah Jessi
Sarah Jess
Sarah Jes
Sarah Je
Sarah J
Sarah 
Sara
Sar
Sa
S

The second Assignment is:
The program receives a string of characters (must be careful with an appropriate input message) with a maximum length of 31 characters (actually 30).
There are pairs of digits in base 8 (byte size) separated by the character $. After the last pair type ENTER. 
The string must be saved in the data segment in the stringocta array.

The program checks with the help of a procedure called is_valid (which accepts as a parameter the address of the stringocta array) whether the input is valid
(if valid, a value between 1-10 will be returned in $v0 indicating the number of pairs of digits in base 8, and if invalid, the value 0 will be returned)

A valid string should:
Contains no more than 30 characters of pairs of digits in base 8 (between 0-7) separated by $ characters between them and ending with the $ character, 
and the marking for the end of a string by the husky code 0 (null terminate) or the husky code 10 (new line) at the end of a string.
Example of valid input: 12$77$23$56$76$00$76$07$
In this case, the valid procedure will return in $v0 the value 8 to indicate that 8 pairs of digits were received in base 8.
Example of illegal input: 111$23$$34$Q3$7$82$2$77$122$43
In this case, the valid procedure will return in $v0 the value 0.

If the input is valid, we will reach this stage where the procedure called convert will be called, which receives three parameters,
one is the address of the stringocta array, the second is the address of an array called NUM, and the third is the number of pairs of octa digits (the value in $v0). 
The procedure converts each pair of characters in the stringocta array to a byte-sized numeric value in the NUM array in order of appearance.
then we will print the values of the array 1 by 1.
then we will sort the array and print it again 1 by 1.





