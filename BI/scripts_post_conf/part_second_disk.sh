#!/bin/bash
#!/bin/bash
echo "Buat Partisi baru dari disk baru yang di present format linux"
new_disk=$(lsblk | awk '{print $1}' | grep sd | tail -n 1)
parted -s /dev/$new_disk mklabel gpt
parted -s /dev/$new_disk mkpart primary 100%
new_part=$(lsblk -o name -n -s -l | grep sd | sort -n | tail -n 1)
pvcreate /dev/$new_part
#buat static variable untuk nama Volume Group
vgcreate vg_data /dev/$new_part
#buat static variable untuk nama Linux Volume
lvcreate --name lv_data -l 100%FREE vg_data
vgname=$(vgs | awk '{print $1}' | tail -n 1)
lvname=$(lvs | awk '{print $1}' | tail -n 1)
mkfs.xfs /dev/$vgname/$lvname
mkdir /data
src_device=$(lsblk -o name -n -s -l | sort -n | tail -n 1)
echo "/dev/mapper/$src_device /data xfs defaults 0 0" >> /etc/fstab
mount -a
echo "Alhamdulillah"