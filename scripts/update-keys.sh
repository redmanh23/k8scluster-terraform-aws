#!/bin/bash
set -o xtrace

##update ssh keys from copied authorized keys

x=1
while IFS= read -r line;
do
    echo "$line" | update-ssh-keys -a $x;
    x=$(( $x + 1 ))
done < /opt/authorized_keys
