
SETS
t periodos /t1*t10/
;

ALIAS (t,tt)

PARAMETERS
f(t) coste fijo de producir en el periodo t
/
t1       10
t2       10
t3       12
t4       12
t5       14
t6       14
t7       12
t8       12
t9       10
t10      10
/


p(t)   Coste unitario de producción en período t
/
t1       0.1
t2       0.2
t3       0.3
t4       0.3
t5       0.4
t6       0.4
t7       0.2
t8       0.1
t9       0.4
t10      0.5
/


h(t) Coste unitario de almacenamiento en período t
/
t1       0.1
t2       0.1
t3       0.1
t4       0.1
t5       0.1
t6       0.1
t7       0.1
t8       0.1
t9       0.1
t10      0.1
/

d(t) Demanda en el período t.
/
t1       20
t2       25
t3       30
t4       35
t5       35
t6       20
t7       10
t8       10
t9       15
t10      20
/
;

SCALAR
Stock_t0 Stock en el periodo t= 0
/0/ ;

BINARY VARIABLES
y(t) ;

POSITIVE VARIABLES
x(t)
Stock(t)
;

VARIABLE
z ;

EQUATIONS
FOBJ,
DEMANDA,
BALANCE_MATERIA_T1
BALANCE_MATERIA_T_DISTINTO_1
;

FOBJ..
         Z =E= sum(t, f(t) * y(t) ) + sum(t, p(t) * x(t) ) +
               sum(t, h(t) * x (t) )
;

BALANCE_MATERIA_T1..
         Stock_t0 + x('t1') =E= d('t1') +  Stock('t1')
;

BALANCE_MATERIA_T_DISTINTO_1(t)$(ord(t)>1)..
         Stock(t-1) + x(t) =E= d(t) + Stock(t)
;

DEMANDA(t)..
         x(t) =L= sum(tt, d(tt)) * y(t)
;



MODEL Problema_Stock / all / ;

SOLVE  Problema_Stock using MIP minimizing z ;

$ontext
La solución del problema muestra como la mejor solución es producir todo en
t1 y despues ir vendiendo lo producido, lo cual estaría almacenado (stock)

x = 220.000 en t1
x = 0    para t distinto de t1


El stock evoluciona de la siguiente forma

t1       .      200.000
t2       .      175.000
t3       .      145.000
t4       .      110.000
t5       .       75.000
t6       .       55.000
t7       .       45.000
t8       .       35.000
t9       .       20.000
t10      .         .

El coste total es de 54.000

$offtext



