#!/bin/sh
case "$1" in
    add)

        if [ $# -lt 3 ]; then
            echo "Usage: pipevault contacts add [name] [address]"
            exit 1
        fi
        # check for duplicate
        if grep -q "$2" datafiles/contacts.tsv; then
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
        if ! grep -q "$2" datafiles/contacts.tsv; then
            echo "Contact $2 not found"
            exit 1
        fi

	#can somebody have a look with deleting, is there a way to delete line from grep?
        grep -v "$2" datafiles/contacts.tsv > temp/contacts.tmp && mv temp/contacts.tmp datafiles/contacts.tsv
        echo "Contact $2 deleted"
        ;;

    edit)
        if [ $# -lt 4 ]; then
            echo "Usage: pipevault contacts edit [name] [new_name] [new_address]"
            exit 1
        fi
        if ! grep -q "$2" datafiles/contacts.tsv; then
            echo "Contact $2 not found"
            exit 1
        fi
        # AWK logic's tough, I think if we need its doable with if-else aswell
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
