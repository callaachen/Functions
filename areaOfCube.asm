.data
	header: .asciiz "This program calculates the VOLUME of a cube\n"
	promptWidth: .asciiz "Enter the width: "
	promptHeight: .asciiz "Enter the height: "
	promptDepth: .asciiz "Enter the depth: "
	promptVolume: .asciiz "The volume of the cube is: "
	
.text
#-------------------------Main Program Function------------------------------------------
main:
	li $v0, 4		# Header of the program
	la $a0, header
	syscall
	
	jal getInput 		# jump to getInput
	
	jal calcVolume		# jump to calcVolume to calculate volume of cube
	
	mul $t3, $v0, $t2	# Calculate volume of cube then store in $t3
	
	li $v0, 4		# Displays resulting prompt volume of cube
	la $a0, promptVolume
	syscall
	
	li $v0, 1
	move $a0, $t3		# Printing the volume of the cube
	syscall
	
	li $v0, 10		# Exiting program safely
	syscall
	 	
#-------------------------Getting User Input----------------------------------------------
getInput:
    	li $v0, 4		# Display width prompt
    	la $a0, promptWidth
    	syscall
    	
    	li $v0, 5		# Store width input to $t0
    	syscall
    	move $t0, $v0
    	
    	li $v0, 4		# Display height prompt
    	la $a0, promptHeight
    	syscall
    	
    	li $v0, 5		# Store height input to $t1
    	syscall
    	move $t1, $v0
    	
    	li $v0, 4		# Display depth prompt
    	la $a0, promptDepth
    	syscall
    	
    	li $v0, 5		# Store depth input to $t2
    	syscall
    	move $t2, $v0
    	
    	jr $ra			# Return from subroutine
    	
#---------------------Calculating Volume of Cube---------------------------------------
calcVolume:
	mul $v0, $t0, $t1	# Calculate width * height, then store it in v0
	mul $v1, $v0, $t2	# in $v1, multiply v0 (width* height) by $t2 (depth) 
	jr $ra			# Return from subroutine
				   	  			    
