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

set_nopasswd_opt(){
	echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
}

change_timezone(){
    rm -f /etc/localtime
    cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime 
}

set_kernel(){
	echo "*	soft	nofile	65535" >> /etc/security/limits.conf
	echo "*	hard	nofile	65535" >> /etc/security/limits.conf
	echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
	echo "net.core.rmem_max=1048576"  >> /etc/sysctl.conf
	echo "net.core.wmem_max=1048576" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_rmem=4096 87380 1048576" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_wmem=4096 65536 1048576" >> /etc/sysctl.conf
	echo "net.core.netdev_max_backlog=30000" >> /etc/sysctl.conf
	echo "net.core.somaxconn = 10240" >> /etc/sysctl.conf
	echo "kernel.msgmni = 1024" >> /etc/sysctl.conf
	echo "kernel.sem = 250 256000 32 1024" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_tw_recycle=1" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_tw_reuse=1" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_fin_timeout=30" >> /etc/sysctl.conf
	sysctl -p
}



case $1 in

        "all")
                change_timezone
               # disable_firewall
		disable_selinux
		set_nopasswd_opt
                create_test_user
                change_root_password
          	set_kernel      
        ;;

        "user")
                create_test_user
                
        ;;

        "firewall")
                disable_firewall
                
        ;;
        
        
        "root_pass")
                change_root_password
                
        ;;
        
        
        "timezone")
                change_timezone
                
        ;;
        
        "selinux")
                disable_selinux
                
        ;;
        
        *)
                echo " parameter 1 must be all | user | firewall |name |root pass "
                echo "when set net or name  you must specify ip address or hostname as parameter 2 "
esac




