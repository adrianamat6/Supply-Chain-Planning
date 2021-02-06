
SETS
i nodos /i1*i11/ ;

ALIAS(i,j) ;

SET
R(i,j) /
i1. (   i2,    i4 ),
i2. (i1,    i3 ),
i3. (   i2,            i6),
i4. (             i5,      i7) ,
i5. (   i2,   i4,      i6),
i6. (       i3,   i5,           i8),
i7. (                               i9),
i8. (                  i6,                   i11),
i9. (                                   i10),
i10.(                               i9,      i11),
i11.(                            i8,    i10)
/


IN(i) /i1/
OUT(i) /i11/ ;


display R ;


TABLE DISTANCIA(i,j)
     i1   i2  i3   i4   i5   i6   i7   i8   i9   i10   i11
i1        16        5
i2   12       13
i3        11                 15
i4                       9         8
i5        7       11         8
i6             8       10             12
i7                                           9
i8                           14                          11
i9                                                 6
i10                                          6            5
i11                                     7          5                ;



POSITIVE VARIABLES
x(i,j)  cantidad transportada desde nodo i a j ;

VARIABLES
Z ;

EQUATIONS
FOBJ
LLEGA
SALE
BALANCE_NODOS;

FOBJ..
         z =E= sum((i,j)$R(i,j), DISTANCIA(i,j) * x(i,j) )
;


SALE(i)$IN(i)..
         sum(j$R(i,j), x(i,j) ) =E= 1
;

LLEGA(i)$OUT(i)..
         sum(j$R(j,i), x(j,i) ) =E= 1
;

BALANCE_NODOS(i)$(NOT IN(i) AND NOT OUT(i))..
         sum(j$R(i,j), x(i,j) ) =E= sum(j$R(j,i), x(j,i) )
;

MODEL Camino_mas_corto /all/ ;

SOLVE   Camino_mas_corto using LP minimizing z ;

$ontext
El camino más corto del nodo i1 al nodo i11 viene dado por:
i1 .i4       .        1.000
i4 .i7       .        1.000
i7 .i9       .        1.000
i9 .i10      .        1.000
i10.i11      .        1.000

$offtext



