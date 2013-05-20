Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:36149 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3ETPPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 11:15:16 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 20 May 2013 09:15:15 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 0/5] BTRFS hot relocation support
Date: Mon, 20 May 2013 23:11:22 +0800
Message-Id: <1369062687-23544-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

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
the design is appropriate to BTRFS hot reloction.

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

Changelog from v0:
 1.) Refactor introducing one new block group.

Zhi Yong Wu (5):
  BTRFS hot reloc, vfs: add one list_head field
  BTRFS hot reloc: add one new block group
  BTRFS hot reloc: add one hot reloc thread
  BTRFS hot reloc, procfs: add three proc interfaces
  BTRFS hot reloc: add hot relocation support

 fs/btrfs/Makefile            |   3 +-
 fs/btrfs/ctree.h             |  35 ++-
 fs/btrfs/extent-tree.c       |  99 ++++--
 fs/btrfs/extent_io.c         |  59 +++-
 fs/btrfs/extent_io.h         |   7 +
 fs/btrfs/file.c              |  24 +-
 fs/btrfs/free-space-cache.c  |   2 +-
 fs/btrfs/hot_relocate.c      | 721 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/hot_relocate.h      |  38 +++
 fs/btrfs/inode-map.c         |   7 +-
 fs/btrfs/inode.c             |  94 +++++-
 fs/btrfs/ioctl.c             |  17 +-
 fs/btrfs/relocation.c        |   6 +-
 fs/btrfs/super.c             |  30 +-
 fs/btrfs/volumes.c           |  29 +-
 fs/hot_tracking.c            |   1 +
 include/linux/btrfs.h        |   4 +
 include/linux/hot_tracking.h |   1 +
 kernel/sysctl.c              |  22 ++
 19 files changed, 1130 insertions(+), 69 deletions(-)
 create mode 100644 fs/btrfs/hot_relocate.c
 create mode 100644 fs/btrfs/hot_relocate.h

-- 
1.7.11.7

