
SETS
p personas /I, II, III/
t trabajos / Contable, DirectorVentas, RecursosHumanos/
;

TABLE Idoneidad(p,t)
     Contable   DirectorVentas   RecursosHumanos
I       11            5              2
II      15           12              8
III     10            1             10
;


VARIABLES
z;

BINARY VARIABLES
y(p,t)
;


EQUATIONS
FOBJ
ASIGNACION_TRABAJOS
ASIGNACION_TRABAJADORES
;

FOBJ..
         z =E= sum((p,t), Idoneidad(p,t) * y(p,t) )
;

ASIGNACION_TRABAJOS(t)..
         SUM(p, y(p,t) ) =E= 1
;

ASIGNACION_TRABAJADORES(p)..
         SUM(t, y(p,t) ) =E= 1
;


MODEL Asignacion /all/
;

SOLVE Asignacion using MIP maximazing z
;

$ONTEXT
La solución del problema es:
I  .Contable             .        1.000
II .DirectorVentas       .        1.000
III.RecursosHumanos      .        1.000

Con una idoneidad total  de 33.000

Viendo la idoniedad de los cadidatos en función del puesto parace una decisión
lógica. El candidato I y III se ajustan su puesto idoneo corresponde con el
aisgnado. Por su parte, el cadidato II presenta un muy alto grado de idoneidad.
Si el candidato II hubiera sido asignado al puesto I la idoniedad global sería
muchísimo menor porque el candidato I para el resto de los puestos presenta
mucha menos puntuación

$OFFTEXT







