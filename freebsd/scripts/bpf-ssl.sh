# Поднимаем лимит eBPF программ и запускаем сбор стеков по ключевым маскам OpenSSL
sudo BPFTRACE_MAX_BPF_PROGS=5000 bpftrace -e '
uprobe:/lib64/libcrypto.so.3:EVP_*,
uprobe:/lib64/libcrypto.so.3:ossl_*,
uprobe:/lib64/libcrypto.so.3:AES_* {
    @[ustack] = count();
}
interval:s:30 { exit(); }' -o /tmp/bpftrace_crypto_stacks.txt



#
./stackcollapse-bpftrace.pl /tmp/bpftrace_crypto_stacks.txt > /tmp/crypto_folded.out
./flamegraph.pl --title="HAProxy TLS/Crypto (via bpftrace)" /tmp/crypto_folded.out > /tmp/crypto_tls_flame.svg
