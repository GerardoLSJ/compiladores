%{
/* Autor: Lopez Santibañez Jimenez Luis Gerardo
   Programa en LEX  que ...

*/     
#include <string.h>

FILE *archSal;
FILE *tokens;
FILE *stringTable;
FILE *identTable;
/* Definimos nuestras expresiones regulares para detectar ++,-- y spaces */
void aux(int class, char *text);
int lineCount = 0;

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
relacionales (\.(DIF|IGL|MN|MNI|MY|MYI)\.)
aritmeticos \+|-|\*|\/|%
especiales \(|\)|\[|\]|,|;
entero {digit}+
real ({digit}+\.|\.{digit}+){digit}*
exp ({real}|{entero})(e|E)(\+|-)?{entero}
cadena \"[^"](\\.|[^\\"])*\"
stringCte (\"(.+)\")
reservadas Bul|Cadena|Cierto|Entero|Falso|Haz|Mientras|Para|Real|Si|Sino
identificador {lowercase}(({uppercase}|{lowercase}){0,7})[^{digit}{newline}]
comment \$\$(.*)\$


%%
{reservadas}    fprintf(archSal, "reservadas ");    aux(0, yytext);
{identificador} fprintf(archSal, "identificador "); aux(1, yytext); //i.push(yytext) buscar, insertar, return ix
{especiales}    fprintf(archSal, "especiales ");    aux(2, yytext);
{asignacion}    fprintf(archSal, "asignacion ");    aux(3, yytext);
{relacionales}  fprintf(archSal, "relacionales");   aux(4, yytext);
{aritmeticos}   fprintf(archSal, "aritmeticos");    aux(5, yytext);
{stringCte}     fprintf(archSal, "cadena");         aux(6, yytext); //c.push(yytext) inseta, return ix
{entero}        fprintf(archSal, "entero");         aux(7, yytext); //e.push(yytext) buscar, insertar, return ix
{real}          fprintf(archSal, "real");           aux(8, yytext); //r.push(yytext)buscar, insertar, return ix
{exp}           fprintf(archSal, "cientifico");     aux(8, yytext); // r.push(yytext) buscar, insertar, return ixreturn ix 
{space}         fprintf(archSal, " "); 
{newline}       fprintf(archSal, "\n"); lineCount++;
{tab}           fprintf(archSal, "\t"); 
{comment}       fprintf(archSal, " "); 
.               fprintf(archSal, "error lineCount %d {%s}", lineCount, yytext); //handleErr(yytext);


%%





int main(int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    archSal = fopen("salida.txt","w");
    yylex();
    fclose(archSal);
    return 0;
}

void aux(int type, char *text){
    char **table;
    switch(type){
        case 0: 
        table = RESERVADAS;
        break;

        case 2: 
        table = ESPECIALES;
        break;

        case 3: 
        table = ASIGNACION;
        break;

        case 4: 
        table = RELACIONALES;
        break;

        case 5: 
        table = ARITMETICOS;
        break;

    }

    /* Buscar elemento en tabla y incrementar o pushear*/

}

