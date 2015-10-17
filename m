Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.commandict.com.au ([203.190.234.55]:49639 "EHLO
	mascot.commandict.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbbJQLyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Oct 2015 07:54:14 -0400
Received: from mascot.commandict.com.au (localhost [IPv6:::1])
	by mascot.commandict.com.au (Postfix) with ESMTP id 5E59D6A3366
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2015 22:54:11 +1100 (AEDT)
Subject: RE: btrfs replace status >100%
From: =?utf-8?Q?Brett_King?= <brett.king@commandict.com.au>
To: =?utf-8?Q?linux-btrfs=40vger=2Ekernel=2Eorg?=
	<linux-btrfs@vger.kernel.org>
Date: Sat, 17 Oct 2015 22:54:11 +1100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.562236e3.5c30.3c74fb95585c4a4e@mascot.commandict.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just following up - the replace operation completed successfully and then the source device (/dev/sdb) was removed, with all chunks moved on the target (/dev/sdj). Putting it down to RAID level complexities I guess.

[root@array ~]# btrfs replace status -1 /export/archive/
Started on 15.Oct 19:15:11, finished on 17.Oct 21:23:10, 0 write errs, 0 uncorr. read errs
[root@array ~]# btrfs fi sh /export/archive/
Label: 'archive'  uuid: 1b1f6bbb-0865-4752-bdaf-07ba30acb27e
        Total devices 8 FS bytes used 20.65TiB
        devid    1 size 5.46TiB used 5.46TiB path /dev/sdc
        devid    2 size 5.46TiB used 5.46TiB path /dev/sdi
        devid    3 size 5.46TiB used 5.46TiB path /dev/sdg
        devid    4 size 5.46TiB used 5.46TiB path /dev/sdf
        devid    5 size 4.55TiB used 4.55TiB path /dev/sdh
        devid    6 size 4.55TiB used 4.55TiB path /dev/sdj
        devid    7 size 5.46TiB used 5.46TiB path /dev/sde
        devid    8 size 5.46TiB used 5.46TiB path /dev/sdd

btrfs-progs v4.2.1
[root@array ~]# btrfs fi usage /export/archive/
Overall:
    Device size:                  41.84TiB
    Device allocated:             41.84TiB
    Device unallocated:           12.19MiB
    Device missing:                  0.00B
    Used:                         41.30TiB
    Free (estimated):            276.69GiB      (min: 276.69GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:20.90TiB, Used:20.63TiB
   /dev/sdc        5.45TiB
   /dev/sdd        5.46TiB
   /dev/sde        5.46TiB
   /dev/sdf        5.45TiB
   /dev/sdg        5.45TiB
   /dev/sdh        4.55TiB
   /dev/sdi        5.45TiB
   /dev/sdj        4.55TiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdc        8.00MiB

Metadata,RAID1: Size:23.00GiB, Used:22.16GiB
   /dev/sdc       10.00GiB
   /dev/sdd        1.00GiB
   /dev/sdf       11.00GiB
   /dev/sdg       11.00GiB
   /dev/sdh        1.00GiB
   /dev/sdi       11.00GiB
   /dev/sdj        1.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdc        4.00MiB

System,RAID1: Size:8.00MiB, Used:2.91MiB
   /dev/sdf        8.00MiB
   /dev/sdg        8.00MiB

Unallocated:
   /dev/sdc        5.02MiB
   /dev/sdd        1.02MiB
   /dev/sde        1.02MiB
   /dev/sdf        1.02MiB
   /dev/sdg        1.02MiB
   /dev/sdh        1.02MiB
   /dev/sdi        1.02MiB
   /dev/sdj        1.02MiB
[root@array ~]# btrfs fi resize 6:max /export/archive/
Resize '/export/archive/' of '6:max'
[root@array ~]# btrfs fi usage /export/archive/
Overall:
    Device size:                  44.57TiB
    Device allocated:             41.84TiB
    Device unallocated:            2.73TiB
    Device missing:                  0.00B
    Used:                         41.30TiB
    Free (estimated):              1.63TiB      (min: 1.63TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:20.90TiB, Used:20.63TiB
   /dev/sdc        5.45TiB
   /dev/sdd        5.46TiB
   /dev/sde        5.46TiB
   /dev/sdf        5.45TiB
   /dev/sdg        5.45TiB
   /dev/sdh        4.55TiB
   /dev/sdi        5.45TiB
   /dev/sdj        4.55TiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdc        8.00MiB

Metadata,RAID1: Size:23.00GiB, Used:22.16GiB
   /dev/sdc       10.00GiB
   /dev/sdd        1.00GiB
   /dev/sdf       11.00GiB
   /dev/sdg       11.00GiB
   /dev/sdh        1.00GiB
   /dev/sdi       11.00GiB
   /dev/sdj        1.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdc        4.00MiB

System,RAID1: Size:8.00MiB, Used:2.91MiB
   /dev/sdf        8.00MiB
   /dev/sdg        8.00MiB

Unallocated:
   /dev/sdc       24.00KiB
   /dev/sdd        1.02MiB
   /dev/sde        1.02MiB
   /dev/sdf        1.02MiB
   /dev/sdg        1.02MiB
   /dev/sdh        1.02MiB
   /dev/sdi        1.02MiB
   /dev/sdj        2.73TiB
[root@array ~]# btrfs fi sh /export/archive/
Label: 'archive'  uuid: 1b1f6bbb-0865-4752-bdaf-07ba30acb27e
        Total devices 8 FS bytes used 20.65TiB
        devid    1 size 5.46TiB used 5.46TiB path /dev/sdc
        devid    2 size 5.46TiB used 5.46TiB path /dev/sdi
        devid    3 size 5.46TiB used 5.46TiB path /dev/sdg
        devid    4 size 5.46TiB used 5.46TiB path /dev/sdf
        devid    5 size 4.55TiB used 4.55TiB path /dev/sdh
        devid    6 size 7.28TiB used 4.55TiB path /dev/sdj
        devid    7 size 5.46TiB used 5.46TiB path /dev/sde
        devid    8 size 5.46TiB used 5.46TiB path /dev/sdd

btrfs-progs v4.2.1
[root@array ~]#
