.data
	header: .asciiz "This program finds the maximum of 8 numbers\n"
	prompt: .asciiz "Please enter a number: "
	result: .asciiz "The maximum number that was inputed is "

.text
#-------------------------Main Program Function-------------------------------------------
main:
	li $v0, 4		# Prompt the header in output
	la $a0, header
	syscall
	
	jal getInput		# Jump and Link to subroutine getInput
	jal findMaxInput	# Jump and Link to subroutine findMaxOutput
	
	li $v0, 4		# Prompt the user for result the max number that they input
	la $a0, result
	syscall
	
	li $v0, 1		# Display the result that the user inputted 
	move $a0, $s0
	syscall

	li $v0, 10		# Exits the program safely
	syscall

#-------------------------Getting User Input-----------------------------------------------
getInput:
	move $t0, $ra		# Storing return address
	li $t1, 8		# Setting $t1 as a counter 

#-------------------------Loop: Getting user input------------------------------------------	
inputLoop:
	li $v0, 4		# Prompt the user to input a number
	la $a0, prompt
	syscall
	
	li $v0, 5		# Getting user input
	syscall
	
	move $a0, $v0		# Storing the input in $a0
	jal pushStack		# Pushing $a0 to the stack
	
	subi $t1, $t1, 1	# Decrementing counter
	bnez $t1, inputLoop	# When counter equals 0, then break the loop
	
	jr $t0			# Return to main
#----------------------Finding the max of 8 user inputs----------------------------------------
findMaxInput:
	move $t0, $ra		# Storing return address in $t0
	li $t1, 8		# Setting counter to 8
	jal popStack		# Popping the top value from the stack
	move $s0, $v0		# Usage of $s0 to storing the max value
	
#-------------------------Loop: Finding max of 8 user inputs-----------------------------------
maxLoop:
	subi $t1, $t1, 1	# Decrementing the counter
	beqz $t1, endMaxLoop	# When the counter equals 0, then break the loop
	jal popStack		# Popping the top value from the stack
	move $s1, $v0		# Usage of $s0 to storing most recent top value
	bge $s0, $s1, maxLoop	# if($s0 >= $s1), then go to next value of the stack
	move $s0, $s1		# else if($s0 < $s1), then $s0 = $s1
	j maxLoop

endMaxLoop:
	jr $t0			# Return back to main
	
#-------------------------Pushing values in Stack-----------------------------------------------
pushStack:
	subiu $sp, $sp, 4	# Make space for new inputs
	sw $a0, 0($sp)		# Storing a0 in stack
	jr $ra			# Returning to main
	
#-------------------------Popping values in Stack------------------------------------------------
popStack:
	lw $v0, 0($sp)		# Setting the top value to $v0
	addiu $sp, $sp, 4	# Restoring top index from the stack
	jr $ra			# Returning to main
	
#-------------------------Top of the stack-------------------------------------------------------
topStack:
	lw $v0, 0($sp)		# Moving the top value to $v0
	jr $ra			# Return to main
