Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aarghimedes.fi ([62.75.165.48]:48561 "EHLO aarghimedes.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbcENI32 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 May 2016 04:29:28 -0400
Received: from [192.168.1.67] (dsl-sjkbrasgw2-54f8f4-39.dhcp.inet.fi [84.248.244.39])
	by aarghimedes.fi (Postfix) with ESMTPSA id 0EA0763C729B
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 11:19:48 +0300 (EEST)
To: linux-btrfs@vger.kernel.org
From: Jukka Larja <roskakori@aarghimedes.fi>
Subject: Kernel crash on mount after SMR disk trouble
Message-ID: <5736DFA3.3090904@aarghimedes.fi>
Date: Sat, 14 May 2016 11:19:47 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In short:

I added two 8TB Seagate Archive SMR disk to btrfs pool and tried to delete 
one of the old disks. After some errors I ended up with file system that can 
be mounted read-only, but crashes the kernel if mounted normally. Tried 
btrfs check --repair (which noted that space cache needs to be zeroed) and 
zeroing space cache (via mount parameter), but that didn't change anything.

Longer version:

I was originally running Debian Jessie with some pretty recent kernel (maybe 
4.4), but somewhat older btrfs tools. After the trouble started, I tried 
updating (now running Kernel 4.5.1 and tools 4.4.1). I checked the new disks 
with badblocks (no problems found), but based on some googling, Seagate's 
SMR disks seem to have various problems, so the root cause is probably one 
type or another of disk errors.

Here's the output of btrfs fi show:

Label: none  uuid: 8b65962d-0982-449b-ac6f-1acc8397ceb9
         Total devices 12 FS bytes used 13.15TiB
         devid    1 size 3.64TiB used 3.36TiB path /dev/sde1
         devid    2 size 3.64TiB used 3.36TiB path /dev/sdg1
         devid    3 size 3.64TiB used 3.36TiB path /dev/sdh1
         devid    4 size 3.64TiB used 3.34TiB path /dev/sdf1
         devid    5 size 1.82TiB used 1.44TiB path /dev/sdi1
         devid    6 size 1.82TiB used 1.54TiB path /dev/sdl1
         devid    7 size 1.82TiB used 1.51TiB path /dev/sdk1
         devid    8 size 1.82TiB used 1.54TiB path /dev/sdj1
         devid    9 size 3.64TiB used 3.31TiB path /dev/sdb1
         devid   10 size 3.64TiB used 3.36TiB path /dev/sda1
         devid   11 size 7.28TiB used 168.00GiB path /dev/sdc1
         devid   12 size 7.28TiB used 168.00GiB path /dev/sdd1

Last two devices (11 and 12) are the new disks. After adding them, I first 
copied some new data in (about 130 GBs), which seemed to go fine. Then I 
tried to remove disk 5. After some time (about 30 GiBs written to 11 and 
12), there were some errors and disk 11 or 12 dropped out and fs went 
read-only. After some trouble-shooting (googling), I decided the new disks 
were too iffy to trust and tried to remove them.

I don't remember exactly what errors I got, but device delete operation was 
interrupted due to errors at least once or twice, before more serious 
trouble began. In between the attempts I updated the HBA's (an LSI 9300) 
firmware. After final device delete attempt the end result was that 
attempting to mount causes kernel to crash. I then tried updating kernel and 
running check --repair, but that hasn't helped. Mounting read-only seems to 
work perfectly, but I haven't tried copying everything to /dev/null or 
anything like that (just few files).

The log of the crash (it is very repeatable) can be seen here: 
http://jane.aarghimedes.fi/~jlarja/tempe/btrfs-trouble/btrfs_crash_log.txt

Snipped from start of that:

touko 12 06:41:22 jane kernel: BTRFS info (device sda1): disk space caching 
is enabled
touko 12 06:41:24 jane kernel: BTRFS info (device sda1): bdev /dev/sdd1 
errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
touko 12 06:41:39 jane kernel: BUG: unable to handle kernel NULL pointer 
dereference at 00000000000001f0
touko 12 06:41:39 jane kernel: IP: [<ffffffffc030e0ee>] 
can_overcommit+0x1e/0xf0 [btrfs]
touko 12 06:41:39 jane kernel: PGD 0
touko 12 06:41:39 jane kernel: Oops: 0000 [#1] SMP

My dmesg log is here: 
http://jane.aarghimedes.fi/~jlarja/tempe/btrfs-trouble/dmesg.log

Other information:
Linux jane 4.5.0-1-amd64 #1 SMP Debian 4.5.1-1 (2016-04-14) x86_64 GNU/Linux
btrfs-progs v4.4.1

btrfs fi df /mnt/Allosaurus/
     Data, RAID1: total=13.13TiB, used=13.07TiB
     Data, single: total=8.00MiB, used=0.00B
     System, RAID1: total=8.00MiB, used=1.94MiB
     System, single: total=4.00MiB, used=0.00B
     Metadata, RAID1: total=87.00GiB, used=85.24GiB
     Metadata, single: total=8.00MiB, used=0.00B
     GlobalReserve, single: total=512.00MiB, used=0.00B


The data is either backups or media data dublicated elsewhere, so I'm in no 
great hurry and could just fix everything just with enough new disks and cp 
-R. However, it would save me a lot of trouble (and some money) if I could 
get this fixed otherwise. Of course, would be nice in general for the future 
kernel not to crash when mounting corrupted file system :) .

-- 
      ...Elämälle vierasta toimintaa...
      Jukka Larja, jlarja@iki.fi, 0407679919

"Our own Charlie D reckons that 18.2 per cent of Internet traffic is now 
pr0n, and if Intel's Netbust can make the Internet faster, can the sempr0n 
make pr0n faster?"
- The Inquirer, http://www.theinquirer.net/?article=16447 -

