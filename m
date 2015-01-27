Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:49021 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbbA0JVZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 04:21:25 -0500
Received: by mail-we0-f180.google.com with SMTP id m14so13695063wev.11
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 01:21:24 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 27 Jan 2015 02:21:24 -0700
Message-ID: <CABeopkFyVaSAxzgVjXZyqmWAWMG2+mnVXx34w9wEp9mWMjo9Gw@mail.gmail.com>
Subject: Am I missing partiy/redundancy - WARNING: RAID56 detected, not implemented
From: Jeff Smith <jeff@unbiasedgeek.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am just getting started with btrfs and wanted to test raid5.  I set
it up and thought it was setup correctly but when I run " btrfs fi
usage /mnt/btrdata"  I get the message "WARNING: RAID56 detected, not
implemented".   Does this mean I have no redundancy?  I know it is
experimental and I am not relying on it for production data (or data
that cannot be replaced).  I don't think I do.  When I check the free
space (3.7TB) it is the same as all the drive together (4x931MB).


Any assistance in helping me understand would be appreciated greatly.

------
uname -a
Linux alexandria.localdomain 3.17.8-300.fc21.x86_64 #1 SMP Thu Jan 8
23:32:49 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

------
btrfs --version
Btrfs v3.18.1

------
btrfs fi show
Label: 'btrfsMain'  uuid: a111f6f0-4dfd-4327-932a-
2eb87e173632
    Total devices 4 FS bytes used 566.93GiB
    devid    1 size 931.51GiB used 192.02GiB path /dev/sdb
    devid    2 size 931.51GiB used 192.00GiB path /dev/sdd
    devid    3 size 931.51GiB used 192.00GiB path /dev/sde
    devid    4 size 931.51GiB used 192.00GiB path /dev/sdg

Btrfs v3.18.1

-----
btrfs fi df /mnt/btrdata
Data, single: total=8.00MiB, used=0.00B
Data, RAID5: total=585.00GiB, used=580.04GiB
System, single: total=4.00MiB, used=0.00B
System, RAID5: total=12.00MiB, used=64.00KiB
Metadata, single: total=8.00MiB, used=0.00B
Metadata, RAID5: total=3.00GiB, used=642.98MiB
GlobalReserve, single: total=224.00MiB, used=0.00B


-----
btrfs fi usage /mnt/btrdata
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
    Device size:           3.64TiB
    Device allocated:          20.00MiB
    Device unallocated:           3.64TiB
    Used:                 0.00B
    Free (estimated):         267.45PiB    (min: 4.21TiB)
    Data ratio:                  0.00
    Metadata ratio:              0.00
    Global reserve:         224.00MiB    (used: 0.00B)

Data,single: Size:8.00MiB, Used:0.00B
   /dev/sdb       8.00MiB

Data,RAID5: Size:588.00GiB, Used:584.31GiB
   /dev/sdb     196.00GiB
   /dev/sdd     196.00GiB
   /dev/sde     196.00GiB
   /dev/sdg     196.00GiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdb       8.00MiB

Metadata,RAID5: Size:3.00GiB, Used:649.06MiB
   /dev/sdb       1.00GiB
   /dev/sdd       1.00GiB
   /dev/sde       1.00GiB
   /dev/sdg       1.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdb       4.00MiB

System,RAID5: Size:12.00MiB, Used:64.00KiB
   /dev/sdb       4.00MiB
   /dev/sdd       4.00MiB
   /dev/sde       4.00MiB
   /dev/sdg       4.00MiB

Unallocated:
   /dev/sdb     734.49GiB
   /dev/sdd     734.51GiB
   /dev/sde     734.51GiB
   /dev/sdg     734.51GiB
