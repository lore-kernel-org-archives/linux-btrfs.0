Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:41083 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751594AbeBVFPj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 00:15:39 -0500
Received: by mail-io0-f173.google.com with SMTP id e4so4643860iob.8
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Feb 2018 21:15:39 -0800 (PST)
MIME-Version: 1.0
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Wed, 21 Feb 2018 21:15:38 -0800
Message-ID: <CAG+QAKXX95w4gtRCqjDkUJoSqgVOM2qEX4oDsb-C_gGbY3+w6A@mail.gmail.com>
Subject: fs was hung and sort of full
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a mount point that became ... hung for lack of a better word.

I was doing a LARGE sort of a file in it, using temporary files in
that directory, and the
system hung and probably the watchdog kicked in, reset the system.

Upon reboot, the filesystem hung if you touched it.  Processes were
unkillable if they were using it.

Kernel logs showed nothing ... nothing in dmesg.

$ btrfs filesystem df /.MEDIA/
Data, RAID1: total=1.51TiB, used=1.51TiB
System, RAID1: total=32.00MiB, used=304.00KiB
Metadata, RAID1: total=4.00GiB, used=2.17GiB
GlobalReserve, single: total=512.00MiB, used=2.23MiB

.....is it out of space?  Data might be?  It's 2 x 2TB drives in RAID1,
and I don't think I'm quite up to that above.   I'm using a single
partition:

Disk /dev/sde: 3907029168 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 5214ED9D-769A-4DF8-886F-8EEC3FDD4D0D
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907029134
Partitions will be aligned on 8-sector boundaries
Total free space is 6 sectors (3.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1              40      3907029134   1.8 TiB     8300  BTRFS MEDIA

I'm not using any advanced features like snapshots or subvolumes here.

I did try a btrfs balance, but it seemed to suffer the same hanging fate...

btfs check was fine:

$ sudo btrfs check /dev/sde1
Checking filesystem on /dev/sde1
UUID: 6a69975b-20f9-408f-9120-c457d23d0e55
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 1661050089472 bytes used err is 0
total csum bytes: 1612603964
total tree bytes: 2325479424
total fs tree bytes: 280821760
total extent tree bytes: 182353920
btree space waste bytes: 317572754
file data blocks allocated: 2495485378560
 referenced 1674323156992

$ sudo btrfs fi show /dev/sde1
Label: 'MEDIA'  uuid: 6a69975b-20f9-408f-9120-c457d23d0e55
        Total devices 2 FS bytes used 1.51TiB
        devid    1 size 1.82TiB used 1.51TiB path /dev/sde1
        devid    2 size 1.82TiB used 1.51TiB path /dev/sdd1

$ sudo mount -oro /.MEDIA

worked... and could interact with it

$ sudo mount -orw,remount /.MEDIA

worked ... and I removed the temporary files, and it seem to be ok now.

But why did it hang before?
