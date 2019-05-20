#!/bin/bash
#this script use to standardize linux


disable_firewall(){

systemctl stop firewalld &&  systemctl disable  firewalld

}

disable_selinux(){
    sed -i  s/SELINUX=enforcing/SELINUX=disabled/  /etc/selinux/config
}

create_test_user(){

        pass=`openssl rand  -base64 12`
        useradd -g wheel -c "test user" test
        echo "$pass" | passwd --stdin  test
        echo "test's password is $pass"

}

change_root_password(){
    root_pass=`openssl rand  -base64 12`
    echo "$root_pass" | passwd --stdin root
    echo "root's password is $root_pass"
    
}

set_name(){
        name=$2
        echo "$2" > /etc/hostname
        hostname -b $name
}

change_timezone(){
    rm -f /etc/localtime
    cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime 
}

set_network(){
    ip=$2
    eth0_file="/etc/sysconfig/network-scripts/ifcfg-eth0"    
    sed -i s/BOOTPROTO=dhcp// $eth0_file 
    sed -i s/\#BOOTPROTO=static/BOOTPROTO=static/  $eth0_file
    sed -i s/ONBOOT=no//  $eth0_file
    sed -i s/\#ONBOOT=yes/ONBOOT=yes/  $eth0_file
    sed -i s/UUID.*//  $eth0_file
    sed -i s/\#PREFIX.*/PREFIX=24/  $eth0_file
    sed -i s/\#IPADDR.*/IPADDR=\${ip}/  $eth0_file
    sed -i s/\#GATEWAY.*/GATEWAY=10.100.11.1/  $eth0_file
    sed -i s/\#DNS1.*/DNS1=223.5.5.5/   $eth0_file
}

case $1 in

        "all")
                change_timezone
                disable_firewall
                disable_selinux
                create_test_user
                change_root_password
                break
        ;;

        "user")
                create_test_user
                break
        ;;

        "firewall")
                disable_firewall
                break
        ;;
        
        "name")
                set_name
                break
        ;;
        
        "root_pass")
                change_root_password
                break
        ;;
        
        "net")
                set_network
                break
        ;;
        
        "timezone")
                change_timezone
                break
        ;;
        
        "selinux")
                disable_selinux
                break
        ;;
        
        *)
                echo " parameter 1 must be all | user | firewall |name |root pass | net"
                echo "when set net or name  you must specify ip address or hostname as parameter 2 "
esac



