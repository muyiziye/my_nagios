#!/bin/bash
#########################################################################
# File Name: check_mem.sh
# Author: liuyang91
# mail: liu-yang91@qq.com
# Created Time: Sat Apr 18 09:28:11 2020
#########################################################################

function help {
    echo -e "\nUseage: This plugin shows the % of used MEM, using tool free\n
    -w <integer>\tIf the % of used MEM is below CRITICAL and above WARN, returns WARN state\n
    -c <integer>\tIf the % of used MEM is above CRITICAL, returns CRITICAL state\n"
    exit -1
}


while getopts "w:c:h" OPT; do
    case $OPT in
        "w") warn=$OPTARG;;
        "c") critical=$OPTARG;;
        "h") help;;
    esac
done

# Checking parameters:
( [ "$warn"x == ""x ] || [ "$critical"x == ""x ] ) && echo "ERROR: You must specify warn and critical levels" && help
[[ "$warn" -ge  "$critical" ]] && echo "ERROR: critical level must be highter than warn level" && help


#free -m
#           total       used        free      shared  buff/cache   available
#Mem:       6913        3112        1675         200        2124        3347
#Swap:      2047           0        2047

total=`free -m | sed -n '2p' | awk '{print $2}'`
used=`free -m| sed -n '2p' | awk '{print $3}'`
free=`free -m| sed -n '2p' | awk '{print $4}'`

let "c=$used*100/$total"
if [[ $c -lt $warn ]]
then
    echo "MEM OK - used:${used}MB($c%) | free=${c}%;${warn};${critical};0;100"
    exit 0
elif [[ $c -lt $critical ]]
then
    echo "MEM Warning - used:${used}MB($c%) | free=${c}%;${warn};${critical};0;100"
    exit 1
else
    echo "MEM Critical - used:${used}MB($c%) | free=${c}%;${warn};${critical};0;100"
    exit 2
fi 
