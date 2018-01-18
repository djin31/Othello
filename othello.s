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