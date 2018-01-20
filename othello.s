.equ SWI_Exit, 0x11
.text
@only r0,r1,r2,r3 available for function use, if modifying any other register restore it back before exiting 
@r4 contains state of the board
@r5 contains the type variable
@r6 contains the # of player 1 blocks
@r7 contains the # of player 2 blocks
@r8 contains 8*move_row + move_col
@r9 contains move_row
@r10 contains move_col
@r11 for main function use

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
	sub r0,r8,#8

		check_up_while:
			mla r3,r0,#4,r4
			ldr r3,[r3]
			cmp r3,r1
			bne check_up_while_out
			cmp r0,#7
			subgt r0,r0,#8
			bgt check_up_label1

		check_up_while_out:
			mla r3,r0,#4,r4
			ldr r3,[r3]
			cmp r3,r5
			bne check_upright_diagonal
			check_up_inner_while:
				mla r3,r0,#4,r4
				str r5,[r3]
				add r0,r0,#8
				cmp r0,r8
				blt check_up_label1_inner_while

		check_upright_diagonal:
			cmp r10,#7
			bge check_upleft_diagonal
			sub r0,r8,#7
			
			check_upright_diagonal_while:
				mla r3,r0,#4,r4
				ldr r3,[r3]
				cmp r3,r1
				bne check_upright_diagonal_while_out
				cmp r0,#7
				subgt r0,r0,#7
				bgt check_upright_diagonal_while
			check_upright_diagonal_while_out:
				mla r3,r0,#4,r4
				ldr r3,[r3]
				cmp r3,r5
				bne check_upleft_diagonal
				check_upright_diagonal_inner_while:
					cmp r0,r8
					bge check_upleft_diagonal
					mla r3,r0,#4,r4
					str r5,[r3]
					add r0,r0,#7
					b check_upright_diagonal_inner_while

		check_upleft_diagonal:
			cmp r10,#0
			ble flip_squares_check_down
			sub r0,r8,#9
			check_upleft_diagonal_while:
				mla r3,r0,#4,r4
				ldr r3,[r3]
				cmp r3,r1
				bne check_upleft_diagonal_while_out
				cmp r0,#9
				subgt r0,r0,#9
				bgt check_upleft_diagonal_while
			check_upleft_diagonal_while_out:
				mla r3,r0,#4,r4
				ldr r3[r3]
				cmp r3,r5
				bne flip_squares_check_down
				check_upleft_diagonal_inner_while:
					cmp r0,r8
					bge flip_squares_check_down
					mla r3,r0,#4,r4
					str r5,[r3]
					add r0,r0,#9
					b check_upleft_diagonal_inner_while

	flip_squares_check_down:
		cmp r9,#7
		bge flip_squares_check_right

		add r0,r8,#8
		check_down_while:
			mla r3,r0,#4,r4
			ldr r3,[r3]
			cmp r3,r1
			bne check_down_while_out
			cmp r0,#56
			addlt r0,r0,#8
			bgt check_down_while
		check_down_while_out:
			mla r3,r0,#4,r4
			ldr r3,[r3]
			cmp r3,r5
			bne check_downleft_diagonal
			check_down_inner_while:
				cmp r0,r8
				ble check_downleft_diagonal
				mla r3,r0,#4,r4
				str r5,[r3]
				sub r0,r0,#8
				b check_down_inner_while

		check_downleft_diagonal:
			cmp r10,#0
			ble check_downright_diagonal
			add r0,r8,#7
			check_downleft_diagonal_while:
				mla r3,r0,#4,r4
				ldr r3,[r3]
				cmp r3,r1
				bne check_downleft_diagonal_while_out
				cmp r0,#56
				addlt r0,r0,#7
				blt check_downleft_diagonal_while
			check_downleft_diagonal_while_out:










			


		


main:
	ldr r4,=AA			@state
	mov r5,#1  			@type

Exit:
	swi SWI_Exit

.data
AA:	.space 400
	.end