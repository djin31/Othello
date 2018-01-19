.equ SWI_Exit, 0x11
.text
@r4 contains state of the board
@r5 contains the type variable
@r6 contains the # of player 1 blocks
@r7 contains the # of player 2 blocks
@r8 contains 8*move_row + move_col
@r9 contains move_row
@r10 contains move_col

initialise:
	mov r0,[r4]
	mov r1,[r4,#256]
	mov r2,#0
	
	initialise_label1:
		str r2,[r0]
		cmp r0,r1
		blt initialise_label1

	mov r2,#1
	str r2,[r4,#108]
	str r2,[r4,#144]

	mov r2,#2
	str r2,[r4,#112]
	str r2,[r4,#140]

	mov r6,#2
	mov r7,#2

	mov pc,lr

@ ****************** checkValid function ******************************
@ -> assumes type in r0, row number in r1, column number in r2
@ -> returns score of move in r0, 0 score for invalid move

checkValid:
	STMDB SP!, { r4,r5,r6,r7,r8,r9,r10 }
	@r3 for array beggining, r6 -> for loop index i, r7 for k, r8 for array index, r9 for #8
	ldr r3,=AA
	mov r4,r0 @store type in r4
	mov r0,#0 @score
	mov r5,#0 @scoreTemp
	mov r9,#8

@row

	add r6,r1,#1
checkValid_Loop1:
	cmp r6,8
	blt checkValid_LoopIn1
	b checkValid_LoopOut1
checkValid_LoopIn1:
	mla r8,r9,r6,r2
	mov r8, r8, LSL #2
	ldr r10,[r3,r8]
	cmp r10,r0
	beq checkValid_LoopOut1
	cmp r10,#0
	beq checkValid_If1
	cmp r6,#7
	beq checkValid_If1
	b checkValid_Else1
checkValid_If1:
	sub r0,r0,r5
	b checkValid_LoopOut1
checkValid_Else1:
	add r0,r0,#1
	add r5,r5,#1
	add r6,r6,#1
	b checkValid_Loop1
checkValid_LoopOut1:

	sub r6,r1,#1
	mov r5,#0
checkValid_Loop2:
	cmp r6,0
	bge checkValid_LoopIn2
	b checkValid_LoopOut2
checkValid_LoopIn2:
	mla r8,r9,r6,r2
	mov r8, r8, LSL #2
	ldr r10,[r3,r8]
	cmp r10,r0
	beq checkValid_LoopOut2
	cmp r10,#0
	beq checkValid_If2
	cmp r6,#0
	beq checkValid_If2
	b checkValid_Else2
checkValid_If2:
	sub r0,r0,r5
	b checkValid_LoopOut2
checkValid_Else2:
	add r0,r0,#1
	add r5,r5,#1
	sub r6,r6,#1
	b checkValid_Loop2
checkValid_LoopOut2:

checkValid_End:
	LDMIA SP!, { r4,r5,r6,r7,r8,r9,r10 }
	mov pc,lr

@ ********************* end of checkValid ****************************

flip_squares:
	cmp r5,#1		@set other_type
	moveq r1,#2
	movne r1,#1

	flip_squares_check_up:
	cmp r9,#0
	ble flip_squares_check_down
	mla r0,r8,#4,r4

		check_up_label1:
		


main:
	ldr r4,=AA			@state
	mov r5,#1  			@type

Exit:
	swi SWI_Exit

.data
AA:	.space 400
	.end