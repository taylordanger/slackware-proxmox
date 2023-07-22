#!/bin/bash

# Define variables
VM_ID=123
VM_NAME="Slackware"
VM_MEMORY=1024
VM_CPU=1
VM_NET="model=virtio,bridge=vmbr0"
STORAGE_NAME="local-lvm"
PROXMOX_NODE="PVE"

# create new VM
qm create $VM_ID --name $VM_NAME --memory $VM_MEMORY --net0 $VM>

# remove default hard drive
qm set $VM_ID --scsi0 none

# download the Slackware ISO
wget -P /var/lib/vz/template/iso/ http://slackware.cs.utah.edu/>

# attach ISO to VM
qm set $VM_ID --cdrom /var/lib/vz/template/iso/slackware64-15.0>

# create new hard drive for the VM on specified storage
qm set $VM_ID --scsi0 $STORAGE_NAME:32

# set boot order to boot from the ISO
qm set $VM_ID --boot order=scsi0

# boot the toots
qm start $VM_ID

# partition the drives
parted /dev/sda --script mklabel msdos
parted /dev/sda --script mkpart primary linux-swap 1MiB 512MiB
parted /dev/sda --script mkpart primary ext4 512MiB 10GiB
parted /dev/sda --script mkpart primary ext4 10GiB 100%

# format the virtual drives
mkswap /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3





