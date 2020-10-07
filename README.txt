Compilateur réalisé par Quentin Guardia (qguardia66@gmail.com) grâce aux technologies Yacc et Flex.

Compilation de pseudo code vers le langage C.

Exemple de pseudo code: ex.txt

Compilation:
	make

Lancer la compilation: (nouveau fichier: Algorithme test.c)
	./exo < ex.txt
Le fichier généré se nomme par le nom donné à l'algorithme suivi de .c

Nettoyer:
	make clean

Grammaire utilisée: G={V,Σ,S,R} avec :
V={S, INSTR, OP, CODE, VAR, SUITEVARIABLE, SUITEVAR, role, debut, fin2, algo, affect, si, fsi, alors, sinon, operateur, variable, valeur, fonction, virgule} 
Σ={role, debut, fin2, algo, affect, si, fsi, alors, sinon, operateur, variable, valeur, fonction, virgule}
R={     S → algo role debut CODE fin2;
	CODE → INSTR CODE | si VAR comparaison VAR alors INSTR fsi CODE | si VAR comparaison VAR alors INSTR sinon INSTR fsi CODE | Ɛ;
	VAR → valeur | variable | fonction p1 VAR p2;
	SUITEVARIABLE → SUITEVARIABLE virgule variable | variable ;
	SUITEVAR → SUITEVAR virgule VAR | VAR ;
	INSTR → variable affect VAR OP | variable affect VAR | lecture p1 SUITEVARIABLE p2 | afficher p1 SUITEVAR p2 | Ɛ
	OP→ operateur VAR OP | operateur VAR;
}
