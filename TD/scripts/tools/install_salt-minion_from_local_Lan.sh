#!/bin/bash

##  install satl-minnion from local repo


cat <<ENDOF > /etc/yum.repos.d/salt-latest.repo
[salt-latest]
name=SaltStack Latest Release Channel for RHEL/Centos \$releasever
baseurl=http://mirrors.bujidele.com/saltstack/redhat/\$releasever/\$basearch/latest
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/saltstack-signing-key
ENDOF


## import saltstack-signing-key
cat <<ENDOF > /etc/pki/rpm-gpg/saltstack-signing-key
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.22 (GNU/Linux)

mQENBFOpvpgBCADkP656H41i8fpplEEB8IeLhugyC2rTEwwSclb8tQNYtUiGdna9
m38kb0OS2DDrEdtdQb2hWCnswxaAkUunb2qq18vd3dBvlnI+C4/xu5ksZZkRj+fW
tArNR18V+2jkwcG26m8AxIrT+m4M6/bgnSfHTBtT5adNfVcTHqiT1JtCbQcXmwVw
WbqS6v/LhcsBE//SHne4uBCK/GHxZHhQ5jz5h+3vWeV4gvxS3Xu6v1IlIpLDwUts
kT1DumfynYnnZmWTGc6SYyIFXTPJLtnoWDb9OBdWgZxXfHEcBsKGha+bXO+m2tHA
gNneN9i5f8oNxo5njrL8jkCckOpNpng18BKXABEBAAG0MlNhbHRTdGFjayBQYWNr
YWdpbmcgVGVhbSA8cGFja2FnaW5nQHNhbHRzdGFjay5jb20+iQE4BBMBAgAiBQJT
qb6YAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAOCKFJ3le/vhkqB/0Q
WzELZf4d87WApzolLG+zpsJKtt/ueXL1W1KA7JILhXB1uyvVORt8uA9FjmE083o1
yE66wCya7V8hjNn2lkLXboOUd1UTErlRg1GYbIt++VPscTxHxwpjDGxDB1/fiX2o
nK5SEpuj4IeIPJVE/uLNAwZyfX8DArLVJ5h8lknwiHlQLGlnOu9ulEAejwAKt9CU
4oYTszYM4xrbtjB/fR+mPnYh2fBoQO4d/NQiejIEyd9IEEMd/03AJQBuMux62tjA
/NwvQ9eqNgLw9NisFNHRWtP4jhAOsshv1WW+zPzu3ozoO+lLHixUIz7fqRk38q8Q
9oNR31KvrkSNrFbA3D89uQENBFOpvpgBCADJ79iH10AfAfpTBEQwa6vzUI3Eltqb
9aZ0xbZV8V/8pnuU7rqM7Z+nJgldibFk4gFG2bHCG1C5aEH/FmcOMvTKDhJSFQUx
uhgxttMArXm2c22OSy1hpsnVG68G32Nag/QFEJ++3hNnbyGZpHnPiYgej3FrerQJ
zv456wIsxRDMvJ1NZQB3twoCqwapC6FJE2hukSdWB5yCYpWlZJXBKzlYz/gwD/Fr
GL578WrLhKw3UvnJmlpqQaDKwmV2s7MsoZogC6wkHE92kGPG2GmoRD3ALjmCvN1E
PsIsQGnwpcXsRpYVCoW7e2nW4wUf7IkFZ94yOCmUq6WreWI4NggRcFC5ABEBAAGJ
AR8EGAECAAkFAlOpvpgCGwwACgkQDgihSd5Xv74/NggA08kEdBkiWWwJZUZEy7cK
WWcgjnRuOHd4rPeT+vQbOWGu6x4bxuVf9aTiYkf7ZjVF2lPn97EXOEGFWPZeZbH4
vdRFH9jMtP+rrLt6+3c9j0M8SIJYwBL1+CNpEC/BuHj/Ra/cmnG5ZNhYebm76h5f
T9iPW9fFww36FzFka4VPlvA4oB7ebBtquFg3sdQNU/MmTVV4jPFWXxh4oRDDR+8N
1bcPnbB11b5ary99F/mqr7RgQ+YFF0uKRE3SKa7a+6cIuHEZ7Za+zhPaQlzAOZlx
fuBmScum8uQTrEF5+Um5zkwC7EXTdH1co/+/V/fpOtxIg4XO4kcugZefVm5ERfVS
MA==
=dtMN
-----END PGP PUBLIC KEY BLOCK-----
ENDOF

yum clean all 
yum makecache fast 


yum -y install salt-minion

sed -i 's/^#master: salt/master: salt-master.tuandai800.cn/' /etc/salt/minion
rpm -qa |grep salt-minion

if [[ $? != 0 ]]; then
    
    # 判断版本

	uname -r |grep ^3
    if [[ $? != 0 ]]; then
	
 	 service salt-minion start
 	 chkconfig --add salt-minion 
  	chkconfig salt-minion on 
   else
#      # centos 7
     systemctl start salt-minion
     systemctl enable salt-minion
   fi
fi

echo "install salt yum repos success"

