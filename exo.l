%{
#include "exo.tab.h"
%}

%option noyywrap
si si
alors alors
sinon sinon
fsi fsi
commentaire ^#.*
valeur  [+-]?([0-9]*[.])?[0-9]+
variable  [a-zA-Z]
operateur ["+""\\""-""*""^""%"]
comparaison "=="|"<="|">="|">"|"<"
p1 "("
p2 ")"
fonction "cos"|"sin"|"exp"|"sqrt"|"log"
affect "="
virgule ","
lecture lire
afficher afficher
algo Algorithme.*
role Role:.*
debut Debut
fin2 Fin
%%


{debut} return debut;
{algo} strcpy(yylval.TypeCaract,yytext);return algo;
{variable} strcpy(yylval.TypeCaract,yytext);return variable;
{valeur} strcpy(yylval.TypeCaract,yytext);return valeur;
{operateur} strcpy(yylval.TypeCaract,yytext);return operateur;
{comparaison} strcpy(yylval.TypeCaract,yytext);return comparaison;
{si} strcpy(yylval.TypeCaract,yytext);return si;
{sinon} strcpy(yylval.TypeCaract,yytext);return sinon;
{fsi} strcpy(yylval.TypeCaract,yytext);return fsi;
{role} strcpy(yylval.TypeCaract,yytext);return role;
{fin2} return fin2;
{virgule} return virgule;
{alors} strcpy(yylval.TypeCaract,yytext);return alors;
{lecture} strcpy(yylval.TypeCaract,yytext);return lecture;
{fonction} strcpy(yylval.TypeCaract,yytext);return fonction;
{affect} strcpy(yylval.TypeCaract,yytext);return affect;
{afficher} strcpy(yylval.TypeCaract,yytext);return afficher;
{p1} strcpy(yylval.TypeCaract,yytext);return p1;
{p2} strcpy(yylval.TypeCaract,yytext);return p2;
{commentaire} ;
\n ;
[ \t]          ;
.        strcpy(yylval.TypeCaract,yytext); return carinvalide;


%%
