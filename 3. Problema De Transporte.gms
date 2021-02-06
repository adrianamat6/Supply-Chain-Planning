SET
p plantas /Coruna, Tarragona, Cadiz, Bilbao /
m mercados /Alicante, Barcelona, Vitoria, Cordoba, Granada, Madrid
            Malaga, Murcia, Sevilla, Valencia, Valladolid, Zaragoza  /
;

TABLE Distancia(p,m)
            Alicante  Barcelona  Vitoria  Cordoba  Granada    Madrid
Coruna        1031       1118     549       995     1043        609
Tarragona      417         98     489       796      770        534
Cadiz          688       1284    1014       263      335        663
Bilbao         817        620      66       795      829        395
+           Malaga      Murcia  Sevilla  Valencia  Valladolid  Zaragoza
Coruna       1153        1010     947       961      445         833
Tarragona     899         402     949       251      598         231
Cadiz         265         613     125       808      714         988
Bilbao        939         796     933       633      280         324
;

display Distancia ;


PARAMETER
Demanda(m) /Alicante    272432,
            Barcelona  1505581,
            Vitoria     261527,
            Cordoba     309961,
            Granada     241471,
            Madrid     2881506,
            Malaga      528079,
            Murcia      349040,
            Sevilla     701927,
            Valencia    739412,
            Valladolid  319946,
            Zaragoza    603367

/ ;


POSITIVE VARIABLES
x(p,m) ;

VARIABLE
Z ;

SCALAR
CAPACIDAD Capacidad de producción /2179000/
;

EQUATIONS
FOBJ,
DEMANDA_MERCADOS,
PRODUCCION ;

FOBJ..
         Z =E= sum((p,m), Distancia(p,m) * x(p,m) )
;

DEMANDA_MERCADOS(m)..
         sum(p, x(p,m)) =G= Demanda(m)
;

PRODUCCION(p)..
         sum(m, x(p,m)) =L=  CAPACIDAD
;

MODEL Plan_Produccion / FOBJ,
                        DEMANDA_MERCADOS,
                        PRODUCCION
                                         / ;

SOLVE Plan_Produccion using LP minimizing z ;

display x.l;

$ONTEXT
Se obtiene la siguiente distribución de la producción:

                     Alicante           Barcelona             Vitoria             Cordoba             Granada        Madrid              Malaga              Murcia             Sevilla            Valencia        Valladolid        Zaragoza
Coruna                                                    1.857.303.000,0                                                                                                                                           319.946.000
Tarragona          223.910.000        1.505.581.000,0                                                                                                                                         449.509.000
Cadiz               48.522.000                                                  309.961.000        241.471.000                         528.079.000         349.040.000        701.927.000
Bilbao                                                     261.527.000                                             1.024.203.000                                                               289.903.000                           603.367.000
                    272432000          1505581000           261527000             309961000        241471000        2881506000          528079000           349040000        701927000        739412000             319946000         603367000


$OFFTEXT


* ======================================================================
* Resolvemos de nuevo el probleman considerando que pueden existir planta que
* produzca o no existir (mediante la introducción de variables discretas) :


POSITIVE VARIABLES
xInt(p,m) ;

BINARY VARIABLE
y(p)

EQUATIONS
FOBJ_INT,
DEMANDA_MERCADOS_INT,
PRODUCCION_INT ;

FOBJ_INT..
         Z =E= sum((p,m), Distancia(p,m) * xINT(p,m) )
;

DEMANDA_MERCADOS_INT(m)..
         sum(p, xInt(p,m)) =G= Demanda(m)
;

PRODUCCION_INT(p)..
         sum(m, xInt(p,m)) =L=  CAPACIDAD * y(p)
;


MODEL Plan_Produccion_INT / FOBJ_INT,
                        DEMANDA_MERCADOS_INT,
                        PRODUCCION_INT
                                         / ;


SOLVE Plan_Produccion_INT using MIP minimizing z ;



display xInt.l ;

$ontext
Se obtiene exactamente la misma capacidad de producción en este caso.
Esto es debido a que la capacidad de producción de las 4 plantas es justamente
la demanda del total de las ciudades. Sería interesante estudiar si se aumenta
la capacidad de producción de alguna de las plantas podría compensar la
producción que se produce en otra planta.
$offtext

* =======================================================================

PARAMETER
CAPACIDAD ;

CAPACIDAD = 4 * 2179000 ;


SOLVE Plan_Produccion_INT  using MIP minimizing z ;


display xInt.l ;

$ontext
Si se aumenta la capacidad de producción de las plantas por igual en un valor
muy elevado, se produce en todas las plantas, pero como existe capacidad de
producción suficiente, cada mercado está suministrado unicamente por una planta
(no existen varias plantas que suministren a un mismo mercado).

$offtext


CAPACIDAD = 2 * 2179000 ;


SOLVE Plan_Produccion_INT  using MIP minimizing z ;


display xInt.l ;

$ontext
Si se aumenta la capacidad de producción de las plantas por igual en un valor
muy elevado, se produce en todas las plantas, pero como existe capacidad de
producción suficiente, cada mercado está suministrado unicamente por una planta
(no existen varias plantas que suministren a un mismo mercado).

$offtext

* =======================================================================

