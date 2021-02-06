$TITLE 2� Parte Problema de transbordo

SETS
i nodos /Memphis, Denver,NY, Chicago, LA, Boston/   ;

ALIAS(i,j,k) ;


SET
R(i,j) /
Memphis.( NY, Chicago, LA, Boston),
Denver. ( NY, Chicago, LA, Boston),
NY.     (     Chicago, LA, Boston)
Chicago.( NY,          LA,Boston)
/ ;

PARAMETERS

* IMPORTANTE, Ajustamos los valores de producci�n a la demanda.
PRODUCCION(i)   /Memphis 111, Denver 149, NY 0 , Chicago 0 , LA 0   , Boston 0  /
CONSUMO(i)      /Memphis   0, Denver   0, NY 0 , Chicago 0 , LA 130 , Boston 130/   ;

TABLE COSTE(i,j)
         Memphis  Denver  NY    Chicago    LA     Boston
Memphis      0             8      13       25       28
Denver               0    15      12       26       25
NY                         0       6       16       17
Chicago                    6       0       14       16
LA                                          0
Boston                                               0

;

VARIABLE
Z;

POSITIVE VARIABLES
x(i,j)

EQUATIONS
FOBJ
BAL_MATERIA

;

FOBJ..
         z =E= sum((i,j)$R(i,j), x(i,j) * COSTE(i,j) )
;

BAL_MATERIA(i)..
         sum(j$R(i,j), x(i,j) ) + CONSUMO(i) =E=
         sum(j$R(j,i), x(j,i) ) + PRODUCCION(i)
;

MODEL Transbordo_3 /
                         FOBJ
                         BAL_MATERIA

                                 / ;




SOLVE Transbordo_3 using LP minimizing z ;

$ontext
SOLUCI�N 1

Para una producci�n en Memphis de 105 y en Denver de 155:

z = 6420.000 y el transporte se realiza seg�n:

Memphis.NY           .      105.000
Denver .LA           .       25.000
Denver .Boston       .      130.000
NY     .LA           .      105.000

----------------------------------------------------------------------------
SOLUCI�N 2

Sin embargo, si se cambia los valores de producci�n a  100 en Memphis y
160 en Denver. El coste es de z= 6430.000   con los siguientes trasbordos

Memphis.NY           .      100.000
Denver .LA           .       30.000
Denver .Boston       .      130.000
NY     .LA           .      100.000

---------------------------------------------------------------------------
SOLUCI�N 3

Si equiparamos la producci�n en ambos sitios: 130 y 130
Memphis.NY           .      130.000
Denver .Boston       .      130.000
NY     .LA           .      130.000

z = 6370.000
---------------------------------------------------------------------------
SOLUCI�N 4

Por �ltimo, si se producci�n la cantidad de 260 entre las dos f�bricas distri-
buyendo la producci�n en cada f�brica en la capacidad relativa de su producci�n.
Esto es:

%Producci�n Memphis = 150/350 = 0.428571
%Producci�n Denver =  200/350 = 0.571428


Producci�n Memphis = 0.428571 * 90 = 39  unidades
Producci�n Denver  = 0.571428 * 90 = 51  unidades


Unidades a produccir en Memphis = 150 - 39 = 111 unidades
Unidades a produccir en Denver  = 200 - 51 = 149 unidades

Total producido = Demanda = 111 + 149 = 260




La soluci�n del problema es:   z = 6408.000

Memphis.NY           .      111.000
Denver .LA           .       19.000
Denver .Boston       .      130.000
NY     .LA           .      111.000


$offtext



