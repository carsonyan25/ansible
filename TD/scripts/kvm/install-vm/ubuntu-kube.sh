#!/bin/bash 

virt-install   --name  ub-11-151  --network bridge:br0  --ram=8192 --vcpus=4  --disk path=/data/vm-images/ub-11-151.img,size=1000  --location /data/system-iso/ubuntu-16.04.2-server-amd64.iso  --vnc --vncport=5911  --vnclisten=0.0.0.0



