.equ SWI_Exit, 0x11
.equ SWI_CheckBlack, 0x202 @check Black button
.equ SWI_SetLED, 0x201
.equ SWI_Exit, 0x11 @ Stop execution
.equ SWI_DRAW_STRING, 0x204 @display a string on LCD
.equ SWI_DRAW_INT, 0x205 @display an int on LCD
.equ SWI_CLEAR_DISPLAY,0x206 @clear LCD
.equ SWI_DRAW_CHAR, 0x207 @display a char on LCD
.equ SWI_CLEAR_LINE, 0x208 @clear a line on LCD



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

@ ****************************** initialise ******************************
initialise:
	mov r0,r4
	add r1,r4,#256
	mov r2,#0
	
	initialise_label1:
		str r2,[r0]
		cmp r0,r1
		addlt r0,r0,#4
		blt initialise_label1

	mov r2,#1
	str r2,[r4,#108]
	str r2,[r4,#144]

	mov r2,#2
	str r2,[r4,#112]
	str r2,[r4,#140]

	mov r2,#0
	str r2,[r4,#300]

	mov r6,#2
	mov r7,#2


	mov pc,lr

@ ****************** checkValid function ******************************
@ -> assumes type in r0, row number in r1, column number in r2
@ -> returns score of move in r0, 0 score for invalid move

checkValid:
	STMDB SP!, { r4,r5,r6,r7,r8,r9,r10,r11 }
	@r3 for array beggining, r6 -> for loop index i, r7 for k, r8 for array index, r9 for #8
	@r11 for y+k
	ldr r3,=AA
	mov r4,r0 @store type in r4
	mov r0,#0 @score
	mov r5,#0 @scoreTemp
	mov r9,#8

	@row

		add r6,r1,#1
	checkValid_Loop1:
		cmp r6,#8
		blt checkValid_LoopIn1
		b checkValid_LoopOut1
	checkValid_LoopIn1:
		mla r8,r9,r6,r2
		mov r8, r8, LSL #2
		ldr r10,[r3,r8]
		cmp r10,r4
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
		cmp r6,#0
		bge checkValid_LoopIn2
		b checkValid_LoopOut2
	checkValid_LoopIn2:
		mla r8,r9,r6,r2
		mov r8, r8, LSL #2
		ldr r10,[r3,r8]
		cmp r10,r4
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

	@column

		add r6,r2,#1
		mov r5,#0
	checkValid_Loop3:
		cmp r6,#8
		blt checkValid_LoopIn3
		b checkValid_LoopOut3
	checkValid_LoopIn3:
		mla r8,r9,r1,r6
		mov r8, r8, LSL #2
		ldr r10,[r3,r8]
		cmp r10,r4
		beq checkValid_LoopOut3
		cmp r10,#0
		beq checkValid_If3
		cmp r6,#7
		beq checkValid_If3
		b checkValid_Else3
	checkValid_If3:
		sub r0,r0,r5
		b checkValid_LoopOut3
	checkValid_Else3:
		add r0,r0,#1
		add r5,r5,#1
		add r6,r6,#1
		b checkValid_Loop3
	checkValid_LoopOut3:

		sub r6,r2,#1
		mov r5,#0
	checkValid_Loop4:
		cmp r6,#0
		bge checkValid_LoopIn4
		b checkValid_LoopOut4
	checkValid_LoopIn4:
		mla r8,r9,r1,r6
		mov r8, r8, LSL #2
		ldr r10,[r3,r8]
		cmp r10,r4
		beq checkValid_LoopOut4
		cmp r10,#0
		beq checkValid_If4
		cmp r6,#0
		beq checkValid_If4
		b checkValid_Else4
	checkValid_If4:
		sub r0,r0,r5
		b checkValid_LoopOut4
	checkValid_Else4:
		add r0,r0,#1
		add r5,r5,#1
		sub r6,r6,#1
		b checkValid_Loop4
	checkValid_LoopOut4:

	@diagnols
		
		mov r7,#1
		add r6,r1,#1
		mov r5,#0
		add r11,r2,r7
	checkValid_Loop5:
		cmp r6,#8
		blt checkValid_Loop5_Condition2
		b checkValid_LoopOut5
	checkValid_Loop5_Condition2:
		cmp r11,#8
		blt checkValid_LoopIn5
		b checkValid_LoopOut5
	checkValid_LoopIn5:
		mla r8,r9,r6,r11
		mov r8, r8, LSL #2
		ldr r10,[r3,r8]
		cmp r10,r4
		beq checkValid_LoopOut5
		cmp r10,#0
		beq checkValid_If5
		cmp r6,#7
		beq checkValid_If5
		cmp r11,#7
		beq checkValid_If5
		b checkValid_Else5
	checkValid_If5:
		sub r0,r0,r5
		b checkValid_LoopOut5
	checkValid_Else5:
		add r0,r0,#1
		add r5,r5,#1
		add r6,r6,#1
		add r7,r7,#1
		b checkValid_Loop5
	checkValid_LoopOut5:

		sub r6,r1,#1
		mov r5,#0
		sub r11,r2,#1
	checkValid_Loop6:
		cmp r6,#0
		bge checkValid_Loop6_Condition2
		b checkValid_LoopOut6
	checkValid_Loop6_Condition2:
		cmp r11,#0
		bge checkValid_LoopIn6
		b checkValid_LoopOut6
	checkValid_LoopIn6:
		mla r8,r9,r6,r11
		mov r8, r8, LSL #2
		ldr r10,[r3,r8]
		cmp r10,r4
		beq checkValid_LoopOut6
		cmp r10,#0
		beq checkValid_If6
		cmp r6,#0
		beq checkValid_If6
		cmp r11,#0
		beq checkValid_If6
		b checkValid_Else6
	checkValid_If6:
		sub r0,r0,r5
		b checkValid_LoopOut6
	checkValid_Else6:
		add r0,r0,#1
		add r5,r5,#1
		sub r6,r6,#1
		sub r11,r11,#1
		b checkValid_Loop6
	checkValid_LoopOut6:

		add r6,r1,#1
		mov r5,#0
		sub r11,r2,#1
	checkValid_Loop7:
		cmp r6,#8
		blt checkValid_Loop7_Condition2
		b checkValid_LoopOut7
	checkValid_Loop7_Condition2:
		cmp r11,#0
		bge checkValid_LoopIn7
		b checkValid_LoopOut7
	checkValid_LoopIn7:
		mla r8,r9,r6,r11
		mov r8, r8, LSL #2
		ldr r10,[r3,r8]
		cmp r10,r4
		beq checkValid_LoopOut7
		cmp r10,#0
		beq checkValid_If7
		cmp r6,#7
		beq checkValid_If7
		cmp r11,#0
		beq checkValid_If7
		b checkValid_Else7
	checkValid_If7:
		sub r0,r0,r5
		b checkValid_LoopOut7
	checkValid_Else7:
		add r0,r0,#1
		add r5,r5,#1
		add r6,r6,#1
		sub r11,r11,#1
		b checkValid_Loop7
	checkValid_LoopOut7:

		sub r6,r1,#1
		mov r5,#0
		add r11,r2,#1
	checkValid_Loop8:
		cmp r6,#0
		bge checkValid_Loop8_Condition2
		b checkValid_LoopOut8
	checkValid_Loop8_Condition2:
		cmp r11,#8
		blt checkValid_LoopIn8
		b checkValid_LoopOut8
	checkValid_LoopIn8:
		mla r8,r9,r6,r11
		mov r8, r8, LSL #2
		ldr r10,[r3,r8]
		cmp r10,r4
		beq checkValid_LoopOut8
		cmp r10,#0
		beq checkValid_If8
		cmp r6,#0
		beq checkValid_If8
		cmp r11,#7
		beq checkValid_If8
		b checkValid_Else8
	checkValid_If8:
		sub r0,r0,r5
		b checkValid_LoopOut8
	checkValid_Else8:
		add r0,r0,#1
		add r5,r5,#1
		sub r6,r6,#1
		add r11,r11,#1
		b checkValid_Loop8
	checkValid_LoopOut8:

	checkValid_End:
		LDMIA SP!, { r4,r5,r6,r7,r8,r9,r10,r11 }
		b here
		mov pc,lr


@ *********************** flip_squares *******************************
flip_squares:
	STMDB SP!, {r6,r7}
	cmp r5,#1		@set other_type
	moveq r1,#2
	movne r1,#1

	mov r7,#4

	flip_squares_check_up:
		cmp r9,#0
		ble flip_squares_check_down
		sub r0,r8,#8

		check_up_while:
			mla r3,r0,r7,r4
			ldr r3,[r3]
			cmp r3,r1
			bne check_up_while_out
			cmp r0,#7
			subgt r0,r0,#8
			bgt check_up_while

		check_up_while_out:
			mla r3,r0,r7,r4
			ldr r3,[r3]
			cmp r3,r5
			bne check_upright_diagonal
			check_up_inner_while:
				mla r3,r0,r7,r4
				str r5,[r3]
				add r0,r0,#8
				cmp r0,r8
				blt check_up_inner_while

		check_upright_diagonal:
			cmp r10,#7
			bge check_upleft_diagonal
			sub r0,r8,#7
			
			check_upright_diagonal_while:
				mla r3,r0,r7,r4
				ldr r3,[r3]
				cmp r3,r1
				bne check_upright_diagonal_while_out
				cmp r0,#7
				subgt r0,r0,#7
				bgt check_upright_diagonal_while
			check_upright_diagonal_while_out:
				mla r3,r0,r7,r4
				ldr r3,[r3]
				cmp r3,r5
				bne check_upleft_diagonal
				check_upright_diagonal_inner_while:
					cmp r0,r8
					bge check_upleft_diagonal
					mla r3,r0,r7,r4
					str r5,[r3]
					add r0,r0,#7
					b check_upright_diagonal_inner_while

		check_upleft_diagonal:
			cmp r10,#0
			ble flip_squares_check_down
			sub r0,r8,#9
			check_upleft_diagonal_while:
				mla r3,r0,r7,r4
				ldr r3,[r3]
				cmp r3,r1
				bne check_upleft_diagonal_while_out
				cmp r0,#9
				subgt r0,r0,#9
				bgt check_upleft_diagonal_while
			check_upleft_diagonal_while_out:
				mla r3,r0,r7,r4
				ldr r3,[r3]
				cmp r3,r5
				bne flip_squares_check_down
				check_upleft_diagonal_inner_while:
					cmp r0,r8
					bge flip_squares_check_down
					mla r3,r0,r7,r4
					str r5,[r3]
					add r0,r0,#9
					b check_upleft_diagonal_inner_while

	flip_squares_check_down:
		cmp r9,#7
		bge flip_squares_check_right

		add r0,r8,#8
		check_down_while:
			mla r3,r0,r7,r4
			ldr r3,[r3]
			cmp r3,r1
			bne check_down_while_out
			cmp r0,#56
			addlt r0,r0,#8
			blt check_down_while
		check_down_while_out:
			mla r3,r0,r7,r4
			ldr r3,[r3]
			cmp r3,r5
			bne check_downleft_diagonal
			check_down_inner_while:
				cmp r0,r8
				ble check_downleft_diagonal
				mla r3,r0,r7,r4
				str r5,[r3]
				sub r0,r0,#8
				b check_down_inner_while

		check_downleft_diagonal:
			cmp r10,#0
			ble check_downright_diagonal
			add r0,r8,#7
			check_downleft_diagonal_while:
				mla r3,r0,r7,r4
				ldr r3,[r3]
				cmp r3,r1
				bne check_downleft_diagonal_while_out
				cmp r0,#56
				addlt r0,r0,#7
				blt check_downleft_diagonal_while
			check_downleft_diagonal_while_out:
				mla r3,r0,r7,r4
				ldr r3,[r3]
				cmp r3,r5
				bne check_downright_diagonal
				check_downleft_diagonal_inner_while:
					cmp r0,r8
					ble check_downright_diagonal
					mla r3,r0,r7,r4
					str r5,[r3]
					sub r0,r0,#7
					b check_downleft_diagonal_inner_while

		check_downright_diagonal:
			cmp r10,#7
			bge flip_squares_check_right
			add r0,r8,#9
			check_downright_diagonal_while:
				mla r3,r0,r7,r4
				ldr r3,[r3]
				cmp r3,r1
				bne check_downright_diagonal_while_out
				cmp r0,#56
				addlt r0,r0,#9
				blt check_downright_diagonal_while
			check_downright_diagonal_while_out:
				mla r3,r0,r7,r4
				ldr r3,[r3]
				cmp r3,r5
				bne flip_squares_check_right
				check_downright_diagonal_inner_while:
					cmp r0,r8
					ble flip_squares_check_right
					mla r3,r0,r7,r4
					str r5,[r3]
					sub r0,r0,#9
					b check_downright_diagonal_inner_while

	
	flip_squares_check_right:
		cmp r10,#7
		bge flip_squares_check_left
		add r0,r8,#1

		mla r6,r9,r7,r7
		add r6,r6,r6

		check_right_while:
			mla r3,r0,r7,r4
			ldr r3,[r3]
			cmp r3,r1
			bne check_right_while_out
			cmp r0,r6
			addlt r0,r0,#1
			blt check_right_while
		check_right_while_out:
			mla r3,r0,r7,r4
			ldr r3,[r3]
			cmp r3,r5
			bne flip_squares_check_left

			check_right_inner_while:
				cmp r0,r8
				ble flip_squares_check_left
				mla r3,r0,r7,r4
				str r5,[r3]
				sub r0,r0,#1
				b check_right_inner_while

	flip_squares_check_left:
		cmp r10,#0
		ble flip_squares_exit
		sub r0,r8,#1

		mul r6,r9,r7
		add r6,r6,r6
		sub r6,r6,#7

		check_left_while:
			mla r3,r0,r7,r4
			ldr r3,[r3]
			cmp r3,r1
			bne check_left_while_out
			cmp r0,r6
			subgt r0,r0,#1
			bgt check_left_while
		check_left_while_out:
			mla r3,r0,r7,r4
			ldr r3,[r3]
			cmp r3,r5
			bne flip_squares_exit

			check_left_inner_while:
				cmp r0,r8
				bge flip_squares_exit
				mla r3,r0,r7,r4
				str r5,[r3]
				add r0,r0,#1
				b check_left_inner_while

	flip_squares_exit:
	LDMIA SP!, {r6,r7}
	mov pc,lr

@*************************** display **************************************
@ r8 -> loop index row
@ r9 -> loop index column
display_state:
	STMDB SP!,{r0,r1,r2,r3,r8,r9,r10,r11}
	swi SWI_CLEAR_DISPLAY
	mov r0,#10 @ column number
	mov r1,#1 @ row number
	ldr r2,=Welcome @ pointer to string
	swi SWI_DRAW_STRING @ draw to the LCD screen
	mov r0,#1 @ column number
	mov r1,#12 @ row number
	ldr r2,=PlayerOneScore @ pointer to string
	swi SWI_DRAW_STRING @ draw to the LCD scree
	mov r0,#18 @ column number
	mov r1,#12 @ row number
	mov r2,r6 @ player1 score
	swi SWI_DRAW_INT @ draw to the LCD scree
	mov r0,#20 @ column number
	mov r1,#12 @ row number
	ldr r2,=PlayerTwoScore @ pointer to string
	swi SWI_DRAW_STRING @ draw to the LCD scree
	mov r0,#37 @ column number
	mov r1,#12 @ row number
	mov r2,r7 @ player1 score
	swi SWI_DRAW_INT @ draw to the LCD scree
	mov r0,#1 @ column number
	mov r1,#13 @ row number
	ldr r2,=CurrentMove @ pointer to string
	swi SWI_DRAW_STRING @ draw to the LCD scree
	mov r0,#21 @ column number
	mov r1,#13 @ row number
	mov r2,r5 @ player
	swi SWI_DRAW_INT @ draw to the LCD scree
	mov r8,#0
	mov r9,#0
	mov r10,#2
	mov r11,#11

	display_index_row:
		mov r0,#9
		mov r1,#3
		mov r2,#0
	display_index_row_in:
		swi SWI_DRAW_INT
		add r2,r2,#1
		add r1,r1,#1
		cmp r2,#8
		blt display_index_row_in

	display_index_col:
		mov r0,#11
		mov r1,#2
		mov r2,#0
	display_index_col_in:
		swi SWI_DRAW_INT
		add r2,r2,#1
		add r0,r0,#2
		cmp r2,#8
		blt display_index_col_in


	loopForBoard:
		cmp r9,#8
		blt loopForBoardInColumn
		b loopForBoardOutColumn
	loopForBoardInColumn:
		cmp r8,#8
		blt loopForBoardInRow
		b loopForBoardOutRow
	loopForBoardInRow:
		mov r3,r8,LSL #3
		add r3,r3,r9
		mov r3,r3,LSL #2
		add r3,r3,r4
		ldr r3,[r3]
		mla r0,r9,r10,r11 @ column number
		add r1,r8,#3 @ row number
		compareTpyeIf:
			cmp r3,#0
			beq compareTpyeIfZero
			cmp r3,#1
			beq compareTpyeIfOne
			b compareTpyeIfTwo
		compareTpyeIfZero:
			mov r2,#'*
			swi SWI_DRAW_CHAR
			b compareTpyeIfOut
		compareTpyeIfOne:
			mov r2,#1
			swi SWI_DRAW_INT
			b compareTpyeIfOut
		compareTpyeIfTwo:
			mov r2,#2
			swi SWI_DRAW_INT
		compareTpyeIfOut:
		add r0,r0,#1
		ldr r2,=Blank
		swi SWI_DRAW_STRING
		add r8,r8,#1
		b loopForBoardInColumn
	loopForBoardOutRow:
		mov r8,#0
		add r9,r9,#1
		b loopForBoard
	loopForBoardOutColumn:
		LDMIA SP!,{r0,r1,r2,r3,r8,r9,r10,r11}
		mov pc,lr

display_winner:
	swi SWI_CLEAR_DISPLAY
	mov r0,#10 @ column number
	mov r1,#7 @ row number
	ldr r2,=Player @ pointer to string
	swi SWI_DRAW_STRING @ draw to the LCD screen
	cmp r6,r7
	movgt r2,#1
	movlt r2,#2
	mov r0,#17 @ column number
	mov r1,#7 @ row number
	swi SWI_DRAW_INT@ draw to the LCD screen
	mov r0,#19 @ column number
	mov r1,#7 @ row number
	ldr r2,=Wins @ pointer to string
	swi SWI_DRAW_STRING @ draw to the LCD scree
	b Exit

display_invalid_move:
	mov r0,#25 @ column number
	mov r1,#13 @ row number
	ldr r2,=InvalidMove @ pointer to string
	swi SWI_DRAW_STRING @ draw to the LCD scree
	b check_invalid_move

@************************* input_moves ************************************

read_from_keyboard:
	swi 0x203
	cmp r0,#0
	beq read_from_keyboard
	mov r1,#0
	tst r0,#255
	addeq r1,r1,#8
	moveq r0,r0,LSR #8
	tst r0,#15
	addeq r1,r1,#4
	moveq r0,r0,LSR #4
	tst r0,#3
	addeq r1,r1,#2
	moveq r0,r0, LSR #2
	tst r0,#1
	addeq r1,r1,#1
	mov pc,lr

pass_move:
	ldr r1,[r4,#300]
	cmp r1,#1
	beq display_winner
	mov r1,#1
	str r1,[r4,#300]
	b turn_switch

input_moves:
	STMDB SP!,{r14}

	button_check:
		swi SWI_CheckBlack
		cmp r0,#0
		beq button_check
		cmp r0,#0x02
		bne pass_move			@left button means the player will play the move, right means pass
	mov r1,#0
	str r1,[r4,#300]
	read_row:
	bl read_from_keyboard    @read row number
	cmp r1,#8
	bge read_row
	mov r9,r1	
	read_column:
	bl read_from_keyboard    @read column number
	cmp r1,#8
	blt read_column
	sub r10,r1,#8
	mov r0,#8
	mla r8,r0,r9,r10
	LDMIA SP!,{r14}
	mov pc,lr

@*************************** main *****************************************
main:
	ldr r4,=AA			@state
	mov r5,#1  			@type
	bl initialise
	bl display_state
	mov r0,#0x02
	swi SWI_SetLED


	main_while:
		add r11,r6,r7
		cmp r11,#64
		bge display_winner

		check_invalid_move:
			bl input_moves @set r8,r9,r10 here , have the feature of pass too
			mov r0,r5
			mov r1,r9
			mov r2,r10
			b checkValid
			here:
			cmp r0,#0
			beq display_invalid_move	@ move back to check_invalid_move
			cmp r5,#1
			addeq r6,r6,r0        		@changing the scores
			addeq r6,r6,#1
			subeq r7,r7,r0
			addne r7,r7,r0
			addne r7,r7,#1
			subne r6,r6,r0


		add r11,r8,r8
		add r11,r11,r11
		str r5,[r4,r11]

		bl flip_squares

		turn_switch:
			cmp r5,#1
			moveq r5,#2
			moveq r0,#0x01
			movne r5,#1
			movne r0,#0x02
			swi SWI_SetLED

		bl display_state
		b main_while



Exit:
	swi SWI_Exit

	.data
AA:	.space 400
Welcome: .asciz "Welcome to Othello"
Blank: .asciz " "
PlayerOneScore: .asciz "Player One Score: "
PlayerTwoScore: .asciz "Player Two Score: "
CurrentMove: .asciz "Current Move: Player"
@Star: .asciz "*"
Player: .asciz "Player"
Wins: .asciz "Wins!"
InvalidMove: .asciz "InvalidMove"
	.end
