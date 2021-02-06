$TITLE Knapsack problem

SETS
O objetos / cofre, anillo, collar, espejo, brazaletes,
            sortija, frasco, diamante, copa, azafran /

PARAMETERS
Precio(o) precio (dinares)
 / cofre 50, anillo 5, collar 3, espejo 20 , brazaletes 16,
            sortija 5, frasco 1, diamante 30, copa 12, azafran 40 /

Volumen(o) volumen  (cm3)
/ cofre 1000, anillo 2, collar 10, espejo 500, brazaletes 15,
            sortija 3, frasco 100, diamante 5, copa 250, azafran 100 /

Peso(o) peso unidad (g)
/ cofre 2000, anillo 20, collar 300, espejo 1000, brazaletes 300,
            sortija 75, frasco 100, diamante 50, copa 500, azafran 100/

Numero(o) numero de unidades en la cueva
/ cofre 1, anillo 10, collar 1, espejo 1, brazaletes 15,
            sortija 1, frasco 1, diamante 1, copa 1, azafran 1/

;


VARIABLES
z ;

INTEGER VARIABLES
x(o) ;

EQUATIONS
FOBJ
UNIDADES
PESO_TOTAL
VOLUMEN_TOTAL

;


FOBJ..
         Z =E= Sum(o, Precio(o) * x(o)  )
;

UNIDADES(o)..
        x(o) =L= Numero(o)
;

PESO_TOTAL..
         sum(o, Peso(o) * x(o) ) =L= 2500
;

VOLUMEN_TOTAL..
         sum(o, Volumen(o) * x(o) ) =L= 2000
;




MODEL AliBaba /all/ ;

SOLVE AliBaba using MINLP maximazing z ;

$ontext
La solución óptima del problema es:
anillo          .       10.000
brazaletes      .        6.000
sortija         .        1.000
frasco          .        1.000
diamante        .        1.000
azafran         .        1.000


Con un z= 222.000

Evidentemente en la selección se han evitado objetos de grandes pesos y
dimensiones. 

$offtext





























