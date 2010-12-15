From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: btrfsck says snapshots have errors
Date: Tue, 14 Dec 2010 21:53:47 -0500
Message-ID: <20101215025346.GA3119@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs 0.19
Ubuntu 10.10
Linux linux 2.6.35-23-generic #41-Ubuntu SMP Wed Nov 24 11:55:36 UTC 2010 x86_64 GNU/Linux

I create a new btrfs on a 200GB disk with one partition.
I mount the partition.
I create a snapshot of that partition.
I unmount the partition.
I run btrfsck and it says I have an "unresolved ref" error.

If I create two snaps, I get three errors.
If I create three snaps, I get six errors.
If I create four snaps, I get ten errors.
If I create five snaps, I get 15 errors.
Etc.

Deleting the snapshots makes btrfsck happy again; no errors.

Who is right, btrfsck or the file system itself?
Are there really errors?

---------- cut script here ----------------------------------------
#!/bin/bash -u
# Test a btrfs partition: one-snap creation and btrfsck
# -Ian! D. Allen - idallen@idallen.ca - www.idallen.com

BTRFS=/mnt/sdc1
BTRFSDEV=/dev/sdc1

echo "Using $BTRFS $BTRFSDEV"

set -x

mkfs.btrfs -L BTRFStest $BTRFSDEV || exit $?

mount -o noatime $BTRFSDEV $BTRFS || exit $?

btrfs subvolume snapshot $BTRFS $BTRFS/snap1

umount $BTRFSDEV

btrfsck $BTRFSDEV
---------- cut script here ----------------------------------------

---------- script output here -------------------------------------
# ./btrfstest.sh
Using /mnt/sdc1 /dev/sdc1
+ mkfs.btrfs -L BTRFStest /dev/sdc1

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label BTRFStest on /dev/sdc1
	nodesize 4096 leafsize 4096 sectorsize 4096 size 186.31GB
Btrfs Btrfs v0.19
+ mount -o noatime /dev/sdc1 /mnt/sdc1
+ btrfs subvolume snapshot /mnt/sdc1 /mnt/sdc1/snap1
Create a snapshot of '/mnt/sdc1' in '/mnt/sdc1/snap1'
+ umount /dev/sdc1
+ btrfsck /dev/sdc1
fs tree 256 refs 2 
	unresolved ref root 256 dir 256 index 3 namelen 5 name snap1 error 600
found 32768 bytes used err is 1
total csum bytes: 0
total tree bytes: 32768
total fs tree bytes: 12288
btree space waste bytes: 26144
file data blocks allocated: 0
 referenced 0
Btrfs Btrfs v0.19
Exit 1
