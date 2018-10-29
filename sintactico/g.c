void G(){
	printf("\n G() %c",c);
	if (c == '['){
		c = getCharFromQ();
		Z();

		if (c == ']'){
			c = getCharFromQ();
		}
		else
			error(c,"G");
	}
	else
		error(c,"G");
}

void Z(){
	printf("\n Z() %c",c);

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
	printf("\n Y() %c",c);
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		S();
		X();
		return;
	}

	else
		error(c,"Y");	
}

void X(){
	printf("\n X() %c",c);
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		Y();
		return;
	}

	else if (c == ']')
		return;

	else
		error(c,"X");		
}

void D(){
	printf("\n D() %c",c);
	if (c == 'b' || c == 'c' || c == 'e' || c == 'd'){
		J();
        c = getCharFromQ();
		if (c == 'a'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"D");

		V();
		return;
	}else{
		error(c,"D");	
    }
    return;
}

void J(){
	printf("\n J() %c",c);
	if (c == 'b'){
		c = getCharFromQ();
		return;
	}

	else if (c == 'c'){
		c = getCharFromQ();
		return;
	}

	else if (c == 'e'){
		c = getCharFromQ();
		return;
	}

	else if (c == 'd'){
		c = getCharFromQ();
		return;
	}

	else
		error(c,"J");
}

void V(){
	printf("\n V() %c",c);
	if (c == ','){
		c = getCharFromQ();

		if (c == 'a'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"V");

		V();
		return;
	}

	else if (c == ';'){
		c = getCharFromQ();
		return;
	}

	else
		error(c,"V");
}

void S(){
	printf("\n S() %c",c);
	if (c == 'a'){
		A();

		if (c == ';'){
			c = getCharFromQ();
			//return;
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

void A(){
	printf("\n A() %c",c);
	if (c == 'a'){

		c = getCharFromQ();

		if (c == '='){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"A");
		
		K();
		return;
	}

	else
		error(c,"A");
}

void H(){
	printf("\n H() %c",c);
	if (c == 'h'){

		c = getCharFromQ();

		if (c == '['){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"H");
		
		Y();

		if (c == ']'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"H");

		if (c == 'm'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"H");

		if (c == '('){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"H");

		R();

		if (c == ')'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"H");

		if (c == ';'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"H");

		return;
	}

	else
		error(c,"H");
}

void M(){
	printf("\n M() %c",c);
	if (c == 'm'){
		
		c = getCharFromQ();

		if (c == '('){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"M");
		
		R();

		if (c == ')'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"M");

		if (c == '['){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"M");

		Y();

		if (c == ']'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"M");

		R();
		return;
	}

	else
		error(c,"M");
}

void P(){
	printf("\n P() %c",c);
	if (c == 'p'){

		c = getCharFromQ();

		if (c == '('){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"R");
		
		A();

		if (c == ';'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"R");

		R();

		if (c == ';'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"R");

		A();

		if (c == ')'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"R");

		if (c == '['){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"R");

		Y();

		if (c == ']'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"R");

		return;
	}

	else
		error(c,"R");
}

void I(){
	printf("\n I() %c",c);
	if (c == 'i'){
		
		c = getCharFromQ();

		if (c == '('){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"I");
		
		R();

		if (c == ')'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"I");

		if (c == '['){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"I");

		Y();

		if (c == ']'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"I");

		N();

		return;
	}

	else
		error(c,"I");
}

void N(){
	printf("\n N() %c",c);
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		return;
	}

	else if (c == 'o'){
		
		c = getCharFromQ();

		if (c == '['){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"N");

		Y();

		if (c == ']'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"N");
		
		return;	
	}
	
	else
		error(c,"N");
}

void K(){
	printf("\n K() %c",c);
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
	printf("\n R() %c",c);
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		E();
		Q();
		return;
	}

	else
		error(c,"R");
}

void Q(){
	printf("\n O() %c",c);
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

void O(){
	printf("\n O() %c",c);
	if (c == '!'){
		c = getCharFromQ();
		return;
	}

	else if (c == 'q'){
		c = getCharFromQ();
		return;
	}

	else if (c == '<'){
		c = getCharFromQ();
		return;
	}

	else if (c == 'l'){
		c = getCharFromQ();
		return;
	}
	
	else if (c == '>'){
		c = getCharFromQ();
		return;
	}
	
	else if (c == 'g'){
		c = getCharFromQ();
		return;
	}
	
	else
		error(c,"O");
}

void E(){
	printf("\n O() %c",c);
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		T();
		EP();
		return;
	}

	else
		error(c,"E");
}

void EP(){
	printf("E\n P() %c",c);
	if (c == '+'){
		c = getCharFromQ();		
		T();
		EP();
		return;
	}

	else if (c == '-'){
		c = getCharFromQ();		
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
	printf("\n T() %c",c);
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		F();
		TP();
		return;
	}

	else
		error(c,"T");
}

void TP(){
	printf("T\n P() %c",c);
	if (c == '*'){
		c = getCharFromQ();		
		F();
		TP();
		return;
	}

	else if (c == '/'){
		c = getCharFromQ();		
		F();
		TP();
		return;
	}

	else if (c == '%'){
		c = getCharFromQ();		
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

void F(){
	printf("\n F() %c",c);
	if (c == '('){
		c = getCharFromQ();
		E();

		if (c == ')'){
			c = getCharFromQ();
			//return;
		}
		else
			error(c,"F");

		return;
	}

	else if (c == 'a'){
		c = getCharFromQ();
		return;
	}

	else if (c == 'n'){
		c = getCharFromQ();
		return;
	}

	else if (c == 'r'){
		c = getCharFromQ();
		return;
	}
	
	else
		error(c,"F");
}