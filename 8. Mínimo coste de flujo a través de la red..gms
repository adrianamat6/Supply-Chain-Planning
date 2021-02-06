
SETS
        i nodos /i1*i7/
;


ALIAS(i,j,k)
;

SET
        R(i,j) conexiones entre nodos
                /i1.(i2,i3),
                 i2.(i4,i7),
                 i3.(i4,i5),
                 i4.(i5,i6),
                 i5.(i6,i7),
                 i6.i7 /

;

display R


TABLE  Coste(i,j)

     i1    i2     i3     i4      i5     i6     i7
i1         12     15
i2                       9                      8
i3                       7        6
i4                                8      4
i5                                       5      3
i6                                             11
i7                                                     ;


PARAMETERS

       Ent(i)  Entrada al nodo i desde el exterior
       Sal(i)  Salida desde el nodo i hacia el exterior    / i6  20,
                                                             i7  30 /
;

   Ent('i1') = 50 ;


POSITIVE VARIABLES
        x(i,j)   cantidad transportada desde el nodo i al j
;

VARIABLE
       MinCoste  variable asociada a la func. objetivo
;

EQUATIONS
       BalMat(i) ecuaciones del balance de materia
       FunObj funcion objetivo
;

       FunObj.. MinCoste =E= Sum((i,j), x(i,j) * Coste(i,j) )
;

       BalMat(i).. Sal(i) + sum(j$(R(i,j)), x(i,j) ) =E= Ent(i)
                          + sum(k$R(k,i), x(k,i))
;

* Importante los indices se corren R(i,j) <---> R(k,i)   asi se indica que
*es en el sentido contrario



MODEL Flujo_red /all/
;

SOLVE Flujo_red using LP minimizing MinCoste
;

$ontext
El flujo optimo a través de la red es de:

i1.i2      .       50.000
i2.i4      .       20.000
i2.i7      .       30.000
i4.i6      .       20.000

lo cual supondría un coste de:

1100.000

$offtext



