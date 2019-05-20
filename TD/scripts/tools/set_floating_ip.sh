#/bin/bash

#此脚本只能在10.100.250.21上执行

test1=fcfb60e644734b8f89b782af31195b47
test2=19d565dcefc64e2ca5b4bfcad083e7a7
test3=e9db544167304d73ab1d79b058242237
dev=5bdc09937a144036b3d9cdaca3fe096c
opt=8ba655428ddc4a84b931fd457f856453
datacenter=03c07397a9924c22bf9e57f73821c29e
bigdata=e296864c90c84816b2e94d497ea627bb
hjzx=53fdfa34bdac44ca9dd9c37d22b1ba57
sz=0893c604247d468d8f8d3429b35e2226
k8s=661eb5867b9444a8863d004fdf58e151
admin=857b06d0012e479ba2b083796cd8c32b

echo -e "列表：\n test1=测试环境1\n test2=测试环境2\n test3=测试环境3\n dev=开发环境\n \
opt=运维环境\n datacenter=数据中心环境\n bigdata=大数据测试环境\n hjzx=呼叫中心\n sz=深圳环境\n k8s=k8s环境 \n admin=admin环境 "
read -p "请选择环境：==> " env
read -p "请选择网段：11 or 12 ==> " net
echo "请输入浮动IP地址："
read -p "==> " ip

if [ $net == "11" ]
then
	net_id=7b117d27-33f5-4b7d-a894-709c71dc6924
elif [ $net == "12" ]
then
        net_id=63a1baf0-2089-493f-9be3-3adcba7dbac7
fi

function set_ip(){
	source /etc/kolla/admin-openrc.sh
	openstack floating ip create --floating-ip-address $ip --project $1 $net_id
}

if [ $env == "test1" ]
then
	set_ip $test1
elif [ $env == "test2" ]
then
	set_ip $test2
elif [ $env == "test3" ]
then
	set_ip $test3
elif [ $env == "dev" ]
then
	set_ip $dev
elif [ $env == "opt" ]
then
	set_ip $opt
elif [ $env == "datacenter" ]
then
	set_ip $datacenter
elif [ $env == "bigdata" ]
then
	set_ip $bigdata
elif [ $env == "hjzx" ]
then
	set_ip $hjzx
elif [ $env == "sz" ]
then
	set_ip $sz
elif [ $env == "k8s" ]
then
	set_ip $k8s

elif [ $env == "admin" ]
then
        set_ip $admin
fi

exit 0
