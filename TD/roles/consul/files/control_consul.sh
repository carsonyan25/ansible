#!/bin/bash
# this script use to start reload or stop consul server

option=$1
consul_bin=/data/consul/consul

function start_consul(){
	${consul_bin} agent   \
	    -enable-script-checks=true  -config-dir=/etc/consul.d  -join=consul-1.tuandai800.cn  -join=consul-2.tuandai800.cn  -join=consul-3.tuandai800.cn  >> /data/consul/logs/consul.log 2>&1  &
}

function stop_consul(){
	#${consul_bin} leave -token=jwomppwennpw88233mcnow392welg 
	${consul_bin} leave 
}

function reload_consul(){
	#${consul_bin} reload -token=jwomppwennpw88233mcnow392welg
	${consul_bin} reload 
}

case ${option} in 
	
	'start')
		start_consul
		;;
	'stop')
		stop_consul
		;;
	'reload')
		reload_consul
		;;
         *)
		echo "parameter must be start | stop | reload"
		;;	
esac

