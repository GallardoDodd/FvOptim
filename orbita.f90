program orbita
implicit none
integer, parameter :: DP = SELECTED_REAL_KIND(15,300)
real(DP) :: xin, yin, eps, tfin, tin, velin
real(DP) :: xj, yj
real(DP), allocatable :: x(:), y(:), t(:), vely(:), velx(:), temp(:), rad(:)
integer :: n, i
!Constants
real(DP), parameter :: G=6.67428D-11, ms=1.9891D30, mt=5.972D24

! Valors inicials
xin = 147.098290D9           ! Posición x inicial perihelio
yin = 0.0D0                  ! Posición y inicial perihelio
velin = 30290D0              ! Velocidad orbital de la tierra en el perihelio
tin = 0.0D0                  ! Tiempo inicial
tfin = 365.25D0 * 24.0D0 * 3600.0D0               ! Tiempo final
n = 1000000                  ! Número de pasos
eps = (tfin - tin)/n         ! Paso de integración

ALLOCATE(x(n), y(n), vely(n), velx(n), temp(n), rad(n))
x(1) = xin
y(1) = yin
vely(1) = velin
velx(1) = 0
rad(1)= sqrt(x(1)**2+y(1)**2)


GO TO 42
!-----<< METODO DE EULER >>-----
!Partimos de la aceleración obtenida de la fuerza gravitacional
do i = 1, n-1
  ! Calculamos iterativamente la velocidad para cada paso
  vely(i+1) = vely(i) + eps*acely(x(i), y(i))
  velx(i+1) = velx(i) + eps*acelx(x(i), y(i))
  ! Calculamos la nueva posicion para cada paso
  x(i+1) = x(i) + eps*velx(i)
  y(i+1) = y(i) + eps*vely(i)

  rad(i+1) = sqrt(x(i+1)**2+y(i+1)**2)
end do
42 continue


!-----<< METODO RUNGE-KUTTA 4 >>-----
do i = 1, n - 1
  call RK4(x(i), y(i), velx(i), vely(i), eps, x(i+1), y(i+1), velx(i+1), vely(i+1))
  rad(i) = sqrt(x(i)**2+y(i)**2) !Calculamos el radio de la orbita
end do

! Escribimos las posiciones de la tierra en su orbita
open(unit=10, file="resultados/posorbita.txt", status="replace")
do i = 1,n
  write(10, *) x(i), y(i)
end do
close(10)

! Escribimos el afelio
open(unit=20, file="resultados/posorbita_afelio.txt", status="replace")
write(20, *) x(maxloc(rad)), y(maxloc(rad))
print *, "Para la orbita de un año, el radio de afelio encontrado és", rad(maxloc(rad))
close(20)

contains
  ! Subrutina que calcula runge-kuta 4 para un paso
  subroutine RK4(x, y, vx, vy, h, xout, yout, vxout, vyout)
    real(DP), intent(in) :: x, y, vx, vy, h
    real(DP), intent(out) :: xout, yout, vxout, vyout
    real(DP) :: k1x, k2x, k3x, k4x
    real(DP) :: k1y, k2y, k3y, k4y
    real(DP) :: k1vx, k2vx, k3vx, k4vx
    real(DP) :: k1vy, k2vy, k3vy, k4vy
    real(DP) :: ax, ay

    ! Paso 1: k1
    ax = acelx(x, y)
    ay = acely(x, y)
    k1x = vx
    k1y = vy
    k1vx = ax
    k1vy = ay

    ! Paso 2: k2
    ax = acelx(x + h/2*k1x, y + h/2*k1y)
    ay = acely(x + h/2*k1x, y + h/2*k1y)
    k2x = vx + h/2*k1vx
    k2y = vy + h/2*k1vy
    k2vx = ax
    k2vy = ay

    ! Paso 3: k3
    ax = acelx(x + h/2*k2x, y + h/2*k2y)
    ay = acely(x + h/2*k2x, y + h/2*k2y)
    k3x = vx + h/2*k2vx
    k3y = vy + h/2*k2vy
    k3vx = ax
    k3vy = ay

    ! Paso 4: k4
    ax = acelx(x + h*k3x, y + h*k3y)
    ay = acely(x + h*k3x, y + h*k3y)
    k4x = vx + h*k3vx
    k4y = vy + h*k3vy
    k4vx = ax
    k4vy = ay

    ! Output RK4
    xout = x + h/6.0_DP * (k1x + 2*k2x + 2*k3x + k4x)
    yout = y + h/6.0_DP * (k1y + 2*k2y + 2*k3y + k4y)
    vxout = vx + h/6.0_DP * (k1vx + 2*k2vx + 2*k3vx + k4vx)
    vyout = vy + h/6.0_DP * (k1vy + 2*k2vy + 2*k3vy + k4vy)
  end subroutine RK4

  ! Función que calcula x'' o y'', la aceleración de la Tierra
  real(DP) function acelx(posx,posy)
    real(DP), intent(in) :: posx, posy
    acelx=-G*ms*(posx**2+posy**2)**(-1.5_DP)*posx
  end function acelx

  real(DP) function acely(posx,posy)
    real(DP), intent(in) :: posx, posy
    acely=-G*ms*(posx**2+posy**2)**(-1.5_DP)*posy
  end function acely

END program orbita