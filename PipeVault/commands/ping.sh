#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: pipevault ping [name or address]"
    exit 1
fi

# same logic as send.sh
case "$1" in
    *@*) address="$1"
         name="Name not specified" ;;
    *)   address=$(grep "$1" datafiles/contacts.tsv | awk '{print $3}')
         name="$1"
         if [ -z "$address" ]; then
             echo "Contact $1 not found in contacts"
             exit 1
         fi ;;
esac

if ssh -q -o ConnectTimeout=5 -o BatchMode=yes "$address" exit; then
    echo "$name $address is online!"
else
    echo "Can't reach $name $address"
fi
