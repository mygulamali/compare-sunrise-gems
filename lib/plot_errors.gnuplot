set terminal png size 800,600 
set output the_plot
set datafile separator ','
set key left top autotitle columnhead
set xlabel 'Day of year'
set ylabel 'Absolute error [minutes]'
plot [0:366] the_data \
     using 1:2 with points, \
  '' using 1:3 with points, \
  '' using 1:4 with points, \
  '' using 1:5 with points, \
  '' using 1:6 with points, \
  '' using 1:7 with points
