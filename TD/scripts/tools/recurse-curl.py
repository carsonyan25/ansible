#!/usr/bin/python

count=1
import commands
import time

while count < 200:
	result=commands.getoutput("curl -i http://121.13.249.210:10201") 
	print(result)
	count = count + 1
	time.sleep(1)



