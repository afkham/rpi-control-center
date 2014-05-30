#!/bin/bash

if ps aux | grep switch.py | grep python ; then
        echo "found"
else
        python /home/pi/switch.py & >> /dev/null
fi
