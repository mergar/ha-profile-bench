#!/bin/sh

service syslogd onestop
service syslogd disable
service cron onestop
service cron disable

[ ! -d /usr/local/etc/nginx -a ! -h /usr/local/etc/nginx ] && ln -s /root/ha-profile-bench/freebsd/etc/nginx /usr/local/etc/nginx

pkg install -y haproxy nginx toxiproxy-cli toxiproxy-server curl httping gmake libepoll-shim gawk

service nginx enable
service haproxy enable

#service toxiproxy-server enable
#service toxiproxy-server start

if [ ! -x /usr/local/bin/h1load ]; then
	gmake -C /root/ha-profile-bench/h1load
	install -m 0755 /root/ha-profile-bench/h1load/h1load /usr/local/bin/h1load
	rm -f /root/ha-profile-bench/h1load/h1load /root/ha-profile-bench/h1load/h1load.o
fi

service nginx restart
service haproxy restart

curl http://127.0.0.1:8080/index.html
