Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:35869 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbcBPUUN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 15:20:13 -0500
Received: by mail-vk0-f54.google.com with SMTP id c3so143971173vkb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 12:20:13 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 16 Feb 2016 15:20:12 -0500
Message-ID: <CABmr4wVBb0CCEoU_N2jxYvC=gVn9vUKWfb0902yZDuP2N3ck3w@mail.gmail.com>
Subject: RAID 6 full, but there is still space left on some devices
From: Dan Blazejewski <dan.blazejewski@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've searched high and low about my issue, but have been unable to
turn up anything like what I'm seeing right now.

A little background: I started using BTRFS over a year ago, in RAID 1
with mixed size drives. A few months ago, I started replacing the
disks with 4 TB drives, and eventually switched over to RAID 6. I am
currently running a 6x4TB RAID6 drive configuration, which should give
me ~14.5 TB
usable, but I'm only getting around 11.

The weird thing is that It seems to completely fill 4/6 of the disks,
while leaving lots of space free on 2 of the disks. I've tried full
filesystem balances, yet the problem continues.

# btrfs fi show

Label: none  uuid: 78733087-d597-4301-8efa-8e1df800b108
        Total devices 6 FS bytes used 11.59TiB
        devid    1 size 3.64TiB used 3.64TiB path /dev/sdd
        devid    2 size 3.64TiB used 3.64TiB path /dev/sdg
        devid    3 size 3.64TiB used 3.64TiB path /dev/sdf
        devid    5 size 3.64TiB used 2.92TiB path /dev/sda
        devid    6 size 3.64TiB used 1.48TiB path /dev/sdb
        devid    7 size 3.64TiB used 3.64TiB path /dev/sdc

btrfs-progs v4.2.3



# btrfs fi df /mnt/data

Data, RAID6: total=11.67TiB, used=11.58TiB
System, RAID6: total=64.00MiB, used=1.70MiB
Metadata, RAID6: total=15.58GiB, used=13.89GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
dan@Morpheus:/mnt/data/temp$ sudo btrfs fi usage /mnt/data



# btrfs fi usage /mnt/data

WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
    Device size:                  21.83TiB
    Device allocated:                0.00B
    Device unallocated:           21.83TiB
    Device missing:                  0.00B
    Used:                            0.00B
    Free (estimated):                0.00B      (min: 8.00EiB)
    Data ratio:                       0.00
    Metadata ratio:                   0.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID6: Size:11.67TiB, Used:11.58TiB
   /dev/sda        2.92TiB
   /dev/sdb        1.48TiB
   /dev/sdc        3.63TiB
   /dev/sdd        3.63TiB
   /dev/sdf        3.63TiB
   /dev/sdg        3.63TiB

Metadata,RAID6: Size:15.58GiB, Used:13.89GiB
   /dev/sda        4.05GiB
   /dev/sdb        1.50GiB
   /dev/sdc        5.01GiB
   /dev/sdd        5.01GiB
   /dev/sdf        5.01GiB
   /dev/sdg        5.01GiB

System,RAID6: Size:64.00MiB, Used:1.70MiB
   /dev/sda       16.00MiB
   /dev/sdb       16.00MiB
   /dev/sdc       16.00MiB
   /dev/sdd       16.00MiB
   /dev/sdf       16.00MiB
   /dev/sdg       16.00MiB

Unallocated:
   /dev/sda      733.65GiB
   /dev/sdb        2.15TiB
   /dev/sdc        1.02MiB
   /dev/sdd        1.02MiB
   /dev/sdf        1.02MiB
   /dev/sdg        1.02MiB




Can anyone shed some light on why a full balance (sudo btrfs balance
start /mnt/data) doesnt seem to straighten this out? Any and all help
is appreciated.


Thanks!
