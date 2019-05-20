#!/usr/bin/python
#this script used to run temp task for all Host and VMs

from subprocess import check_output as sub_output
from time import sleep
from glob import glob as GLOB
from sys import argv
import threading
import subprocess

# A class which run ansilbe task in async
class AsyncAnsible(threading.Thread):

    def __init__(self,inventory_file,module_name,module_argu,fork_num):
        super(AsyncAnsible,self).__init__()
        self.inventory_file = inventory_file
        self.module_name = module_name
        self.module_argu = " ' " + module_argu + " ' "
        self.fork_num = fork_num

# run ansible task with some arguments
    def run(self):
        print("---run ansible task now!---")
        self.ansible_full_cmd="ansible  all -i " +  self.inventory_file + " -m " + self.module_name + " -a " + self.module_argu + " --fork " + self.fork_num
        print("ansible full command is %s" %self.ansible_full_cmd )
        self.run_result=sub_output(self.ansible_full_cmd ,stderr=subprocess.STDOUT ,shell=True )
        print(str(self.run_result),'\n\n','----------------Next Inventory-----------------------','\n')
        sleep(2)  


def main_task(m_name,m_argu,f_num):
    inventory_list = [ x for x in GLOB('./inventory/openstack*')]
    print("inventory_list is %s " %inventory_list)
    for i_file in inventory_list :
        ansible_task=AsyncAnsible(inventory_file=i_file, module_name=m_name , module_argu=m_argu, fork_num=f_num)
        ansible_task.start()
	break
#        ansible_task.join()


if __name__ == '__main__' :
    if argv.__len__() <=3 :
	print(argv.__len__()) 
        module_argu_list=[ str(i) for i in argv[3:]]
        module_argu_str = ' '.join(module_argu_list)
        print(module_argu_str)
        
        print('input 3 or more arguments for use , script_name  fork_num  module_name  module_argu ') 
    else:
        module_argu_list=[ str(i) for i in argv[3:]]
        module_argu_str = ' '.join(module_argu_list)
        main_task(m_name=argv[2],  m_argu=module_argu_str,  f_num=argv[1])

