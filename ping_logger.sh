#!/bin/bash

user=`whoami`
domain=$1

if [ ! -n "$1" ]; then
    echo "Enter host to ping : "
    read input_domain
    domain=$input_domain
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo
    echo "Usage :"
    echo "  ping_logger.sh <domain>"
    exit 1
fi

echo "Ping Logger"

if [ -d "logs" ];
then
    echo "CSV logs in "$PWD"/logs"
else
	echo "CSV logs directory created "$PWD"/logs"
    mkdir logs
    ts=`date +%Y-%m-%d`
    log_file="logs/${ts}_${domain}_ping_log.csv"
fi

printf "\nPing request sent to "$domain"\n"

while true; do
    start_time=$(date +%s)
    tstamp_date=$(date +%Y-%m-%d)
    tstamp_time=$(date +%H:%M:%S)
    log_file="logs/${tstamp_date}_${domain}_ping_log.csv"
    if [ -f $log_file ];
    then
        echo "WOOOOHOOO File "$log_file" exists"
    else
        echo "NOOOOOOOO File "$log_file" does not exist"
        echo "date;time;user;host;result;ttl;time" > $log_file
    fi
    ping_req=$(ping -c 1 $domain | grep 'icmp\|unknown')
    # If ping_req gives error, redirect error to file
    ping_req="${ping_req/" time="/;}"
    ping_req="${ping_req/": icmp_seq=0 ttl="/;}"
    ping_req="${ping_req/" ms"/}"

    time_and_ping="$tstamp_date;$tstamp_time;$user;$domain;$ping_req"
    echo $time_and_ping >> "$log_file"
    echo $time_and_ping

    sleep 5
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

done
