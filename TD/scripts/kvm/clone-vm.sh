#!/bin/bash

original=$2
target=$3

full(){
	virt-clone --name ${target}  --original ${original}  --file /data/vm-images/${target}.img
}


preserve(){
	virt-clone --name ${target}  --original ${original}  --preserve-data --file /data/vm-images/${target}.img
}

case $1 in 
	
	'full') 
		full
		break
		;;

	'preserve')
		preserve
		break
		;;
	
	*)
		echo "parameter 1 must be full | preserve"

esac
