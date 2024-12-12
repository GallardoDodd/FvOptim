program orbita
implicit none
integer, parameter :: DP = SELECTED_REAL_KIND(15,300)
real(DP) :: xin, yin, eps, tfin, tin, velyin, velxin
real(DP) :: xj, yj
real(DP), allocatable :: x(:), y(:), t(:), vely(:), velx(:)
integer :: n, i
!Constants
real(DP), parameter :: G=6.67428D-11, ms=1.9891D30, mt=5.972D24

! Valors inicials
xin = 147.0D9                  ! Posición x inicial perihelio
yin = 0.0D0                  ! Posición y inicial perihelio
tin = 0.0D0                  ! Tiempo inicial
tfin = 2.0D0                 ! Tiempo final
n = 1000                     ! Número de pasos
eps = (tfin - tin)/n         ! Paso de integración

ALLOCATE(x(n), y(n), vely(n), velx(n))
x(1) = xin
y(1) = yin


!-----<< METODO DE EULER >>-----
!Partimos de la aceleración obtenida de la fuerza gravitacional
do i = 1, n     ! Calculamos iterativamente la velocidad para cada paso
    vely(i+1) = vely(i) + eps*acely(x(i), y(i))
    velx(i+1) = velx(i) + eps*acelx(x(i), y(i))

end do

contains
  ! Función que calcula x'' o y'', la aceleración de la Tierra
  real(DP) function acelx(posx,posy)
    real(DP), intent(in) :: posx, posy
    acelx=-G*ms*(posx**2+posy**2)**(-3/2)*posx
  end function acelx

  real(DP) function acely(posx,posy)
    real(DP), intent(in) :: posx, posy
    acely=-G*ms*(posx**2+posy**2)**(-3/2)*posy
  end function acely

END program orbita