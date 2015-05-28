/**
 * RESULTS
 * 9bbbd8c8, 1a37f7fb, 46f8e8c5,                                                                                                                                                        
 * 460c6085, 70f83b8a, 284b8303,                                                                                                                                                         
 * 513e1454, f621ed22, 3125065d,                                                                                                                                                         
 * 11a83a5d, d427686b, 713ad82d,                                                                                                                                                         
 * 4b792f99, 2799a4dd, a7901c49,                                                                                                                                                         
 * dede871a, 36c03196, a7efc249,                                                                                                                                                         
 * 61a78bb8, 3b0a1d2b, 4dbfca76,                                                                                                                                                         
 * ae162167, 30d76b0a, 43192304,                                                                                                                                                         
 * f6cc1431, 65046380,    
 */ 
#include <stdio.h>
#include <stdlib.h>

unsigned int rotl(const unsigned int value, unsigned int shift);

int main(){
    //128 bits too large broken into 2 64 bits
    unsigned long long int key_1 = 0x0000000000000000;
    unsigned long long int key_2 = 0x0000000000000000;
   	                            
   	unsigned long L[8]; 
   	L[0] = (key_1>>00) & 0xFFFFFFFF;
   	L[1] = (key_1>>31) & 0xFFFFFFFF;
   	L[2] = (key_2>>00) & 0xFFFFFFFF;
   	L[3] = (key_2>>31) & 0xFFFFFFFF;
   	
	//--S[0] = 0xB7E15163 (Pw)
	//	--for i=1 to 25 do  S[i] = S[i-1]+ 0x9E3779B9 (Qw)
    unsigned int S[26];
    S[0] = 0xB7E15163;
    for(int i=1;i<26;i++){
        S[i] = S[i-1] + 0x9E3779B9;
    }
    
    //i=0;j=0;
    //    do 78 times // 78 = 3*max(26,4);
    //    A = S[i] = (S[i] + A + B) <<< 3;
    //	B = L[j] = (L[j] + A + B) <<< (A + B);
    //	i = (i + 1) mod 26; 
    //	j = (j + 1) mod 4;     

	int  i=0, j=0;
	unsigned long A=0, B=0;
	for(int k=0; k<78; k++){
		A = S[i] = rotl(S[i] + A + B, 3);
		B = L[j] = rotl(L[j] + A + B, A + B);
		i = (i + 1) % 26;
		j = (j + 1) % 4;
	}
    
    for(int i=0;i<26;i++){
        printf("%x\n",S[i]);
    }

    return 0;
}

unsigned int rotl(unsigned int value, unsigned int shift) {
    return (value << shift) | (value >> (32 - shift));
}



