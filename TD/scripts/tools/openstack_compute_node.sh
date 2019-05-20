#!/bin/bash

node_name=$1
log_dir=/data/install_logs
log_file=$log_dir/`date +%F`.log

#在配置文件中写入node
sed -i "10 a${node_name}" /home/openstack-cluster

function install_openstack(){
	#环境检查
	/usr/bin/kolla-ansible prechecks -i /home/openstack-cluster > /dev/null 2>&1

	#正式部署
	if [ $? -eq 0 ]
	then
		/usr/bin/kolla-ansible deploy -i /home/openstack-cluster && sleep 10s && /bin/bash /home/set_neutron.sh
	else
		echo 111 && exit
	fi
}

install_openstack > $log_file 2>&1

if [ $? -eq 0 ]
then
	echo 100
else
	echo 111
fi
