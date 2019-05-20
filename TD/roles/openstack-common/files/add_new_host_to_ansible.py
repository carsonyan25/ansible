#!/usr/bin/python
# this script use to add new host info to inventory on ansible server

import commands
import sys

def add_new_host(port):
    ansible_ssh_port = port
    cur_hostname = commands.getoutput('hostname -s')
    ansible_ssh_host = str(commands.getoutput(
        'curl -s  http://169.254.169.254/latest/meta-data/public-ipv4'))
    key_string=(str(commands.getoutput("curl -s http://169.254.169.254/latest/meta-data/public-keys")).split('='))[1]
    key_name=key_string.split('-')[0]
    commands.getoutput("mkdir /openstack")
    mount_result = commands.getstatusoutput(
        "mount -t  nfs nfs.tuandai800.cn:/nfs-data/samba/ansible   /openstack")
    if mount_result[0] == 0:
        file_name = "/openstack/roles/inventory/openstack-{}-inventory.cfg".format(
            key_name)
        with open(file_name, mode='a') as inventory_file:
            inventory_file.write(
                '{}  ansible_ssh_host={}       ansible_ssh_port={}  ansible_ssh_user=centos    ansible_become_user=root  ansible_become=true  ansible_ssh_private_key_file="/key-files/openstack/{}-centos.pri"\n'.format(
                    cur_hostname,
                    ansible_ssh_host,
                    ansible_ssh_port,
                    key_name))
    else:
        print(
            "can't mount nfs.tuandai800.cn:/nfs-data/samba/ansible , failed to add new host")
        exit(2)
    umount_result = commands.getstatusoutput("umount  /openstack")
    if umount_result[0] == 0:
        commands.getoutput("rm -fr  /openstack")
    else:
        print("can't umount nfs.tuandai800.cn:/nfs-data/samba/ansible, umount it manaully")
        exit(3)
    return 0


if __name__ == '__main__' :
    try:
        port=sys.argv[1]
    except IndexError :
        port=22522
    finally:
        add_new_host(port)

