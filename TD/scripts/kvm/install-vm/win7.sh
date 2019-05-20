#!/bin/bash 

virt-install   --name win7-temp  --network bridge:br0  --ram=6144 --vcpus=2   --disk path=/data/vm-images/win7-temp.img,size=100  --graphics vnc  --cdrom /data/system-iso/cn_windows_7_ultimate_with_sp1_x64_dvd_u_677408.iso



