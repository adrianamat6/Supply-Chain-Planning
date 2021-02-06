
SETS
i nodos /i1*i8/

ALIAS(i,j)


SETS
R(i,j) /
i1.( i2,  i3, i4,                 i8),
i2.(          i4),
i3.(          i4,  i5,      i7),
i4.(i2,            i5, i6 ),
i5.(          i4,           i7),
i6.(          i4,           i7,  i8),
i7.(               i5, i6,       i8),
i8.(                        i7)
/

E(i) /i1/
S(i) /i8/
;

TABLE CAPACIDAD(i,j)
    i1  i2   i3   i4   i5   i6   i7   i8
i1       7    5   12                  15
i2                11
i3                 6    4         5
i4  10                  7   21
i5                 7              6
i6                 21            15   25
i7                      7   15        18
i8                               25              ;


VARIABLES
Z ;

POSITIVE VARIABLES
x(i,j), FiIN(i), FiOUT(i) ;

EQUATIONS
FOBJ
BALANCE
REST_CAPACIDAD
;

FOBJ..
            z=E= sum(i$E(i), FiIN(i) )
;

BALANCE(i)..
         sum(j$R(i,j), x(i,j) ) + FiOUT(i) =E= sum(j$R(j,i), x(j,i) )  + FiIN(i)
;

REST_CAPACIDAD(i,j)..
         x(i,j) =L=  CAPACIDAD(i,j)
;


MODEL Flujo_maximo /all/ ;

FiIN.fx(i)$( NOT E(i) ) = 0 ;
FiOUT.fx(i)$( NOT S(i) ) = 0 ;


SOLVE Flujo_maximo using LP maximazing z ;


$ontext
El flujo máximo de personas que atravesaría los nodos sería:
i1.i2      .        7.000
i1.i3      .        5.000
i1.i4      .       12.000
i1.i8      .       15.000
i2.i4      .        7.000
i3.i7      .        5.000
i4.i5      .        6.000
i4.i6      .       13.000
i5.i7      .        6.000
i6.i8      .       25.000
i7.i6      .       12.000
i8.i7      .        1.000

con un flujo total máximo de 39.000

$offtext
