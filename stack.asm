.data



.text

main: 
	li $a0, 10
	jal push
	
	li $a0, 8
	jal push
	
			
	li $a0, 16
	jal push
	
	jal pop
	
	move $a0, $v0
	
	li $v0, 1
	syscall

	li $v0, 10	# Exits the program safely 
	syscall

#-----------------Pecondition: Value to be in a0----------------------------
push:
	subiu $sp, $sp, 4
	sw $a0, 0($sp)
	jr $ra
	
pop:
	lw $v0, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
top:
	lw $v0, 0($sp)
	jr $ra