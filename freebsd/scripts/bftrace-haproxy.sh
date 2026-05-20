#!/bin/sh
BPFTRACE_MAX_AST_NODES=8192 bpftrace -e '
profile:hz:997 /comm == "haproxy"/ {
    @[ustack, kstack] = count();
}
interval:s:30 { exit(); }' -o /tmp/haproxy_bpftrace.txt
sync
sleep 2
cd /root/FlameGraph
./stackcollapse-bpftrace.pl /tmp/haproxy_bpftrace.txt | ./flamegraph.pl > /tmp/haproxy_flamegraph.svg
