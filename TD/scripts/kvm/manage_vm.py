#!/usr/bin/python

import commands

class VM_MANAGE:

        def __init__(self):
                self.vm_list=''
                pass

        def get_vm_list(self):
                vm_string=commands.getoutput(" virsh list --all | awk '{print $2}' | grep -Ev '(cs-temp|win-temp|win7-temp|Name)' " )
                vm_string=vm_string.strip()
                self.vm_list=vm_string.split('\n')

        def set_autostart(self):
                for vm in self.vm_list:
                        result=commands.getstatusoutput(" virsh autostart %s " %vm )
                        if result[0]==0 :
                                pass
                        else :
                                print("failed to set %s to autostart" %vm)


        def check_autostart(self):
                autostart_list=commands.getoutput(" virsh list --autostart ")
                vm_list=commands.getoutput(" virsh list --all ")
                print(autostart_list)
                print(vm_list)





opt=VM_MANAGE()
opt.get_vm_list()
opt.set_autostart()
opt.check_autostart()

