#################################
#		Text Segment    
#################################
.text
.globl main
main:
    # Display the menu
    while:
        la $a0, menu1
        li $v0, 4
        syscall

        la $a0, menu2
        li $v0, 4
        syscall

        la $a0, menu3
        li $v0, 4
        syscall

        la $a0, menu4
        li $v0, 4
        syscall

        la $a0, menu5
        li $v0, 4
        syscall

        la $a0, menu6
        li $v0, 4
        syscall

        la $a0, menu7
        li $v0, 4
        syscall

        la $a0, menu8
        li $v0, 4
        syscall

        la $a0, menu9
        li $v0, 4
        syscall

        li $v0, 5
        syscall
        sw $v0, opCode
        lw $t0, opCode

        # If opcode is 1
        beq $t0, 1, createUserMatrix

        # If opcode is 2
        beq $t0, 2, createAutoMatrix

        # If opcode is 3
        beq $t0, 3, getElement

        # If opcode is 4
        beq $t0, 4, display

        # If opcode is 5
        beq $t0, 5, getTrace

        # If opcode is 6
        beq $t0, 6, getOppTrace

        # If opcode is 7
        beq $t0, 7, rowSum

        # If opcode is 8
        beq $t0, 8, colSum

        j continue

continue:
    lw $t0, opCode
        bne $t0, 9, while
    beq $t0, 9, exit

exit:
    li $v0, 10
    syscall

createUserMatrix:
    # get N
    li $v0, 5
    syscall
    move $s0, $v0
    sw $s0, elements
    
    mult	$s0, $s0			# $t0 * $t1 = Hi and Lo registers
    mflo	$s0					# copy Lo to $t2

    sll	$s3, $s0, 2

    # Create dynamic array
    move $a0, $s3
    li $v0, 9
    syscall
    sw $v0, array
    la $s1, array

    lw $t1, elements
    la $s1, array
    # get elements
    for:
        lw $t2, elements
        for1:
            li $v0, 5
            syscall
            sw $v0, ($s1)
            addi $s1, $s1, 4
            addi $t2, $t2, -1
            bgt $t2, $zero, for1
        addi $t1, $t1, -1
        bgt $t1, $zero, for
            
    j continue

createAutoMatrix:
# get N
    li $v0, 5
    syscall
    move $s0, $v0
    sw $s0, elements
    
    mult	$s0, $s0			# $t0 * $t1 = Hi and Lo registers
    mflo	$s0					# copy Lo to $t2

    sll	$s3, $s0, 2

    # Create dynamic array
    move $a0, $s3
    li $v0, 9
    syscall
    sw $v0, array
    la $s1, array

    lw $t1, elements
    la $s1, array
    li $t3, 1
    # get elements
    for4:
        lw $t2, elements
        for5:
            sw $t3, ($s1)
            addi $t3, $t3, 1
            addi $s1, $s1, 4
            addi $t2, $t2, -1
            bgt $t2, $zero, for5
        addi $t1, $t1, -1
        bgt $t1, $zero, for4
            
    j continue

getElement:
    la $a0, elRow
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    la $a0, elcol
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t2, $v0

    lw $t3, elements
    li $t4, 4

    la $s1, array

    addi $t1, $t1, -1
    mult	$t1, $t3			# $t1 * $t1 = Hi and Lo registers
    mflo	$t1					# copy Lo to $t2
    mult	$t1, $t4			# $t1 * $41 = Hi and Lo registers
    mflo	$t1					# copy Lo to $t2
    
    addi $t2, $t2, -1
    mult	$t2, $t4			# $t2 * $41 = Hi and Lo registers
    mflo	$t2					# copy Lo to $t2
    
    add $t1, $t1, $t2

    add $s1, $s1, $t1
    lw $t5, ($s1)

    move $a0, $t5
    li $v0, 1
    syscall
    
    la $a0, space
    li $v0, 4
    syscall

    j continue

display:
    lw $t1, elements
    la $s1, array
    for2:
        lw $t2, elements
        for3:
            lw $a0, ($s1)
            li $v0, 1
            syscall

            la $a0, tab
            li $v0, 4
            syscall
            
            addi $s1, $s1, 4
            addi $t2, $t2, -1
            bgt $t2, $zero, for3
        la $a0, space
        li $v0, 4
        syscall
        addi $t1, $t1, -1
        bgt $t1, $zero, for2
    
    j continue

getTrace:
    lw $t0, elements
    lw $t3, elements
    li $t4, 4
    li $t6, 1
    li $t7, 0
    for6:
        move $t1, $t6
        move $t2, $t6
        la $s1, array

        addi $t1, $t1, -1
        mult	$t1, $t3			# $t1 * $t1 = Hi and Lo registers
        mflo	$t1					# copy Lo to $t2
        mult	$t1, $t4			# $t1 * $41 = Hi and Lo registers
        mflo	$t1					# copy Lo to $t2
        
        addi $t2, $t2, -1
        mult	$t2, $t4			# $t2 * $41 = Hi and Lo registers
        mflo	$t2					# copy Lo to $t2
        
        add $t1, $t1, $t2

        add $s1, $s1, $t1
        lw $t5, ($s1)
        add $t7, $t7, $t5
        addi $t6, $t6, 1
        addi $t0, $t0, -1
        bgt $t0, $zero, for6

    move $a0, $t7
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall
    j continue

getOppTrace:
    lw $t0, elements
    lw $t3, elements
    li $t4, 4
    lw $t6, elements
    li $t8, 1
    li $t7, 0
    for7:
        move $t1, $t8
        move $t2, $t6
        la $s1, array

        addi $t1, $t1, -1
        mult	$t1, $t3			# $t1 * $t1 = Hi and Lo registers
        mflo	$t1					# copy Lo to $t2
        mult	$t1, $t4			# $t1 * $41 = Hi and Lo registers
        mflo	$t1					# copy Lo to $t2
        
        addi $t2, $t2, -1
        mult	$t2, $t4			# $t2 * $41 = Hi and Lo registers
        mflo	$t2					# copy Lo to $t2
        
        add $t1, $t1, $t2

        add $s1, $s1, $t1
        lw $t5, ($s1)
        add $t7, $t7, $t5
        addi $t6, $t6, -1
        addi $t8, $t8, 1
        addi $t0, $t0, -1
        bgt $t0, $zero, for7

    move $a0, $t7
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall

    j continue

rowSum:
    la $a0, elRow
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $t1, $v0 # row
    lw $t3, elements
    lw $t7, elements
    li $t4, 4
    li $t2, 1
    li $t6, 0

    addi $t1, $t1, -1
    mult	$t1, $t3			# $t1 * $t1 = Hi and Lo registers
    mflo	$t1					# copy Lo to $t2
    mult	$t1, $t4			# $t1 * $41 = Hi and Lo registers
    mflo	$t1					# copy Lo to $t2

    for8:
        la $s1, array
        li $t0, 0
        addi $t0, $t2, -1
        mult	$t0, $t4			# $t2 * $41 = Hi and Lo registers
        mflo	$t0					# copy Lo to $t2
        
        add $t0, $t1, $t0
        add $s1, $s1, $t0
        lw $t5, ($s1)
        add $t6, $t6, $t5

        addi $t2, $t2, 1
        addi $t7, $t7, -1
        bgt $t7, $zero, for8

    move $a0, $t6
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall
    j continue

colSum:
    la $a0, elCol
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $t2, $v0 # col
    lw $t3, elements
    lw $t7, elements
    li $t4, 4
    li $t1, 1
    li $t6, 0

    addi $t2, $t2, -1
    mult	$t2, $t4			# $t2 * $41 = Hi and Lo registers
    mflo	$t2					# copy Lo to $t2

    for9:
        la $s1, array

        addi $t0, $t1, -1
        mult	$t0, $t3			# $t1 * $t1 = Hi and Lo registers
        mflo	$t0					# copy Lo to $t2
        mult	$t0, $t4			# $t1 * $41 = Hi and Lo registers
        mflo	$t0					# copy Lo to $t2

        add $t0, $t0, $t2
        add $s1, $s1, $t0
        lw $t5, ($s1)
        add $t6, $t6, $t5

        addi $t1, $t1, 1
        addi $t7, $t7, -1
        bgt $t7, $zero, for9

    move $a0, $t6
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall

    j continue
#################################
#		Data Segment    
#################################
    .data
.align 2
array: .space 100000
elements: .word 0
opCode: .word 0
tab: .asciiz "\t"
space: .asciiz "\n"
menu1: .asciiz "1.	Enter matrix dimension and elements row by row.\n"
menu2: .asciiz "2.	Enter matrix dimension.\n"
menu3: .asciiz "3.	Get desired element.\n"
menu4: .asciiz "4.	Display matrix.\n"
menu5: .asciiz "5.	Find trace.\n"
menu6: .asciiz "6.	Find trace of other diagonal.\n"
menu7: .asciiz "7.	Find row-major sum of matrix elements.\n"
menu8: .asciiz "8.	Find column-major sum of matrix elements.\n"
menu9: .asciiz "9.  Exit.\n"
elRow: .asciiz "Enter row: \n"
elcol: .asciiz "Enter column: \n"