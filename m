From: "Thomas Schneider" <c.monty@web.de>
Subject: Btrfs Partition out of free space - no mount possible
Date: Thu, 31 Mar 2011 09:05:35 +0200 (CEST)
Message-ID: <132839091.3008.1301555135774.JavaMail.fmail@mwmweb057>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hello!

My Btrfs partition (/home) is out of free space.
The partition is a logical drive within a LVM configuration.

I've already extended the LVM logical volume.
However, it's impossible to mount the partition from a live CD system (SystemRescue CD).
The error in dmesg is: BTRFS: inode 8443 still on the orphan list

Here my executed commands:
root@sysresccd /root % btrfs filesystem show
failed to read /dev/fd0
Label: 'home'  uuid: c6da646e-83aa-432d-9a24-d0d276c3de4d
    Total devices 1 FS bytes used 284.13MB
    devid    1 size 756.00MB used 756.00MB path /dev/dm-3

root@sysresccd /root % pvscan
  PV /dev/mapper/lvm-crypt   VG linux   lvm2 [7.86 GiB / 0    free]
  Total: 1 [7.86 GiB] / in use: 1 [7.86 GiB] / in no VG: 0 [0   ]

root@sysresccd /root % vgscan
  Reading all physical volumes.  This may take a while...
  Found volume group "linux" using metadata type lvm2

root@sysresccd /root % lvscan
  ACTIVE            '/dev/linux/root' [6.52 GiB] inherit
  ACTIVE            '/dev/linux/swap' [416.00 MiB] inherit
  ACTIVE            '/dev/linux/home' [956.00 MiB] inherit

When I try to mount the Btrfs partition, the system hangs:
  root@sysresccd /root % mount /dev/linux/home /mnt/backup
  
  root@sysresccd /root % dmesg
[ 5142.990126] device label home devid 1 transid 951018 /dev/mapper/linux-home
[ 5143.110843] BTRFS: inode 8443 still on the orphan list
[ 5143.148987] BTRFS: inode 8443 still on the orphan list
[ 5143.158262] BTRFS: inode 8443 still on the orphan list
[ 5143.167229] BTRFS: inode 8443 still on the orphan list
[ 5143.177283] BTRFS: inode 8443 still on the orphan list
[ 5143.186218] BTRFS: inode 8443 still on the orphan list
[ 5143.196194] BTRFS: inode 8443 still on the orphan list
[ 5143.206172] BTRFS: inode 8443 still on the orphan list
[ 5143.220235] BTRFS: inode 8443 still on the orphan list

How can I resolve this issue?

THX


