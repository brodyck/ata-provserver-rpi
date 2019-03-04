## Does not include actual firmware or config files
You must download/create those yourself

---

**To set up on stock Raspbian:**
1. sudo git clone https://github.com/brodyck/ata-provserver-rpi.git
    - Make sure everything is executable 
2. sudo ./update-docker 
3. sudo ./get-provfiles # downloads files from wherever they are stored (currently a private repo)
4. sudo ./ata-provserver enable # Enables the service on boot of RPi
5. sudo ./ata-provserver start (or reboot)  
<br/>

**To use:**
1. Power on RPi (service takes maybe 2 minutes to start functioning? haven't timed it.)
    - Optionally plug RPi into switch
2. Power on ATA
3. Factory reset ATA
4. Connect ATA to RPi
5. Repeat with as many ATAs as there are ports on the switch  
<br/>

**What happens:**
1. 2 Docker services start up; ISC-DHCP and Lighttpd
2. ISC-DHCP leases to ATA
    - Lease includes option 160, which overrides the default fm.grandstream and points the ATA config/firmware server @ http://192.168.1.1/gs
4. ATA asks for http://192.168.1.1/gs/htY0X.bin (the firmware)
    - ATA flashes some lights to show it's upgrading
5. ATA reboots and checks for http://http://192.168.1.1/gs/cfg.xml which sets its config/firmware server to https://whatever.ca/prov
6. Once ATA is plugged into a DHCP server without Option 160, it checks https://whatever.ca/prov and applies it
7. Ends with 'Power', 'Internet', on 80xs, additionally 'Link/Act' on 70xs  

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


