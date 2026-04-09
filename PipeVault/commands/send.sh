#!/bin/sh

if [ $# -lt 3 ]; then
  echo "Usage: ./send [name_or_address] [compression] [file(s)]"
  exit 1
fi
name="not specified"
case "$1" in
  *@*) address="$1" ;;
  *)   address=$(awk -v name="$1" '$2 == name {print $3}' datafiles/contacts.tsv)
       name="$1" ;;
esac
echo "Address identified: $address. Name in contacts: $name"
case "$2" in
  0)
    compression=""
    ext=""
    ;;
  1)
    compression="gzip"
    ext=".gz"
    ;;
  2)
    compression="bzip2"
    ext=".bz2"
    ;;
  3)
    compression="xz"
    ext=".xz"
    ;;
  *)
    echo "Invalid compression option. Please choose 0, 1, 2, or 3."
    exit 1
    ;;
esac

timestamp=$(date '+%F_%H-%M-%S')
shift 2
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "Error: $file not found"
        exit 1
    fi
done


tar -cvf "temp/archive.tar" "$@" 2>/dev/null
if [ -n "$compression" ]; then
    $compression temp/archive.tar
    $compression -t temp/archive.tar$ext || { echo "Archive corrupted, aborting"; exit 1; }
fi
file_size=$(ls -lh "temp/archive.tar$ext" | awk '{print $5}')
if [ -z "$compression" ]; then
    echo "File(-s) saved as archive.tar, will be sent without compression. Archive size: $file_size"
    else
    echo "File(-s) saved as and compressed in archive.tar$ext. Archive size: $file_size"
fi

cd temp
sha256sum archive.tar$ext > archive.tar$ext.sha256
cd ..
full_hash=$(cat temp/archive.tar$ext.sha256 | awk '{print $1}')
IDr=$(echo "$full_hash" | cut -c1-8)

status="succes"
if rsync -avz --progress "temp/archive.tar$ext" "temp/archive.tar$ext.sha256" "$address:/home/PipeVault/$timestamp"; then
    echo "Delivered successfully"
    ssh "$address" "
        cd /home/PipeVault/$timestamp
        sha256sum -c archive.tar$ext.sha256 && echo 'Checksum OK' || echo 'Checksum FAILED'
        tar -xf archive.tar$ext
        echo 'Unpacked successfully'
    "
else
    MAX_RETRIES=3
    attempt=1
    while [ $attempt -le $MAX_RETRIES ]; do
        rsync -avz --progress "temp/archive.tar$ext" "temp/archive.tar$ext.sha256" "$address:/home/PipeVault/$timestamp" && break
        echo "Attempt $attempt failed, retrying..."
        attempt=$((attempt + 1))
        if [ $attempt = 4 ]; then
            echo "Delivery failed"
            status="failed"
        fi
    done
fi


rm -f temp/archive.tar temp/archive.tar$ext temp/archive.tar$ext.sha256
echo "Temporary files removed. Logging results..."
printf "%-10s\t%-10s\t%-20s\t%-15s\t%-40s\t%s\n" "$IDr" "$status" "$timestamp" "$name" "$address" "$#" >> datafiles/history.log
