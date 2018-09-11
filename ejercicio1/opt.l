
%{
/* Autor: Lopez Santibañez Jimenez Luis Gerardo
   Programa en LEX  que cambia los ++ por --
   y los -- por ++
*/
/*
Definimos el archivo de salida
*/
FILE *archSal;
%}
/* Definimos nuestras expresiones regulares para detectar ++,-- y espacios */
plusplus \+\+
minmin --
space [ \n\t]

/* Definimos que sera escrito en caso de hacer match con las expresiones */
%%
{plusplus} fprintf(archSal, "--");
{minmin}  fprintf(archSal, "++");
{space}  fprintf(archSal, "%s", yytext);
. fprintf(archSal, "%s", yytext);
%%
//Definimos nuestra funcion principal, el archivo de entrada y el de salida
void main(int argc, char *argv[])
{
yyin = fopen(argv[1],"r");
archSal = fopen("salida.txt","w");
yylex();
fclose(archSal);
}