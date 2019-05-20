#!/bin/bash


IP=$1
NAME=$2

verify_args() {
	if test -z "$IP" ; then
		echo "parameter 1 must be ip address"
		exit 1
	fi


	if test -z "$NAME" ; then
		echo "parameter 2 must be hostname"
		exit 2
	fi

}


set_ip() {
	echo "IPADDR=${IP}" >> /etc/sysconfig/network-scripts/ifcfg-eth0
}

set_hostname() {
	echo "${NAME}" > /etc/hostname
	hostname -b ${NAME}
}

verify_args
set_ip
set_hostname
reboot now

