From: Shen Feng <shen@cn.fujitsu.com>
Subject: A bug with multiple devices?
Date: Tue, 30 Dec 2008 09:44:38 +0800
Message-ID: <49597D06.1050806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I create a raid-1 btrfs with the following command.

[root@localhost ~]# fdisk -l /dev/sdb

Disk /dev/sdb: 320.0 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xb44829ea

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1        4863    39062016   83  Linux
/dev/sdb2            4864        9726    39062047+  83  Linux
/dev/sdb3            9727       38905   234375905+   f  W95 Ext'd (LBA)
/dev/sdb5            9727       14590    39063374   83  Linux
/dev/sdb6           14590       19453    39068690+   7  HPFS/NTFS
/dev/sdb7           19454       29178    78116031   83  Linux
/dev/sdb8           29179       31610    19535008+  83  Linux
/dev/sdb9           31611       34041    19526976   83  Linux
/dev/sdb10          34042       36473    19535008+  83  Linux
/dev/sdb11          36474       38904    19526976   83  Linux

[root@localhost ~]# mkfs.btrfs -m raid1 /dev/sdb8 /dev/sdb9 /dev/sdb10 /dev/sdb11
adding device /dev/sdb9 id 2
adding device /dev/sdb10 id 3
adding device /dev/sdb11 id 4
fs created label (null) on /dev/sdb8
	nodesize 4096 leafsize 4096 sectorsize 4096 size 74.50GB
Btrfs v0.16-29-g0d53b21

[root@localhost ~]# mount -t btrfs /dev/sdb8 /mnt/btrfs[root@localhost ~]# df
Filesystem           1K-blocks      Used Available Use% Mounted on
...
/dev/sdb8             78123968        28  78123940   1% /mnt/btrfs

I think the partition size is no correct since this is a raid-1 partition.
The size should be half.
Is this a bug?

-Shen
