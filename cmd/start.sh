#!/bin/bash

STOP_REQUESTED=false
trap "STOP_REQUESTED=true" TERM INT SIGTERM

wait_signal() {
    while ! $STOP_REQUESTED; do
        sleep 1
    done
}

wait_exit() {
    while pidof $1; do
        sleep 1
    done
}

/etc/init.d/cron start
wait_signal
/etc/init.d/cron stop
wait_exit "cron"