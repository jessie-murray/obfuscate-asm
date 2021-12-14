#include <stdio.h>
#include <stdlib.h>

extern void obfuscate(char*, int);
extern void unobfuscate(char*, int);

int main(int argc, char **argv)
{
   int i;
   
   #define INPUT_SIZE 12345
   #define LOOP_COUNT 67890
   //#define SHOW
   
   char *tab = malloc(INPUT_SIZE);
   char *validation_array = malloc(INPUT_SIZE);
   
   srand(time(NULL));
   for (i = 0;i<INPUT_SIZE - 1;++i){
      tab[i] = 'A' + rand() % ('z'-'A'); /* a-zA-Z\]^_` */
   }
   tab[INPUT_SIZE] = 0;
   
   memcpy(validation_array, tab, INPUT_SIZE);
   
   
   #ifdef SHOW
   printf("\t  Original: %s\n",tab);
   #endif
   
   printf("  OBFUSCATING: "); fflush(stdout);
   
   for (i=0;i<LOOP_COUNT;i++) {
      obfuscate(tab,INPUT_SIZE);
   }
   printf("\tdone\n");
   
   #ifdef SHOW
   printf("\t  Obfuscated: %s\n",tab);
   #endif
   
   printf("UNOBFUSCATE: "); fflush(stdout);
   for (i=0;i<LOOP_COUNT;i++) {
      unobfuscate(tab,INPUT_SIZE);
   }
   printf("\tdone\n");
   #ifdef SHOW
   printf("\tUnobfuscated: %s\n",tab);
   #endif
   
   printf("Validation: "); fflush(stdout);
   if (memcmp(tab, validation_array, INPUT_SIZE) == 0){
      printf("\tSuccess\n");
   } else {
      printf("\tFAILURE\n");
   }
   
   return 0;
}
