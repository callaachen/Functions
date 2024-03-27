.data
	mainStorage: .space 4
	newLine: .asciiz "\n"

.text


main: 
#--------------------------8 Factorial------------------------------------------------	
	li $a0, 8		# Setting 8 as our argument
	jal funct 		# Calling factorial function

	move $t1, $v0		# Moving result into $t1
	
	move $a0, $t1		# Moving $t1 into $a0 for printing
	li $v0, 1		# Printing
	syscall
	
#--------------------------New Line Function------------------------------------------	
	li $v0, 4	
	la $a0, newLine
	syscall
	
#---------------------------Saving $t1-------------------------------------------------
	sw $t1, mainStorage
	
#---------------------------3 Factorial------------------------------------------------	
	li $a0, 3		# Setting 3- as our argument
	jal funct 		# Calling factorial function
	
#----------------------------restoring $t1 --------------------------------------------		
	lw $t1, mainStorage
	
#----------------------------Continuing Programming 3 Factorial------------------------
	move $t2, $v0		# Moving result into $t1
	
	move $a0, $t2		# Moving $t1 into $a0 for printing
	li $v0, 1		# Printing
	syscall
	
#---------------------------Adding 8! and $3!------------------------------------------
	add $t3, $t1, $t2	# Setting $t3 to the sum of $t1 and $t2
	
	li $v0, 4		# Printing New Line
	la $a0, newLine
	syscall
	
	move $a0, $t3		# Printing $t3
	li $v0, 1
	syscall
	
#----------------------------Exiting Program-------------------------------------------	
	li $v0, 10
	syscall
	
#----------------------------Funct: Index & Accumulator--------------------------------		
funct:

	move $t0, $a0		# Index
	li $t1, 1		# Accumulator

loop:
	ble $t0, 1, end		
	mul $t1, $t1, $t0 	# Set $t1 to the product of $t1 and $t0
	subi $t0, $t0, 1	# Decrement the index $t0
	j loop			# Looping Back
	


end: 
	move $v0, $t1		# Setting $v0 to my return value
	
	jr $ra			# REturning 