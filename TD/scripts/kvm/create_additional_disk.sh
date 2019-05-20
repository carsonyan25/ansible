#!/bin/bash


qemu-img create -f qcow2 /data/vm-images/cs12-88-bigdata-add.img  400G
qemu-img create -f qcow2 /data/vm-images/cs12-90-bigdata-add.img  400G
qemu-img create -f qcow2 /data/vm-images/cs12-91-bigdata-add.img  400G

if [ $? -eq 0 ] ; then 
	echo "create additional disk successfully"
fi

