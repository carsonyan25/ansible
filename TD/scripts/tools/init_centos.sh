#!/bin/bash

log_dir=/data/install_logs
log_file=$log_dir/`date +%F`.log

mkdir -p $log_dir

function init_node(){
#关闭selinux
/usr/sbin/selinuxenabled
if [ $? -ne 0 ]
then 
	/usr/sbin/getenforce
else 
	setenforce 0
	sed -i s/enforcing/disabled/g /etc/selinux/config
fi

#关闭防火墙
systemctl disable firewalld && systemctl stop firewalld && systemctl status firewalld

#安装epel源
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

#同步时间
yum install -y chrony
sed -i s/0.centos.pool.ntp.org/time1.aliyun.com/g /etc/chrony.conf
sed -i s/1.centos.pool.ntp.org/time2.aliyun.com/g /etc/chrony.conf
sed -i s/2.centos.pool.ntp.org/time3.aliyun.com/g /etc/chrony.conf
sed -i s/3.centos.pool.ntp.org/time4.aliyun.com/g /etc/chrony.conf
systemctl restart chronyd
sleep 5s && chronyc sources

#ssh端口改为22522
sed -i s/#Port/Port/g /etc/ssh/sshd_config
sed -i s/22/22522/g /etc/ssh/sshd_config
systemctl restart sshd

#设置密钥
mkdir -p /root/.ssh && mkdir -p /home/test/.ssh
chmod 700 /root/.ssh && chmod 700 /home/test/.ssh
wget -O /root/.ssh/authorized_keys http://pkg.tuandai888.com/ssh-key/openstack/host-keys/openstack_root.pub
wget -O /home/test/.ssh/authorized_keys http://pkg.tuandai888.com/ssh-key/openstack/host-keys/openstack_test.pub
chown -R test.test /home/test

#给磁盘打标签
for i in `ls /dev/sd* |grep -v sda|grep -v [0-9]`
do
	/usr/sbin/parted $i mklabel gpt && /usr/sbin/parted $i print
done

#安装docker
wget -q http://pkg.tuandai888.com/packages/docker-1.12.6/docker-engine-1.12.6-1.el7.centos.x86_64.rpm
wget -q http://pkg.tuandai888.com/packages/docker-1.12.6/docker-engine-selinux-1.12.6-1.el7.centos.noarch.rpm
yum localinstall -y docker-engine-1.12.6-1.el7.centos.x86_64.rpm docker-engine-selinux-1.12.6-1.el7.centos.noarch.rpm
rm -f docker-engine-1.12.6-1.el7.centos.x86_64.rpm docker-engine-selinux-1.12.6-1.el7.centos.noarch.rpm

#设置docker
mkdir /etc/systemd/system/docker.service.d 
tee /etc/systemd/system/docker.service.d/kolla.conf << 'EOF' 
[Service] 
MountFlags=shared 
EOF

#设置访问私有的Docker仓库
sed -i s/^ExecStart/#ExecStart/g /usr/lib/systemd/system/docker.service
sed -i '11 aExecStart=/usr/bin/dockerd --insecure-registry op:4000' /usr/lib/systemd/system/docker.service
systemctl daemon-reload && systemctl enable docker && systemctl restart docker

#安装依赖包
yum install -y python-devel libffi-devel gcc openssl-devel git python-pip qemu-kvm qemu-img

#升级pip以及安装docker模块
pip install -U pip -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install docker --ignore-installed docker
}

if init_node > $log_file 2>&1
then
	echo 100
else
	echo 111 && exit
fi
