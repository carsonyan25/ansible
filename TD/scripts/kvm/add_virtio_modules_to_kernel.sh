#!/bin/bash
#this script is use to add virtio modules in initramfs image
#after that the VM machine would load the virtio modules on boot system
#for Esxi VM's migrate to KVM  especially 

add_virtio() {
dracut --add-drivers "virtio_pci virtio_blk virtio_scsi virtio_net" --force -v 
}

verify_virtio() {
    
   lsinitrd | grep virtio
}

add_virtio
verify_virtio

