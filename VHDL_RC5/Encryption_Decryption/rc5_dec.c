/**
  * INPUT              : RESULT                                                                                                                                      
  * 0xEA04BFBEB6EB797B : 0xFEDCBA9876543210                                                                                                                          
  * 0xEEDBA5216D8F4B15 : 0x0000000000000000                                                                                                                          
  * 0x4C719ECA593EFF1F : 0xFFFFFFFFFFFFFFFF                                                                                                                          
  * 0x3A39493576DB0451 : 0xFFFFFFFF00000000                                                                                                                          
  * 0x5740400D13C70A03 : 0x00000000FFFFFFFF
*/
#include <stdio.h>

#define VEC_SIZE 5
unsigned int rotr(const unsigned int value, unsigned int shift);

int main(){
    int i,s;
    int skey[26] = {
                0x9BBBD8C8, 0x1A37F7FB, 0x46F8E8C5, 0x460C6085, 0x70F83B8A, 
                0x284B8303, 0x513E1454, 0xF621ED22, 0x3125065D, 0x11A83A5D, 
                0xD427686B, 0x713AD82D,	0x4B792F99, 0x2799A4DD, 0xA7901C49, 
                0xDEDE871A,	0x36C03196, 0xA7EFC249, 0x61A78BB8, 0x3B0A1D2B,
				0x4DBFCA76, 0xAE162167, 0x30D76B0A, 0x43192304, 0xF6CC1431, 
				0x65046380
    };
    
    unsigned long long din[VEC_SIZE] = {0xEA04BFBEB6EB797B,
                                        0xEEDBA5216D8F4B15,
                                        0x4C719ECA593EFF1F,
                                        0x3A39493576DB0451,
                                        0x5740400D13C70A03
    };  
    
    unsigned long long dout[VEC_SIZE];
    unsigned long long sig = 0;
    unsigned long long res = 0;
    
    unsigned int A = 0;//din>>32;
    unsigned int B = 0;//din & 0xFFFFFFFF;
    for(s=0;s<VEC_SIZE;s++){
        sig = din[s];
        A = sig>>32;
        B = sig & 0xFFFFFFFF;
        for(i=12; i>=1; i--){
			//B = ((B - S[2×i +1]) >>> A) xor A;
			B -= skey[2*i+1];
			B = rotr(B,A&0x1f);
			B ^= A;
            //A = ((A - S[2×i]) >>> B) xor B;
			A -= skey[2*i];
			A = rotr(A,B&0x1f);
			A ^= B;
        }
        B-=skey[1];
        A-=skey[0];
        res = (long long) A << 32 | B;
        dout[s] = res;
    }
    
    printf("%s%22s\n","INPUT",": RESULT");
    for(i=0;i<VEC_SIZE;i++){
        printf("0x%016llX : 0x%016llX\n",din[i],dout[i]);
    }

    return 0;
}

unsigned int rotr(unsigned int value, unsigned int shift) {
	return (value >> shift) | (value << (32 - shift));
}
