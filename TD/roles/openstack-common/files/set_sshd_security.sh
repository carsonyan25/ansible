#!/bin/bash
# this script use to enable ssh  pubkey authentication

sshd_port=$2

if test -z "$sshd_port" ; then
	sshd_port=22
fi


enable_root_login(){
    
    echo "  " >> /etc/ssh/sshd_config
    echo "##### generated setting by ansible ####"  >> /etc/ssh/sshd_config 
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
}

enable_pubkey_auth(){
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
    sed -i s/^PasswordAuthentication.*//g   /etc/ssh/sshd_config
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
}

change_sshd_port() {

	sed -i s/^\#Port.*/Port\ ${sshd_port}/g   /etc/ssh/sshd_config

}

keepalive_setting() {
	
	sed -i "s/#ClientAliveInterval 0/ClientAliveInterval 60/g" /etc/ssh/sshd_config
	sed -i "s/#ClientAliveCountMax 3/ClientAliveCountMax 3/g" /etc/ssh/sshd_config

}

case $1 in 

    "security")
	enable_root_login
	enable_pubkey_auth
	change_sshd_port
        keepalive_setting
	;;
    
    *)
        echo "parameter 1 must be security  "
        ;;
esac


        
