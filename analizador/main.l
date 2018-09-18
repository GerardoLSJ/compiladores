%{
/* Autor: Lopez Santibañez Jimenez Luis Gerardo
   Programa en LEX  que ...

*/     
#include <string.h>

FILE *archSal;
/* Definimos nuestras expresiones regulares para detectar ++,-- y spaces */
void regexMatched(int class, char *text, int ix);
// void handleErr(char *err);
int findInStaticTable(int class, char *text);
 int line = 0;

char *RESERVADAS[] = {
    "Bul", "Cadena", "Cierto", "Entero", "Falso", "Haz","Mientras", "Para", "Real", "Si","Sino"
    };

char *ESPECIALES[] = {
    "(",
    ")", 
    ",", 
    ";", 
    "[", 
    "]"
};

char *ASIGNACION[] = {":="};

char *RELACIONALES[] = {
    ".DIF.",".IGL.",
    ".MN.", ".MNI.",
    ".MY.", ".MYI."
    };
    
char *ARITMETICOS[] = {"+","-","*","/","%"};


%}
/* Definiciones */
space [ ]
newline [\n]
tab [\t]
uppercase [A-Z]
lowercase [a-z]
digit [0-9]
asignacion :=
relacionales \.DIF\.|\.IGL\.|\.MN\.|\.MNI\.|\.MY\.|\.MYI\.
aritmeticos \+|-|\*|\/|%
especiales \(|\)|\[|\]|,|;
entero {digit}+
real ({digit}+\.|\.{digit}+){digit}*
cientifico ({real}|{entero})(e|E)(\+|-)?{entero}
cadena \"[^"](\\.|[^\\"])*\"
reservadas Bul|Cadena|Cierto|Entero|Falso|Haz|Mientras|Para|Real|Si|Sino
identificador {lowercase}(({uppercase}|{lowercase}){0,7})[^{digit}{newline}]



%%
{reservadas}    fprintf(archSal, "reservadas ");    regexMatched(0, yytext, -1);
{identificador} fprintf(archSal, "identificador "); regexMatched(1, yytext, -1); //i.push(yytext) buscar, insertar, return ix
{especiales}    fprintf(archSal, "especiales ");    regexMatched(2, yytext, -1);
{asignacion}    fprintf(archSal, "asignacion ");    regexMatched(3, yytext, -1);
{relacionales}  fprintf(archSal, "relacionales");   regexMatched(4, yytext, -1);
{aritmeticos}   fprintf(archSal, "aritmeticos");    regexMatched(5, yytext, -1);
{cadena}        fprintf(archSal, "cadena");         regexMatched(6, yytext, -1); //c.push(yytext) inseta, return ix
{entero}        fprintf(archSal, "entero");         regexMatched(7, yytext, -1); //e.push(yytext) buscar, insertar, return ix
{real}          fprintf(archSal, "real");           regexMatched(8, yytext, -1); //r.push(yytext)buscar, insertar, return ix
{cientifico}    fprintf(archSal, "cientifico");     regexMatched(8, yytext, -1); // r.push(yytext) buscar, insertar, return ixreturn ix 
{space}       fprintf(archSal, " "); 
{newline}         fprintf(archSal, "\n"); line++;
{tab}           fprintf(archSal, "\t"); 
.               fprintf(archSal, "error line %d {%s}", line, yytext); //handleErr(yytext);


%%





int main(int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    archSal = fopen("salida.txt","w");
    yylex();
    fclose(archSal);
    return 0;
}

void regexMatched(int class, char *text, int ix){


}



int findInStaticTable(int class, char *text){
    return 0;
}