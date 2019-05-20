#!/bin/bash

node_name=$1
node_ip=$2
log_dir=/data/install_logs
log_file=$log_dir/`date +%F`.log

mkdir -p $log_dir

function install_ceph(){
	#配置环境变量使用阿里云的源
	export CEPH_DEPLOY_GPG_URL=http://mirrors.aliyun.com/ceph/keys/release.asc
	export CEPH_DEPLOY_REPO_URL=http://mirrors.aliyun.com/ceph/rpm-luminous/el7/

	#设置无密码访问node
	echo "$2 $1" >> /etc/hosts
	/usr/local/bin/auto_login.sh $1
	
	#将新添加的节点写入hosts并同步
	if [ $? -eq 0 ]
	then
		/usr/bin/scp /etc/hosts $1:/etc/
	else
		echo 111 && exit
	fi
	
	#安装ceph
	cd /home/ceph/
	ceph-deploy install $1

	#复制配置文件到节点
	cd /home/ceph/
	ceph-deploy admin $1

	#检查集群:
	ceph -s
}

if install_ceph $node_name $node_ip > $log_file 2>&1
then
	echo 100
else
	echo 111 && exit
fi
