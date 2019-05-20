#!/bin/bash
#this script use to standardize linux

insert_ansible_server_pubkey(){
    
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBN0KHVaaneIJawFBvsDCGGjRczajMjdJXvPk0j8C413+jtoAt+6A3Pt5DvuZ2UZBTdQou3m4nBcCn2mWrnyIE+r9rriwewhL8eZWcOV7x8QqbcK8Z5LVmROGAGp6g7V9Sk8AVwwIc51UruM0lAmJH/yUCZtciI+X57beo3qebhftutJeRjjxixIFTptZdcL39T9OJTPiyhCEsp8eA5NLdNiSR+/zczSkLgLPlNk+WsfETO1A7o+21IbHEjGQQVTIdif2xtb2wyIc9Y5qVg0cN5Zt2ypIuz1jHWJicQDCmkeJ+2fc5BzJOKA/a67MmFLgzzTREW0vCyj32EzxZG8vL pubkey-from-10.100.14.47-ansible"  >> /home/centos/.ssh/authorized_keys
}

insert_root_pubkey(){
    
    CURRENT_ROOT_PUBKEY=` curl http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key `
    
    echo "${CURRENT_ROOT_PUBKEY}" > /root/.ssh/authorized_keys

    chmod 600 /root/.ssh/authorized_keys
    
}


change_root_password(){
    root_pass="TDtest123"
    echo "$root_pass" | passwd --stdin root
    echo "root's password is $root_pass"
    
}

change_centos_password(){
    centos_pass="TDtest123"
    echo "$centos_pass" | passwd --stdin centos
    echo "centos's password is $centos_pass"
    
}

set_nopasswd_opt(){
	echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
}



case $1 in



        "all") 
		insert_ansible_server_pubkey
		insert_root_pubkey
                change_root_password
                change_centos_password
		set_nopasswd_opt
	;;

        "change_root_password")
		change_root_password
        ;;

                
        *)
                echo " parameter 1 must be all "
esac




