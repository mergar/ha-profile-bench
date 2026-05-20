#!/bin/sh

sudo bpftrace -e '
profile:hz:997 /comm == "haproxy"/ {
    @[ustack, kstack] = count();
}
interval:s:30 { 
    exit(); 
}' | awk '
/^[a-zA-Z0-9]/ { 
    # Склеиваем строки стека через точку с запятой, как просит FlameGraph
    printf "%s;", $0 
} 
/^[ ]*[0-9]+$/ { 
    # В конце стека выводим количество совпадений
    print " " $1 
}' > /tmp/haproxy_folded.txt
