#!/bin/sh
cd /root/FlameGraph
#perf record -F 997 -p $(pgrep haproxy) --call-graph dwarf -- sleep 30
# Используем -e cpu-clock вместо стандартных циклов процессора
#sudo perf record -e cpu-clock -F 997 -p $(pgrep haproxy) --call-graph dwarf -- sleep 30

perf record -e cpu-clock -F 997 -a --call-graph dwarf -- sleep 30
#perf script | ./stackcollapse-perf.pl | ./flamegraph.pl > /tmp/haproxy_perf_flamegraph.svg


perf script | grep "haproxy" -A 20 | ./stackcollapse-perf.pl | ./flamegraph.pl > /tmp/haproxy_perf_flamegraph.svg
