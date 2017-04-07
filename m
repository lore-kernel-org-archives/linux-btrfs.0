Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:36394 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755917AbdDGArh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 20:47:37 -0400
Received: by mail-it0-f42.google.com with SMTP id 19so15372115itj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Apr 2017 17:47:32 -0700 (PDT)
MIME-Version: 1.0
From: John Petrini <jpetrini@coredial.com>
Date: Thu, 6 Apr 2017 20:47:31 -0400
Message-ID: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
Subject: Volume appears full but TB's of space available
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello List,

I have a volume that appears to be full despite having multiple
Terabytes of free space available. Just yesterday I ran a re-balance
but it didn't change anything. I've just added two more disks to the
array and am currently in the process of another re-balance but the
available space has not increased.

Currently I can still write to the volume (I haven't tried any large
writes) so I'm not sure if this is just a reporting issue or if writes
will eventually fail.

Any help is appreciated. Here's the details:

uname -a
Linux yuengling.johnpetrini.com 4.4.0-66-generic #87-Ubuntu SMP Fri
Mar 3 15:29:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.4

sudo btrfs fi df /mnt/storage-array/
Data, RAID10: total=10.72TiB, used=10.72TiB
System, RAID0: total=128.00MiB, used=944.00KiB
Metadata, RAID10: total=14.00GiB, used=12.63GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

sudo btrfs fi show /mnt/storage-array/
Label: none  uuid: e113ab87-7869-4ec7-9508-95691f455018
Total devices 10 FS bytes used 10.73TiB
devid    1 size 4.55TiB used 2.65TiB path /dev/sdj
devid    2 size 4.55TiB used 2.65TiB path /dev/sdk
devid    3 size 3.64TiB used 2.65TiB path /dev/sdd
devid    4 size 3.64TiB used 2.65TiB path /dev/sdf
devid    5 size 3.64TiB used 2.65TiB path /dev/sdg
devid    6 size 3.64TiB used 2.65TiB path /dev/sde
devid    7 size 3.64TiB used 2.65TiB path /dev/sdb
devid    8 size 3.64TiB used 2.65TiB path /dev/sdc
devid    9 size 9.10TiB used 149.00GiB path /dev/sdh
devid   10 size 9.10TiB used 149.00GiB path /dev/sdi

sudo btrfs fi usage /mnt/storage-array/
Overall:
    Device size:   49.12TiB
    Device allocated:   21.47TiB
    Device unallocated:   27.65TiB
    Device missing:      0.00B
    Used:   21.45TiB
    Free (estimated):   13.83TiB (min: 13.83TiB)
    Data ratio:       2.00
    Metadata ratio:       2.00
    Global reserve:  512.00MiB (used: 0.00B)

Data,RAID10: Size:10.72TiB, Used:10.71TiB
   /dev/sdb    1.32TiB
   /dev/sdc    1.32TiB
   /dev/sdd    1.32TiB
   /dev/sde    1.32TiB
   /dev/sdf    1.32TiB
   /dev/sdg    1.32TiB
   /dev/sdh   72.00GiB
   /dev/sdi   72.00GiB
   /dev/sdj    1.32TiB
   /dev/sdk    1.32TiB

Metadata,RAID10: Size:14.00GiB, Used:12.63GiB
   /dev/sdb    1.75GiB
   /dev/sdc    1.75GiB
   /dev/sdd    1.75GiB
   /dev/sde    1.75GiB
   /dev/sdf    1.75GiB
   /dev/sdg    1.75GiB
   /dev/sdj    1.75GiB
   /dev/sdk    1.75GiB

System,RAID0: Size:128.00MiB, Used:944.00KiB
   /dev/sdb   16.00MiB
   /dev/sdc   16.00MiB
   /dev/sdd   16.00MiB
   /dev/sde   16.00MiB
   /dev/sdf   16.00MiB
   /dev/sdg   16.00MiB
   /dev/sdj   16.00MiB
   /dev/sdk   16.00MiB

Unallocated:
   /dev/sdb    2.31TiB
   /dev/sdc    2.31TiB
   /dev/sdd    2.31TiB
   /dev/sde    2.31TiB
   /dev/sdf    2.31TiB
   /dev/sdg    2.31TiB
   /dev/sdh    9.03TiB
   /dev/sdi    9.03TiB
   /dev/sdj    3.22TiB
   /dev/sdk    3.22TiB

Thank You,

John Petrini
