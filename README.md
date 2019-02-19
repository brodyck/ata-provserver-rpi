ISC-DHCP server that has a custom option 160 set up for grandstreams HT70x/HT80x to provision/update over HTTP. The HTTP server is lighttpd.

Should work out of the box after installing docker & docker compose on Raspbian for the Raspberry Pi.

At the time of this writing, only working docker-compose is through PIP, so that's why it's included in the 'update-docker' script.

To use:
```
git clone https://github.com/brodyck/ata-provserver-rpi.git
./update-docker
./install-service
```

After that, just follow docker commands. To remove it from startup, run `rc-update.d ata-provserver remove`.

Some notes/articles here: https://github.com/brodyck/ata-provserver/tree/master/isc-dhcpd
