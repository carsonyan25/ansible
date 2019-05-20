#!/bin/bash
# this script use to enable ssh  pubkey authentication

test_pass="TDtest123"
root_pass="TDtest123"
sshd_port=$2

if test -z "$sshd_port" ; then
	sshd_port=22
fi

create_root_key(){

    rm -fr /root/.ssh
    ssh-keygen -q -t rsa -b 2048  -f /root/.ssh/id_rsa -N ""
    cd /root/.ssh
    cat id_rsa.pub > authorized_keys
    chmod 600 authorized_keys
    echo "-------------------------------------------------"
    echo "-------------------------------------------------"
    echo "root's private key is"
    cat id_rsa
    echo "-------------------------------------------------"
    echo "root's public key is"
    cat id_rsa.pub
    echo "-------------------------------------------------"
    echo "the key pair save in /root/.ssh ,keep the key pair safely"
}

create_test_key(){

    useradd -m -g sudo  -c "test user"  test
    rm -fr  /home/test/.ssh
    su  test -c " ssh-keygen -q -t rsa -b 2048  -f /home/test/.ssh/id_rsa -N '' "
    cd /home/test/.ssh
    cat id_rsa.pub > authorized_keys
    chown test:sudo authorized_keys
    chmod 600 authorized_keys
    echo "-------------------------------------------------"
    echo "-------------------------------------------------"
    echo "test's private key is"
    cat id_rsa
    echo "-------------------------------------------------"
    echo "test's public key is"
    cat id_rsa.pub
    echo "-------------------------------------------------"
    echo "the key pair save in /home/test/.ssh ,keep the key pair safely"
}

set_test_password(){

        echo "$test_pass" | passwd --stdin  test
        echo "test's password is $pass"

}

set_root_password(){

    echo "$root_pass" | passwd --stdin root
    echo "root's password is $root_pass"
    
}

enable_pubkey_auth(){
    
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
    sed -i s/^PasswordAuthentication.*//g   /etc/ssh/sshd_config
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
   # systemctl restart sshd 
}

change_sshd_port() {

	sed -i s/^\#Port.*/Port\ ${sshd_port}/g   /etc/ssh/sshd_config

}

keepalive_setting() {
	
	sed -i "s/#ClientAliveInterval 0/ClientAliveInterval 60/g" /etc/ssh/sshd_config
	sed -i "s/#ClientAliveCountMax 3/ClientAliveCountMax 3/g" /etc/ssh/sshd_config

}

case $1 in 

    "pubkey")
        create_test_key
        create_root_key
 #       set_test_password
 #       set_root_password
	change_sshd_port
        enable_pubkey_auth
	keepalive_setting
        if [ $? -eq 0 ] ; then
            echo "enable ssh pubkey authentication successfully"
        else 
            echo "Failed to enable ssh pubkey"
        fi
        ;; 

    "change_sshd_port")
	change_sshd_port
	;;
    
    *)
        echo "parameter 1 must be pubkey or change_sshd_port  "
        ;;
esac


        
