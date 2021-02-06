
SETS
i zonas a cubrir /z1*z12/

ALIAS(i,j)
* j son las posibles localizaciones de las estaciones de bomberos

display i, j ;


SETS
A(i,j) zonas adyacente
/z1.(z1, z2, z3,     z5) ,
 z2.(z1, z2,         z5 ) ,
 z3.(z1,     z3, z4, z5, z6, z7) ,
 z4.(        z3, z4, z5, z6,                   z11 ) ,
 z5.(z1, z2, z3, z4, z5,                  z10, z11 ) ,
 z6.(        z3, z4,     z6, z7, z8,           z11 ) ,
 z7.(z3,                     z7, z8,                z12 ) ,
 z8.(        z3,         z6, z7, z8, z9,       z11, z12 ) ,
 z9.(                            z8, z9, z10,  z11, z12 ) ,
z10.(                 z5,            z9, z10,  z11 ) ,
z11.(             z4, z5, z6,    z8, z9, z10,  z11 ) ,
z12.(                        z7, z8, z9 )
/ ;


BINARY VARIABLES
y(j)  ;

VARIABLES
z ;

EQUATIONS
FOBJ,
SERVICIO_ZONAS ;

FOBJ..
         z =E= sum(j, y(j) )
;

SERVICIO_ZONAS(i)..
         sum(j$A(i,j), y(j) ) =G= 1
;

MODEL coberturaConjuto /all/ ;

SOLVE  coberturaConjuto using MIP minimizing z ;

$ONTEXT
La solución del problema muestra como con instalar dos estaciones en las zonas
5 y 8 es suficiente para cubrir a todas las zonas restantes

$OFFTEXT
