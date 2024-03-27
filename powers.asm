.data
	greeting: .asciiz "This program will return the power of a base number while USING RECURSION\n"
	basePrompt: .asciiz "Enter a base: "
	exponentPrompt: .asciiz "Enter an exponent: "
	results: .asciiz "The power is "
.text
#-------------------------Main Program Function--------------------------------
main: 
	move $fp, $sp 		# Setting default frame pointer
	
	li $v0, 4		# Greets the user of what the program does; Header for output
	la $a0, greeting
	syscall
	
	subiu $sp, $sp, 8	# Making room in stack for the parameters
	
	la $a0, basePrompt	# Ask the user to input a number as the base	
	jal getInput
	sw $v0, 4($sp)		# Store input for base into $v0 parameter
	
	la $a0, exponentPrompt	# Ask the user to input a number as the exponent	
	jal getInput
	sw $v0, 0($sp)		# Store input for exponent into $v0 parameter
	
	jal calcBaseExp		# Jump and link to calcBaseExp
	
	move $t0, $v0		# Setting the results into $t0
	
	li $v0, 4		# Displays the message of the calculated input (base ^exponent)
	la $a0, results
	syscall
	
	li $v0, 1		# Displays the numerical result of the calculated output
	move $a0, $t0		
	syscall
	
	li $v0, 10		# Exiting program safely
	syscall
#-------------------------Getting User Input-----------------------------------
getInput:
	la $v0, 4		# Asking the user to input a base and exponent
	syscall
	
	la $v0, 5		# Getting user input for base and exponent	
	syscall
	
	jr $ra			# Jump to Return Address

#----------------Loop Begin: Calculating Base & Exponent----------------------
calcBaseExp:
	subiu $sp, $sp, 12	# In 1 word, there are 4 bytes. Expand the stack to fit both base and exponent
				# Expanding stack for the stack frame
	sw $ra, 8($sp)		# Storing return address
	sw $fp, 4($sp)		# Storing value in previous frame pointer
	addiu $fp, $sp, 8	# Setting up the new frame pointer
	
	lw $t0, 8($fp)		# Load base into $t0
	lw $t1, 4($fp)		# Loading exponent into $t1
	
#--------------Base Case: If n = 0 (n == 0), then return 1---------------------
	bne $t1, $zero, genCase
	
	li $v0, 1
	j endCalcBaseExp	# Returns 1 if exponent is 0

#----------------General Case: Result = base ^exponent--------------------------
genCase:
	subiu $t2, $t1, 1	# Acts like (n-1); $t2 = exponent - 1
	subiu $sp, $sp, 8	# Add two words (equivalent to 8 bytes) in parameter
	sw $t0, 4($sp)		# Storing base into the stack; uses an additional 4 bytes
	
	sw $t2 0($sp)		# Storing the (exp - 1) value into stack in $t2
	
	jal calcBaseExp		# Recursively calling the calcBaseExp subroutine function
		
	lw $t0, 8($fp)		# Loading base input into $t0
	lw $t1, 4($fp)		# Loading exponent input into $t1
	mul $t3, $t0, $v0	# In $t3, multiply the base power (base, exp - 1)
	sw $t3, -8($fp)		# Storing the result of the calculated inputs in memory
	move $v0, $t3		# Setting $v0 to the result of the calculated inputs

#---------------Loop End: Calculating Base & Exponent----------------------------		
endCalcBaseExp:
	lw $ra, 0($fp)		# Resetting return address
	lw $fp, -4($fp)		# Resetting frame pointer
	addiu $sp, $sp, 20	# Popping off the stack frame, including parameters = 8 bytes
	jr $ra
