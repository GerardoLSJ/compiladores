%{
/* Programa en lex que presenta en base hexadecimal los números
introducidos que están en base diez
*/
#include <stdlib.h>
#include <stdio.h>
int count = 0;
%}
dig [0-9]
num {dig}+
%%
{num} {int n= atoi(yytext);
printf("%x", n);
if (n>9) count++;}

%%
main()
{yylex();
fprintf(stderr,"número de reemplazos = %d", count);
return 0;
}