#!/bin/bash 

host="cs11-198-win2008"

virt-install   --name ${host}  --network bridge:br0  --ram=4096 --vcpus=2   --disk path=/data/vm-images/${host}.img,size=100  --graphics vnc  --cdrom /data/system-iso/windows_2008_R2_x64.iso



