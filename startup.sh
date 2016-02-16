#!/bin/bash
# This script puts the wireless interface in monitor mode and starts Snoopy
# Run with
#   nohup bash /home/pi/snoopy-ng/startup.sh &

sudo /usr/bin/tvservice -o

RET_DIR="$PWD";
cd $SNOOP_DIR;

if [ "$#" -gt 0 ]; then
    read -t 30 -r -p  "[?] Which battery is being used? ['white' / 'black'] " battery
    if ! [ -z $battery ]; then
        bash ./uptime.sh battery &
    fi
fi

sudo { export alias SNOOP_DIR=${SNOOP_DIR} }
mkdir -p /tmp/Snoopy/
time="date +%k%M"

if [[ $(eval "$time") -le "2200" ]] && [[ "$(eval "$time")" -gt "730" ]]; then
    at 10 PM -f ./suspend.sh         > /dev/null &

    sudo bash ./monitor_mode.sh > /dev/null &

    # Give monitor mode a chance to initailize
    sleep 15;

    sudo bash ./start_snooping.sh > ./snooping.out&
else
    sudo bash ./suspend.sh
fi

cd $RET_DIR