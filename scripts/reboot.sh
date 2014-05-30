#!/bin/bash

mac=`/sbin/ifconfig | grep 'eth0' | tr -s ' ' | cut -d ' ' -f5`
echo $mac
flag=`curl -u wso2@azeez.org:hellohoneybunny "http://appserver.stratoslive.wso2.com/t/azeez.org/webapps/rpi/secure/reboot?mymac=$mac"`
echo $flag
if [ $flag = "true" ]; then
reboot
fi
