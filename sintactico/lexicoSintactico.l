%{
/*  Autor: López Santibáñez Jiménez Luis Gerardo
           Robles Uribe Karen Abril

    Compiladores, grupo 2
    
    Analizador léxico creado con ANSI C y lex.
*/     
#include <string.h>
#include <stdlib.h>

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

typedef struct Caracter{
    char caracter;

    struct Caracter * prev;
    struct Caracter * next;
}Caracter;

typedef struct atomQueue{
    struct Caracter *head;
    struct Caracter *tail;

    int size;
}atomQueue;

/* ------------------------ Declaración de variables -------------------------- */

FILE *archSal;
FILE *archErr;
FILE *tokens;

intQueue * tokenQ;
strQueue * identQ;
strQueue * strQ;
strQueue * floatQ;
strQueue * entQ;
strQueue * espQ;
atomQueue * syntaxQ;

int lineCount = 0;

// Declaramos las tablas estáticas a usar
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

char *ASIGNACION[] = { ":=" };

char *RELACIONALES[] = {
    ".DIF.",".IGL.",
    ".MN.", ".MNI.",
    ".MY.", ".MYI."
};
    
char *ARITMETICOS[] = {"+","-","*","/","%"};




/* ------------------------- Funciones ------------------------- */
// Funciones de tipo Caracter
int busquedaStr(strQueue *q, char *str) {
    Cadena *pointer = (Cadena*) malloc(sizeof(Cadena));
    pointer = q->head;

    while( pointer != NULL) {
        if (!strcmp(pointer->cadena, str))
            return pointer->posicion;
        pointer = pointer->next;
    }

    return -1;
}

int insertaColaStr(strQueue *q, int pos, char *valor, int clase ) {

    int index = busquedaStr(q, valor);
    if(index != -1)
        return index;

    Cadena * item = (Cadena*)malloc(sizeof(Cadena));
    
    item->cadena = (char*)malloc(sizeof(char)*strlen(valor));
    strcpy(item->cadena, valor);
    item->posicion = pos;

    if (q->head == NULL) { // Primer elemento en la cola
        
        item->next  = NULL;
        item->prev = NULL;
        q->head = item;
        q->tail = item;

        q->size += 1;
        return q->size - 1;
    }

    // Si ya existen elementos
    item->next  = NULL;
    item->prev = q->tail;
    q->tail->next = item;
    q->tail = item;

    q->size += 1;
    
    return q->size-1;
}

void muestraTablaStr(strQueue *q , char *nombre) {
    printf("\n  -- -- -- -- -- %s -- -- -- -- -- \n", nombre);
    printf("\n\t Indice\t\tValor \n");

    Cadena * pointer = (Cadena*)malloc(sizeof(Cadena));
    pointer = q->head;

    while(pointer != NULL) {
        printf("\n\t %d\t\t%s", pointer->posicion, pointer->cadena);
        pointer = pointer->next;
    }

    printf("\n  -- -- -- -- -- -- -- -- -- -- -- -- -- \n");
    return;
}

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

void muestraTablaInt(intQueue *q) {
    printf("\n  -- -- -- -- -- -- -- -- -- -- -- -- \n");
    printf("\n\t Clase\t\tValor \n");

    Numero * pointer = (Numero*)malloc(sizeof(Numero));
    pointer = q->head;

    while(pointer != NULL) {
        printf("\n\t %d\t\t%d", pointer->clase, pointer->valor);
        pointer = pointer->next;
    }

    printf("\n  -- -- -- -- -- -- -- -- -- -- -- -- \n");
    return;
}

//Funciones Generales (Inicializacion)
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


/* SINTACTICO */
int insertarAtomo(atomQueue *q, int pos, char valor ) {
    Caracter * item = (Caracter*)malloc(sizeof(Caracter));
    
    item->caracter = valor;

    if (q->head == NULL) { // Primer elemento en la cola
        
        item->next  = NULL;
        item->prev = NULL;
        q->head = item;
        q->tail = item;

        q->size += 1;
        return q->size - 1;
    }

    // Si ya existen elementos
    item->next  = NULL;
    item->prev = q->tail;
    q->tail->next = item;
    q->tail = item;

    q->size += 1;
    
    return q->size-1;
}
void insertarAtomoReservado(atomQueue *q, char *valor){
    if (strcmp(valor, RESERVADAS[0]) == 0){
        insertarAtomo(q, q->size, 'b' );
    }else if (strcmp(valor, RESERVADAS[1]) == 0){
        insertarAtomo(q, q->size, 'c' );
    }else if (strcmp(valor, RESERVADAS[2]) == 0){
        insertarAtomo(q, q->size, 't' );
    }else if (strcmp(valor, RESERVADAS[3]) == 0){
        insertarAtomo(q, q->size, 'e' );
    }else if (strcmp(valor, RESERVADAS[4]) == 0){
        insertarAtomo(q, q->size, 'f' );
    }else if (strcmp(valor, RESERVADAS[5]) == 0){
        insertarAtomo(q, q->size, 'h' );
    }else if (strcmp(valor, RESERVADAS[6]) == 0){
        insertarAtomo(q, q->size, 'm' );
    }else if (strcmp(valor, RESERVADAS[7]) == 0){
        insertarAtomo(q, q->size, 'p' );
    }else if (strcmp(valor, RESERVADAS[8]) == 0){
        insertarAtomo(q, q->size, 'd' );
    }else if (strcmp(valor, RESERVADAS[9]) == 0){
        insertarAtomo(q, q->size, 'i' );
    }else if (strcmp(valor, RESERVADAS[10]) == 0){
        insertarAtomo(q, q->size, 'o' );
    }
}
void buscarAtomoRelacional(atomQueue *q, char *valor){
    if (strcmp(valor, RELACIONALES[0]) == 0){
        insertarAtomo(q, q->size, '!' );
    }else if (strcmp(valor, RELACIONALES[1]) == 0){
        insertarAtomo(q, q->size, 'q' );
    }else if (strcmp(valor, RELACIONALES[2]) == 0){
        insertarAtomo(q, q->size, '<' );
    }else if (strcmp(valor, RELACIONALES[3]) == 0){
        insertarAtomo(q, q->size, 'l' );
    }else if (strcmp(valor, RELACIONALES[4]) == 0){
        insertarAtomo(q, q->size, '>' );
    }else if (strcmp(valor, RELACIONALES[5]) == 0){
        insertarAtomo(q, q->size, 'g' );
    }
}

void muestraTablaAtomo(atomQueue *q , char *nombre) {
    printf("\n  -- -- -- -- -- %s -- -- -- -- -- \n", nombre);
    printf("\n\t Valor \n");

    Caracter * pointer = (Caracter*)malloc(sizeof(Caracter));
    pointer = q->head;

    while(pointer != NULL) {
        printf("\n\t %c", pointer->caracter);
        pointer = pointer->next;
    }

    printf("\n  -- -- -- -- -- -- -- -- -- -- -- -- -- \n");
    return;
}


%}

/* Definiciones de expresiones en lex */
space           [ ]
newline         [\n]
tab             [\t]

uppercase       [A-Z]
lowercase       [a-z]
digit           [0-9]
comment         \$\$(.*)

reservadas      Bul|Cadena|Cierto|Entero|Falso|Haz|Mientras|Para|Real|Si|Sino
especiales      \(|\)|\[|\]|,|;
identificador   {lowercase}(({uppercase}|{lowercase}){0,7})
asignacion      :=
relacionales    (\.(DIF|IGL|MN|MNI|MY|MYI)\.)
aritmeticos     \+|-|\*|\/|%
stringCte       (\"(.+)\")

entero          {digit}+
real            ({digit}+\.|\.{digit}+){digit}*
exp             ({real}|{entero})(e|E)(\+|-)?{entero}

%%
{comment}       {
                }
{reservadas}    {
                    fprintf(archSal, "reservadas ");
                    int len = sizeof(RESERVADAS) / sizeof(RESERVADAS[0]);
                    for (int i = 0; i < len; i++){
                         if (strcmp(yytext, RESERVADAS[i]) == 0){
                             insertaColaNum(tokenQ, 0, i);
                             fprintf(tokens, "(0,%d)\n", i);
                             insertarAtomoReservado(syntaxQ, yytext);

                         }
                     }
                }
{especiales}    {
                    fprintf(archSal, "especiales ");
                    int idx = insertaColaStr(espQ, espQ->size, yytext, 2);
                    insertaColaNum(tokenQ, 2, idx);
                    insertarAtomo(syntaxQ, syntaxQ->size, yytext[0] );
                }
{identificador} {
                    fprintf(archSal, "identificador "); 
                    int idx = insertaColaStr(identQ, identQ->size, yytext, 1);
                    insertaColaNum(tokenQ, 1, idx);
                    insertarAtomo(syntaxQ, syntaxQ->size, 'a' );

                }
{asignacion}    {
                    fprintf(archSal, "asignacion ");
                    insertaColaNum(tokenQ, 3, 0);
                    insertarAtomo(syntaxQ, syntaxQ->size, '=' );

                }
{relacionales}  {
                    fprintf(archSal, "relacionales");
                    int len = sizeof(RELACIONALES) / sizeof(RELACIONALES[0]);
                    for (int i = 0; i < len; i++){

                        if (strcmp(yytext, RELACIONALES[i]) == 0){
                            insertaColaNum(tokenQ, 4, i);
                            buscarAtomoRelacional(syntaxQ, yytext); 
                        }
                             
                    }
                }
{aritmeticos}   {
                    int len = sizeof(ARITMETICOS) / sizeof(ARITMETICOS[0]);
                    for (int i = 0; i < len; i++){
                        if (strcmp(yytext, ARITMETICOS[i]) == 0){
                             insertaColaNum(tokenQ, 5, i);
                             insertarAtomo(syntaxQ, syntaxQ->size, yytext[0] );
                        }

                    }
                }
{stringCte}     {
                    int idx = insertaColaStr(strQ, strQ->size, yytext, 6);
                    insertaColaNum(tokenQ, 6, idx);
                    insertarAtomo(syntaxQ, syntaxQ->size, 's' );
                }
{entero}        {           
                    fprintf(archSal, "entero "); 
                    int idx = insertaColaStr(entQ, entQ->size, yytext, 8);
                    insertaColaNum(tokenQ, 7, idx);
                    insertarAtomo(syntaxQ, syntaxQ->size, 'n' );
                }
{real}          {         
                    fprintf(archSal, "real "); 
                    int idx = insertaColaStr(floatQ, floatQ->size, yytext, 8);
                    insertaColaNum(tokenQ, 8, idx);
                    insertarAtomo(syntaxQ, syntaxQ->size, 'r' );
                }
{exp}           {       
                    fprintf(archSal, "centifico "); 
                    int idx = insertaColaStr(floatQ, floatQ->size, yytext, 7);
                    insertaColaNum(tokenQ, 8, idx);
                    insertarAtomo(syntaxQ, syntaxQ->size, 'r' );
                }
{space}         fprintf(archSal, " "); 
{newline}       fprintf(archSal, "\n"); lineCount++;
{tab}           fprintf(archSal, "\t");  
.               fprintf(archErr, "error lineCount %d {%s}", lineCount, yytext); //handleErr(yytext);
%%

int main(int argc, char *argv[]) {

    tokenQ = (intQueue*) malloc(sizeof(intQueue));
    identQ = (strQueue*) malloc(sizeof(strQueue));
    strQ = (strQueue*) malloc(sizeof(strQueue));
    floatQ = (strQueue*) malloc(sizeof(strQueue));
    espQ = (strQueue*) malloc(sizeof(strQueue));
    entQ = (strQueue*) malloc(sizeof(strQueue));
    syntaxQ = (atomQueue*) malloc(sizeof(atomQueue));

    yyin = fopen(argv[1],"r");
    archSal = fopen("salida.txt","w");
    archErr = fopen("errores.txt", "w");
    tokens = fopen("tokens.txt","w");


    initQueueInt(tokenQ);
    initQueueStr(identQ);
    initQueueStr(espQ);
    initQueueStr(strQ);
    initQueueStr(floatQ);
    initQueueStr(entQ);

    yylex();
    fclose(archSal);

    // muestraTablaInt(tokenQ);
    // muestraTablaStr(identQ, "idents");
    // muestraTablaStr(espQ, "espec");
    // muestraTablaStr(entQ, "enteros");
    // muestraTablaStr(floatQ, "floats");
    // muestraTablaStr(strQ, "strings");
    muestraTablaAtomo(syntaxQ, "Syntax");

    return 0;
}