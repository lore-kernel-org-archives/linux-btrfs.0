Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37679 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3EFIxE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 04:53:04 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 6 May 2013 04:53:03 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 72FEF6E803F
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 04:52:57 -0400 (EDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r468r0W8345188
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 04:53:00 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r468qxh3008072
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 02:53:00 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com, chris.mason@fusionio.com, idryomov@gmail.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 0/5] BTRFS hot relocation support
Date: Mon,  6 May 2013 16:53:33 +0800
Message-Id: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  The patchset as RFC is sent out mainly to see if it goes in the
correct development direction.

  The patchset is trying to introduce hot relocation support
for BTRFS. In hybrid storage environment, when the data in
HDD disk get hot, it can be relocated to SSD disk by BTRFS
hot relocation support automatically; also, if SSD disk ratio
exceed its upper threshold, the data which get cold can be
looked up and relocated to HDD disk to make more space in SSD
disk at first, and then the data which get hot will be relocated
to SSD disk automatically.

  BTRFS hot relocation mainly reserve block space from SSD disk
at first, load the hot data to page cache from HDD, allocate
block space from SSD disk, and finally write the data to SSD disk.

  If you'd like to play with it, pls pull the patchset from
my git on github:
  https://github.com/wuzhy/kernel.git hot_reloc

For how to use, please refer too the example below:

root@debian-i386:~# echo 0 > /sys/block/vdc/queue/rotational
^^^ Above command will hack /dev/vdc to be one SSD disk
root@debian-i386:~# echo 999999 > /proc/sys/fs/hot-age-interval
root@debian-i386:~# echo 10 > /proc/sys/fs/hot-update-interval
root@debian-i386:~# echo 10 > /proc/sys/fs/hot-reloc-interval
root@debian-i386:~# mkfs.btrfs -d single -m single -h /dev/vdb /dev/vdc -f
     
WARNING! - Btrfs v0.20-rc1-254-gb0136aa-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using
     
[ 140.279011] device fsid c563a6dc-f192-41a9-9fe1-5a3aa01f5e4c devid 1 transid 16 /dev/vdb
[ 140.283650] device fsid c563a6dc-f192-41a9-9fe1-5a3aa01f5e4c devid 2 transid 16 /dev/vdc
[ 140.517089] device fsid 197d47a7-b9cd-46a8-9360-eb087b119424 devid 1 transid 3 /dev/vdb
[ 140.550759] device fsid 197d47a7-b9cd-46a8-9360-eb087b119424 devid 1 transid 3 /dev/vdb
[ 140.552473] device fsid c563a6dc-f192-41a9-9fe1-5a3aa01f5e4c devid 2 transid 16 /dev/vdc
adding device /dev/vdc id 2
[ 140.636215] device fsid 197d47a7-b9cd-46a8-9360-eb087b119424 devid 2 transid 3 /dev/vdc
fs created label (null) on /dev/vdb
nodesize 4096 leafsize 4096 sectorsize 4096 size 14.65GB
Btrfs v0.20-rc1-254-gb0136aa-dirty
root@debian-i386:~# mount -o hot_move /dev/vdb /data2
[ 144.855471] device fsid 197d47a7-b9cd-46a8-9360-eb087b119424 devid 1 transid 6 /dev/vdb
[ 144.870444] btrfs: disk space caching is enabled
[ 144.904214] VFS: Turning on hot data tracking
root@debian-i386:~# dd if=/dev/zero of=/data2/test1 bs=1M count=2048
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 23.4948 s, 91.4 MB/s
root@debian-i386:~# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/vda1 16G 13G 2.2G 86% /
tmpfs 4.8G 0 4.8G 0% /lib/init/rw
udev 10M 176K 9.9M 2% /dev
tmpfs 4.8G 0 4.8G 0% /dev/shm
/dev/vdb 15G 2.0G 13G 14% /data2
root@debian-i386:~# btrfs fi df /data2
Data: total=3.01GB, used=2.00GB
System: total=4.00MB, used=4.00KB
Metadata: total=8.00MB, used=2.19MB
Data_SSD: total=8.00MB, used=0.00
root@debian-i386:~# echo 108 > /proc/sys/fs/hot-reloc-threshold
^^^ Above command will start HOT RLEOCATE, because The data temperature is currently 109
root@debian-i386:~# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/vda1 16G 13G 2.2G 86% /
tmpfs 4.8G 0 4.8G 0% /lib/init/rw
udev 10M 176K 9.9M 2% /dev
tmpfs 4.8G 0 4.8G 0% /dev/shm
/dev/vdb 15G 2.1G 13G 14% /data2
root@debian-i386:~# btrfs fi df /data2
Data: total=3.01GB, used=6.25MB
System: total=4.00MB, used=4.00KB
Metadata: total=8.00MB, used=2.26MB
Data_SSD: total=2.01GB, used=2.00GB
root@debian-i386:~# 

Zhi Yong Wu (5):
  vfs: add one list_head field
  btrfs: add one new block group
  btrfs: add one hot relocation kthread
  procfs: add three proc interfaces
  btrfs: add hot relocation support

 fs/btrfs/Makefile            |   3 +-
 fs/btrfs/ctree.h             |  26 +-
 fs/btrfs/extent-tree.c       | 107 +++++-
 fs/btrfs/extent_io.c         |  31 +-
 fs/btrfs/extent_io.h         |   4 +
 fs/btrfs/file.c              |  36 +-
 fs/btrfs/hot_relocate.c      | 802 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/hot_relocate.h      |  48 +++
 fs/btrfs/inode-map.c         |  13 +-
 fs/btrfs/inode.c             |  92 ++++-
 fs/btrfs/ioctl.c             |  23 +-
 fs/btrfs/relocation.c        |  14 +-
 fs/btrfs/super.c             |  30 +-
 fs/btrfs/volumes.c           |  28 +-
 fs/hot_tracking.c            |   1 +
 include/linux/btrfs.h        |   4 +
 include/linux/hot_tracking.h |   1 +
 kernel/sysctl.c              |  22 ++
 18 files changed, 1234 insertions(+), 51 deletions(-)
 create mode 100644 fs/btrfs/hot_relocate.c
 create mode 100644 fs/btrfs/hot_relocate.h

-- 
1.7.11.7

