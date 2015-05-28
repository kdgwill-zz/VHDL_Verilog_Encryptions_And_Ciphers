/*
 * INPUT              : RESULT                                                                                                                                      
 * 0x0000000000000000 : 0xEEDBA5216D8F-4B15                                                                                                                          
 * 0x00000000000000FF : 0x15555F8EF974-3134                                                                                                                          
 * 0x00000000000000F0 : 0xB54A3283794B-2690                                                                                                                          
 * 0x000000000000000F : 0x587B7A10886C-622A                                                                                                                          
 * 0x00000000000000AA : 0x9D2287A288F8-4AE2                                                                                                                          
 * 0x0000000000000055 : 0x2A51068495F2-9408  
*/
#include <stdio.h>

#define VEC_SIZE 6
unsigned int rotl(const unsigned int value, unsigned int shift);

int main(){
    int i,s;
    int skey[26] = {
                0x9BBBD8C8, 0x1A37F7FB, 0x46F8E8C5, 0x460C6085, 0x70F83B8A, 
                0x284B8303, 0x513E1454, 0xF621ED22, 0x3125065D, 0x11A83A5D, 
                0xD427686B, 0x713AD82D,    0x4B792F99, 0x2799A4DD, 0xA7901C49, 
                0xDEDE871A,    0x36C03196, 0xA7EFC249, 0x61A78BB8, 0x3B0A1D2B,
                0x4DBFCA76, 0xAE162167, 0x30D76B0A, 0x43192304, 0xF6CC1431, 
                0x65046380
    };
    unsigned long long din[VEC_SIZE] = {0x0000000000000000,
                                        0x00000000000000FF,
                                        0x00000000000000F0,
                                        0x000000000000000F,
                                        0x00000000000000AA,
                                        0x0000000000000055
    };   
    unsigned long long dout[VEC_SIZE];
    unsigned long long sig = 0;
    unsigned long long res = 0;
    
    unsigned int A = 0;//din>>32;
    unsigned int B = 0;//din & 0xFFFFFFFF;
    for(s=0;s<VEC_SIZE;s++){
        sig = din[s];
        A = sig>>32;//Initial
        B = sig & 0xFFFFFFFF;//Initial
        //PreRound
        A += skey[0];
        B += skey[1];
        //Round-Op
        for(i=1; i<=12; i++){
            //A = ((A XOR B) <<< B) + S[2*i];
            A ^= B;
            A = rotl(A,B&0x1f);
            A += skey[2*i];
            //B = ((B XOR A) <<< A) + S[2*i+1];
            B ^= A;
            B = rotl(B,A&0x1f);
            B += skey[2*i+1];
        }
        res = (long long) A << 32 | B;
        dout[s] = res;
    }
    
    printf("%s%22s\n","INPUT",": RESULT");
    for(i=0;i<VEC_SIZE;i++){
        printf("0x%016llX : 0x%016llX\n",din[i],dout[i]);
    }

    return 0;
}

unsigned int rotl(unsigned int value, unsigned int shift) {
    return (value << shift) | (value >> (32 - shift));
}