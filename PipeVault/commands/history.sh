#!/bin/sh
if [ -z "$1" ]; then
    echo "Usage: pipevault log [Num_records_to_show]\n"
    cat datafiles/history.log
else
    head -n 1 datafiles/history.log
    tail -n "$1" datafiles/history.log
fi
