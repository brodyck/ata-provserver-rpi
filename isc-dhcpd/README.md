These are some notes.

http://www.grandstream.com/sites/default/files/Resources/DHCP_Options_Guide_Linux_0.pdf
https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
https://linux.die.net/man/5/dhcp-options
https://www.isc.org/wp-content/uploads/2017/08/dhcp43options.html
http://manpages.ubuntu.com/manpages/trusty/man5/dhcp-options.5.html
http://www.grandstream.com/sites/default/files/Resources/gs_provisioning_guide.pdf
https://www.excentis.com/blog/how-provision-cable-modem-using-isc-dhcp-server
http://www.grandstream.com/support/firmware

option 2 time offset

option 12 hostname

option 42 ntp

option 43 vendor specific information

option 60 vendor class identifier

option 66 tftp server name

       option tftp-server-name "ipaddress";
       
       option tftp-server-name "http://ipadddress";
       
option 120 sip server 

option 125 vendor-identifying vendor options

option 160 confirguration server address (can be a list)

       option option-160 code 160 = text;
       
       option option-160 "asfd://ipaddress.whatever";
       
