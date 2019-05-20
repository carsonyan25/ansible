#!/usr/bin/python
# this script use to generate ssh key ,
# write new public key to centos and root user,
# upload ssh key pair to key server(NFS)

from subprocess import call as subcall
from subprocess import check_output
from datetime import date
import commands
import sys

class KeyManager:
    def __init__(self,init=False):
        try:
            int(init)
        except ValueError :
            init=0
        finally:
            if int(init) >= 1 :
                self.init=True
            else:
                self.init=False
#        print("self.init value",self.init)

    def generate(self):
        cur_date_str = date.today().strftime("%Y-%m-%d")
        self.hostname = check_output(['hostname', '-s']).strip('\n')
        self.key_file = "/tmp/%s_%s" % (self.hostname, cur_date_str)
        self.key_pub = self.key_file + ".pub"
        subcall("rm -f %s*  " % (self.key_file), shell=True)
        subcall(
            'ssh-keygen   -b 2048 -t rsa  -f %s  -q -N ""' %
            (self.key_file), shell=True)
        subcall("mv  %s   %s.pri " %(self.key_file,self.key_file), shell=True)
        # print new ssh key pair name , for debug use
        print("{}.pri".format(self.key_file), "---", self.key_pub)

    def write(self):
        centos_auth_key = "/home/centos/.ssh/authorized_keys"
        centos_pub = "/home/centos/.ssh/id_rsa.pub"
        root_auth_key = "/root/.ssh/authorized_keys"
        root_pub = "/root/.ssh/id_rsa.pub"
        # delete old  public key on  centos and root user
        subcall("sed -i s/.*%s.*//g  %s"%(self.hostname,centos_auth_key),shell=True)
        subcall("sed -i s/.*%s.*//g  %s"%(self.hostname,root_auth_key),shell=True)

	# write new public key on centos and root user
	if self.init is True : 
            subcall("cat %s > %s " % (self.key_pub, centos_auth_key), shell=True)
            subcall("cat %s > %s " % (self.key_pub, root_auth_key), shell=True)
	else:
            subcall("cat %s >> %s " % (self.key_pub, centos_auth_key), shell=True)
            subcall("cat %s >> %s " % (self.key_pub, root_auth_key), shell=True)

        subcall("cat %s > %s " % (self.key_pub, centos_pub), shell=True)
        subcall("cat %s > %s " % (self.key_pub, root_pub), shell=True)

        # change access mode for centos and root public file
        subcall("chmod 600 %s && chmod 600 %s " %
                (centos_auth_key, centos_pub), shell=True)
        subcall(
            "chmod 600 %s && chmod 600 %s " %
            (root_auth_key, root_pub), shell=True)

        # delete temp ssh key file
        subcall("rm -f %s* " % (self.key_file), shell=True)

    def upload(self):
        dest = "/mnt/key-files"
        # mount key-file server(nfs server)
        subcall(
            " mkdir -p %s && mount -t nfs  nfs.tuandai800.cn:/nfs-data/samba/server-key-files %s" %
            (dest, dest), shell=True)
        # copy ssh key files to  nfs server
        subcall("cp -f %s*  %s/openstack-vm-keys " % (self.key_file, dest), shell=True)
        umount_result=commands.getstatusoutput("umount  %s"%(dest))
        if umount_result[0] == 0 :
            commands.getoutput("rm -fr %s"%(dest))
        else :
            print("can't umount nfs.tuandai800.cn:/nfs-data/samba/server-key-files , umount it manaully")
            exit(3)


if __name__ == '__main__' :
    try:
        init=sys.argv[1]
    except IndexError :
        init=0
    finally:
        key = KeyManager(init)
        key.generate()
        key.upload()
        key.write()


