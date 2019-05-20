#!/bin/bash

#此脚本为openstack私有云--centos虚拟机定制化脚本
#主要进行以下处理
#标准化实例,禁用selinux,优化内核参数，更改时区，设置root密码为TDtest123
#标准化实例，部署小米监控客户端和jdk环境
#标准化实例，注入centos公钥至这root账号，允许root远程登录，设置sshd安全性
#安装需要的应用包
#自动重启实例


function standardize_instance(){

#标准化实例脚本
#安装epel包,ansible及相关工具包
yum install -y epel-release  
yum install -y ansible git
yum install -y python-pip python-netaddr
pip install --upgrade pip  

git clone http://git.tuandai888.com/yangpeigen/ansible.git  /data/ansible 
cd /data/ansible/roles
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i inventory/inventory.cfg init.yaml -e sshd_port=22522  --limit localhost

ansible-playbook -i inventory/inventory.cfg java-server.yaml   --limit localhost
    
}


function reboot_instance(){
    
    #清除ansible环境并重启实例
    rm -fr /data/ansible 
    shutdown --reboot  --no-wall +2
}




function install_nginx(){
    
    #安装额外应用包
    yum install -y nginx 
    systemctl enable nginx
}


function install_mysql(){

# 安装二进制版的mysql，版本5.7.18，生成ssl-rsa证书。
# 运行了secure_installtion，提高安全性，输出mysql命令至环境，方便使用。   
# install mysql in /data/mysql
# database store in /data/database
# my.cnf store in /etc
# mysql root default password is TDmysql+123
# create test user ,has all privileges , password is JHAk+FABP4wUydBq3 
# create dev user ,has all privileges , password is 6+PcRYJrGaEITjrM 
# create repl user for REPLICATION , password is Go+GwK1nnjI1AbHsG 

    cd /data/ansible/roles
    export ANSIBLE_HOST_KEY_CHECKING=False

    # install mysql master 
    ansible-playbook -i inventory/inventory.cfg mysql.yaml  -e server=master  --limit localhost
    
     # install mysql slave
#    ansible-playbook -i inventory.cfg mysql.yaml  -e server=slave  --limit localhost

}

standardize_instance
#install_nginx
#install_mysql
reboot_instance

exit 0

