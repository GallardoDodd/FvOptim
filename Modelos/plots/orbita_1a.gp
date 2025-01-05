# Script de Gnuplot para graficar la órbita de la Tierra durante un año

set title "Órbita de la Tierra alrededor del Sol durante 1 año" font ",18"
set xlabel "Posición X [m]" font ",14"
set ylabel "Posición Y [m]" font ",14"
set key font ",16"
set tics font ",14"

set xrange [-2e11:2e11]
set yrange [-2e11:2e11]
set size ratio 1
set key outside
set grid
set terminal pngcairo enhanced size 1400,900
set output 'orbita_1a.png'

datafile = '../resultados/posorbita.txt'

# Coordenadas del perihelio
x0 = 147.09829e9
y0 = 0

#Coordenadas del afelio
stats '../resultados/posorbita_afelio.txt' using 1:2 nooutput
x_afelio = STATS_max_x   # Coordenada X del afelio
y_afelio = STATS_max_y   # Coordenada Y del afelio


# Crear archivo temporal con el punto del perihelio (x0, y0) y el centro (0, 0)
set print 'temp_points1.dat'
print 0, 0  # El centro
print x0, y0  # El perihelio
unset print
set print 'temp_points2.dat'
print x0, y0  # El perihelio
unset print
set print 'temp_points3.dat'
print 0,0  # El Sol
unset print
set print 'temp_points4.dat'
print x_afelio, y_afelio #El afelio
print 0,0  
unset print


# Dibujar la órbita Dibujamos punto rojo en el perihelio Dibujamos linea del centro al perihelio Dibujamos punto ilustrativo de la posicion del sol
plot datafile using 1:2 with lines title 'Órbita Tierra', \
    'temp_points3.dat' using 1:2 with points pt 7 ps 4 lc rgb 'yellow' title 'Sol', \
    'temp_points2.dat' using 1:2 with points pt 7 ps 2 lc rgb 'red' title 'Perihelio', \
    'temp_points1.dat' using 1:2 with lines ls 1 lc rgb 'red' title 'Radio perihelio: 147e9 [m]', \
    '../resultados/posorbita_afelio.txt' using 1:2 with points pt 7 ps 2 lc rgb 'blue' title 'Afelio', \
    'temp_points4.dat' using 1:2 with lines ls 1 lc rgb 'blue' title 'Radio afelio: 152e9 [m]', \



# Eliminar el archivo temporal después de graficar
system('rm temp_points1.dat')
system('rm temp_points2.dat')
system('rm temp_points3.dat')
system('rm temp_points4.dat')



# Cerrar el archivo de salida
set output