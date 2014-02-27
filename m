Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:60649 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaB0STG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 13:19:06 -0500
Received: by mail-pa0-f68.google.com with SMTP id kq14so568718pab.3
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 10:19:05 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 27 Feb 2014 12:19:05 -0600
Message-ID: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
Subject: Help with space
From: Justin Brown <otakujunction@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've a 18 tera hardware raid 5 (areca ARC-1170 w/ 8 3 gig drives) in
need of help.  Disk usage (du) shows 13 tera allocated yet strangely
enough df shows approx. 780 gigs are free.  It seems, somehow, btrfs
has eaten roughly 4 tera internally.  I've run a scrub and a balance
usage=5 with no success, in fact I lost about 20 gigs after the
balance attempt.  Some numbers:

terra:/var/lib/nobody/fs/ubfterra # uname -a
Linux terra 3.12.4-2.44-desktop #1 SMP PREEMPT Mon Dec 9 03:14:51 CST
2013 i686 i686 i386 GNU/Linux

terra:/var/lib/nobody/fs/ubfterra # parted -l
Model: Areca ARC-1170-VOL#00 (scsi)
Disk /dev/sdb: 21.0TB
Sector size (logical/physical): 4096B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name              Flags
 1      1049kB  21.0TB  21.0TB               Linux filesystem

terra:/var/lib/nobody/fs/ubfterra # du -shc *
1.7M    40588-4-1376856876.jpg
2.7M    40588-4-1376856876b.jpg
1008G   Anime
180G    Doctor Who (classic)
5.5T    Downloads
28G     Flash Rescue
1.9T    Jus
3.6T    Tornado
4.0K    dirsanime
4.0K    filesanime
55G     home videos
0       testsub
4.0K    unsharedanime
13T     total

terra:/var/lib/nobody/fs/ubfterra # btrfs fi show /dev/sdb1
Label: ubfterra  uuid: 40f0f692-c68c-4af7-ade2-c15a127ceab5
        Total devices 1 FS bytes used 17.61TiB
        devid    1 size 19.10TiB used 18.34TiB path /dev/sdb1

Btrfs v3.12

terra:/var/lib/nobody/fs/ubfterra # btrfs fi df .
Data, single: total=17.58TiB, used=17.57TiB
System, DUP: total=8.00MiB, used=1.93MiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=392.00GiB, used=33.50GiB
Metadata, single: total=8.00MiB, used=0.00


I use no subvolumes nor are there any snapshots, at least as near as I
can tell.  Any suggestions as to how to recover the missing space
assuming it's possible?  Any help is most appreciated.

-Justin
