#!/usr/bin/env bash

# Absolute idiotic way to pair hostname and ip
# What this does is it takes all the args, splits them in half and
# it pairs them like 0 len/2, 1 len/2 + 1, 2 len/2 + 2
# So 192.168.3.3 192.168.3.4 host1 host2 will result into
# 192.168.3.3 host1
# 192.168.3.4 host2

DOCKER_REGISTRY="$1"

argsLen=$(($# - 1))
args=(${@:2})
argsLen=$((argsLen / 2))

START="##### GENERATED #####"
END="##### END GENERATED #####"

# Detect special section
EXISTS=$(cat /etc/hosts | grep "$START" | wc -l)

# Working copy
cp /etc/hosts /tmp/etc_hosts

# Add special section if not there
if (( $EXISTS < 1 )); then
  echo "" | tee -a /tmp/etc_hosts
  echo $START | tee -a /tmp/etc_hosts
  echo $END | tee -a /tmp/etc_hosts
  echo "" | tee -a /tmp/etc_hosts
fi

# Cleanup special section
sed -i '/'"$START"'/,/'"$END"'/{//!d}' /tmp/etc_hosts

# Hostname alias will be last, we're inserting at the top of the stack
# HOST_LINE="`echo $(hostname -i | cut -d\" \" -f1) \\ $(cat /etc/hostname)`"
# sed -i '/'"$START"'/a '"$HOST_LINE"'' /tmp/etc_hosts

# Registry
HOST_LINE="$DOCKER_REGISTRY    registry"
sed -i '/'"$START"'/a '"$HOST_LINE"'' /tmp/etc_hosts

# Fill in aliases
# echo "" | sudo tee -a /etc/hosts
for (( c=0; c<$argsLen; c++ ))
do
   # echo "${args[c]}    ${args[c+$argsLen]}" | sudo tee -a /etc/hosts
   HOST_LINE="${args[c]}    ${args[c+$argsLen]}"
   sed -i '/'"$START"'/a '"$HOST_LINE"'' /tmp/etc_hosts
done

# Add space / lines for readability
HOST_LINE="#"
sed -i '/'"$START"'/a '"$HOST_LINE"'' /tmp/etc_hosts
sed -i 's|'"$END"'|#\n'"$END"'|g' /tmp/etc_hosts

# Backup and replace
sudo cp /etc/hosts /etc/hosts.bkp
sudo mv /tmp/etc_hosts /etc/hosts
sudo chmod 644 /etc/hosts
