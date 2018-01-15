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

void display(int move_row,int move_col,int type){
	int temp;
	if (move_row>0){
		temp=8*move_row + move_col - 8;
		while (state[temp]==2){
			if state[temp]
		}
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