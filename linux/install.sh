#!/bin/sh

[ ! -d /etc/nginx -a ! -h /etc/nginx ] && ln -s /root/ha-profile-bench/linux/etc/nginx /etc/nginx

dnf install -y haproxy nginx curl make gcc openssl-devel.x86_64 dtrace
#toxiproxy-cli toxiproxy-server httping
systemctl nginx enable
systemctl haproxy enable

#service toxiproxy-server enable
#service toxiproxy-server start

if [ ! -x /usr/bin/h1load ]; then
	make -C /root/ha-profile-bench/h1load-lin
	install -m 0755 /root/ha-profile-bench/h1load-lin/h1load /usr/bin/h1load
	rm -f /root/ha-profile-bench/h1load-lin/h1load /root/ha-profile-bench/h1load-lin/h1load.o
fi

systemctl restart nginx
systemctl restart haproxy

curl http://127.0.0.1:8080/index.html
