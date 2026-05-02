#!/bin/sh

gawk '!/^#/ && NF > 0 { a[NR] = $8; count++ } 
END { 
    if (count <= 4) { print 0; exit }
    for (i = 3; i <= count - 2; i++) {
        # Преобразование "22k0" в число 22000
        val = a[i+2] # +2 так как NR учитывает и строки с комментариями
        gsub(/k/, "000", val); gsub(/M/, "000000", val);
        sum += val
    }
    print sum / (count - 4)
}' throughput.dat
