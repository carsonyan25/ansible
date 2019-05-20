#!/bin/bash
# this script use to change path in /etc/crontab
# created by carson yan 

new_path="PATH=\/sbin:\/bin:\/usr\/sbin:\/usr\/bin:\/opt\/dell\/srvadmin\/sbin:\/opt\/dell\/srvadmin\/bin"

sed -i "2s/^PATH.*$/${new_path}/g"   /etc/crontab

