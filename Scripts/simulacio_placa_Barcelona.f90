PROGRAM simulacio_placa_Barcelona
IMPLICIT NONE
INTEGER, PARAMETER :: DP = SELECTED_REAL_KIND(15,300)

! Variables per a simular la òrbita terrestre:

REAL(DP), PARAMETER :: &
  theta_inicial = 0.0D0, &                            ! [rad]                  Angle inicial de referiencia (periheli)
  dot_theta = 2.09D-7, &                              ! [rad/s]                Velocitat angular de la òrbita (ref. periheli)
  M_Sol = 1.98847D30, &                               ! [kg]                   Massa del Sol
  G = 6.677428D-15, &                                 ! [km^2kg^(-1)s^(-1)]    Constant de gravitació universal
  R_per = 147100000.0D0, &                            ! [km]                   Distància Terra-Sol al periheli
  PI = 3.141592653589793_DP, &                        ! [NA]                   Valor de pi a doble precissió
  n_d = 366.242D0                                     ! [NA]                   Nombre de dies siderals que té un anys sideral
  
INTEGER, PARAMETER :: n = 10000                       ! [NA]                   Nombre d'increments angulars
INTEGER :: i                                          ! [NA]                   Índex

REAL(DP), PARAMETER :: &
  theta_final = 2.0D0*PI, &                           ! [rad]                  Angle final (periheli)
  l = (R_per)**2 * dot_theta, &                       ! [km^2/s]               Moment angular específic (de la Terra)
  inc_theta = (theta_final)/n, &                      ! [rad]                  Increment d'angle
  epsilon = 47*PI/360, &                              ! [rad]                  Declinació màxima
  desf_e_set = 1.45*PI, &                             ! [rad]                  Desfasament per a ajustar l'equinoci de setembre
  beta = 7*PI/10, &                                   ! [rad]                  Latitud aproximada de Barcelona
  mu = PI/4, &                                        ! [rad]                  Altura a on s'orienta la placa (45 graus respecte a l'horitzó)
  eta = PI                                            ! [rad]                  Orientació cardinal (al Sud) 
REAL(DP) :: &
  theta, &                                            ! [rad]                  Variable angular
  theta_new, &                                        ! [rad]                  Variable angular extra
  phi_0, &                                            ! [rad]                  Variable de desfasament diürn
  v, &                                                ! [NA]                   y1 = u
  v_new, &                                            ! [NA]                   y1 = u extra
  r, &                                                ! [NA]                   y2 = du/do
  r_new, &                                            ! [NA]                   y2 = du/do extra
  param, &                                            ! [km^(-1)]              Paràmetre de l'EDO
  S_0, &                                              ! [km^(-2)]              Variable de constant solar
  I_value, &                                          ! []                     Variable de flux d'intensitat que arriba a la placa 
  u_x, &                                              ! [NA]                   Components vector unitari d'orientació de la placa
  u_y, &
  u_z, &
  v_x, &                                              ! [NA]                   Components vector unitari que apunta a la placa des del Sol
  v_y, &
  v_z
  
REAL(DP), ALLOCATABLE :: &
  theta_list(:), &                                    ! [rad]                  Llista d'angles orbitals
  theta_h_list(:), &                                  ! [rad]                  Llista d'angles horaris
  r_list(:), &                                        ! [NA]                   Llista de radis inversos normalitzats
  R_norm_list(:), &                                   ! [NA]                   Llista de radis normalitzats
  x_list(:), &                                        ! [m]                    Llista que emmagatzema la variable x
  y_list(:), &                                        ! [m]                    Llista que emmagatzema la variable y
  alpha_list(:), &                                    ! [rad]                  Llista de valors de la declinació
  phi_0_list(:), &                                    ! [rad]                  Llista de valors de l'angle de desfasament diürn
  delta_list(:), &                                    ! [rad]                  Llista de valors d'elevació aparent del Sol
  I_list(:)                                           ! []                     Llista de flux d'intensitat que arriba a la placa a temps real
LOGICAL :: &
  NS_like, &                                          ! [bool]                 TRUE si és N-like, FALSE si és S-like
  trop                                                ! [bool]                 TRUE si ens trobem a la zona intertropical
! -----<< MÈTODE D'EULER D'ORDRE REDUÏT >>-----
ALLOCATE(r_list(n),theta_list(n),x_list(n),y_list(n))
param = G*M_Sol/(R_per*l**2) - 1/R_per
r = 1.0D0
v = 0.0D0
r_list(1) = r
theta = theta_inicial
theta_list(1) = theta
x_list(1) = 1.0D0
y_list = 0.0D0
DO i = 1,n-1
  r_new = r + inc_theta*v 
  v_new = v + inc_theta*(2/r * v**2 - param *r)
  theta_new = theta + inc_theta

  r_list(i+1) = r_new
  theta_list(i+1) = theta_new
  r = r_new
  theta = theta_new
  x_list(i+1) = r*COS(theta)
  y_list(i+1) = r*SIN(theta)
END DO

OPEN(unit=10, file="radis_euler.txt", status="replace")
DO i = 1,n
  WRITE(10, *) r_list(i), x_list(i), y_list(i)
END DO
CLOSE(10)

DEALLOCATE(x_list,y_list)

! -----<< DELINACIÓ AL LLARG DE L'ANY, ANGLE HORARI, ANGLE DE DESFASAMENT DIüRN, ELEVACIÓ SOLAR APARENT >>-----
ALLOCATE(alpha_list(n), theta_h_list(n),phi_0_list(n))
alpha_list = epsilon*SIN(theta_list - desf_e_set)
theta_h_list = MOD(theta_list*n_d/(2*PI),2*PI)
phi_0_list = ASIN(SIN(alpha_list)/COS(beta))
delta_list = ABS((PI/2 -alpha_list-beta))*SIN(theta_h_list)
OPEN(unit=10, file="evo_declinacio.txt", status="replace")
DO i = 1,n
  WRITE(10, *) theta_list(i), alpha_list(i), theta_h_list(i), phi_0_list(i), delta_list(i)
END DO
CLOSE(10)

! -----<< ORIENTACIÓ DE LA PLACA >>-----
u_x = -COS(mu)*SIN(eta)
u_y = COS(mu)*COS(eta)
u_z = SIN(eta)

! -----<< CONDICIONS I SIMULACIÓ DEL DIA REAL >>-----
ALLOCATE(I_list(n))
IF (beta .GT. epsilon) THEN
  trop = .FALSE.
  NS_like = .TRUE.
  PRINT*, 'La placa es troba sobre el tropic de de Càncer'
ELSE IF (beta .LT. -epsilon) THEN
  trop = .FALSE.
  NS_like = .FALSE.
  PRINT*, 'La placa es troba sota el tropic de Capricorn'
ELSE
  trop = .TRUE.
  PRINT*, 'La placa es troba a la zona intertropical'
END IF

DO i = 1,n
  IF (trop) THEN
    IF (alpha_list(i) .GE. 0) THEN
      NS_like = .TRUE.
    ELSE
      NS_like = .FALSE.
    END IF
  END IF
  S_0 = r_list(i)**(-2)
  IF (NS_like) THEN
    phi_0 = phi_0_list(i)
  ELSE
    phi_0 = -phi_0_list(i)
  END IF
  IF (delta_list(i) .GT. 0 .AND. phi_0 .LT. theta_h_list(i) .AND. theta_h_list(i) .LT. PI - phi_0) THEN
    v_x = -COS(delta_list(i))*COS(theta_h_list(i))
    v_y = -COS(delta_list(i))*SIN(theta_h_list(i))
    v_z = -SIN(delta_list(i))
    I_value = S_0*ABS(v_x*u_x + v_y*u_y + v_z*u_z)
    I_list(i) = I
  ELSE
    I_list(i) = 0.0
  END IF
END DO
OPEN(unit=10, file="intensitats.txt", status="replace")
DO i = 1,n
  WRITE(10, *) theta_list(i), I_list(i), r_list(i)
END DO
CLOSE(10)

END PROGRAM simulacio_placa_Barcelona