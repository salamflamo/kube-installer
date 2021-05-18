#!/bin/bash

#vars
vgname="vg_shared"
lvname="lv_shared"
mountpoint="/u02"

echo "Buat Partisi baru dari disk baru yang di present format linux"
new_disk=$(lsblk | awk '{print $1}' | grep sdc | tail -n 1)
(
echo g
echo n
echo p
echo 1
echo
echo
echo w
) | sudo fdisk /dev/$new_disk
partprobe
new_part=$(lsblk -o name -n -s -l | grep sdc | sort -n | tail -n 1)
pvcreate /dev/$new_part
#buat static variable untuk nama Volume Group
vgcreate ${vgname} /dev/$new_part
#buat static variable untuk nama Linux Volume
lvcreate --name ${lvname} -l 100%FREE ${vgname}
mkfs.xfs /dev/mapper/${vgname}-${lvname}
mkdir /${mountpoint}
#src_device=$(lsblk -o name -n -s -l | sort -n | tail -n 1)
echo "/dev/mapper/${vgname}-${lvname} /${mountpoint} xfs defaults 0 0" >> /etc/fstab
mount -a