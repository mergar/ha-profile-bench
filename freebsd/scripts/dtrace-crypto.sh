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
/* Отслеживаем вход во ВСЕ функции libcrypto, вызванные процессом haproxy */
pid$target:libcrypto.so.3::entry {
    @[probefunc] = count();
}
tick-30s { exit(0); }' -p $(pgrep -o haproxy) -o /tmp/crypto_functions.txt

sync
sleep 2

cd /root/FlameGraph
./stackcollapse.pl /tmp/crypto_functions.txt | ./flamegraph.pl > /tmp/crypto_flamegraph.svg
