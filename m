Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.commandict.com.au ([203.190.234.55]:49558 "EHLO
	mascot.commandict.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbbJPKmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 06:42:21 -0400
Received: from mascot.commandict.com.au (localhost [IPv6:::1])
	by mascot.commandict.com.au (Postfix) with ESMTP id 94AD1681484
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 21:36:49 +1100 (AEDT)
Subject: btrfs replace status >100%
From: =?utf-8?Q?Brett_King?= <brett.king@commandict.com.au>
To: =?utf-8?Q?linux-btrfs=40vger=2Ekernel=2Eorg?=
	<linux-btrfs@vger.kernel.org>
Date: Fri, 16 Oct 2015 21:36:49 +1100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.5620d341.12f4.4502d22b70e60c50@mascot.commandict.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,
I am noticing some strange numbers when replacing a disk under RAID1:

[root@array ~]# btrfs replace status -1 /export/archive/
367.2% done, 0 write errs, 0 uncorr. read errs

The filesystem is currently at 6x 6TB + 2x 5TB, replacing the first of each 5TB with 8TB units:

[root@array ~]# btrfs fi df /export/archive/
Data, RAID1: total=20.90TiB, used=20.62TiB
System, RAID1: total=8.00MiB, used=2.91MiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=23.00GiB, used=22.13GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B
[root@array ~]# btrfs fi sh /export/archive/
Label: 'archive'  uuid: 1b1f6bbb-0865-4752-bdaf-07ba30acb27e
        Total devices 9 FS bytes used 20.64TiB
        devid    0 size 4.55TiB used 4.55TiB path /dev/sdj
        devid    1 size 5.46TiB used 5.46TiB path /dev/sdc
        devid    2 size 5.46TiB used 5.46TiB path /dev/sdi
        devid    3 size 5.46TiB used 5.46TiB path /dev/sdg
        devid    4 size 5.46TiB used 5.46TiB path /dev/sdf
        devid    5 size 4.55TiB used 4.55TiB path /dev/sdh
        devid    6 size 4.55TiB used 4.55TiB path /dev/sdb
        devid    7 size 5.46TiB used 5.46TiB path /dev/sde
        devid    8 size 5.46TiB used 5.46TiB path /dev/sdd

btrfs-progs v4.2.1
[root@array ~]# btrfs device usage /export/archive/
/dev/sdb, ID: 6
   Device size:             4.55TiB
   Data,RAID1:              4.55TiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             1.02MiB

/dev/sdc, ID: 1
   Device size:             5.46TiB
   Data,RAID1:              5.45TiB
   Metadata,single:         8.00MiB
   Metadata,RAID1:         10.00GiB
   System,single:           4.00MiB
   Unallocated:             5.02MiB

/dev/sdd, ID: 8
   Device size:             5.46TiB
   Data,RAID1:              5.46TiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             1.02MiB

/dev/sde, ID: 7
   Device size:             5.46TiB
   Data,RAID1:              5.46TiB
   Unallocated:             1.02MiB

/dev/sdf, ID: 4
   Device size:             5.46TiB
   Data,RAID1:              5.45TiB
   Metadata,RAID1:         11.00GiB
   System,RAID1:            8.00MiB
   Unallocated:             1.02MiB

/dev/sdg, ID: 3
   Device size:             5.46TiB
   Data,RAID1:              5.45TiB
   Metadata,RAID1:         11.00GiB
   System,RAID1:            8.00MiB
   Unallocated:             1.02MiB

/dev/sdh, ID: 5
   Device size:             4.55TiB
   Data,RAID1:              4.55TiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             1.02MiB

/dev/sdi, ID: 2
   Device size:             5.46TiB
   Data,RAID1:              5.45TiB
   Metadata,RAID1:         11.00GiB
   Unallocated:             1.02MiB

/dev/sdj, ID: 0
   Device size:             7.28TiB
   Unallocated:             4.55TiB

[root@array ~]# uname -r
4.1.10-200.fc22.x86_64

Is this a problem ? And is there another way to see moved / total blocks from the running replace job ?

Thanks,
Brett.
