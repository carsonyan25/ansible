#!/usr/bin/python
# this script use to check openfalcon module  service

import subprocess

def check_module(module_path):

    result=subprocess.check_output("cd " + module_path  +  " && ./open-falcon check ", stderr=subprocess.STDOUT,shell=True)
    #when openfalcon's module is down , result is not equal -1
    if result.find('DOWN') == -1  :
            pass
        else:
            subprocess.call("cd  " + module_path  +  " && ./open-falcon restart ", shell=True)

