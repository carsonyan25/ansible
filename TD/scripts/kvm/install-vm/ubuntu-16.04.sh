#!/bin/bash 

virt-install --accelerate  --arch=x86_64  --name ub12-103  --network model=virtio,bridge=br0  --ram=4096 --vcpus=2  --disk path=/data/vm-images/ub12-103.img,size=120,bus=virtio --os-type linux --os-variant generic  --location /data/system-iso/template/iso/ubuntu-16.04.3-server-amd64.iso  --vnc  --vnclisten=0.0.0.0



