#include <stdio.h>
int state[64];
int black=2;
int white=2;

void initialise(){
	for (int i=0;i<64;i++)
		state[i]=0;
	state[15]=1;
	state[16]=2;
	state[23]=2;
	state[24]=1;
	black=2;
	white=2;
}

void flip_squares(int move_row,int move_col,int type){
	int temp;
    int other_type;
    if (type==1)
        other_type=2;
    else
        other_type=1;
	if (move_row>0){           
		temp=8*move_row + move_col - 8;   //check up
		while (state[temp]==other_type){
			if (temp>7)
                temp-=8;
            else
                break;
		}
        if (temp>0){
            if (state[temp]==type){
                while (temp<move_row){
                    state[temp]=type;
                    temp+=8;
                }
            }
        }

        if (move_col<7){
            temp=8*move_row+move_col-7;         //check up right diagonal
            while (state[temp]==other_type){
                if (temp>7)
                    temp-=7;
                else
                    break;
            }   
            if (temp>0){
                if (state[temp]==type){
                    while (temp<move_row){
                        state[temp]=type;
                        temp+=7;
                    }
                }
            }
        }
        

        if (move_col>0){
            temp=8*move_row+move_col-9;         //check up left diagonal
            while (state[temp]==other_type){
                if (temp>0)
                    temp-=9;
                else
                    break;
            }
            if (temp>0){
                if (state[temp]==type){
                    while (temp<move_row){
                        state[temp]=type;
                        temp+=9;
                    }
                }
            }   
        }
        
	}

    if (move_row<7){
        temp=8*move_row + move_col + 8;   //check down
        while (state[temp]==other_type){
            if (temp<56)
                temp+=8;
            else
                break;
        }
        if (temp<64){
            if (state[temp]==type){
                while (temp<move_row){
                    state[temp]=type;
                    temp-=8;
                }
            }
        }

        if (move_col>0){
            temp=8*move_row + move_col + 7;     //check left down diagonal
            while (state[temp]==other_type){
                if (temp<56)
                    temp+=7;
                else
                    break;
            }
            if (temp<64){
                if (state[temp]==type){
                    while (temp<move_row){
                        state[temp]=type;
                        temp-=7;
                    }
                }
            }   
        }

        if (move_col<7){
            temp=8*move_row + move_col + 9;     //check right down diagonal
            while (state[temp]==other_type){
                if (temp<56)
                    temp+=9;
                else
                    break;
            }
            if (temp<64){
                if (state[temp]==type){
                    while (temp<move_row){
                        state[temp]=type;
                        temp-=9;
                    }
                }
            }   
        }

    }

    if (move_col<7){
        temp=8*move_row + move_col + 1;   //check right
        limit = 8*move_row-8;
        while (state[temp]==other_type){
            if (temp<limit)
                temp+=1;
            else
                break;
        }
        if (temp<limit){
            if (state[temp]==type){
                while (temp<move_row){
                    state[temp]=type;
                    temp-=1;
                }
            }
        }
    }

    if (move_col>0){
        temp=8*move_row + move_col - 1;   //check left
        limit = 8*move_row + 7;
        while (state[temp]==other_type){
            if (temp<limit)
                temp-=1;
            else
                break;
        }
        if (temp<limit){
            if (state[temp]==type){
                while (temp<move_row){
                    state[temp]=type;
                    temp+=1;
                }
            }
        }
    }
}

void display(){
    temp=0;
    for (int i=0;i<7;i++){
        for (int j=0;j<7;j++){
            printf("%d ",state[temp]);
            temp+=1;
        }
        printf("\n");
    }
}

int main()
{
	initialise();
	int move_row,move_col;
	bool valid_move;
	int type=1;
	while (black+white<64){
		scanf("%d",move_row);
		scanf("%d",move_col);
		valid_move=checkValid(move_row,move_col,type);
		while (valid_move==0){
			scanf("%d",move_row);
			scanf("%d",move_col);
			valid_move=checkValid(move_row,move_col,type);
		}
		state[8*move_row+move_col]=type;
		display(move_row,move_col,type);
		if (type==1)
			type=2;
		else
			type=1;


	}


}

int checkValid(int x, int y, int type){    //x -> row num, y -> col num
    int score = 0;
    int scoreTemp = 0;
    int opposite;
    if(type == 1){
        opposite = 2;
    }
    else{
        opposite = 1;
    }
    if(state[8*x + y] != 0){
        return 0;
    }
    
    // checking for another disc of same color in row
    scoreTemp = 0;
    for(int i = x+1; i < 8; i++){
        if(state[8*i+y] == type){
            break;
        }        
        if(state[8*i+y] == 0 || i == 7){
        	score = score - scoreTemp;
        	break;
        }
        else{
            scoreTemp++;
			score++;
        }
    }
    scoreTemp = 0;
    for(int i = x-1; i >= 0; i--){
        if(state[8*i+y] == type){
            break;
        }        
        if(state[8*i+y] == 0 || i == 0){
        	score = score - scoreTemp;
        	break;
        }        
        else{
            scoreTemp++;
			score++;
        }
    }
    
    // checking in column
    scoreTemp = 0;
    for(int i = y+1; i < 8; i++){
        if(state[8*x+i] == type){
            break;
        }        
        if(state[8*x+i] == 0 || i == 7){
        	score = score - scoreTemp;
        	break;
        }
        else{
            scoreTemp++;
			score++;
        }
    }
    scoreTemp = 0;
    for(int i = y-1; i >= 0; i--){
        if(state[8*x+i] == type){
            break;
        }        
        if( state[8*x+i] == 0 || i == 0){
        	score = score - scoreTemp;
        	break;
        }
        else{
            scoreTemp++;
			score++;
        }
    }
    
    //checking along diagnols
    int k = 1;
    scoreTemp = 0;
    for(int i = x+1; i < 8; i++,k++){
        if(state[8*i+y + k] == type){
            break;
        }        
        if(state[8*i+y + k] == 0 || i == 7){
        	score = score - scoreTemp;
        	break;
        }
        else{
            scoreTemp++;
			score++;
        }
    }
    k = 1;
    scoreTemp = 0;
    for(int i = x-1; i >= 0; i--,k--){
        if(state[8*i+y+k] == type){
            break;
        }  
        if(state[8*i+y+k] == 0 || i == 0){
        	score = score - scoreTemp;
        	break;
        }      
        else{
            scoreTemp++;
			score++;
        }
    }
    k = -1;
    scoreTemp = 0;
    for(int i = x+1; i < 8; i++,k--){
        if(state[8*i+y + k] == type){
            break;
        }  
        if(state[8*i+y + k] == 0 || i == 7){
        	score = score - scoreTemp;
        	break;
        }      
        else{
            scoreTemp++;
			score++;
        }
    }
    k = 1;
    scoreTemp = 0;
    for(int i = x-1; i >= 0; i--,k++){
        if(state[8*i+y+k] == type){
            break;
        }  
        if(state[8*i+y+k] == 0 || i == 0){
        	score = score - scoreTemp;
        	break;
        }      
        else{
            scoreTemp++;
			score++;
        }
    }
    return score;
}