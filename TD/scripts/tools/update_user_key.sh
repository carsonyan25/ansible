#!/bin/bash

PROJECT=$1
PASSWORD="TDtest123"

function update_root_key() {

    mkdir -p /root/.ssh
    wget -q -O /root/.ssh/id_rsa   http://pkg.tuandai888.com/ssh-key/openstack/$PROJECT-centos.pri
    wget -q -O /root/.ssh/id_rsa.pub   http://pkg.tuandai888.com/ssh-key/openstack/$PROJECT-centos.pub
    wget -q -O /root/.ssh/authorized_keys   http://pkg.tuandai888.com/ssh-key/openstack/$PROJECT-centos.pub
    
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/id_rsa
    chmod 600 /root/.ssh/authorized_keys
    chmod 644 /root/.ssh/id_rsa
    
}

function create_centos_key() {
    
    useradd -g wheel -c "centos user"  centos
    echo "$PASSWORD" | passwd --stdin  centos 
    mkdir -p /home/centos/.ssh
    
    wget -q -O /home/centos/.ssh/id_rsa   http://pkg.tuandai888.com/ssh-key/openstack/$PROJECT-centos.pri
    wget -q -O /home/centos/.ssh/id_rsa.pub   http://pkg.tuandai888.com/ssh-key/openstack/$PROJECT-centos.pub
    wget -q -O /home/centos/.ssh/authorized_keys   http://pkg.tuandai888.com/ssh-key/openstack/$PROJECT-centos.pub
   
    chown -R centos:wheel /home/centos/.ssh 
    chmod 700 /home/centos/.ssh
    chmod 600 /home/centos/.ssh/id_rsa
    chmod 600 /home/centos/.ssh/authorized_keys
    chmod 644 /home/centos/.ssh/id_rsa
    
}
    

update_root_key
create_centos_key
