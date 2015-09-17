Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34340 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbbIQKoH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 06:44:07 -0400
Received: by igcpb10 with SMTP id pb10so9369011igc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 03:44:06 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 17 Sep 2015 12:44:06 +0200
Message-ID: <CADPUUGHfiadVFxOpjH8bmvuznZ6+w+EP2xnyzGKtaFuW9vUSdw@mail.gmail.com>
Subject: btrfs progs 4.1.1 & 4.2 segfault on chunk-recover
From: Daniel Wiegert <daniel@thewiegerts.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello guys

I think I might found a bug, Lots of text, I dont know what you want
from me and not, so I try to get almost everything in one mail, please
dont shoot me! :)

To make a long store somewhat short, this is about what happend to me;
(skip to **** if you dont care about history)

Arch-linux, btrfs-progs 4.1.1 & 4.2, linux 4.1.6-1

Data, RAID5: total=3.11TiB, used=0.00B <-- this one said the other day
used=3.05TiB
System, RAID1: total=32.00MiB, used=0.00B
Metadata, RAID1: total=8.00GiB, used=144.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

Label: 'Isolinear'  uuid: 9bb3f369-f2a9-46be-8dde-1106ae740e36
        Total devices 9 FS bytes used 144.00KiB
        devid    7 size 2.73TiB used 541.12GiB path /dev/sdi
        devid    9 size 1.36TiB used 533.09GiB path /dev/sdd2
        devid   10 size 1.36TiB used 533.09GiB path /dev/sdg2
        devid   11 size 1.82TiB used 536.12GiB path /dev/sdj2
        devid   12 size 1.82TiB used 538.09GiB path /dev/sdh2
        devid   13 size 286.09GiB used 286.09GiB path /dev/sda3
        devid   14 size 286.09GiB used 286.09GiB path /dev/sdb3
        devid   15 size 372.61GiB used 372.61GiB path /dev/sdf1
        *** Some devices missing

drive 8 was a 1.36TiB
drive 15 is the new drive I added to the system.


*one of 8 drives started to fail, smart saw error, I failed in my
configure and I didn't get notified - Ran for 3-14 days before I
realized.
*I tried on active running system to btrfs dev del /dev/sd[failing] -
Did not work (I think it was csum errors)
*I added one new disk to raid, rebooted and added new disk to array,
tried balancing. Power fail and ups fail after x hours
*I rebooted realized the failing drive was now dead. I could mount
system with degraded and some files gave me kernel panic (
https://goo.gl/photos/UXrZj6YEUW3945b37 )- others were reading fine.
-Was unable to dev del missing.

At this point I knew the system was probobly broken beyond repair. so
I just tried all commands I could think of. check repair, check
init-csum-tree etc endless loop - First very fast text scrolling, lots
of CPU not much diskIO, after ~48h text slow, lots of cpu, almost no
diskIO same type of message repeating (with new numbers):
-----
ref mismatch on [17959857729536 4096] extent item 0, found 1
adding new data backref on 17959857729536 parent 35277570539520 owner
0 offset 0 found 1
Backref 17959857729536 parent 35277570539520 owner 0 offset 0 num_refs
0 not found in extent tree
Incorrect local backref count on 17959857729536 parent 35277570539520
owner 0 offset 0 found 1 wanted 0 back 0x145f7800
backpointer mismatch on [17959857729536 4096]
ref mismatch on [17959857733632 4096] extent item 0, found 1
adding new data backref on 17959857733632 parent 35277570785280 owner
0 offset 0 found 1
Backref 17959857733632 parent 35277570785280 owner 0 offset 0 num_refs
0 not found in extent tree
Incorrect local backref count on 17959857733632 parent 35277570785280
owner 0 offset 0 found 1 wanted 0 back 0x145f7b90
backpointer mismatch on [17959857733632 4096]
-----

**** Found out that chunk-recover gave segfault.(4.1.1 & kdave 4.2)
4.1.1 said in bt:
#0  0x00000000004251bb in btrfs_new_device_extent_record ()
#1  0x00000000004301cb in ?? ()
#2  0x000000000043085d in ?? ()
#3  0x00007fd8071074a4 in start_thread () from /usr/lib/libpthread.so.0
#4  0x00007fd806e4513d in clone () from /usr/lib/libc.so.6

not much help, but I compiled -> https://github.com/kdave/btrfs-progs
and backtrace:

-->  http://pastebin.com/XqRrqAB5

I can repeat the segfault. I made two btrfs-image , one is around 4MB
the other is around 300MB think it was.

So, did I find a bug? I cant find my logs at the beginning of my
failing drive, what it said when I tried to remove the broken drive. I
might be able to try the setup again (Got one more
drive-about-to-fail)



ps;
Ive tried to make alpine to work, but it wont accept my passwords, I
hope gmail web client is ok for you guys, openwrt dev team rejected my
posts just because of this email client

best regards
Daniel

end
