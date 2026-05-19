#!/bin/sh
cat <<EOF


Info/howto:

# Oracle:
#sudo dnf install -y perl-open

cd /root
git clone https://github.com/brendangregg/FlameGraph.git
cd FlameGraph
./stackcollapse.pl /tmp/haproxy_stacks.txt > /tmp/haproxy_collapsed.txt
./flamegraph.pl /tmp/haproxy_collapsed.txt > /tmp/haproxy_flamegraph.svg

#./stackcollapse.pl /tmp/haproxy_stacks.txt | ./flamegraph.pl > /tmp/haproxy_flamegraph.svg


EOF


dtrace -n '
profile-997 /execname == "haproxy"/ {
    @[ustack(100), stack()] = count();
}
tick-30s { exit(0); }' -o /tmp/haproxy_stacks.txt

sync
sleep 2

cd /root/FlameGraph
./stackcollapse.pl /tmp/haproxy_stacks.txt | ./flamegraph.pl > /tmp/haproxy_flamegraph.svg
