Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:44123 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab3AHR6W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 12:58:22 -0500
Received: by mail-la0-f47.google.com with SMTP id fh20so787601lab.20
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2013 09:58:21 -0800 (PST)
Message-ID: <50EC5E2D.8000308@gmail.com>
Date: Tue, 08 Jan 2013 21:58:05 +0400
From: Alexander Meshcheryakov <alexander.s.m@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Buffer I/O error with mirrored lvm on top of files on Btrfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I tried to test LVM Raid1 robustness with following setup:

fallocate -l 128M file1
fallocate -l 128M file2
losetup /dev/loop0 file1
losetup /dev/loop1 file2
pvcreate /dev/loop{0,1}
vgcreate testvg /dev/loop{0,1}
lvcreate -L 100M --mirrorlog core -m 1 -n testlv testvg

So far so good. But suddenly on attempt to use this volume:

mkfs.ext4 /dev/testvg/testlv
<uninteresting messages>
Superblock backups stored on blocks:
         8193, 24577, 40961, 57345, 73729

Allocating group tables: done
Warning: could not read block 0: Attempt to read block from filesystem 
resulted in short read
Warning: could not erase sector 0: Attempt to write block to filesystem 
resulted in short write
Writing inode tables: done
ext2fs_update_bb_inode: Attempt to read block from filesystem resulted 
in short read while setting bad block inode

And following error messages in dmesg appears:

[211114.749967] device-mapper: raid1: All sides of mirror have failed.
[211114.754559] Buffer I/O error on device dm-4, logical block 0
[211114.755097] Buffer I/O error on device dm-4, logical block 72
[211114.758176] Buffer I/O error on device dm-4, logical block 25584
[211114.758184] Buffer I/O error on device dm-4, logical block 25584
[211114.758192] Buffer I/O error on device dm-4, logical block 25598
[211114.758195] Buffer I/O error on device dm-4, logical block 25598
[211114.758201] Buffer I/O error on device dm-4, logical block 0
[211114.758204] Buffer I/O error on device dm-4, logical block 0
[211114.758209] Buffer I/O error on device dm-4, logical block 1

With a couple of more experiments I found that:
1) This setup works well if underlying filesystem is ext4 or FAT32, but 
fails if underlying FS is Btrfs or ntfs-3g;
2) It works well everywhere, if LV is not mirrored.

It seems to me that there is obscure problem somewhere.

I concocted a script to help with reproducing this problem. It 
constructs volume group from two test files in current directory:
----------------------
#!/bin/sh

#PV size has to specified in megabytes, or loopback files creation with 
dd will break
PVSIZE=128M
LVSIZE=100M
FILES='loopback1 loopback2'
LBDEVICES=''
VGNAME='lvmlbtest'
LVNAME='mirror'

#####################
#  Test
#####################

for f in $FILES; do
     fallocate -l $PVSIZE $f || dd if=/dev/zero of=$f bs=$((1024*1024)) 
count=${PVSIZE%M} || exit 1
     losetup -v -f $f
     LBDEVICES="$LBDEVICES $(losetup -a|grep $f|cut -d: -f1|tail -n 1)"
done
pvcreate $LBDEVICES
vgcreate $VGNAME $LBDEVICES
lvcreate -L $LVSIZE --mirrorlog core -m 1 -n $LVNAME $VGNAME

LVPATH=$(lvs --noheadings -o lv_path|grep $VGNAME|grep $LVNAME)


read -p 'LV created. Press enter to proceed with mkfs ' sleepvar
mkfs.ext4 $LVPATH

#####################
#  Cleanup
#####################
read -p 'Press enter to delete test VG ' sleepvar

vgremove -f $VGNAME
sync
for LB in $LBDEVICES; do
     losetup -v -d $LB
done
for f in $FILES; do
     rm -v $f
done
