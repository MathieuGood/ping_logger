#!/bin/bash

echo "Ping Logger"
# If $1 = '' then prompt user to enter domain
# If $1 = '-h' or '--help' print help

user=`whoami`
domain=$1
if [  -d "logs" ];
then
    echo "CSV logs in "$PWD"/logs"
else
	echo "CSV logs directory created "$PWD"/logs"
    mkdir logs
    ts=`date +%Y-%m-%d`
    log_file="logs/${ts}_${domain}_ping_log.csv"
    echo "date;time;user;host;result;ttl;time" > $log_file
fi

printf "\nPing request sent to "$domain"\n"

while true; do
    ts=`date +%Y-%m-%d`
    tstamp=`date +%Y-%m-%d_%H:%M:%S`
    log_file="logs/${ts}_${domain}_ping_log.csv"
    start_time=$(date +%s)

    while true; do
        tstamp_date=$(date +%Y-%m-%d)
        tstamp_time=$(date +%H:%M:%S)
        ping_req=$(ping -c 1 $domain | grep 'icmp\|unknown')

        ping_req="${ping_req/" time="/;}"
        ping_req="${ping_req/": icmp_seq=0 ttl="/;}"
        ping_req="${ping_req/" ms"/}"

        time_and_ping="$tstamp_date;$tstamp_time;$user;$domain;$ping_req"
        echo $time_and_ping >> "$log_file"
        echo $time_and_ping

        sleep 5
        current_time=$(date +%s)
        elapsed=$((current_time - start_time))

        if (( elapsed >= 3600 )); then   
            break
        fi
    done
done
