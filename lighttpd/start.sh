#!/bin/sh

# this launcher script tails the access and error logs
# to the stdout and stderr, so that `docker logs -f lighthttpd` works.

tail -F /var/log/lighttpd/access.log 2>/dev/null &
tail -F /var/log/lighttpd/error.log 2>/dev/null 1>&2 &
while : ; do
    ping ${1} -c1 -W1 && break
    sleep 2
done    

lighttpd -D -f /etc/lighttpd/lighttpd.conf
