#!/usr/bin/python
# this script use to check openfalcon module  service

import subprocess

def check_module(module_path, is_openfalcon=False):

    # we are checking openfalcon main module
    if is_openfalcon:
        result = subprocess.check_output(
            "cd " +
            module_path +
            " && ./open-falcon check ",
            stderr=subprocess.STDOUT,
            shell=True)
        # when openfalcon's module is down , result is not equal -1
        if result.find('DOWN') == -1:
            pass
        else:
            subprocess.call(
                "cd  " +
                module_path +
                " && ./open-falcon restart ",
                shell=True)

    # we are checking third-party module
    else:
        result = subprocess.check_output(
            "cd  " +
            module_path +
            " && ./control status ",
            stderr=subprocess.STDOUT,
            shell=True)

        # when module is down ,result is not started
        if result.strip('\n') == 'started':
            pass
        else:
            subprocess.call(
                "cd " +
                module_path +
                " && ./control start ",
                shell=True)


check_module("/data/app/openfalcon", is_openfalcon=True)
check_module("/data/app/openfalcon/urlooker/web")
check_module("/data/app/openfalcon/urlooker/agent")
check_module("/data/app/openfalcon/urlooker/alarm")
check_module("/data/app/openfalcon/mail-provider")
