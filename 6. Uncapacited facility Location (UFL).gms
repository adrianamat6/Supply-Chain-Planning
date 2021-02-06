$TITLE    Uncapacited facility Location (UFL)

SETS
m mercados /Cataluna, Norte, Noroeste, Levante, Centro, Sur/
p plantas / Barcelona, Bilbao, Madrid, Valencia / ;

TABLE CosteTransp(p,m)
            Cataluna   Norte   Noroeste   Levante   Centro   Sur
Barcelona      10       62        110       35         62    100
Bilbao         62       10         63       63         40     83
Madrid         62       40         60       35          7     54
Valencia       35       63         96       10         35     67 ;

PARAMETERS
CAPACIDAD(p) "unidades/año" / Barcelona 1000, Bilbao 1000, Madrid 1000, Valencia 1000/
COSTEFIJO(p) "unidades/año" / Barcelona 100000, Bilbao 100000, Madrid 80000, Valencia 100000/
DEMANDA(m)  "unidades/año"  /Cataluna 480, Norte 356, Noroeste 251, Levante 349, Centro 598, Sur 326/
;

POSITIVE VARIABLES
x(p,m)  cantidad transportada desde planta p hasta mercado m

BINARY VARIABLE
y(p) si se selecciona la planta p
;

VARIABLE
Z  Func. obj asociado al coste total

EQUATIONS
FOBJ
REST_DEMANDA
REST_CAPACIDAD   ;

FOBJ..
         Z =E= SUM((m,p), x(p,m) *  CosteTransp(p,m) ) +
                 SUM(p, CosteFijo(p) * y(p) )
;

REST_DEMANDA(m)..
         sum(p, x(p,m) ) =G= DEMANDA(m)
;

REST_CAPACIDAD(p)..
         sum(m, x(p,m) ) =L= CAPACIDAD(p)  * y(p)
;

MODEL  Facility_Location  /ALL/ ;

SOLVE  Facility_Location using MIP minimizing z ;

$ontext

La zolución del problema es transportar las siguientes unidades:

Planta    Mercado              Cantidad
Barcelona.Cataluna      .      480.000
Barcelona.Levante       .      349.000
Bilbao   .Norte         .      356.000
Bilbao   .Noroeste      .      175.000
Madrid   .Noroeste      .       76.000
Madrid   .Centro        .      598.000
Madrid   .Sur           .      326.000

Lo cual supondría un coste de 3.3795E+5


Es importante recalcar en este problema se han tenido que utilizar variables
binarias, puesto que aparecia un coste fijo que había que eliminar en caso de
no seleccionar la planta. En los resultados se observa que la unica planta que
no se debe de construir es la de Valencia.


$offtext


