Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out16.tpgi.com.au ([220.244.226.126]:39598 "EHLO
	mail16.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752476AbbIUMKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 08:10:03 -0400
Received: from mail.jabawok.net (110-175-170-78.static.tpgi.com.au [110.175.170.78])
	by mail16.tpgi.com.au (envelope-from btrfswok@jabawok.net) (8.14.3/8.14.3) with ESMTP id t8LBoG1I017146
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 21:50:18 +1000
Received: from roar.localnet (roar.robhome [192.168.33.192])
	by mail.jabawok.net (Postfix) with ESMTP id 93AAF3A3166
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 19:50:16 +0800 (AWST)
From: Rob <btrfswok@jabawok.net>
To: linux-btrfs@vger.kernel.org
Subject: RAID6 duplicate device in array after replacing a drive. what the?
Date: Mon, 21 Sep 2015 18:20:19 +0800
Message-ID: <3593680.XCB9qMyItR@roar>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I managed to get a test raid6 into a strange state after removing a drive that 
was going faulty, putting in a blank replacement and then mounting with -o 
degraded

uname -a
Linux urvile 4.1.7-v7+ #815 SMP PREEMPT Thu Sep 17 18:34:33 BST 2015 armv7l 
GNU/Linux
btrfs --version
btrfs-progs v4.1.2


Here's the steps taken to get into this state:
1. btrfs scrub start /media/btrfs-rpi-raid6

- at some point the I/O rate dropped, scrub status started showing a lot of 
corrections on sdc1 and kernel spitting heaps of sector errors on sdc. 
smartctl shows lots of current_pending_sectors etc. Time to replace the drive.

2. btrfs scrub cancel /media/btrfs-rpi-raid6

- I waited 4h but this didnt return to a prompt (tried unmounting, killall -9 
btrfs) so i switched power off to the disks, replaced the faulty disk and 
switched the enclosure on again.

at this point we have:
   8        0 1953514584 sda
   8       48 1953514584 sdd
   8       49 1953513560 sdd1
   8       16 1953514584 sdb
   8       17 1953513560 sdb1
   8       32 1953514584 sdc
   8       33 1953513560 sdc1

You can see the drives have shifted position theres a new "sdc" which is one 
of the good drives, and sda is the new unpartitioned drive.

3. mount /dev/sdb1 /media/btrfs-rpi-raid6 -o degraded,noatime

4. btrfs fi usage btrfs-rpi-raid6/
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
    Device size:                  7.28TiB
    Device allocated:            20.00MiB
    Device unallocated:           7.28TiB
    Device missing:                 0.00B
    Used:                          0.00B
    Free (estimated):            83.70PiB     (min: 7.37TiB)
    Data ratio:                     0.00
    Metadata ratio:                  0.00
    Global reserve:              48.00MiB     (used: 0.00B)
Data,single: Size:8.00MiB, Used:0.00B
   /dev/sdc1       8.00MiB
Data,RAID6: Size:92.00GiB, Used:91.34GiB
   /dev/sdb1      46.00GiB
   /dev/sdc1      46.00GiB
   /dev/sdc1      46.00GiB
   /dev/sdd1      46.00GiB
Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdc1       8.00MiB
Metadata,RAID6: Size:2.00GiB, Used:125.38MiB
   /dev/sdb1       1.00GiB
   /dev/sdc1       1.00GiB
   /dev/sdc1       1.00GiB
   /dev/sdd1       1.00GiB
System,single: Size:4.00MiB, Used:0.00B
   /dev/sdc1       4.00MiB
System,RAID6: Size:16.00MiB, Used:16.00KiB
   /dev/sdb1       8.00MiB
   /dev/sdc1       8.00MiB
   /dev/sdc1       8.00MiB
   /dev/sdd1       8.00MiB
Unallocated:
   /dev/sdb1       1.77TiB
   /dev/sdc1       1.77TiB
   /dev/sdc1       1.77TiB
   /dev/sdd1       1.77TiB

The files inside look ok, but looking at the above, i'm scared to touch it lest 
the array goes corrupt.  

So my questions for anyone that is knowledgable are:
- Should the above not say theres a missing device? 
- why is sdc1 listed twice?  
- will bad things (tm) happen if i write to the filesystem?
- are there some commands i can run to safely remove the duplicate so i can 
add the replacement drive and balance?

For completeness, heres some more data points:

btrfs fi df btrfs-rpi-raid6
--------------------
Data, single: total=8.00MiB, used=0.00B
Data, RAID6: total=92.00GiB, used=91.34GiB
System, single: total=4.00MiB, used=0.00B
System, RAID6: total=16.00MiB, used=16.00KiB
Metadata, single: total=8.00MiB, used=0.00B
Metadata, RAID6: total=2.00GiB, used=125.38MiB
GlobalReserve, single: total=48.00MiB, used=0.00B

btrfs fi show btrfs-rpi-raid6
--------------------
Label: 'btrfs-rpi-raid6'  uuid: de8aa5e0-1d58-43df-a14e-160471caef5b
        Total devices 4 FS bytes used 91.46GiB
        devid    1 size 1.82TiB used 47.03GiB path /dev/sdc1
        devid    2 size 1.82TiB used 47.01GiB path /dev/sdc1
        devid    3 size 1.82TiB used 47.01GiB path /dev/sdd1
        devid    4 size 1.82TiB used 47.01GiB path /dev/sdb1

again, duplicate device as devid 1 *and* 2 looks abnormal



Thanks for reading!

-Rob
