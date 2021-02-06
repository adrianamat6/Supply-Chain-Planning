SETS
i productos producidos /A, B, C, D, E, F/
;

ALIAS (i,j)
;

SET Comb(i,j) Combinaciones posibles de ciclo de producción
/
A.(   B, C, D,    F),
B.(A,    C,    E),
C.(A, B,    D,    F),
D.(A,    C,    E),
E.(   B,    D,    F),
F.(A, B, C,    E   )
/
;

TABLE C(i,j)  Ganancias (€) del compuesto i seguido del j
    A     B    C     D    E     F
A        250  300   100        170
B  250        160        270   150
C  300   160        230        140
D  100        230        220
E        270        200        100
F  170   150  140        100
;


VARIABLES
z   funcion objetivo del problema
;

BINARY VARIABLES
y(i,j)    toma valor TRUE si sale de i y llega a j
;

EQUATIONS
FOBJ
SALE_PRODUCTO
LLEGA_PRODUCTO
;

FOBJ..
         Z =E= sum((i,j), C(i,j) * y(i,j) )
;

SALE_PRODUCTO(j)..
         sum(i$Comb(i,j), y(i,j) ) =E= 1
;

LLEGA_PRODUCTO(i)..
         sum(j$Comb(i,j), y(i,j) ) =E= 1
;


MODEL SecuenciaProduccion /all/
;

SOLVE SecuenciaProduccion  using MIP minimizing z
;


* Como se dan ciclos que no completan todo el camino (subtours) se introducen
* restricciones: "cut set constraint" o "subtour elimination constraints"


SETS
S1(j) /A, D/
S2(j) /B, C/
S3(j) /E, F/

;

PARAMETER
num1 , num2 , num3;

num1 = card(S1);
num2 = card(S2);
num3 = card(S3);




display num1, num2 , num3

;

EQUATIONS
CORTE_CICLO_1
CORTE_CICLO_2
CORTE_CICLO_3
;

* Se prueban los dos tipos de ecuaciones de corte.
* Se ha comprobado como se obtiene el mismo resultado con ambas

CORTE_CICLO_1..
         Sum((i,j)$(S1(i) AND NOT S1(j) AND Comb(i,j) ), y(i,j) ) =G=  1

*           SUM((i,j)$(S1(i) AND S1(j) AND Comb(i,j) ), y(i,j) ) =L= num1 - 1

;

CORTE_CICLO_2..
        Sum((i,j)$(S2(i) AND NOT S2(j) AND Comb(i,j)), y(i,j) ) =G=  1


*           SUM((i,j)$(S2(i) AND S2(j) AND Comb(i,j) ), y(i,j) ) =L= num2 - 1
;

CORTE_CICLO_3..
        Sum((i,j)$(S3(i) AND NOT S3(j) AND Comb(i,j)), y(i,j) ) =G=  1


*           SUM((i,j)$(S3(i) AND S3(j) AND Comb(i,j) ), y(i,j) ) =L= num3 - 1
;



MODEL SecuenciaProduccion_2 /
FOBJ
SALE_PRODUCTO
LLEGA_PRODUCTO
CORTE_CICLO_1
CORTE_CICLO_2
CORTE_CICLO_3

/
;

*OPTION miNLp = SBB;
SOLVE SecuenciaProduccion_2 using MIP minimizing z
;


$ontext

 Tras introducir las cinco ecuaciones de corte se obtiene el camino óptimo
    A--->B---->C---->F---->E-----D---->
    ^                                  |
    |---------------------------------<

$offtext