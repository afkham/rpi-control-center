#!/bin/bash

pp=`uptime | awk '{print $10}'`
qq=`echo $pp | sed 's/,//g'`
echo $qq
mac=`/sbin/ifconfig | grep 'eth0' | tr -s ' ' | cut -d ' ' -f5`
ip=`/sbin/ifconfig \
   | grep '\<inet\>' \
   | sed -n '1p' \
   | tr -s ' ' \
   | cut -d ' ' -f3 \
   | cut -d ':' -f2`
pre_json=`/usr/bin/python /home/pi/monitor.py`
#json=`echo ${pre_json} |sed 's/%//g' | sed "s/RRMACRR/${mac}/g" |sed "s/RRIPRR/${ip}/g" | sed "s/'/\"/g"`
json=`echo ${pre_json} |sed 's/%//g' | sed "s/RRMACRR/${mac}/g" |sed "s/RRIPRR/${ip}/g" | sed "s/'/\"/g" | sed "s/RRCPURR/${qq}/g"`
#json=`echo ${pre_json} |sed 's/%//g' | sed "s/RRIPRR/${ip}/g" | sed "s/'/\"/g" | sed 's/RRMACRR/b8:27:eb:30:b0:5f/g' | sed "s/RRCPURR/${qq}/g"`
#echo $json
output=`curl -u 'wso2@azeez.org:hellohoneybunny' -d "info=${json}" -i http://appserver.stratoslive.wso2.com/t/azeez.org/webapps/rpi/secure/updatepi`
echo $output
