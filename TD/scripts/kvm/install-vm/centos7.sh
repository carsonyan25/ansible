#!/bin/bash 

virt-install   --name cs-temp  --network bridge:br0  --ram=8192 --vcpus=4  --disk path=/data/vm-images/cs-temp.img,size=120  --location /data/system-iso/CentOS-7-x86_64-Minimal-1708.iso  --vnc  --vnclisten=0.0.0.0



