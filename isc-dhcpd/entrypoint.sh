#!/bin/ash
# Changed the above to 'ash' because 'bash' doesn't actually exist on alpine

set -e

init="/usr/bin/dumb-init"

# Single argument to command line is interface name
if [ ${#} -eq 1 -a -n "$1" ]; then # changed to ${#} for moderness
    # skip wait-for-interface behavior if found in path
    if ! which "$1" >/dev/null; then
        # loop until interface is found, or we give up
        NEXT_WAIT_TIME=1
        until [ -e "/sys/class/net/${1}" ] || [ ${NEXT_WAIT_TIME} -eq 4 ]; do
            sleep $(( NEXT_WAIT_TIME++ ))
            echo "Waiting for interface '${1}' to become available... ${NEXT_WAIT_TIME}"
        done
        if [ -e "/sys/class/net/${1}" ]; then
            IFACE="${1}"
        fi
    fi
fi

# No arguments mean all interfaces
if [ -z "${1}" ]; then
    IFACE=" "
fi

if [ -n "${IFACE}" ]; then
    # Run dhcpd for specified interface or all interfaces

    data_dir="/data"
    if [ ! -d "${data_dir}" ]; then
        echo "Please ensure '${data_dir}' folder is available."
        echo 'If you just want to keep your configuration in "data/", add -v "$(pwd)/data:/data" to the docker run cmd.'
        exit 1
    fi

    dhcpd_conf="$data_dir/dhcpd.conf"
    if [ ! -r "${dhcpd_conf}" ]; then
        echo "Please ensure '$dhcpd_conf' exists and is readable."
        echo "Run the container with arguments 'man dhcpd.conf' if you need help with creating the configuration."
        exit 1
    fi

    uid=$(stat -c%u "${data_dir}")
    gid=$(stat -c%g "${data_dir}")

    # Alpine's default user-management system is a little different if you don't install 'shadow'
    if ! grep -q /etc/passwd -e "dhcpd"; then
	if [ ${uid} -ne 0 ]; then
	    echo "Creating user 'dhcpd' now"
            adduser -u ${uid} dhcpd -D
	    echo "Done creating user 'dhcpd'"
	    echo "Now setting permissions"
	    if [ -e "${data_dir}/dhcpd.leases" ]; then
		chown dhcpd:dhcpd "${data_dir}/dhcpd.leases"
	    fi
	    if [ -e "${data_dir}/dhcpd.leases~" ]; then
		chown dhcpd:dhcpd "${data_dir}/dhcpd.leases~"
	    fi	    
	fi
	# May need these if something goes wrong
    	#deluser dhcpd
	#delgroup dhcpd
    else
	echo "User 'dhcpd' exists"
    fi
    
    # Commented the following out because adduser magically adds correct group w/ gid
    # if [ ${gid} -ne 0 ]; then
    #    
    # fi    

    [ -e "${data_dir}/dhcpd.leases" ] || touch "${data_dir}/dhcpd.leases"

    exec ${init} -- /usr/sbin/dhcpd -4 -f -d --no-pid -cf "${data_dir}/dhcpd.conf" -lf "${data_dir}/dhcpd.leases" ${IFACE}
else
    # Run another binary
    exec ${init} -- "$@"
fi
