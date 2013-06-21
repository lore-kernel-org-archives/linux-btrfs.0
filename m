Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41464 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161107Ab3FUMVu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 08:21:50 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Fri, 21 Jun 2013 08:21:50 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 83C84C90042
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 08:21:47 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r5LCLm9v276858
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 08:21:48 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r5LCLkUi002122
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 08:21:48 -0400
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, chris.mason@fusionio.com, jbacik@fusionio.com,
        idryomov@gmail.com, Martin@lichtvoll.de,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 0/5] BTRFS hot relocation support
Date: Fri, 21 Jun 2013 20:20:55 +0800
Message-Id: <1371817260-8615-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  This patchset can work well with the patchset v3 for VFS
hot tracking in RAID single mode now.

  The patchset as RFC is sent out mainly to see if its design
goes in the correct development direction.

  When working on this feature, i am trying to change as less
the existing btrfs code as possible. After V0 was sent out,
i carefully checked the patchset for speed profile, and don't
think that it is meanful to BTRFS hot relocation, but think
that it is one simple and effective way to introduce one new
block group for nonrotating disk to differentiate if the block
space is reserved from rotating disk or nonrotating disk; So
It's very appreciated that the developers can double check if
the design is appropriate to BTRFS hot relocation.

  The patchset is trying to introduce hot relocation support
for BTRFS. In hybrid storage environment, when the data in
rotating disk get hot, it can be relocated to nonrotating disk
by BTRFS hot relocation support automatically; also, if
nonrotating disk ratio exceed its upper threshold, the data
which get cold can be looked up and relocated to rotating disk
to make more space in nonrotating disk at first, and then the
data which get hot will be relocated to nonrotating disk
automatically.

  BTRFS hot relocation mainly reserve block space from nonrotating
disk at first, load the hot data to page cache from rotating disk,
allocate block space from nonrotating disk, and finally write the
data to it.

Below is its TODO list:

  - BTRFS RAID full support. [Martin Steigerwald, Zhiyong]
  - Mark files as hot via ioctl. [Martin Steigerwald]
  - Easier setup. With BTRFS flexibility I would expect that a SSD as hot data
cache can be added and removed on the fly during filesystem is mounted. Only
seems supported at mkfs-time as I read the patch docs, but from my basic
technical understanding of BTRFS it can be extented to be done on the fly with
a mounted FS as well. [Martin Steigerwald]

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

Changelog from v1:
 - Fixed up one nospc bug which is introduced by this feature.

v1:
 - Refactor introducing one new block group.


Zhi Yong Wu (5):
  BTRFS hot reloc, vfs: add one list_head field
  BTRFS hot reloc: add one new block group
  BTRFS hot reloc: add one hot reloc thread
  BTRFS hot reloc, procfs: add three proc interfaces
  BTRFS hot reloc: add hot relocation support

 fs/btrfs/Makefile            |   3 +-
 fs/btrfs/ctree.h             |  35 ++-
 fs/btrfs/extent-tree.c       |  99 ++++--
 fs/btrfs/extent_io.c         |  51 ++-
 fs/btrfs/extent_io.h         |   7 +
 fs/btrfs/file.c              |  27 +-
 fs/btrfs/free-space-cache.c  |   2 +-
 fs/btrfs/hot_relocate.c      | 721 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/hot_relocate.h      |  38 +++
 fs/btrfs/inode-map.c         |   7 +-
 fs/btrfs/inode.c             | 106 +++++--
 fs/btrfs/ioctl.c             |  17 +-
 fs/btrfs/relocation.c        |   6 +-
 fs/btrfs/super.c             |  30 +-
 fs/btrfs/volumes.c           |  29 +-
 fs/hot_tracking.c            |   1 +
 include/linux/btrfs.h        |   4 +
 include/linux/hot_tracking.h |   1 +
 kernel/sysctl.c              |  22 ++
 19 files changed, 1132 insertions(+), 74 deletions(-)
 create mode 100644 fs/btrfs/hot_relocate.c
 create mode 100644 fs/btrfs/hot_relocate.h

-- 
1.7.11.7

