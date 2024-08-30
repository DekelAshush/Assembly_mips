
#Author: dekel ashush | דקל עשוש
#Description: get numbers in octa  
#Input: String 1-30 letter long
#Output: move it to decimal than print it than order it and print again

###################### Data segment ###########################
.data
	stringocta:     .space 31        # Reserve space for the input string
	NUM: .space 10 # Reserve space for the NUM array
	sortarray: .space 10 # Reserve space for the sortarray array
	invalid_msg:    .asciiz "Input is invalid. Please enter again: "
	prompt_msg:     .asciiz "Enter a string of octal pairs separated by $ (max 30 chars): "
	valid_msg:	.asciiz "Input is valid."
	convert_msg: .asciiz "Input is convert."
	newline: .asciiz "\n"
        finish_print_msg: .asciiz "array done printing."
        finish_sort_msg: .asciiz "sortarray is now sorted."
###################### Data segment ###########################        
        
.text
.globl main
main:
    # Print prompt message
    li $v0, 4
    la $a0, prompt_msg
    syscall
    
    # Read input string
    li $v0, 8
    la $a0, stringocta
    li $a1, 31
    syscall
    
input_loop:
    # Check if input is valid
    la $a0, stringocta   # Load the address of the input string
    jal is_valid #jump to is valid
    beqz $v0, invalid_input #input not valid jump to enter again
    
    
    move $t4, $v0       # Number of pairs of octa digits need to save it for later procedure
    la $a0, stringocta   # Address of the stringocta array
    move $a1, $v0       # Number of pairs of octa digits
    la $a2, NUM   # Address of the NUM array
    jal convert #jump to conert
    
    move $t3,$t4         # Number of pairs of octa digits need to save it for later procedure
    la $a0, NUM        # Address of the NUM array
    move $a1,$t4        # Number of digits to print 
    jal print #jump to print
    
    move $t7,$t3         # Number of pairs of octa digits need to save it for later procedure
    la $a0, sortarray   # Load address of sortarray into $t6
    la $a1, NUM         # Load address of NUM array into $t7
    move $a2, $t3       # Copy the number of bytes to sort 
    jal sort            # Call the sort procedure
   

    la $a0, sortarray  # Address of the sortarray array
    move $a1,$t7      # Number of digits to print 
    jal print #jump to print

exit_print:

    # Exit the program
    li $v0, 10
    syscall
    
# Procedure to check if the input is valid
is_valid:
    # $a0 contains the address of the input string
    
    move $t0, $a0	  # Copy address to $t0
    li $t1, 0             # Initialize a counter to keep track of valid pairs
    
loop:
    lb $t2, ($t0)         # Load the first character of the pair
    beqz $t2,valid   # If it's NULL (end of string), exit loop
    
    li $t3, 10            # ASCII value of '\n' (newline)
    beq $t2, $t3, valid  # If it's newline, exit loop
    
    li $t3, 48            # ASCII value of '0'
    li $t4, 55             # ASCII value of '7'
    blt $t2, $t3, invalid_pair  # If less than '0', invalid pair
    bgt $t2, $t4, invalid_pair  # If greater than '7', invalid pair
    
    addi $t0, $t0, 1      # Move to the second character of the pair
    lb $t2, ($t0)         # Load the second character of the pair
    li $t3, 48            # ASCII value of '0'
    li $t4, 55             # ASCII value of '7'
    blt $t2, $t3, invalid_pair  # If less than '0', invalid pair
    bgt $t2, $t4, invalid_pair  # If greater than '7', invalid pair
    
    addi $t0, $t0, 1      # Move to the third character of the pair
    lb $t2, ($t0)         # Load the third character of the pair
    li $t3, 36            # ASCII value of '$'
    bne $t2, $t3,invalid_pair  # If it's '$', move to the next pair
    
    addi $t0, $t0, 1      # Move to the next pair
    addi $t1, $t1, 1      # Increment valid pair counter
    j loop

invalid_pair:
    li $v0, 0             # Set the return value to 0
    jr $ra                 

invalid_input:
    # Print invalid message
    li $v0, 4
    la $a0, invalid_msg
    syscall
    
    
    # Clear the input buffer
    li $v0, 8
    la $a0, stringocta
    li $a1, 31
    syscall
     move $v0,$zero #if input nut valid $vo get value zero
    
    # Go back to input loop
    j input_loop
    
valid: # Print valid message
    
    li $v0, 4
    la $a0, valid_msg
    syscall
    
    move $v0, $t1         # Return the valid pair count
    jr $ra                #end of procedure go back 
    
    
# Procedure to convert stringocta into dec value and put in into num
convert:
    
    move $t0, $a0       # Copy address of stringocta to $t0
    move $t5, $a1       # Copy numbers of pairs
    move $t7, $a2       # Copy address of NUM to $t7

    convert_loop:
    beq $t5, $zero, convert_done  # If all pairs converted, exit loop
    
    lb $t2, ($t0)           # Load the first character of the pair
    lb $t3, 1($t0)          # Load the second character of the pair
    sub $t2, $t2, 48        # Convert ASCII to numerical value
    sub $t3, $t3, 48        # Convert ASCII to numerical value
    mul $t2, $t2, 8         # Multiply first digit by 8
    add $t2, $t2, $t3       # Add second digit
    
    sb $t2, ($t7)           # Store the result in NUM array
    
    addi $t0, $t0, 3        # Move to the next pair
    addi $t7, $t7, 1        # Move to the next location in NUM array
    addi $t5, $t5, -1       # Decrement loop counter
    
    j convert_loop
    
convert_done:
    # move to the next row
    li $v0, 4
    la $a0, newline
    syscall
    
     # Tell the program that convert is done succesfully
    li $v0, 4
    la $a0, convert_msg
    syscall
    
     # move to the next row
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra #end of procedure go back 
    
    
# Procedure to print array
print: 
	  move $t7,$a0 # Address of the NUM array
          move $t4,$a1 # Number of digits to print 
          prin_num: #print the next word, each time with 1 letter less
   	  lbu $t5, ($t7)       # Load the character at the current position
  	  beqz $t4, finish_print  # If we finished printing the string jump
  	  sub $t4,$t4,1
  	  li $v0, 1         # Print number  syscall code
 	  move $a0, $t5       # Load the number to print
 	  syscall  #print first letter
	
   	  li $a0, 32 #ASCII code of black space
	  li $v0, 11  # syscall number for printing character
	  syscall

	  li $a0, 32 #ASCII code of black space
	  li $v0, 11  # syscall number for printing character
	  syscall  #theres 2 spaces between 2 numbers
	
  	  addi $t7, $t7, 1    # Move to the next character
 	  j prin_num #jump to print next letter
    
    
finish_print:    
     # move to the next row
    li $v0, 4
    la $a0, newline
    syscall
    
     # move to the next row
    li $v0, 4
    la $a0, finish_print_msg
    syscall
    
    # move to the next row
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra #end of procedure go back 

    

  # Procedure to sort the array

sort: 
    move $t0, $a0       # Copy address of sortarray to $t0
    move $t6, $a0       # Copy address of sortarray to $t0
    move $t1, $a1       # Copy address of NUM array to $t1
    move $t2, $a2       # Copy number of bytes to sort to $t2
    move $t8, $a2       # Copy number of bytes to sort to $t2
move_num_into_sortarray:
    beqz $t2, move_done # If no more bytes to sort, exit loop
    
    lb $t3, ($t1)       # Load byte from NUM array
    sb $t3, ($t0)       # Store byte in sortarray
    
    addi $t0, $t0, 1    # Move to next position in sortarray
    addi $t1, $t1, 1    # Move to next position in NUM array
    addi $t2, $t2, -1   # Decrement byte counter
    
    j move_num_into_sortarray
    
    
    
    
move_done:

#start sorting sortarray
outer_loop:
    move $t0, $t6   # Move to start of sortarray
    li $t3, 1           # Flag to check if any swaps were made
    addi $t8, $t8, -1   # Decrement the byte counter
    
    beqz $t8, sort_done # If no more bytes to sort, exit loop
    
    move $t4, $t8       # Number of iterations for inner loop
    
inner_loop:

    beqz $t4, outer_loop_done  # If inner loop completed, exit loop

    lb $t5, ($t0)       # Load byte from sortarray
    lb $t1, 1($t0)      # Load byte from the next position in sortarray
    
    blt $t5, $t1, no_swap  # If the current byte is smaller, no swap needed
    
    sb $t1, ($t0)       # Swap the bytes
    sb $t5, 1($t0)
    
    li $t3, 0           # Set swap flag to indicate a swap was made
    
no_swap:
           addi $t4, $t4, -1   # Decrement the inner loop counter
  	   addi $t0, $t0, 1    # Move to next position in sortarray
  	   j inner_loop

outer_loop_done:
    beqz $t3, outer_loop  # If a swap was made, repeat the outer loop
    
sort_done:
    # Print sorting completion message
    li $v0, 4
    la $a0, finish_sort_msg
    syscall
    
    # Move to the next row
    li $v0, 4
    la $a0, newline
    syscall
    
    jr $ra
    
