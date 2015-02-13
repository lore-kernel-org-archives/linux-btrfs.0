Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frodo.1stsolutions.be ([192.168.250.215])
	by SC01.hds.spamcleaner.be  with ESMTP id t1D7Jt1j016372-t1D7Jt1k016372
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 08:19:55 +0100
Message-Id: <54DDB3A9020000AF000D6A8D@frodo.1stsolutions.be>
Date: Fri, 13 Feb 2015 08:19:53 +0100
From: "Roel Niesen" <Roel.Niesen@1stsolutions.be>
To: <linux-btrfs@vger.kernel.org>
Subject: slow system
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
 
Sometimes my system is hanging for a few seconds.
When I start top, I see this :
 
%cpu: 80.7 command: btrfs-transacti
 
Is it normal that btrfs-transaction takes such hijg cpu.
 
uname- a:
Linux sanos1 3.13.11-ckt13 #1 SMP Tue Feb 3 12:06:18 CET 2015 x86_64 x86_64 x86_64 GNU/Linux
 
btrfs fi sh:
 
Label: firstpool  uuid: 517e8cfa-4275-4589-8da4-6a46ad613daa
        Total devices 16 FS bytes used 5.12TiB
        devid    1 size 931.51GiB used 930.92GiB path /dev/sdd
        devid    2 size 931.51GiB used 930.92GiB path /dev/sde
        devid    5 size 931.51GiB used 930.92GiB path /dev/sdh
        devid    6 size 931.51GiB used 930.92GiB path /dev/sdi
        devid    7 size 931.51GiB used 930.92GiB path /dev/sdj
        devid    8 size 931.51GiB used 930.92GiB path /dev/sdk
        devid    9 size 931.51GiB used 930.92GiB path /dev/sdl
        devid    10 size 931.51GiB used 930.92GiB path /dev/sdm
        devid    11 size 931.51GiB used 930.92GiB path /dev/sdn
        devid    12 size 931.51GiB used 930.92GiB path /dev/sdo
        devid    13 size 931.51GiB used 930.92GiB path /dev/sdp
        devid    14 size 931.51GiB used 930.92GiB path /dev/sdq
        devid    15 size 931.51GiB used 930.92GiB path /dev/sdf
        devid    16 size 931.51GiB used 930.92GiB path /dev/sdg
        devid    18 size 931.51GiB used 1.13GiB path /dev/sdb
        devid    19 size 931.51GiB used 1.13GiB path /dev/sdc
 
The drive sdb and sdc where added for another problem where I will make another mail for.
 
btrfs fi df /btrfs
Data, RAID10: total=6.35TiB, used=5.11TiB
System, RAID10: total=64.00MiB, used=604.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID10: total=14.00GiB, used=10.62GiB
 
dmesg:
empty
 
Important:
btrfs device stats /btrfs
[/dev/sdk].write_io_errs   5
[/dev/sdk].read_io_errs    19
[/dev/sdk].flush_io_errs   0
[/dev/sdk].corruption_errs 0
[/dev/sdk].generation_errs 0
[/dev/sdl].write_io_errs   144
[/dev/sdl].read_io_errs    0
[/dev/sdl].flush_io_errs   48
[/dev/sdl].corruption_errs 129
[/dev/sdl].generation_errs 41
All other drive and values are  0.
 
Questions:
 
1) why is my system slow
 
2) unsificient disk space
The 2 disk where added in panic because my system got the message on btrfs unsuficiant disk space.  I saw some articles that if the metadata is > 75% it becomes slow and even can't write anythign to it.
I solved this by temporary added a disk, but that was an iscsi disk from an unstable system.
So I removed that disk and added 2 new fysical disk.
The are not yet use until I do a btrfs balance /btrfs ??
How  can I increase the metadata space?
 
3) error's on the disk k en l
Are these drive broke?
So maybey I have to replace these with teh 2 new once?
 
 
 
 
 
 
 
 
Met vriendelijke groeten,
Best regards,
 
Roel Niesen
1st Solutions
Become One

