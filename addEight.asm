.data
	greeting: .asciiz "This program will add EIGHT numbers\n"
	prompt: .asciiz "Please enter a number: "
	result: .asciiz "The sum is "

.text

main: 
	subiu $sp , $sp, 32
	addiu $fp, $sp, 28
	
	li $v0, 4		# Greet the user
	la $a0, greeting
	syscall
	
#-------------------------Repeat Loop to get all parameters-----------------------	
	subi $t0, $sp, 4	# Set $t0 to top of parameters
	
	subiu $sp , $sp, 32	# For our 8 parameters
	
startParamLoop:	
	blt $t0, $sp, endParamLoop	# Start loop for parameters
	
	jal getInput		# get a number
	sw $v0, 0($t0)		# store a number in the parameters
	subiu $t0, $t0, 4	# Point to the next parameter
	j startParamLoop	# loop back 
	
#-------------------------Getting 4 Numbers in memory-------------------------------------		
	jal getInput		# Get first number
	sw $v0, 0($t0)		# storing first number in stack frame
	
endParamLoop:
	
	jal addEight
	
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
#----------------------Here we go. add 8 loop-----------------------------------------------
addEight:
	subiu $sp, $sp, 16	# Adding 4 bytes to the stack
	sw $ra, 12($sp)		# Storing return address
	sw $fp, 8($sp)		# Storing frame pointer
	addiu $fp, $sp, 12	# Setting new frame pointer
	
	lw $a0, 32($fp)		# Loading in the first set of 4 arguments
	lw $a1, 28($fp)
	lw $a2, 24($fp)
	lw $a3, 20($fp)	
	jal addFour		# Call addFour
	sw $v0, -8($fp)	
	
	lw $a0, 16($fp)		# Loading in the second set of 4 arguments
	lw $a1, 12($fp)
	lw $a2, 8($fp)
	lw $a3, 4($fp)	
	jal addFour		# Call addFour
	sw $v0, -12($fp)
	
	lw $a0, -8($fp)		# Loading in the two sums
	lw $a1, -12($fp)
	jal addTwo		# Call addTwo with the sums; $v0 now contains the total sum
	
	lw $ra, 0($fp)		# Resetting return address
	lw $fp, -4($fp)		# Resetting frame pointer
	addiu $sp, $sp, 48	# Popping the stack frame and parameters off the stack
			
	jr $ra
#-------------------Precondition: $a0-$a3 contains number to add---------------------------
addFour: 
	subiu $sp, $sp, 32	# Adding 32 byte stack frame to stack pointer
	sw $ra, 28($sp)		# Store the return address
	sw $fp, 24($sp)		# Store the old frame pointer
	addiu $fp, $sp, 28	# Set the new frame pointer
	
	sw $a0, -8($fp)		# Store $a0 in the stack frame 
	sw $a1, -12($fp)	# Store $a1 in the stack frame 
	sw $a2, -16($fp)	# Store $a2 in the stack frame 
	sw $a3, -20($fp)	# Store $a3 in the stack frame 
	
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
	lw $fp, -4($fp)		# Restproing the frame pointer
	
	addiu $sp, $sp, 32	# Popping the stack
	jr $ra			# returning to the return address
	
#-------------------Precondition: $a0 and $a1 contain numbers to add--------------------------
addTwo:
	add $v0, $a0, $a1
	jr $ra