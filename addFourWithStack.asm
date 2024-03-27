.data
	greeting: .asciiz "This program will add four numbers\n"
	prompt: .asciiz "Please enter a number: "
	result: .asciiz "The sum is "

.text

main: 
	subiu $sp , $sp, 32
	addiu $fp, $sp, 28
	
	li $v0, 4		# Greet the user
	la $a0, greeting
	syscall
	
#-------------------------Getting 4 Numbers in memory-----------------------------------------	
	jal getInput		# Get first number
	sw $v0, 0($fp)		# storing first number in stack frame
	
	jal getInput		# Get second number
	sw $v0, -4($fp)		# storing second number in stack frame
	
	jal getInput		# Get third number
	sw $v0, -8($fp)		# storing third number in stack frame
	
	jal getInput		# Get fourth number
	sw $v0, -12($fp)	# storing fourth number in stack frame
	
	
	lw $a0, 0($fp)		# Loading the add four arguments
	lw $a1, -4($fp)		# Loading the add four arguments
	lw $a2, -8($fp)		# Loading the add four arguments
	lw $a3, -12($fp)	# Loading the add four arguments
	
	jal addFour
	
	sw $v0, -16($fp)
	
	li $v0, 4
	la $a0, result
	syscall
	
	lw $a0, -16($fp)
	li $v0, 1
	syscall
	
	li $v0, 10		# Exiting the program safely
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
	
#-------------------Precondition: $a0-$a3 contains number to add--------------------------
addFour: 
	subiu $sp, $sp, -32	# Adding 32 byte stack frame to stack pointer
	sw $ra, 28($sp)		# store the return address
	sw $fp, 24($sp)		# store the old frame pointer
	addiu $fp, $sp, 28	# set the new frame pointer
	
	sw $a0, -8($fp)		#store $a0 in the stack frame 
	sw $a1, -12($fp)	#store $a1 in the stack frame 
	sw $a2, -16($fp)	#store $a2 in the stack frame 
	sw $a3, -20($fp)	#store $a3 in the stack frame 
	
#-----------------Storing, loading, and adding 1st and 2nd numbers---------------------------
	lw $a0, -8($fp)		# Load 1st number
	lw $a1, -12($fp)	# Load 2nd number
	
	jal addTwo
	
	sw $v0, -24($fp)	# Storing the sum of 1st and 2nd number
	
#-----------------Storing, loading, and adding 3rd and 4th numbers---------------------------	
	lw $a0, -16($fp)	# Loading and adding 3rd and 4th number
	lw $a1, -20($fp)
	jal addTwo
	
	sw $v0, -28($fp) 	# Storing the sum of 3rd and 4th numbers
	
#-----------------Storing, loading, and adding previous sums---------------------------------	
	lw $a0, -24($fp)	# Loading and adding previous sums
	lw $a1, -28($fp)
	jal addTwo
	
	lw $ra, 0($fp)		# Restoring return address
	lw $fp, 4($fp)		# Restproing the frame pointer
	
	addiu $sp, $sp, 32	# Popping the stack
	jr $ra			# returning to the return address
	
	
#-------------------Precondition: $a0 and $a1 contain numbers to add--------------------------
addTwo:
	add $v0, $a0, $a1
	jr $ra