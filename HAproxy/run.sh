trap "exit" SIGINT SIGTERM
/bin/bash /var/lib/haproxy/cloudflare_ddns.sh
crond -b
haproxy -f "/usr/local/etc/haproxy/haproxy.cfg"
