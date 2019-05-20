#!/bin/bash

source /data/openrc/opt-openrc.sh

#创建快照
/usr/bin/nova image-create cs-wiki cs-wiki-backup-`date +%F`

#删除镜像
id=$(/usr/bin/glance image-list |grep `date +%F`|cut -d"|" -f2|sed 's/ //g')
/usr/bin/glance image-delete $id

#删除一周前的快照
time=$(date +%F -d "1 week ago")

if /usr/bin/openstack volume snapshot list |grep -q cs-wiki-backup-$time
then
	for i in $(/usr/bin/openstack volume snapshot list |grep  cs-wiki-backup-$time|cut -d"|" -f2|sed 's/ //g')
	do
		/usr/bin/openstack volume snapshot delete $i
	done
fi

echo -e "$(date)\nwiki backup is finished"

