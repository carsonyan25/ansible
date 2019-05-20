#!/bin/bash

 if ! echo $PATH | /bin/grep -q /data/mysql/bin ; then 
	PATH=${PATH}:/data/mysql/bin 
 fi 

export PATH
