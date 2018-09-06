%{
FILE *archSal;
%}
plusplus \+\+
minmin --
space [ \n\t]

%%
{plusplus} fprintf(archSal, "--");
{minmin}  fprintf(archSal, "++");
{space}  fprintf(archSal, "%s", yytext);
. fprintf(archSal, "%s", yytext);
%%
void main(int argc, char *argv[])
{
yyin = fopen(argv[1],"r");
archSal = fopen("salida.txt","w");
yylex();
fclose(archSal);
}