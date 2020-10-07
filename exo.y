%{
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

typedef struct ligne {
	char texte[1000];
	char var;
} ligne;

ligne l[1000];
int indice=0,indice2=0;
char tab1[250],tab2[250],tab3[250],tab4[200];
char var2[100];

char message[1200];
char nom[1200];
int yyerror (const char*msg);
int yylex();
int suitevariable=0;



int recherche(char a){
	for (int i=0;i<indice2;i++){
		if(var2[i]==a)
			return 1;
	}
	return 0;
}
	
%}

%union
{
	char TypeCaract[1000];
}

%token <TypeCaract> carinvalide
%token <TypeCaract> role debut fin2 algo affect si fsi alors sinon operateur variable valeur fonction virgule
%token <TypeCaract> afficher lecture comparaison p1 p2
%type <TypeCaract> S INSTR OP CODE VAR SUITEVARIABLE SUITEVAR
%start S
%%
S :algo role debut CODE fin2  {
	sprintf(nom,"%s.c",$1);
	sprintf(l[indice].texte,"//%s\n",$2);
	indice++;
}
| carinvalide { sprintf(message, "chaine invalide : %s", $$); yyerror(message);}
;
CODE : INSTR CODE {
	sprintf(l[indice].texte,"%s",$1);
	indice++;
}
| si VAR comparaison VAR alors INSTR fsi CODE {
	sprintf(l[indice].texte,"if(%s%s%s){\n\t\t%s\t}\n",$2,$3,$4,$6);
	indice++;
}| si VAR comparaison VAR alors INSTR sinon INSTR fsi CODE {
	sprintf(l[indice].texte,"if(%s%s%s){\n\t\t%s\t}\n\telse{\n\t\t%s\t}\n",$2,$3,$4,$6,$8);
	indice++;
}
| {}
;
VAR : variable {}
| valeur {}
| fonction p1 VAR p2 { 
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$1);
	memset(tab2,0,sizeof(tab2));strcpy(tab2,$3);
	sprintf($$,"%s(%s)",tab1,tab2);
}
;

SUITEVARIABLE : SUITEVARIABLE virgule variable {
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$1);
	memset(tab2,0,sizeof(tab2));strcpy(tab2,$3);
	sprintf($$,"%s,&%s",tab1,tab2);
	suitevariable++;
}
| variable {}
;

SUITEVAR : SUITEVAR virgule VAR {
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$1);
	memset(tab2,0,sizeof(tab2));strcpy(tab2,$3);
	sprintf($$,"%s,%s",tab1,tab2);
	suitevariable++;
}
| VAR {}
;


INSTR: variable affect VAR OP {
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$1);
	memset(tab2,0,sizeof(tab2));strcpy(tab2,$2);
	memset(tab3,0,sizeof(tab3));strcpy(tab3,$3);
	memset(tab4,0,sizeof(tab4));strcpy(tab4,$4);
	sprintf($$,"%s%s%s%s;\n",tab1,tab2,tab3,tab4);
}
|variable affect VAR {
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$1);
	memset(tab2,0,sizeof(tab2));strcpy(tab2,$2);
	memset(tab3,0,sizeof(tab3));strcpy(tab3,$3);
	sprintf($$,"%s%s%s;\n",tab1,tab2,tab3);
}
| lecture p1 SUITEVARIABLE p2 {
	suitevariable++;
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$3);
	strcpy($$,"scanf(\"");
	while(suitevariable>0){
		strcat($$,"%d ");
		suitevariable--;
	}
	strcat($$,"\",&");
	strcat($$,tab1);
	strcat($$,");\n");
}
| afficher p1 SUITEVAR p2 {
	suitevariable++;
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$3);
	sprintf($$,"printf(\"%%d\\n\",%s);\n",tab1);
	strcpy($$,"printf(\"");
	while(suitevariable>0){
		strcat($$,"%d ");
		suitevariable--;
	}
	strcat($$,"\\n\",");
	strcat($$,tab1);
	strcat($$,");\n");
}
| {}
;

OP: operateur VAR OP {
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$1);
	memset(tab2,0,sizeof(tab2));strcpy(tab2,$2);
	memset(tab3,0,sizeof(tab3));strcpy(tab3,$3);
	sprintf($$,"%s%s%s",tab1,tab2,tab3);

}
| operateur VAR {
	memset(tab1,0,sizeof(tab1));strcpy(tab1,$1);
	memset(tab2,0,sizeof(tab2));strcpy(tab2,$2);
	sprintf($$,"%s%s",tab1,tab2);
}
;


%%
int yyerror (const char*msg){
	printf(" erreur: %s \n",msg);
	exit(0);
}
int main (void){
	
	FILE *f;
	f=fopen("tmp.txt","w");
	fprintf(f,"#include <stdio.h>\n#include <math.h>\n\nint main(void){\n");
	int precedent=0;
	yyparse();
	for(int i=indice-1;i>=0;i--){
		if(l[i].texte[1]=='='){
			if(!recherche(l[i].texte[0])){
				var2[indice2]=l[i].texte[0];
				indice2++;
				fprintf(f,"\tint %s",l[i].texte);
			}
			else{
				fprintf(f,"\t%s",l[i].texte);
			}
		}else{		
			fprintf(f,"\t%s",l[i].texte);
		}
				
	}

	fprintf(f,"\n\treturn 0;\n}\n");
		
	fclose(f);
	rename("tmp.txt", nom);
	
	return 0;
	
}
