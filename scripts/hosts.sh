#!/bin/bash

host="elb.pi.wso2.com"
flag=`curl -u wso2@azeez.org:hellohoneybunny "http://appserver.stratoslive.wso2.com/t/azeez.org/webapps/rpi/secure/kv?key=$host"`
echo $flag
sed "s/RRELBRR/${flag}/" /etc/hosts.org > /etc/hosts


