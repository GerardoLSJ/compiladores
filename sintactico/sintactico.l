%{
/*  Autor: López Santibáñez Jiménez Luis Gerardo
           Robles Uribe Karen Abril

    Compiladores, grupo 2
    
    Analizador léxico - sintactico creado con ANSI C y lex.
*/     
#include <string.h>
#include <stdlib.h>

/* ------------------------- Estructuras ------------------------- */
typedef struct Cadena{
    int  posicion;
    char *cadena;
	char *tipo;

    struct Cadena * prev;
    struct Cadena * next;
}Cadena;

typedef struct Numero{
    int clase;
    int valor;
	char *tipo;

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
FILE *salida;
FILE *archErr;
FILE *tokens;
FILE *errSintactico;

intQueue * tokenQ;
strQueue * identQ;
strQueue * strQ;
strQueue * floatQ;
strQueue * entQ;
strQueue * espQ;
strQueue * simbolosQ;
atomQueue * syntaxQ;

Numero * tokenP;
char *curr;
int lineCount = 0;
char c = '0';

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


// Declaracion de las funciones para el analizador sintactico
void G();
void Z();
void Y();
void X();
void D();
void J();
void T();
void V();
void S();
void H();
void M();
void P();
void I();
void N();
void K();
void Q();
void O();
void E();
void EP();
void TP();
void F();
void R();
void A();



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
void insertaColaNum(intQueue *q, int clase, int valor, char *tipo) {
    Numero * item = (Numero*)malloc(sizeof(Numero));
    
    item->valor = valor;
    item->clase = clase;
	item->tipo = (char *)calloc(strlen(tipo),sizeof(char));
	strcpy(item->tipo, tipo);
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
    printf("\n\t Clase\t\t Valor \t\tTipo \n");

    Numero * pointer = (Numero*)malloc(sizeof(Numero));
    pointer = q->head;

    while(pointer != NULL) {
        printf("\n\t %d\t\t%d \t\t%s", pointer->clase, pointer->valor, pointer->tipo);
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


/* ---------------------------------------- SINTACTICO ---------------------------------------- */
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

void insertarAtomoReservado(atomQueue *q, char *valor) {

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

void buscarAtomoRelacional(atomQueue *q, char *valor) {

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
    //printf("\n  -- -- -- -- -- %s -- -- -- -- -- \n", nombre);
    printf("\n-- -- -- -- -- Cadena de atomos -- -- -- -- -- \n");

    Caracter * pointer = (Caracter*)malloc(sizeof(Caracter));
    pointer = q->head;

    while (pointer != NULL) {
        printf("%c" , pointer->caracter);
        pointer = pointer->next;
    }

    printf("\n  -- -- -- -- -- -- -- -- -- -- -- -- -- \n");
    return;
}

char getCharFromQ() {
    if (syntaxQ->head != NULL) {
        char AUX = syntaxQ->head->caracter;

        if(syntaxQ->head->next != NULL){
            syntaxQ->head = syntaxQ->head->next;
        }
        else
            syntaxQ->head = NULL;
        
        c = AUX; // VARIABLE GLOBAL C

        return AUX;
    }
    else {
        printf(" \n :: COLA VACIA, TERMINO LA DE EJECUTARSE EL ANALISIS SINTACTICO :: \n\n");
        c = '0';
        return '0';
    }
}

//-- Funciones de cada NT para el analizador sintáctico
void error(char val, char *atomo) {
    printf("\n Error en atomo %s(), valor ingresado: \"%c\" \n", atomo,val);
	fprintf(errSintactico, "\n Error en atomo %s(), valor ingresado: \"%c\" ", atomo,val);
}

void analisisSintactico(intQueue *q) {
    printf(":: Inicio de analizador sintactico :: \n\n");

	tokenP = (Numero*)malloc(sizeof(Numero));
	printf("malloc %d", q->head->valor);
    tokenP = tokenQ->head;  // A Q U I 
	
	printf("\n tokenP: %d", tokenP->clase);

    getCharFromQ(); // INIT
    G();
}


// **************************************************************************************************

/*
    Funciones de cada NT para el analizador sintáctico
*/

/* analisis semantico */

//nextAtrib

int nextAtr(){
	tokenP = tokenP->next;
	curr = (char *)calloc(strlen(tokenP->tipo),sizeof(char));
	strcpy(curr,tokenP->tipo);
	printf("\n curr: %s", curr);
	return 0;
}


//TChar()
int TChar(){
	fprintf(salida,"%s", curr);
	return 0;
}

int TRes(){
return 0;
}
//avt
int AddValTrans(){
return 0;
}

//TP
int TSim(){
return 0;
}
//TS
int TStr(){
return 0;
}

int TRel(){
return 0;
}


//Funciones
void G(){
	//printf("\n G() %c",c);
	if (c == '['){

        TChar();

        fprintf (salida, "\n\t");
		
        c = getCharFromQ();
        nextAtr();
		Z();

		if (c == ']'){
            fprintf(salida, "\n\t");
            //TChar();

			c = getCharFromQ();
		}
		else
			error(c,"G");
	}
	else
		error(c,"G");
}

void Z(){
	//printf("\n Z() %c",c);

	if (c == 'b' || c == 'c' || c == 'e' || c == 'd'){
		D();
		Z();
		return;
	}
	
	else if (c == ']'){
		return;
	}
	
	else if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		Y();
		return;
	}

	else
		error(c,"Z");
}

void Y(){
	//printf("\n Y() %c",c);
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		S();
		X();
		return;
	}

	else
		error(c,"Y");	
}

void X(){
	//printf("\n X() %c",c);
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		Y();
		return;
	}

	else if (c == ']')
		return;

	else
		error(c,"X");		
}

//Funciones
//Argumentos
void D(int t, int p){
	//printf("\n D() %c",c);
	if (c == 'b' || c == 'c' || c == 'e' || c == 'd'){
		J();

		if (c == 'a'){
            //AVT(t,p);
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"D");

		V(t);
		return;
	}

	else
		error(c,"D");	
}

//Funciones
//Argumentos
void J(){
	//printf("\n J() %c",c);
	if (c == 'b'){
        //TR();
        //int p;
        //int t;
        ////t = convertToInt(atr);

		c = getCharFromQ();
        //nextAtr();
        ////p = convertToInt(atr);

		return;
	}

	else if (c == 'c'){
		//TR();
        //int p;
        //int t;
        //t = convertToInt(atr);

		c = getCharFromQ();
        //nextAtr();
        //p = convertToInt(atr);

		return;
	}

	else if (c == 'e'){
		//TR();
        //int p;
        //int t;
        //t = convertToInt(atr);

		c = getCharFromQ();
        //nextAtr();
        //p = convertToInt(atr);

		return;
	}

	else if (c == 'd'){
		//TR();
        //int p;
        //int t;
        //t = convertToInt(atr);

		c = getCharFromQ();
        //nextAtr();
        //p = convertToInt(atr);

		return;
	}

	else
		error(c,"J");
}

//Funciones // int t
void V(){
	//printf("\n V() %c",c);
	if (c == ','){

        //TChar();
        //int p;
		c = getCharFromQ();
        //nextAtr();
        ////p = convertToInt(atr);

		if (c == 'a'){

            //AVT(t, p);

			c = getCharFromQ();

            //nextAtr();
			//return;
		}
		else
			error(c,"V");

		V();
		return;
	}

	else if (c == ';'){
        //TChar();
        fprintf(salida, "\n\t");

		c = getCharFromQ();

        //nextAtr();

		return;
	}

	else
		error(c,"V");
}

//No pusieron los return para h, m, p...
//Funciones
void S(){
	//printf("\n S() %c",c);
	if (c == 'a'){
		A();

		if (c == ';'){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
            nextAtr();
		}

		else
			error(c,"S");

		return;
	}

	else if (c == 'h'){
		H();
		return;
	}

	else if (c == 'm'){
		M();
		return;
	}

	else if (c == 'p'){
		P();
		return;
	}

	else if (c == 'i'){
		I();
		return;
	}

	else
		error(c,"S");
}

//Funciones
void A(){
	//printf("\n A() %c",c);
	if (c == 'a'){

        //TP();
		c = getCharFromQ();
        //nextAtr();

		if (c == '='){
            //TChar();
			c = getCharFromQ();
            //nextAtr();
		}
		else
			error(c,"A");
		
		K();
		return;
	}

	else
		error(c,"A");
}

//Funciones
void H(){
	//printf("\n H() %c",c);
	if (c == 'h'){

        //TR();
		c = getCharFromQ();
        //nextAtr();

		if (c == '['){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
            //nextAtr();
		}
		else
			error(c,"H");
		
		Y();
        fprintf(salida, "\n\t");

		if (c == ']'){
            //TChar();
			c = getCharFromQ();
            //nextAtr();
		}
		else
			error(c,"H");

		if (c == 'm'){
            //TR();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"H");

		if (c == '('){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"H");

		R();

		if (c == ')'){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"H");

		if (c == ';'){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
            fprintf(salida, "\n\t");
		}
		else
			error(c,"H");

		return;
	}

	else
		error(c,"H");
}

//Funciones
//Error al final?
void M(){
	//printf("\n M() %c",c);
	if (c == 'm'){
		
        //TR();
		c = getCharFromQ();
        //nextAtr();

		if (c == '('){
            TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"M");
		
		R();

		if (c == ')'){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"M");

		if (c == '['){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"M");

		Y();
        fprintf(salida, "\n\t");

		if (c == ']'){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"M");

		//R(); //Creo que esta no va...
		return;
	}

	else
		error(c,"M");
}

//Funciones
void P(){
	//printf("\n P() %c",c);
	if (c == 'p'){

        //TR();
		c = getCharFromQ();
        //nextAtr();

		if (c == '('){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"R");
		
		A();

		if (c == ';'){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"R");

		R();

		if (c == ';'){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"R");

		A();

		if (c == ')'){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"R");

		if (c == '['){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"R");

		Y();

		if (c == ']'){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
            //nextAtr();
			return;
		}
		else
			error(c,"R");

		return;
	}

	else
		error(c,"R");
}

//Funciones
void I(){
	//printf("\n I() %c",c);
	if (c == 'i'){
		
        //TR();
		c = getCharFromQ();
        //nextAtr();

		if (c == '('){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"I");
		
		R();

		if (c == ')'){
            //TChar();
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"I");

		if (c == '['){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"I");

		Y();
        fprintf(salida, "\n\t");        

		if (c == ']'){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"I");

		N();

		return;
	}

	else
		error(c,"I");
}

//Funciones
void N(){
	//printf("\n N() %c",c);
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i' || c ==  ']'){
		return;
	}

	else if (c == 'o'){
		
        //TR();
		c = getCharFromQ();
        //nextAtr();

		if (c == '['){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
			//nextAtr();
		}
		else
			error(c,"N");

		Y();
        fprintf(salida, "\n\t");

		if (c == ']'){
            //TChar();
            fprintf(salida, "\n\t");
			c = getCharFromQ();
            ///nextAtr();
			return;
		}
		else
			error(c,"N");
		
		return;	
	}
	
	else
		error(c,"N");
}

//Modificar
void K(){
	//printf("\n K() %c",c);
	if (c == 's'){
		c = getCharFromQ();
		return;
	}

	else if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		E();
		return;
	}

	else if (c == 't'){
		c = getCharFromQ();
		return;
	}

	else if (c == 'f'){
		c = getCharFromQ();
		return;
	}

	else
		error(c,"K");
}

void R(){
	//printf("\n R() %c",c);
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		E();
		Q();
		return;
	}

	else
		error(c,"R");
}

void Q(){
	//printf("\n O() %c",c);
	if (c == '!' || c == 'q' || c == '<' || c == 'l' || c == '>' || c == 'g'){
		O();
		E();
		return;
	}

	else if (c == ')' || c == ';')
		return;

	else
		error(c,"Q");
}

//Funciones
void O(){
	//printf("\n O() %c",c);
	if (c == '!'){
        //TOR();
		c = getCharFromQ();
        //nextAtr();
		return;
	}

	else if (c == 'q'){
		//TOR();
		c = getCharFromQ();
        //nextAtr();
		return;
	}

	else if (c == '<'){
		//TOR();
		c = getCharFromQ();
        //nextAtr();
		return;
	}

	else if (c == 'l'){
		//TOR();
		c = getCharFromQ();
        //nextAtr();
		return;
	}
	
	else if (c == '>'){
		//TOR();
		c = getCharFromQ();
        //nextAtr();
		return;
	}
	
	else if (c == 'g'){
		//TOR();
		c = getCharFromQ();
        //nextAtr();
		return;
	}
	
	else
		error(c,"O");
}

void E(){
	//printf("\n O() %c",c);
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		T();
		EP();
		return;
	}

	else
		error(c,"E");
}

//Funciones
void EP(){
	//printf("E\n P() %c",c);
	if (c == '+'){
        //TChar();
		c = getCharFromQ();
        //nextAtr();
		T();
		EP();
		return;
	}

	else if (c == '-'){
        //TChar();
		c = getCharFromQ();		
        //nextAtr();
		T();
		EP();
		return;
	}

	else if (c == ')' || c == ';' ||c == '!' || c == 'q' || c == '<' || c == 'l' || c == '>' || c == 'g')
		return;

	else
		error(c,"EP");
}

void T(){
	//printf("\n T() %c",c);
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		F();
		TP();
		return;
	}

	else
		error(c,"T");
}

//Funciones
void TP(){
	//printf("T\n P() %c",c);
	if (c == '*'){
        //TChar();
		c = getCharFromQ();	
        //nextAtr();
		F();
		TP();
		return;
	}

	else if (c == '/'){
		//TChar();
		c = getCharFromQ();
        //nextAtr();	
		F();
		TP();
		return;
	}

	else if (c == '%'){
		//TChar();
		c = getCharFromQ();
        //nextAtr();	
		F();
		TP();
		return;
	}

	else if (c == '+' || c == '-' || c == ')' || c == ';' ||c == '!' || c == 'q' || c == '<' || c == 'l' || c == '>' || c == 'g'){
		return;
	}
	else
		error(c,"TP");
}

//Funciones
void F(){
	//printf("\n F() %c",c);
	if (c == '('){
		//TChar();
		c = getCharFromQ();		
        //nextAtr();
		E();

		if (c == ')'){
			//TChar();
            c = getCharFromQ();		
            //nextAtr();
		}
		else
			error(c,"F");

		return;
	}

	else if (c == 'a'){
        //TP();
		c = getCharFromQ();
        //nextAtr();
		return;
	}

	else if (c == 'n'){
        //TChar();
		c = getCharFromQ();
        //nextAtr();
		return;
	}

	else if (c == 'r'){
        //TChar();
		c = getCharFromQ();
        //nextAtr();
		return;
	}
	
	else
		error(c,"F");
}
// ANALISIS LEXICO END

// **************************************************************************************************


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
                             insertaColaNum(tokenQ, 0, i, RESERVADAS[i] );
                             fprintf(tokens, "(0,%d)\n", i);
                             insertarAtomoReservado(syntaxQ, yytext);

                         }
                     }
                }
{especiales}    {
                    fprintf(archSal, "especiales ");
                    int idx = insertaColaStr(espQ, espQ->size, yytext, 2);
                    insertaColaNum(tokenQ, 2, idx, yytext);
                    insertarAtomo(syntaxQ, syntaxQ->size, yytext[0] );
                }
{identificador} {
                    fprintf(archSal, "identificador "); 
                    int idx = insertaColaStr(identQ, identQ->size, yytext, 1);
                    insertaColaNum(tokenQ, 1, idx, yytext);
                    insertarAtomo(syntaxQ, syntaxQ->size, 'a' );

                }
{asignacion}    {
                    fprintf(archSal, "asignacion ");
                    insertaColaNum(tokenQ, 3, 0, "=");
                    insertarAtomo(syntaxQ, syntaxQ->size, '=' );

                }
{relacionales}  {
                    fprintf(archSal, "relacionales");
                    int len = sizeof(RELACIONALES) / sizeof(RELACIONALES[0]);
                    for (int i = 0; i < len; i++){

                        if (strcmp(yytext, RELACIONALES[i]) == 0){
                            insertaColaNum(tokenQ, 4, i, RELACIONALES[i]);
                            buscarAtomoRelacional(syntaxQ, yytext); 
                        }
                             
                    }
                }
{aritmeticos}   {
                    int len = sizeof(ARITMETICOS) / sizeof(ARITMETICOS[0]);
                    for (int i = 0; i < len; i++){
                        if (strcmp(yytext, ARITMETICOS[i]) == 0){
                             insertaColaNum(tokenQ, 5, i, ARITMETICOS[i]);
                             insertarAtomo(syntaxQ, syntaxQ->size, yytext[0] );
                        }

                    }
                }
{stringCte}     {
                    int idx = insertaColaStr(strQ, strQ->size, yytext, 6);
                    insertaColaNum(tokenQ, 6, idx, yytext);
                    insertarAtomo(syntaxQ, syntaxQ->size, 's' );
                }
{entero}        {           
                    fprintf(archSal, "entero "); 
                    int idx = insertaColaStr(entQ, entQ->size, yytext, 8);
                    insertaColaNum(tokenQ, 7, idx, yytext);
                    insertarAtomo(syntaxQ, syntaxQ->size, 'n' );
                }
{real}          {         
                    fprintf(archSal, "real "); 
                    int idx = insertaColaStr(floatQ, floatQ->size, yytext, 8);
                    insertaColaNum(tokenQ, 8, idx, yytext);
                    insertarAtomo(syntaxQ, syntaxQ->size, 'r' );
                }
{exp}           {       
                    fprintf(archSal, "centifico "); 
                    int idx = insertaColaStr(floatQ, floatQ->size, yytext, 7);
                    insertaColaNum(tokenQ, 8, idx, yytext);
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
	salida = fopen("traduccion.txt","w");
    archErr = fopen("errores.txt", "w");
    tokens = fopen("tokens.txt","w");
    errSintactico = fopen("syntaxErrors.txt","w");

    initQueueInt(tokenQ);
    initQueueStr(identQ);
    initQueueStr(espQ);
    initQueueStr(strQ);
    initQueueStr(floatQ);
    initQueueStr(entQ);

    yylex();
    fclose(archSal);
	fclose(salida);

    muestraTablaInt(tokenQ);
    muestraTablaStr(identQ, "idents");
    muestraTablaStr(espQ, "espec");
    muestraTablaStr(entQ, "enteros");
    muestraTablaStr(floatQ, "floats");
    muestraTablaStr(strQ, "strings");
    muestraTablaAtomo(syntaxQ, "Syntax");

    analisisSintactico(tokenQ);

    return 0;
}