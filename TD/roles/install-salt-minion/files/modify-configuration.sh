#!/bin/bash
#this script used to modify salt-minion configuration
#created by carson


IDNAME=`hostname | cut -d '.' -f 1`
sed -i 's/^#master: salt/master: salt-master.tuandai800.cn/' /etc/salt/minion
sed -i "s/^#id:/id: $IDNAME/" /etc/salt/minion
