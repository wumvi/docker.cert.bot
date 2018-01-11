#!/bin/bash

source /lib-utils

echo 'Run all'
/multi-tail.sh $LOG_FILES
cron &

echo 'Wait SIGTERM or SIGINT'
wait_signal

echo 'Call stop'
pkill -x tail
pkill -x cron

echo 'Wait stop'
wait_exit "cron tail"