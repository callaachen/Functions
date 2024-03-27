.data
	welcomeMessage: .asciiz "This program calculates the factorial of a number using recursion\n"
	message: .asciiz "Enter a number for the factorial: "
	result:  .asciiz "The factorial is: "
.text


main:
	move $fp, $sp		# Setting the default frame pointer
	
	li $v0, 4		# Welcoming the user
	la $a0, welcomeMessage
	syscall
	
	li $v0, 4		# Ask the user for a number
	la $a0, message
	syscall
	
	li $v0, 5		# Getting user input
	syscall
	
	subiu $sp, $sp, 4	# Making room in the stack for the parameters 
	sw $v0, 0($sp)		# Storing the n value in the parameter
	
	jal factorial		# Call factorial function 
	
	move $t0, $v0
	
	li $v0, 4		# Displaying the result string
	la $a0, result
	syscall
	
	li $v0, 1		# Display the ACTUAL result
	move $a0, $t0
	syscall
	
	li $v0, 10		# Exiting program safely
	syscall

#--------------------------Function for Factorial-----------------------------------	
factorial:
	subiu $sp, $sp, 12	# Expanding the stack for the stack frame
	sw $ra, 8($sp)		# Storing the return address
	sw $fp, 4($sp)		# Storing the previous frame pointer
	addiu $fp, $sp, 8	# setting the frame pointer
	
	lw $t0, 4($fp)		# Loading n into $t0

#----------------------Base Case: if (n == 0) return 1--------------------------------	
	bne $t0, $zero, genCase
	li $v0, 1
	j returnFromFactorial
	
#----------------------General Case: result = factorial(n-1)--------------------------
genCase:
	subi $t1, $t0, 1	# t1 = n-1
	subiu $sp, $sp, 4	# Adding 1 word for parameters
	sw $t1, 0($sp)		# The parameter to n
	jal factorial		# Calling factorial recursively 
	lw $t0, 4($fp)		# Loading n into $t0
	mul $t2, $t0, $v0	# set $t2 to n * factorial(n-1)
	sw $t2, -8($fp)		# Storing the result
	move $v0, $t2		# Setting the result to the returned
	
#-----------------returnFromFactorial: resetting EVERYTHING-----------------------------
returnFromFactorial:
	lw $ra, 0($fp)		# Resetting the return address
	lw $fp, -4($fp)		# Resetting the frame pointer
	addiu $sp, $sp, 16	# Pop off the stack frame, including the parameters
	jr $ra			# Jump to return address
