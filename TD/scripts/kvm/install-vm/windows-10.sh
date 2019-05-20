#!/bin/bash 

host="win11-224-win10"

virt-install   --name ${host}  --network bridge:br0  --ram=4096 --vcpus=2   --disk path=/data/vm-images/${host}.img,size=100  --graphics vnc  --cdrom /data/system-iso/cn_windows_10_multiple_editions_version_1511_x64_dvd_7223622.iso



