$TITLE 1ª Parte Problema de transbordo

$ontext
Este documento está dividido en dos partes. En la primera se comprueba como se
obtiene soluciones infactibles y se razona por qué. En la segunda parte se
resuelve el problema

$offtext


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
PRODUCCION(i)   /Memphis 220, Denver 200, NY 0 , Chicago 0 , LA 0   , Boston 0  /
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


display R ;

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



MODEL Transbordo /
                         FOBJ
                         BAL_MATERIA

                                 / ;


SOLVE Transbordo using LP minimizing z ;



$ontext
Se tiene un problema INFEASIBLE. Desarrollamos las ecuaciones para ver que es lo
que está ocurriendo.


$offtext


EQUATIONS
BAL_MATERIA_Memphis
BAL_MATERIA_Denver
BAL_MATERIA_NY
BAL_MATERIA_Chicago
BAL_MATERIA_Boston
BAL_MATERIA_LA ;

BAL_MATERIA_Memphis..
         x('Memphis','NY') + x('Memphis','Chicago') +  x('Memphis','LA')
         +  x('Memphis','Boston') + CONSUMO('Memphis') =E=
*          x('NY','Memphis')
*         +  x('Chicago','Memphis') +  x('LA','Memphis')
*         +  x('Boston','Memphis') +
           PRODUCCION('Memphis')
;

BAL_MATERIA_Denver..
         x('Denver','NY') + x('Denver','Chicago') +  x('Denver','LA')
         +  x('Denver','Boston') + CONSUMO('Denver') =E=
*          x('NY','Denver')
*         +  x('Chicago','Denver') +  x('LA','Denver')
*         +  x('Boston','Denver') +
         PRODUCCION('Denver')
;

BAL_MATERIA_NY..
         + x('NY','Chicago') +  x('NY','LA')
         +  x('NY','Boston') + CONSUMO('NY') =E=
         +  x('Chicago','NY') +  x('Denver','NY')
         +  x('Memphis','NY') + PRODUCCION('NY')
;

BAL_MATERIA_Chicago..
         + x('Chicago','NY') +  x('Chicago','LA')
         +  x('Chicago','Boston') + CONSUMO('Chicago') =E=
         +  x('NY','Chicago') +  x('Denver','Chicago')
         +  x('Memphis','Chicago') + PRODUCCION('Chicago')
;

BAL_MATERIA_Boston..
          CONSUMO('Boston') =E=   x('Memphis', 'Boston')
         +  x('NY','Boston') + x('Denver','Boston')  + x('Chicago','Boston')
          + PRODUCCION('Boston')
;

BAL_MATERIA_LA..
          CONSUMO('LA') =E=    + x('Memphis', 'LA')
         +  x('NY','LA') + x('Denver','LA')  + x('Chicago','LA')
          + PRODUCCION('LA')
;


MODEL Transbordo_2 /
                         FOBJ
*                         BAL_MATERIA
                         BAL_MATERIA_Memphis
                         BAL_MATERIA_Denver
                         BAL_MATERIA_NY
                         BAL_MATERIA_Chicago
                         BAL_MATERIA_Boston
                         BAL_MATERIA_LA

                                 / ;




SOLVE Transbordo_2 using LP minimizing z ;

$ontext
Se vuelve a dar un problema INFEASIBLE.Este infeasible es debido a:

1)   La oferta total disponible. s=150+200 = 350
No coincide con la demanda total  d= 130+130 = 260

2) ejemplo los puntos de transbordo no tienen ni demanda ni oferta por si mismos.
Sin embargo, la oferta y demanda, debería de haber algún valor de tal forma que
solucion dek problema sea factible.

Ir a la segunda parte del documento  ----------------->



Nota: si la cantidad a transportar a los destinos finales no tuviera que ser una
exacta no se produciría este problema. Es decir, el problema de infactibilidad
también se puede solucionar introducciendo en el balance de materia un

         sum(j$R(i,j), x(i,j) ) + CONSUMO(i) =L=
         sum(j$R(j,i), x(j,i) ) + PRODUCCION(i)


$offtext
