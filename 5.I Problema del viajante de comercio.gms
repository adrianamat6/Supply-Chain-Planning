SETS
i ciudades /A, B, C, D, E, F/
;

ALIAS (i,j)
;

SET Comb(i,j) Combinaciones posibles
/
A.(   B,    D,    F),
B.(A,    C, D, E),
C.(   B,    D, E, F),
D.(A, B, C,       F),
E.(B,    C,       F),
F.(A,    C, D, E   )
/
;

TABLE C(i,j)  distancias entre ciudades
    A   B    C    D    E     F
A   0   8         3          4
B   8   0    1    5    9
C       1    0    7    2     21
D   3   5    7    0          3
E       9    2         0     35
F   4        21   3    35    0
;


VARIABLES
z   funcion objetivo del problema
;

BINARY VARIABLES
y(i,j)    toma valor TRUE si sale de i y llega a j
;

EQUATIONS
FOBJ
SALE_CIUDADES
LLEGA_CIUDADES
;

FOBJ..
         Z =E= sum((i,j), C(i,j) * y(i,j) )
;

SALE_CIUDADES(j)..
         sum(i$Comb(i,j), y(i,j) ) =E= 1
;

LLEGA_CIUDADES(i)..
         sum(j$Comb(i,j), y(i,j) ) =E= 1
;


MODEL viajante /all/
;

SOLVE viajante  using MIP minimizing z
;



* Como se dan ciclos que no completan todo el camino (subtours) se introducen
* restricciones: "cut set constraint" o "subtour elimination constraints"

SETS
S1(j) /B, C, E/
S2(j) /A, D, F/

;

PARAMETER
num1 , num2 ;

num1 = card(S1);
num2 = card(S2)

;


display num1, num2

;

EQUATIONS
CORTE_CICLO_1
CORTE_CICLO_2
;

* Se prueban los dos tipos de ecuaciones de corte.
* Se ha comprobado como se obtiene el mismo resultado con ambas

CORTE_CICLO_1..
*         Sum((i,j)$(S1(i) AND NOT S1(j) AND Comb(i,j) ), y(i,j) ) =G=  1

           SUM((i,j)$(S1(i) AND S1(j) AND Comb(i,j) ), y(i,j) ) =L= num1 - 1

;

CORTE_CICLO_2..
*        Sum((i,j)$(S2(i) AND NOT S2(j) AND Comb(i,j)), y(i,j) ) =G=  1


           SUM((i,j)$(S2(i) AND S2(j) AND Comb(i,j) ), y(i,j) ) =L= num2 - 1
;


MODEL Viajante_2 /
FOBJ
SALE_CIUDADES
LLEGA_CIUDADES
CORTE_CICLO_1
CORTE_CICLO_2

/
;

*OPTION miNLp = SBB;
SOLVE Viajante_2 using MIP minimizing z
;


* Se hace necesario añadir nuevas restricciones

SETS
S3(j) /A, F/
S4(j) /B, D/
S5(j) /E, C/

PARAMETER
num3
num4
num5
;

num3 = card(S3) ;
num4 = card(S4) ;
num5 = card(S5) ;


EQUATIONS
CORTE_CICLO_3
CORTE_CICLO_4
CORTE_CICLO_5
;


*  Se comprueba que si se añaden las ecuaciones de "cut-set-contraint" para
*  CORTE_CICLO_3, CORTE_CICLO_4 y CORTE_CICLO_5 marcadas en comentario,
*  volverían a formarse nuevos ciclos que habria que eliminar con nuevas
*  ecuaciones. Sin embargo, con las ecuaciones "subtour elimination contraints"
*  nos evitamos tener que añadir todavía más restricciones.



CORTE_CICLO_3..
*         Sum((i,j)$(S3(i) AND NOT S3(j) AND Comb(i,j) ), y(i,j) ) =G=  1

           SUM((i,j)$(S3(i) AND S3(j) AND Comb(i,j) ), y(i,j) ) =L= num3 - 1
;

CORTE_CICLO_4..
*         Sum((i,j)$(S4(i) AND NOT S4(j) AND Comb(i,j) ), y(i,j) ) =G=  1

           SUM((i,j)$(S4(i) AND S4(j) AND Comb(i,j) ), y(i,j) ) =L= num4 - 1
;

CORTE_CICLO_5..
*         Sum((i,j)$(S5(i) AND NOT S3(j) AND Comb(i,j) ), y(i,j) ) =G=  1

           SUM((i,j)$(S5(i) AND S5(j) AND Comb(i,j) ), y(i,j) ) =L= num5 - 1
;


MODEL Viajante_3 /
FOBJ
SALE_CIUDADES
LLEGA_CIUDADES
CORTE_CICLO_1
CORTE_CICLO_2
CORTE_CICLO_3
CORTE_CICLO_4
CORTE_CICLO_5
/
;

*OPTION miNLp = SBB;
SOLVE Viajante_3 using MIP minimizing z
;

* Tras introducir las cinco ecuaciones de corte se obtiene el camino óptimo
*   A--->B---->E---->C---->D-----F----
*   ^                                  |
*   |---------------------------------
