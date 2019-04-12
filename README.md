## Does not include actual firmware or config files
You must download/create those yourself

---

There is currently vsftpd built into this, but it's not working just yet. Having it there doesn't effect the usage of this.

---

**To set up on stock Raspbian:**
1. sudo git clone https://github.com/brodyck/ata-provserver-rpi.git
2. sudo ./update-docker 
3. Get the cfg.xml and firmware and put them in the root-www folder
    - for my purposes, I run `sudo ./get-provfiles` which gets them from a private repo only I can access
4. sudo ./ata-provserver enable # Enables the service on boot of RPi
5. sudo ./ata-provserver start (or reboot)  
<br/>

**To use:**
1. Plug RPi into power
2. Plug ATAs into power
3. Factory reset ATAs (if they are being reused)
4. Plug ATAs into RPi, preferably by network switch for bulk
5. Wait
6. Done 
<br/>

**What happens:**  
0. Assuming the ‘cfg.xml’ file has this in it:  
```xml
<P192>whatever.ca/prov</P192>
<P237>whatever.ca/prov</P237>
<P212>2</P212> # this is for HTTPS; 1 is for HTTP
```  
1. (at boot) Two Docker services start up; ISC-DHCP and Lighttpd
2. DHCP leases IP to ATA
    - Lease includes DHCP option 160, which is a captive portal that overrides the default config server and points to http://192.168.20.1/gs
4. ATA asks for firmware from http://192.168.20.1/gs
    - If the firmware is newer, ATA flashes some lights to show it's upgrading; this takes a minute or so
5. ATA asks for cfg.xml from http://192.168.20.1/gs
    - This is what sets the config server path to whatever.ca/prov
    - Ends with 'Power' & 'Internet', on 80xs, additionally 'Link/Act' on 70xs
6. Once ATA is plugged into a customer modem, it checks https://whatever.ca/prov and does whatever needs to be done

Note: Assumes you're in the default /home directory of a stock Raspbian installation, /home/pi.  
<br/>
<br/>

**Uses these two programs within docker:**
- ISC-DHCP server that has a custom option 160 set up for grandstreams HT70x/HT80x to provision/update over HTTP.
  - https://www.isc.org/downloads/dhcp/
- The HTTP server is lighttpd.
  - https://www.lighttpd.net/
<br/>

Some notes/articles here: https://github.com/brodyck/ata-provserver/tree/master/isc-dhcpd  
Explenation of DHCP options from Grandstream here: http://www.grandstream.com/sites/default/files/Resources/DHCP_Options_Guide_Linux_0.pdf  
<br/>
<br/>

**todo:**
- FTP service for editing configs remotely
- possible option for auto-updating files in www-root/gs/ folder  
<br/>
<br/>

Should work out of the box after installing docker & docker compose on Raspbian for the Raspberry Pi, and on anything else so long as the init-system and paths line up in the scripts.  
<br/>

At the time of this writing, only working docker-compose is through PIP, so that's why it's included in the 'update-docker' script.
<br/>


