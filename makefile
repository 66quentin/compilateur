exo: exo.tab.c lex.yy.c
	gcc exo.tab.c lex.yy.c -o exo -lm

exo.tab.c:exo.y
	bison -d exo.y
	
lex.yy.c:exo.l
	flex exo.l
	
clean:
	rm exo.tab.c exo.tab.h lex.yy.c exo



