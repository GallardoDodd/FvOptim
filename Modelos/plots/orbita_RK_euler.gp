# Script de Gnuplot para comprarar euler y RK4

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
set output 'orbita_rk_euler.png'

datafile = '../resultados/posorbita.txt'

# Dibujar la órbita Dibujamos punto rojo en el perihelio Dibujamos linea del centro al perihelio Dibujamos punto ilustrativo de la posicion del sol
plot datafile using 1:2 with lines title 'Órbita Tierra RK4', \
    '../resultados/posorbita_euler.txt' using 1:2 with lines title 'Órbita Tierra Euler'



