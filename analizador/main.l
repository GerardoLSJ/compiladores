%{
/* Autor: Lopez Santibañez Jimenez Luis Gerardo
   Programa en LEX  que ...

*/     
#include <string.h>

FILE *archSal;
FILE *tokens;
FILE *stringTable;
FILE *identTable;

/* ------------------------- Estructuras ------------------------- */
typedef struct Cadena{
    int  posicion;
    char *cadena;

    struct Cadena * prev;
    struct Cadena * next;
}Cadena;

typedef struct Numero{
    int clase;
    int valor;

    struct Numero * prev;
    struct Numero * next;
}Numero;

typedef struct intQueue{
    struct Numero *head;
    struct Numero *tail;

    int size;
}intQueue;

typedef struct strQueue{
    struct Cadena *head;
    struct Cadena *tail;

    int size;
}strQueue;

/* ------------------------- Funciones ------------------------- */

	// Funciones de tipo Caracter
	void insertaColaStr(strQueue *q, int posicion, char *valor) {
		Cadena * item = (Cadena*)malloc(sizeof(Cadena));
        
        item->cadena = (char*)malloc(sizeof(char)*strlen(valor));
        strcpy(item->cadena, valor);
		item->posicion = posicion;

		if (q->head == NULL) { // Primer elemento en la cola
			
            item->next  = NULL;
			item->prev = NULL;
			q->head = item;
			q->tail = item;

			q->size += 1;
			return;
		}

		// Si ya existen elementos
	    item->next  = NULL;
		item->prev = q->tail;
		q->tail->next = item;
		q->tail = item;

		q->size += 1;
		
		return;
	}

    // void busquedaItem(Queue *q, char *valor) {
    //     Cadena *pointer = (Cadena*)malloc(sizeof(Cadena));
    //     pointer = q->head;

	// 	while(pointer != NULL) {
	// 		if(strcmp(valor, pointer->valor) == 0)
    //             return cursor->posicion;

	// 		pointer = pointer->next;
	// 	}
    //     return -1;
    // }

	// void muestraTabla(Queue *q, char *tablaN) {
	// 	printf("\n -- -- -- -- -- %s -- -- -- -- -- \n", tablaN);
	// 	printf("\n Posicion\t\tValor \n");

	// 	Cadena * pointer = (Cadena*)malloc(sizeof(Cadena));
	// 	pointer = q->head;

	// 	while(pointer != NULL) {
	// 		printf("\n %d\t\t%s", pointer->posicion, pointer->valor);
	// 		pointer = pointer->next;
	// 	}

	// 	printf("\n -------------------------------- \n");
	// 	return;
	// }

    //Funciones de tipo Numericas
    void insertaColaNum(intQueue *q, int clase, int valor) {
		Numero * item = (Numero*)malloc(sizeof(Numero));
        
		item->valor = valor;
        item->clase = clase;

		if (q->head == NULL) { // Primer elemento en la cola
            item->next  = NULL;
			item->prev = NULL;
			q->head = item;
			q->tail = item;

			q->size += 1;
			return;
		}

		// Si ya existen elementos
	    item->next  = NULL;
		item->prev = q->tail;
		q->tail->next = item;
		q->tail = item;

		q->size += 1;
		return;
	}

    int busquedaInt(intQueue *q, int valor) {
        Numero *pointer = (Numero*)malloc(sizeof(Numero));
        pointer = q->head;

		while(pointer != NULL) {
			if(valor == pointer->valor)
                return pointer->clase;

			pointer = pointer->next;
		}
        return -1;
    }

    void muestraTablaStr(strQueue *q, char *tablaN) {
		printf("\n -- -- -- -- -- %s -- -- -- -- -- \n", tablaN);
		printf("\n Clase\t\tValor \n");

		Cadena * pointer = (Cadena*)malloc(sizeof(Cadena));
		pointer = q->head;

		while(pointer != NULL) {
			printf("\n %d\t\t%s", pointer->posicion, pointer->cadena);
			pointer = pointer->next;
		}

		printf("\n -------------------------------- \n");
		return;
	}
    void muestraTablaInt(intQueue *q, char *tablaN) {
		printf("\n -- -- -- -- -- %s -- -- -- -- -- \n", tablaN);
		printf("\n Clase\t\tValor \n");

		Numero * pointer = (Numero*)malloc(sizeof(Numero));
		pointer = q->head;

		while(pointer != NULL) {
			printf("\n %d\t\t%d", pointer->clase, pointer->valor);
			pointer = pointer->next;
		}

		printf("\n -------------------------------- \n");
		return;
	}

    //Funciones Generales
	void initQueueInt(intQueue *q) {
		q->head = NULL;
		q->tail = NULL;
		q->size = 0;
		return;
	}
    void initQueueStr(strQueue *q) {
		q->head = NULL;
		q->tail = NULL;
		q->size = 0;
		return;
	}

/* -------------------------------------------------------------- */


//int i = 0; Para qué era?

/* Definimos nuestras expresiones regulares para detectar ++,-- y spaces */
void aux(int class, char *text);
int lineCount = 0;

char *RESERVADAS[] = {
    "Bul", "Cadena", "Cierto", "Entero", "Falso", "Haz","Mientras", "Para", "Real", "Si", "Sino"
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
space           [ ]
newline         [\n]
tab             [\t]
uppercase       [A-Z]
lowercase       [a-z]
digit           [0-9]
asignacion      :=
relacionales    (\.(DIF|IGL|MN|MNI|MY|MYI)\.)
aritmeticos     \+|-|\*|\/|%
especiales      \(|\)|\[|\]|,|;
entero          {digit}+
real            ({digit}+\.|\.{digit}+){digit}*
exp             ({real}|{entero})(e|E)(\+|-)?{entero}
stringCte       (\"(.+)\")
reservadas      Bul|Cadena|Cierto|Entero|Falso|Haz|Mientras|Para|Real|Si|Sino
identificador   {lowercase}(({uppercase}|{lowercase}){0,7})[^{digit}{newline}]
comment         \$\$(.*)\$


%%
{reservadas}    {
                    fprintf(archSal, "reservadas ");
                    // for (i = 0; i < 11; i++){
                    //     if (strcmp(text, table[i]) == 0)
                    //         fprintf(tokens, "(0,%d)", i);
                    // }
                }
{identificador} fprintf(archSal, "identificador "); aux(1, yytext); //i.push(yytext) buscar, insertar, return ix
{especiales}    {
                    fprintf(archSal, "especiales ");
                    // for (i = 0; i < 6; i++){
                    //     if (strcmp(text, table[i]) == 0)
                    //         fprintf(tokens, "(0,%d)", i);
                    // }
                }
{asignacion}    {
                    fprintf(archSal, "asignacion ");
                    fprintf(tokens, "(0,0)");
                }
{relacionales}  {
                    fprintf(archSal, "relacionales");
                    // for (i = 0; i < 6; i++){
                    //     if (strcmp(text, table[i]) == 0)
                    //         fprintf(tokens, "(0,%d)", i);
                    // }
                }
{aritmeticos}   {
                    fprintf(archSal, "aritmeticos");
                    // for (i = 0; i < 5; i++){
                    //     if (strcmp(text, table[i]) == 0)
                    //         fprintf(tokens, "(0,%d)", i);
                    // }
                }
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