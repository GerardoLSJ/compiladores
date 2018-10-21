//-- Funciones de cada NT para el analizador sintáctico
G(){
	if (c == '['){
		c = getchar();
		Z();

		if (c == ']'){
			c = getchar();
			return;
		}
		else
			error();
	}
	else
		error();
}

Z(){
	if (c == 'b' || c == 'c' || c == 'e' || c == 'd'){
		D();
		Z();
		return;
	}

	else if (c == ']'){
		return;

	else if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		Y();
		return;
	}

	else
		error();
}

Y(){
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		S();
		X();
		return;
	}
	
	else
		error();	
}

X(){
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		Y();
		return;
	}
	
	else if (c == ']')
		return;

	else
		error();		
}

D(){
	if (c == 'b' || c == 'c' || c == 'e' || c == 'd'){
		J();

		if (c == 'a'){
			c = getchar();
			return;
		}
		else
			error();

		V();
		return;
	}
	else
			error();	
}

J(){
	if (c == 'b'){
		c = getchar();
		return;
	}

	else if (c == 'c'){
		c = getchar();
		return;
	}

	else if (c == 'e'){
		c = getchar();
		return;
	}

	else if (c == 'd'){
		c = getchar();
		return;
	}

	else
		error();
}

V(){
	if (c == ','){
		c = getchar();

		if (c == 'a'){
			c = getchar();
			return;
		}
		else
			error();

		V();
		return;
	}

	else if (c == ';'){
		c = getchar();
		return;
	}

	else
		error();
}

S(){
	if (c == 'a'){
		A();

		if (c == ';'){
			c = getchar();
			return;
		}
		else
			error();

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
		error();
}

A(){
	if (c == 'a'){

		c = getchar();

		if (c == '='){
			c = getchar();
			return;
		}
		else
			error();
		
		K();
		return;
	}

	else
		error();
}

H(){
	if (c == 'h'){

		c = getchar();

		if (c == '['){
			c = getchar();
			return;
		}
		else
			error();
		
		Y();

		if (c == ']'){
			c = getchar();
			return;
		}
		else
			error();

		if (c == 'm'){
			c = getchar();
			return;
		}
		else
			error();

		if (c == '('){
			c = getchar();
			return;
		}
		else
			error();

		R();

		if (c == ')'){
			c = getchar();
			return;
		}
		else
			error();

		if (c == ';'){
			c = getchar();
			return;
		}
		else
			error();

		return;
	}

	else
		error();
}

M(){
	if (c == 'm'){
		
		c = getchar();

		if (c == '('){
			c = getchar();
			return;
		}
		else
			error();
		
		R();

		if (c == ')'){
			c = getchar();
			return;
		}
		else
			error();

		if (c == '['){
			c = getchar();
			return;
		}
		else
			error();

		Y();

		if (c == ']'){
			c = getchar();
			return;
		}
		else
			error();

		R();

		return;
	}

	else
		error();
}

P(){
	if (c == 'p'){

		c = getchar();

		if (c == '('){
			c = getchar();
			return;
		}
		else
			error();
		
		A();

		if (c == ';'){
			c = getchar();
			return;
		}
		else
			error();

		R();

		if (c == ';'){
			c = getchar();
			return;
		}
		else
			error();

		A();

		if (c == ')'){
			c = getchar();
			return;
		}
		else
			error();

		if (c == '['){
			c = getchar();
			return;
		}
		else
			error();

		Y();

		if (c == ']'){
			c = getchar();
			return;
		}
		else
			error();

		return;
	}

	else
		error();
}

I(){
	if (c == 'i'){
		
		c = getchar();

		if (c == '('){
			c = getchar();
			return;
		}
		else
			error();
		
		R();

		if (c == ')'){
			c = getchar();
			return;
		}
		else
			error();

		if (c == '['){
			c = getchar();
			return;
		}
		else
			error();

		Y();

		if (c == ']'){
			c = getchar();
			return;
		}
		else
			error();

		N();

		return;
	}

	else
		error();
}

N(){
	if (c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
		return;
	}

	else if (c == 'o'){
		
		c = getchar();

		if (c == '['){
			c = getchar();
			return;
		}
		else
			error();

		Y();

		if (c == ']'){
			c = getchar();
			return;
		}
		else
			error();

		return;

	else
		error();
}

K(){
	if (c == 's'){
		c = getchar();
		return;
	}

	else if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		E();
		return;
	}

	else if (c == 't'){
		c = getchar();
		return;

	else if (c == 'f'){
		c = getchar();
		return;

	else
		error();
}

R(){
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		E();
		Q();
		return;
	}

	else
		error();
}

Q(){
	if (c == '!' || c == 'q' || c == '<' || c == 'l' || c == '>' || c == 'g'){
		O();
		E();
		return;
	}

	else if (c == ')' || c == ';')
		return;

	else
		error();
}

O(){
	if (c == '!'){
		c = getchar();
		return;
	}

	else if (c == 'q'){
		c = getchar();
		return;

	else if (c == '<'){
		c = getchar();
		return;

	else if (c == 'l'){
		c = getchar();
		return;

	else if (c == '>'){
		c = getchar();
		return;

	else if (c == 'g'){
		c = getchar();
		return;

	else
		error();
}

E(){
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		T();
		EP();
		return;
	}

	else
		error();
}

EP(){
	if (c == '+'){
		c = getchar();		
		T();
		EP();
		return;
	}

	else if (c == '-'){
		c = getchar();		
		T();
		EP();
		return;
	}

	else if (c == ')' || c == ';' ||c == '!' || c == 'q' || c == '<' || c == 'l' || c == '>' || c == 'g')
		return;

	else
		error();
}

T(){
	if (c == '(' || c == 'a' || c == 'n' || c == 'r'){
		F();
		TP();
		return;
	}

	else
		error();
}

TP(){
	if (c == '*'){
		c = getchar();		
		F();
		TP();
		return;
	}

	else if (c == '/'){
		c = getchar();		
		F();
		TP();
		return;
	}

	else if (c == '%'){
		c = getchar();		
		F();
		TP();
		return;
	}

	else if (c == '+' || c == '-' || c == ')' || c == ';' ||c == '!' || c == 'q' || c == '<' || c == 'l' || c == '>' || c == 'g')
		return;

	else
		error();
}

F(){
	if (c == '('){
		c = getchar();
		E();

		if (c == ')'){
			c = getchar();
			return;
		}
		else
			error();

		return;
	}

	else if (c == 'a'){
		c = getchar();
		return;
	}

	else if (c == 'n'){
		c = getchar();
		return;

	else if (c == 'r'){
		c = getchar();
		return;

	else
		error();
}