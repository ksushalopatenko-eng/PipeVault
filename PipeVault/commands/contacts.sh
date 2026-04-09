#!/bin/sh

case "$1" in
    add)
        if [ $# -lt 3 ]; then
            echo "Usage: pipevault contacts add [name] [address]"
            exit 1
        fi
        if awk -v name="$2" '$2 == name {found=1} END {exit !found}' datafiles/contacts.tsv; then
            echo "Contact $2 already exists"
            exit 1
        fi
        next_id=$(wc -l < datafiles/contacts.tsv)
        printf "%-5s\t%-15s\t%-40s\n" "$next_id" "$2" "$3" >> datafiles/contacts.tsv
        echo "Contact $2 added with ID $next_id"
        ;;
    delete)
        if [ $# -lt 2 ]; then
            echo "Usage: pipevault contacts delete [name or ID]"
            exit 1
        fi
        if echo "$2" | grep -qE '^[0-9]+$'; then
            if ! awk -v id="$2" '$1 == id {found=1} END {exit !found}' datafiles/contacts.tsv; then
                echo "Contact with ID $2 not found"
                exit 1
            fi
            awk -v id="$2" '$1 != id' datafiles/contacts.tsv > temp/contacts.tmp
        else
            if ! awk -v name="$2" '$2 == name {found=1} END {exit !found}' datafiles/contacts.tsv; then
                echo "Contact $2 not found"
                exit 1
            fi
            awk -v name="$2" '$2 != name' datafiles/contacts.tsv > temp/contacts.tmp
        fi
        mv temp/contacts.tmp datafiles/contacts.tsv
        awk 'NR==1 { print; next } { printf "%-5s\t%-15s\t%-40s\n", NR-1, $2, $3 }' datafiles/contacts.tsv > temp/contacts.tmp
        mv temp/contacts.tmp datafiles/contacts.tsv
        echo "Contact $2 deleted"
        ;;
    edit)
        if [ $# -lt 4 ]; then
            echo "Usage: pipevault contacts edit [name] [new_name] [new_address]"
            exit 1
        fi
        if ! awk -v name="$2" '$2 == name {found=1} END {exit !found}' datafiles/contacts.tsv; then
            echo "Contact $2 not found"
            exit 1
        fi
        awk -v old="$2" -v new_name="$3" -v new_addr="$4" '
            $2 == old { printf "%-5s\t%-15s\t%-40s\n", $1, new_name, new_addr; next }
            { print }
        ' datafiles/contacts.tsv > temp/contacts.tmp && mv temp/contacts.tmp datafiles/contacts.tsv
        echo "Contact $2 updated"
        ;;
    list)
        cat datafiles/contacts.tsv
        ;;
    *)
        echo "Usage: pipevault contacts [add|delete|edit|list]"
        exit 1
        ;;
esac
