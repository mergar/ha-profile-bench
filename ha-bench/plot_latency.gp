# Настройка вывода
set terminal pngcairo size 1200,800 font "Arial,10"
set output 'latency_graph.png'

set title "Анализ производительности: Задержка vs Количество запросов"
set grid xtics ytics

# Настройка оси X (Логарифмическая шкала для процентилей)
set logscale x
set xlabel "Процентили (на базе invtail)"
set xtics ( "50%" 2, "90%" 10, "99%" 100, "99.9%" 1000, "99.99%" 10000, "99.999%" 100000 )

# Настройка первой оси Y (Задержка)
set ylabel "Задержка (ms)"
set ytics nomirror
set yrange [0:*]

# Настройка второй оси Y (Количество запросов)
set y2label "Накопленное кол-во запросов (Total Requests)"
set y2tics
set y2range [0:*]
set format y2 "%.0s%c" # Сокращения типа 1M, 10M

# Стиль легенды
set key left top box padding 1

# Отрисовка
# $3 - invtail (X)
# $5 - ttfb ms (Y1)
# $4 - ttfbcnt (Y2)
plot "latency.dat" using 3:4 axes x1y2 with filledcurves x1 title "Накопленные запросы" fillcolor rgb "#E0E0E0", \
     "latency.dat" using 3:5 axes x1y1 with linespoints title "Задержка TTFB (ms)" lw 2 pt 7 lc rgb "#FF4500"
