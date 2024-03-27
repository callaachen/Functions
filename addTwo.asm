.data
	greeting: .asciiz "This program will add two numbers\n"
	prompt: .asciiz "Please enter a number: "
	result: .asciiz "The sum is "

.text
	li $v0, 4		# Greet the user
	la $a0, greeting
	syscall
	
	
	jal getInput		# Get first number
	move $t0, $v0
	
	jal getInput		# Get second number
	move $t1, $v0
	
	move $a0, $t0		# Set up arguments
	move $a1, $t1
	jal addTwo		# call addTwo
	move $t2, $v0		# Store the return value in t2
	
	li $v0, 4		# Printing result label
	la $a0, result
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 10		# Exit program safely
	syscall

#-------------------------Getting User Input----------------------------------------------
getInput:
	li $v0, 4		# Prompt the user for a number
	la $a0, prompt
	syscall
	
	li $v0, 5		# Get input from user
	syscall
				# value is already in v0
	jr $ra
#--------------------------Summing up a0 & a1 and returns them in $v0---------------------
addTwo:
	add $v0, $a0, $a1
	jr $ra			# value is already in v0
