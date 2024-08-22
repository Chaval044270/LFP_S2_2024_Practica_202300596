# Manual Técnico
A continuación se presenta un manual con los modulos, tipos y subrutinas que contiene el programa.
## Modulo Cargar Inventario
El modulo Cargar inventario contiene la lista que almacena los datos de los inventarios que se utilizan en el programa y diferentes subrutinas capaces de cumplir ciertas funciones del programa.

``` Fortran
module CargarInventario
```
## Tipo inventario (lista inventario)
El tipo inventario, sirve para definir la lista donde se almacenaran los datos que se van almacenando en la lectura de archivos.
``` Fortran
type :: inventario
    character(len=12) :: nombre
    integer :: cantidad
    real :: precioUnitario
    character(len=100) :: ubicacion
end type inventario
```

La lista define una variable de tipo character que sirve para el nombre del equipo, una variable de tipo integer para la cantidad del equipo, una variable de tipo real, para el precio unitario del equipo y una variable de tipo character para la ubicación del equipo.

## Subrutinas
### Subrutina Crear Equipo
La subrutina Crear Equipo recibe como parametro el nombre del archivo "inventario.inv" para darle lectura al mismo y de esa forma extraer las lineas de comandos para ir agregando los distintos equipos a la lista de inventario.
```Fortran
subroutine crearEquipo(nombreDeArchivo)
```
### Subrutina Gestionar Inventario
La subrutina Gestionar Inventario recibe como parametro el nombre del archivo "movimientos.mov" para darle lectura al mismo y de esa forma extraer las lineas de comandos para ir agregando o eliminado cierta cantidad de un determinado equipo, en una determinada ubicación.
```Fortran
subroutine gestionarInventario(nombreDeArchivo)
```
Cabe aclarar que si un determinado equipo, no se encuentra en una ubicación, la subrutina imprimirá un mensaje de error. Esto tambien sucede cuando se elimina una cantidad de equipo mayor a la que se encuentra en la lista de inventario.
### Subrutina Crear Informe
La subrutina Crear Informe permite crear un archivo con el nombre "informe.txt" en el cual redacta un informe detallado de los equipos existentes en la lista de inventarios.
```Fortran
subroutine crearInforme()
```
Esta subrutina redacta el nombre del equipo, su cantidad, el precio unitario del mismo, el valor total del equipo que se obtiene al multiplicar su precio unitario por su cantidad y la ubicación del equipo.
## Programa Práctica
El programa Práctica, utiliza el modulo Inventario con el tipo Inventario y todas sus subrutinas y desplega un menú, el cual permite utilizar todas las funcionalidades de forma comoda para el usuario.
```Fortran
program Practica
```