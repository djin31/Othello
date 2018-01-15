#include <stdio.h>
int state[64];

int main()
{
	
	int move_row,move_col;
	scanf("%d",move_row);
	scanf("%d",move_col);


}

int checkValid(int x, int y, int type){    //x -> row num, y -> col num
    int scoreTemp = 0;
    int opposite;
    if(type == 1){
        opposite = 2;
    }
    else{
        opposite = 1;
    }
    if(state[8*x + y] == 1 || state[8*x + y] == 2){
        return false;
    }
    
    // checking for another disc of same color in row
    
    for(int i = x+1; i < 8; i++){
        if(state[8*i+y] == 0 || state[8*i+y] == type){
            break;
        }        
        else{
            scoreTemp++;
        }
    }
    for(int i = x-1; i >= 0; i--){
        if(state[8*i+y] == 0 || state[8*i+y] == type){
            break;
        }        
        else{
            scoreTemp++;
        }
    }
    
    // checking in column
    
    for(int i = y+1; i < 8; i++){
        if(state[8*x+i] == 0 || state[8*x+i] == type){
            break;
        }        
        else{
            scoreTemp++;
        }
    }
    for(int i = y-1; i >= 0; i--){
        if(state[8*x+i] == 0 || state[8*x+i] == type){
            break;
        }        
        else{
            scoreTemp++;
        }
    }
    
    //checking along diagnols
    int k = 1;
    for(int i = x+1; i < 8; i++,k++){
        if(state[8*i+y + k] == 0 || state[8*i+y + k] == type){
            break;
        }        
        else{
            scoreTemp++;
        }
    }
    k = 1;
    for(int i = x-1; i >= 0; i--,k--){
        if(state[8*i+y+k] == 0 || state[8*i+y+k] == type){
            break;
        }        
        else{
            scoreTemp++;
        }
    }
    k = -1;
    for(int i = x+1; i < 8; i++,k--){
        if(state[8*i+y + k] == 0 || state[8*i+y + k] == type){
            break;
        }        
        else{
            scoreTemp++;
        }
    }
    k = 1;
    for(int i = x-1; i >= 0; i--,k++){
        if(state[8*i+y+k] == 0 || state[8*i+y+k] == type){
            break;
        }        
        else{
            scoreTemp++;
        }
    }
    return scoreTemp;
}