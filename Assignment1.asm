#Title: Maman 11 question 3                      
#Filename:mmn11q3
#Author: dekel ashush | דקל עשוש
#ID: 316031194
#Description:print a string in a staggered form.
#Input: String 1-30 letter long
#Output: The program presents the string in a graded form

###################### Data segment ###########################
.data
	input:  .space 31   # Space for input string (up to 30 characters + null terminator)
	message: .asciiz "Enter a string (up to 30 characters): "
	nextRow: .asciiz "\n"

###################### Code segment ###########################

.text
.globl main

main: #main program entry
    
    li $v0, 4         # Print string
    la $a0, message   # Load address of message string
    syscall  #print messege

    # Read input from user
    li $v0, 8         # Read input string
    la $a0, input    # Load address of input buffer
    li $a1, 30       # Maximum number of characters to read
    syscall #get the string

    # Initialize variables
    move $t0, $a0     # Copy address of input buffer to $t0
    lb $t1, ($t0)     # Load a byte from input buffer
    

    # Print the original string in staggered form
    la $t0, input       # Load the address of the input string into t0
    li $t1, 0           # Initialize a counter to keep track of the current character position

#arr.length

loop:
    lb $t2, ($t0)       # Load the character at the current position
    beqz $t2, end_loop  # If the character is null, exit loop
    addi $t0, $t0, 1    # Move to the next character
    addi $t1, $t1, 1    # Increment the counter
    j loop

end_loop:
    # Calculate array length
    sub $t1, $t1, 1     # Decrement the counter to get the correct array length
#arr.length
    move $t6,$t1 #save the row of string in $t6 
    move $t7,$t6 #save the col in $t7


la $t0, input      # Load the address of the input string into t0
Letterloop: #print the next word, each time with 1 letter less
   	  lb $t5, ($t0)       # Load the character at the current position
  	  beqz $t6, next_word  # If we finished printing the string jump
  	  sub $t6,$t6,1
  	  li $v0, 11          # Print character syscall code
 	  move $a0, $t5       # Load the character to print
 	  syscall #print first letter

  	  addi $t0, $t0, 1    # Move to the next character
 	  j Letterloop #jump to print next letter
    
next_word:
   		la $t0, input # Load the address of the input string into t00
   		sub $t7,$t7,1 #need to print without the last letter each time
   		move $t6,$t7 #save the col in $t7
		beqz $t7,exit_printing #when col finish means all printed so go to finish program
		
		li $v0, 4  # Print string
    		la $a0, nextRow   # Load nextRow
   		syscall  #print nextRow
    		j Letterloop #jump to print next word

exit_printing:
    # Exit program
    li $v0, 10        # Exit program
    syscall


