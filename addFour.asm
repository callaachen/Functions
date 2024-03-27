.data
	mainMemory: .space 32
	addFourMemory: .space 32
	
	greeting: .asciiz "This program will add four numbers\n"
	prompt: .asciiz "Please enter a number: "
	result: .asciiz "The sum is "

.text
	li $v0, 4		# Greet the user
	la $a0, greeting
	syscall
#-------------------------Getting 4 Numbers in memory-----------------------------------------	
	jal getInput			# Get first number
	sw $v0, mainMemory + 0		# storing first number in memory
	
	jal getInput			# Get second number
	sw $v0, mainMemory + 4		# storing second number in memory
	
	jal getInput			# Get third number
	sw $v0, mainMemory + 8		# storing third number in memory
	
	jal getInput			# Get fourth number
	sw $v0, mainMemory + 12		# storing fourth number in memory
	
	lw $a0, mainMemory + 0 		# Load 1st Number
	lw $a1, mainMemory + 4 		# Load 2nd Number
	lw $a2, mainMemory + 8 		# Load 3rd Number
	lw $a3, mainMemory + 12 	# Load 4th Number
	
#--------------------------Call addFour-------------------------------------------------------	
	jal addFour		# call addTwo
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
	
#--------------------------Adding 4 numbers and returning result in v0--------------------
# Precondition: The numbers are in a0-a3
addFour:
	sw $ra, addFourMemory + 0	# Storing the return address
	sw $a0, addFourMemory + 4	# Storing arguments in memory
	sw $a1, addFourMemory + 8
	sw $a2, addFourMemory + 12
	sw $a3, addFourMemory + 16
		
		
	lw $a0, addFourMemory + 4	# Call addTwo on the first 2 numbers
	lw $a1, addFourMemory + 8
	jal addTwo
	sw $v0, addFourMemory + 20	# Storing result in memory
	
	lw $a0, addFourMemory + 12	# Call addTwo on the first 3rd and 4th numbers
	lw $a1, addFourMemory + 16
	jal addTwo
	sw $v0, addFourMemory + 24	# Storing result in memory
	
	lw $a0, addFourMemory + 20	# Call addTwo on the first 3rd and 4th numbers
	lw $a1, addFourMemory + 24
	jal addTwo
	sw $v0, addFourMemory + 28	# Storing result in memory
	
	lw $v0, addFourMemory + 28	# Set v0 to return the final result
	lw $ra, addFourMemory + 0	# Restore the return address
	
	jr $ra
	
#--------------------------Summing up a0 & a1 and returns them in $v0---------------------
addTwo:
	add $v0, $a0, $a1
	jr $ra	