Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:37904 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdAUOuV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jan 2017 09:50:21 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
        (envelope-from <mh+linux-btrfs@zugschlus.de>)
        id 1cUwTB-000870-KF
        for linux-btrfs@vger.kernel.org; Sat, 21 Jan 2017 15:16:41 +0100
Date: Sat, 21 Jan 2017 15:16:41 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: "not a btrfs filesystem"
Message-ID: <20170121141641.GS4155@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a file system that I can show, check, but not rebalance:

1 [4/3420]mh@fan:~ $ sudo btrfs fi show /dev/mapper/banana-root
Label: none  uuid: b2906231-70a9-46d9-9830-38a13cb73171
        Total devices 1 FS bytes used 1.82GiB
        devid    1 size 6.00GiB used 3.69GiB path /dev/mapper/banana-root

1 [10/3426]mh@fan:~ $ sudo btrfs check /dev/mapper/banana-root
Checking filesystem on /dev/mapper/banana-root
UUID: b2906231-70a9-46d9-9830-38a13cb73171
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 1954635785 bytes used err is 0
total csum bytes: 1833964
total tree bytes: 75907072
total fs tree bytes: 64241664
total extent tree bytes: 7843840
btree space waste bytes: 21224578
file data blocks allocated: 2168119296
 referenced 2088648704
[11/3427]mh@fan:~ $ sudo btrfs balance /dev/mapper/banana-root
ERROR: not a btrfs filesystem: /dev/mapper/banana-root
1 [12/3428]mh@fan:~ $

The filesystem is on a logical volume which is on a PV which is in a
loop device that is on a disk file:

[12/3428]mh@fan:~ $ sudo lvs
  LV                  VG     Attr       LSize
  root                banana -wi-a---p-   6,00g
[13/3429]mh@fan:~ $ sudo vgs
  VG     #PV #LV #SN Attr   VSize   VFree  
  banana   1   2   0 wz-pn-   7,16g 164,00m
[14/3430]mh@fan:~ $ sudo pvs
  PV         VG     Fmt  Attr PSize   PFree  
  [unknown]  banana lvm2 a-m    7,16g 164,00m
(no idea why this says "unknown" here, it is
[15/3431]mh@fan:~ $ ls -al /dev/mapper/loop0p2
lrwxrwxrwx 1 root root 8 Jan 21 14:40 /dev/mapper/loop0p2 -> ../dm-39
[16/3432]mh@fan:~ $ ls -al /dev/dm-39
brw-rw---- 1 root disk 254, 39 Jan 21 14:40 /dev/dm-39
[24/3440]mh@fan:~ $ sudo kpartx -l banana.sdcard
loop0p1 : 0 497664 /dev/loop0 2048
loop0p2 : 0 15024128 /dev/loop0 499712
[25/3441]mh@fan:~ $ sudo losetup --list
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE              DIO
/dev/loop0         0      0         0  0 /home/mh/banana.sdcard   0
[26/3442]mh@fan:~ $

Can a btrfs be so broken that btrfs balance doesn't recognize it any
more? What is going on with this file system?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
