#!/bin/bash 

virt-install   --name cs11-176-SQLserver  --network bridge:br0  --ram=16384 --vcpus=2   --disk path=/data/vm-images/cs11-176-SQLserver.img,size=80  --graphics vnc  --cdrom /data/system-iso/windows_2008_R2_x64.iso 



