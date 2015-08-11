Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34504 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715AbbHKLIg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 07:08:36 -0400
Received: by lbbtg9 with SMTP id tg9so4009522lbb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 04:08:19 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 11 Aug 2015 13:08:19 +0200
Message-ID: <CAC+fKQUhwxYkMcCtmnh__EMAh0CjmmM7XE0+roegBCL9=vOuiA@mail.gmail.com>
Subject: Usage of new added disk not updated while doing a balance
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
To: Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have added a new disk to my filesystem and I'm doing a balance right
now, but I'm a bit worried that the disk usage does not get updated as
it should. I remember from earlier versions that you could see the
disk usage being balanced across all disks.

These are the commands I've run:
# btrfs device add /dev/sdb2 /mnt/btrfs_raid1
# btrfs fi balance /mnt/btrfs_raid1

I see the unallocated space of sdc2 and sdd2 increasing, but for sdb2
(the new disk), it doesn't change. sdb2 doesn't even appear in the
btrfs usage command for data, metadata and system.

Is this normal? It's very strange the disk not showing up in the usage report.

# btrfs --version
btrfs-progs v4.1

# uname -a
Linux xenon 4.1.3-201.fc22.x86_64 #1 SMP Wed Jul 29 19:50:22 UTC 2015
x86_64 x86_64 x86_64 GNU/Linux

# btrfs fi usage /mnt/btrfs_raid1
Overall:
    Device size:                   5.44TiB
    Device allocated:              2.74TiB
    Device unallocated:            2.70TiB
    Device missing:                  0.00B
    Used:                          2.61TiB
    Free (estimated):              1.42TiB      (min: 1.42TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 16.00KiB)

Data,RAID1: Size:1.36TiB, Used:1.30TiB
   /dev/sdc2       1.36TiB
   /dev/sdd2       1.36TiB

Metadata,RAID1: Size:10.00GiB, Used:8.11GiB
   /dev/sdc2      10.00GiB
   /dev/sdd2      10.00GiB

System,RAID1: Size:32.00MiB, Used:224.00KiB
   /dev/sdc2      32.00MiB
   /dev/sdd2      32.00MiB

Unallocated:
   /dev/sdb2       1.81TiB
   /dev/sdc2     454.48GiB
   /dev/sdd2     454.48GiB

# btrfs fi df /mnt/btrfs_raid1
Data, RAID1: total=1.36TiB, used=1.30TiB
System, RAID1: total=32.00MiB, used=224.00KiB
Metadata, RAID1: total=10.00GiB, used=8.13GiB
GlobalReserve, single: total=512.00MiB, used=18.83MiB

# btrfs fi show /mnt/btrfs_raid1
Label: 'btrfs_raid1'  uuid: 03eeb44b-de69-4f1f-9261-70bd7a5c6de0
        Total devices 3 FS bytes used 1.30TiB
        devid    1 size 1.81TiB used 1.37TiB path /dev/sdc2
        devid    2 size 1.81TiB used 1.37TiB path /dev/sdd2
        devid    3 size 1.81TiB used 0.00B path /dev/sdb2

btrfs-progs v4.1

And the kernel log:
ago 11 11:54:45 xenon kernel: BTRFS info (device sdd2): disk added /dev/sdb2
ago 11 11:56:18 xenon kernel: BTRFS info (device sdd2): relocating
block group 1715902349312 flags 17
ago 11 11:56:36 xenon kernel: BTRFS info (device sdd2): found 12127 extents
ago 11 12:09:52 xenon kernel: BTRFS info (device sdd2): found 12127 extents
ago 11 12:09:56 xenon kernel: BTRFS info (device sdd2): relocating
block group 1714828607488 flags 17
ago 11 12:10:11 xenon kernel: BTRFS info (device sdd2): found 1076 extents
ago 11 12:11:24 xenon kernel: BTRFS info (device sdd2): found 1076 extents
ago 11 12:11:25 xenon kernel: BTRFS info (device sdd2): relocating
block group 1713754865664 flags 17
ago 11 12:11:37 xenon kernel: BTRFS info (device sdd2): found 8 extents
ago 11 12:11:50 xenon kernel: BTRFS info (device sdd2): found 8 extents
ago 11 12:11:50 xenon kernel: BTRFS info (device sdd2): relocating
block group 1712681123840 flags 17
ago 11 12:12:16 xenon kernel: BTRFS info (device sdd2): found 1432 extents
ago 11 12:13:17 xenon kernel: BTRFS info (device sdd2): found 1432 extents
[...]

-- 
Juan Orti
https://miceliux.com
