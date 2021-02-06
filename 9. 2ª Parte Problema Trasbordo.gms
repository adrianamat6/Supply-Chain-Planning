$TITLE 2ª Parte Problema de transbordo

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

* IMPORTANTE, Ajustamos los valores de producción a la demanda.
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
SOLUCIÓN 1

Para una producción en Memphis de 105 y en Denver de 155:

z = 6420.000 y el transporte se realiza según:

Memphis.NY           .      105.000
Denver .LA           .       25.000
Denver .Boston       .      130.000
NY     .LA           .      105.000

----------------------------------------------------------------------------
SOLUCIÓN 2

Sin embargo, si se cambia los valores de producción a  100 en Memphis y
160 en Denver. El coste es de z= 6430.000   con los siguientes trasbordos

Memphis.NY           .      100.000
Denver .LA           .       30.000
Denver .Boston       .      130.000
NY     .LA           .      100.000

---------------------------------------------------------------------------
SOLUCIÓN 3

Si equiparamos la producción en ambos sitios: 130 y 130
Memphis.NY           .      130.000
Denver .Boston       .      130.000
NY     .LA           .      130.000

z = 6370.000
---------------------------------------------------------------------------
SOLUCIÓN 4

Por último, si se producción la cantidad de 260 entre las dos fábricas distri-
buyendo la producción en cada fábrica en la capacidad relativa de su producción.
Esto es:

%Producción Memphis = 150/350 = 0.428571
%Producción Denver =  200/350 = 0.571428


Producción Memphis = 0.428571 * 90 = 39  unidades
Producción Denver  = 0.571428 * 90 = 51  unidades


Unidades a produccir en Memphis = 150 - 39 = 111 unidades
Unidades a produccir en Denver  = 200 - 51 = 149 unidades

Total producido = Demanda = 111 + 149 = 260




La solución del problema es:   z = 6408.000

Memphis.NY           .      111.000
Denver .LA           .       19.000
Denver .Boston       .      130.000
NY     .LA           .      111.000


$offtext



