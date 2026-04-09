#!/bin/sh
if [ $# -lt 1 ]; then
    echo "Usage: pipevault ping [name or address]"
    exit 1
fi

case "$1" in
    *@*)           address="$1"
                   name="Name not specified" ;;
    [0-9]*.*.*.*)  address="$1"
                   name="$1" ;;
    *)             address=$(awk -v name="$1" '$2 == name {print $3}' datafiles/contacts.tsv)
                   name="$1"
                   if [ -z "$address" ]; then
                       echo "Contact $1 not found in contacts"
                       exit 1
                   fi ;;
esac

case "$address" in
    [0-9]*.*.*.*)
        if ping -c 1 -W 3 "$address" > /dev/null 2>&1; then
            echo "$address is online!"
        else
            echo "Can't reach $address"
        fi ;;
    *)
        if ssh -q -o ConnectTimeout=5 -o BatchMode=yes "$address" exit; then
            echo "$name $address is online!"
        else
            echo "Can't reach $name $address"
        fi ;;
esac
