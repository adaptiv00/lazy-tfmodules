#!/bin/bash

# Based on documentation from Packet.net
# https://www.packet.net/help/kb/hardware/how-do-i-configure-an-nvme-flash-drive/

# This has also some pretty obsolete code in there, related to disk detection.
# It's just not good / generic enough

partition()
{
  USER=$3
  TO_PARTITION=$1
  TO_MOUNT=/mnt/$USER$2
  if [[ 1 == $2 ]]; then
    TO_MOUNT="/mnt/$USER" # FIRST disk we mount is /mnt/app, rest will be
  fi
  echo " -- Partitioning drive: $1, will mount to: '$TO_MOUNT'"
  sudo parted -s -a optimal $TO_PARTITION mklabel gpt
  sudo parted -s -a optimal $TO_PARTITION mkpart primary ext4 0% 100%
  sudo mkfs.ext4 -F $TO_PARTITION

  #change mount point as required
  sudo mkdir -p $TO_MOUNT
  sudo mount $TO_PARTITION $TO_MOUNT -t ext4
  echo "$TO_PARTITION $TO_MOUNT ext4 defaults 0 2" | sudo tee -a /etc/fstab
}

echo
echo " -- Attempting partitioning"

# In GCE we name them as we want, will appear as 'serial'. If it's there, only pick those
# Second issue is, Terraform provisioner will not add the proper metadata when creating the disk, aka serial=disk name
# Also eliminate sda as that's Google boot disk
# This GCE thing is all shaky and could use some rework. Terraform patch ideally
disks_str=$(lsblk -i -o name,type,serial | grep persistent-disk- | awk '{print $1}' | xargs -n10 echo | sed 's/sda//g')
if [ -z "$disks_str" ]; then
  # Pick up various patterns of what we know these disks "look like". Sucks.
  disks_str=$(lsblk | awk '{print $1}' | grep -E 'sda|sdb|sdc|sdd|sde|sdf|nvme' | xargs -n10 echo)
fi

if [[ "$disks_str" == "sda sdb sdc sdd sde sdf" ]]; then
  echo " -- Identified the 6 SSDs version"
  disks_str="sda sdb sdc sdd sde sdf"
elif [[ "$disks_str" =~ .*sdc\ sdd ]]; then
  echo " -- Identified the 2 SSDs version"
  disks_str="sdc sdd"
elif [[ "$disks_str" =~ .*nvme0n2.* ]]; then
  echo " -- Identified GCE multiple NVMEs version"
  disks_str=$(lsblk | awk '{print $1}' | grep -E 'nvme' | xargs -n10 echo)
elif [[ "$disks_str" =~ .*nvme0n1 ]]; then
  echo " -- Identified the 1 NVMEs version"
  disks_str="nvme0n1"
elif [[ "$disks_str" =~ .*sdb ]]; then
  echo " -- Identified GCE disks"
  #disks_str="sdc sdd"
else
  echo " -- Haven't found any extra disks to format, Kafka will run on the root disk"
  echo
  exit 0
fi

APP_USER=${APP_USER:-"app"}
echo " -- Will format: $disks_str, owner: $APP_USER"

idx=0
kafka_idx=0
#disks_str=$(lsblk | awk '{print $1}' | grep -E 'sda|sdb|sdc|sdd|sde|sdf|nvme0n1' | xargs -n10 echo)
IFS=' ' disks=($disks_str)
while [ "$idx" -le ${#disks[@]} ]; do
  disk=${disks[idx]}
  if [ ! -z "$disk" ]; then
    kafka_idx=`expr $kafka_idx + 1`
    echo " -- Formatting /dev/$disk"
    partition "/dev/$disk" $kafka_idx "$APP_USER"
    echo
  fi
  idx=`expr $idx + 1`
done

echo
echo " -- Folders mounted: $(mount | grep "$APP_USER" | awk '{print $3}' | xargs -L10 echo | sed 's/ /,/g')"
echo
