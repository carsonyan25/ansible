#!/bin/bash

 if ! echo $PATH | /bin/grep -q /data/consul ; then
        PATH=${PATH}:/data/consul
 fi

export PATH

