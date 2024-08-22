module CargarInventario
    implicit none

    type :: inventario
        character(len=12) :: nombre
        integer :: cantidad
        real :: precioUnitario
        character(len=100) :: ubicacion
    end type inventario

    type(inventario), allocatable :: listaInventario(:)

    contains

    subroutine crearEquipo(nombreDeArchivo)
        character(len=14), intent(in) :: nombreDeArchivo
        character(len=100) :: linea
        character(len=100) :: comando
        character(len=100) :: datos
        integer :: inicio, fin
        integer :: contador
        integer :: i, iostat, numero_archivo
        character(len=200) :: datosTemporal
        character(len=50) :: nombres_temp, cantidad_temp, precio_unitario_temp, ubicacion_temp
        type(inventario), allocatable :: temp(:)

        numero_archivo = 10

        open(numero_archivo, file = nombreDeArchivo, status = 'old', action = 'read', iostat = iostat)

        if (iostat /= 0) then
            print *, 'Error: No se pudo abrir el archivo ', trim(nombreDeArchivo)
            return
        end if

        contador = 1
        allocate(listaInventario(contador))

        do
            read(numero_archivo, '(A)', iostat=iostat) linea

            if (iostat /= 0) exit

            inicio = 1
            fin = scan(linea(inicio:), ' ')

            if (fin == 0) then
                comando = trim(linea(inicio:))
                datos = ''
            else
                comando = trim(linea(inicio:inicio+fin-2))
                datos = trim(linea(inicio+fin:))
            end if

            print *, ''

            print *, 'Se ha creado el siguiente equipo: '
            datosTemporal = datos
            inicio = 1

            do i = 1,4
                fin = index(datosTemporal(inicio:), ';')
                if (fin == 0 .and. i == 4) then
                    ubicacion_temp = datosTemporal(inicio:)
                    exit
                else 
                    select case(i)
                        case(1)
                            nombres_temp = datosTemporal(inicio:inicio+fin-2)
                        case(2)
                            cantidad_temp = datosTemporal(inicio:inicio+fin-2)
                        case(3)
                            precio_unitario_temp = datosTemporal(inicio:inicio+fin-2)
                    end select
                    inicio = inicio + fin
                end if
            end do

            print *, 'Nombre: ', nombres_temp
            listaInventario(contador)%nombre = trim(nombres_temp)
            print *, 'Cantidad: ', cantidad_temp
            read(cantidad_temp, *, iostat=i) listaInventario(contador)%cantidad
            print *, 'Precio unitario: $ ', precio_unitario_temp
            read(precio_unitario_temp, *, iostat=i) listaInventario(contador)%precioUnitario
            print *, 'Ubicacion: ', ubicacion_temp
            listaInventario(contador)%ubicacion = trim(ubicacion_temp)

            contador = contador + 1
            if (contador > 1) then
                call move_alloc(listaInventario, temp)
                allocate(listaInventario(contador))
                listaInventario(1:contador-1) = temp
            end if

        end do

        close(numero_archivo)

    end subroutine crearEquipo

    subroutine gestionarInventario(nombreDeArchivo)
        character(len=*) :: nombreDeArchivo
        character(len=100) :: linea
        character(len=100) :: comando
        character(len=100) :: datos
        integer :: inicio, fin
        integer :: contador
        integer :: i, iostat, iostat_read
        character(len=200) :: datosTemporal
        character(len=50) :: campos(3)
        integer :: cantidad_temp

        open(15, file = nombreDeArchivo, status = 'old', action = 'read', iostat = iostat)

        if (iostat /= 0) then
            print *, 'Error: No se pudo abrir el archivo ', trim(nombreDeArchivo)
            return
        end if

        contador = 0

        do
            read(15, '(A)', iostat=iostat) linea

            if (iostat /= 0) exit

            inicio = 1
            fin = scan(linea(inicio:), ' ')

            if (fin == 0) then
                comando = trim(linea(inicio:))
                datos = ''
            else
                comando = trim(linea(inicio:inicio+fin-2))
                datos = trim(linea(inicio+fin:))
            end if

            datosTemporal = datos
            inicio = 1

            do i = 1,3
                fin = index(datosTemporal(inicio:), ';')
                if (fin == 0 .and. i == 3) then
                    campos(i) = datosTemporal(inicio:)
                    exit
                else 
                    campos(i) = datosTemporal(inicio:inicio+fin-2)
                    inicio = inicio + fin
                end if
            end do

            read(campos(2), *, iostat=iostat_read) cantidad_temp

            do i = 1, size(listaInventario)
                if (trim(listaInventario(i)%nombre) == trim(campos(1)) .and. trim(listaInventario(i)%ubicacion) == trim(campos(3))) then
                    if (comando == 'agregar_stock') then
                        listaInventario(i)%cantidad = listaInventario(i)%cantidad + cantidad_temp
                        print *, 'Se agregaron ', cantidad_temp, ' unidades de ', trim(campos(1)), ' en ', trim(campos(3))
                    else if (comando == 'eliminar_equipo') then
                        if (cantidad_temp > listaInventario(i)%cantidad) then
                            print *, 'Error: La cantidad a eliminar del equipo ', trim(campos(1)), ' es mayor que la cantidad en la ubicacion ', trim(campos(3))
                        else
                            listaInventario(i)%cantidad = listaInventario(i)%cantidad - cantidad_temp
                            print *, 'Se eliminaron ', cantidad_temp, ' unidades de ', trim(campos(1)), ' en ', trim(campos(3))
                        end if
                    end if
                    exit
                end if
            end do

            if (i > size(listaInventario)) print*, 'Error: El equipo ', trim(campos(1)), ' no existe en la ubicacion ', trim(campos(3))

            contador = contador + 1

        end do

        close(15)

    end subroutine gestionarInventario

    subroutine crearInforme()
        integer :: i
        integer :: unidad = 10

        print *, 'Creando informe de inventario...'

        open(unit=unidad, file='informe.txt', status='unknown', action='write')

        write(unidad, *) 'Informe de inventario: '
        write(unidad, *) ''
        write(unidad, *) 'Equipo          Cantidad          Precio Unitario          Valor Total          Ubicacion'
        write(unidad, *) '------------------------------------------------------------------------------------------'
        do i = 1, size(listaInventario)-1
            write(unidad, *) ''
            write(unidad, '(4(A), I0, 5(A), F10.2, 4(A), F10.2, 5(A))') listaInventario(i)%nombre, ACHAR(9), ACHAR(9), '  ', listaInventario(i)%cantidad, ACHAR(9), ACHAR(9), ACHAR(9), '$', ACHAR(9), listaInventario(i)%precioUnitario, ACHAR(9), ACHAR(9), ACHAR(9), '$', listaInventario(i)%cantidad * listaInventario(i)%precioUnitario, ACHAR(9), ACHAR(9), ACHAR(9), '   ', listaInventario(i)%ubicacion
            write(unidad, *) ''
            write(unidad, *) '------------------------------------------------------------------------------------------'
        end do

        close(unidad)

    end subroutine crearInforme
    
end module CargarInventario

program Practica
    use CargarInventario
    integer :: opcionMenu, iostat

    do
        print *, ''
        print *, ''
        print *, '--------------------------------------------------'
        print *, 'Practica 1 - Lenguajes Formales y de Programacion'
        print *, '--------------------------------------------------'
        print *, '# Sistema de gestion de inventario:'
        print *, ''
        print *, '1. Cargar inventario inicial'
        print *, '2. Cargar instrucciones de movimientos'
        print *, '3. Crear informe de inventario'
        print *, '4. Salir'
        print *, ''
        print *, 'Elige una opcion:'
        read (*,*, iostat = iostat) opcionMenu

        if (iostat /= 0) then
            print *, 'Error: entrada no valida'
            cycle
        end if

        select case (opcionMenu)
            case (1)
                call crearEquipo("inventario.inv")
            case (2)
                call gestionarInventario("movimientos.mov")
            case (3)
                call crearInforme()
            case (4)
                print *, 'Gracias por usar el sistema de gestion de inventario, adios.'
                exit
            case default
                print *, 'Error: opcion no valida'
        end select
    end do

end program Practica