#!/bin/bash


old_vol=$1
new_vol=$2
vol_name=$3

function install_rbd_mirror(){

    echo "[ceph-noarch]"  > /etc/yum.repos.d/Ceph.repo
    echo "name=Ceph noarch packages"   >> /etc/yum.repos.d/Ceph.repo
    echo "baseurl=http://mirrors.aliyun.com/ceph/rpm-luminous/el7/x86_64/" >> /etc/yum.repos.d/Ceph.repo
    echo "enabled=1" >> /etc/yum.repos.d/Ceph.repo
    echo "gpgcheck=0" >> /etc/yum.repos.d/Ceph.repo
    echo "type=rpm-md" >> /etc/yum.repos.d/Ceph.repo
    echo "gpgkey=http://mirrors.aliyun.com/ceph/keys/release.asc" >> /etc/yum.repos.d/Ceph.repo
    yum clean all
    yum makecache fast
    yum install -y epel-release
    yum install -y rbd-mirror
}

function delete_vol(){
    
    rbd rm -p volumes volume-$vol_name
}

function convert_vol(){
  
  qemu-img convert -f qcow2 -O raw   $old_vol  $new_vol
}

function import_to_ceph(){
    
    rbd --image-format 2 import --dest-pool volumes $new_vol volume-$vol_name
    
    if [ "$?" -eq "0" ] ; then 
        rm -f $new_vol
    else 
        echo "Failed to import ceph "
    fi
}

if [ ! -f "/usr/bin/rbd" ] ; then
    install_rbd_mirror
fi
delete_vol
#convert_vol
import_to_ceph

exit 0
