Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34585 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbcBFVfE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Feb 2016 16:35:04 -0500
Received: by mail-lb0-f170.google.com with SMTP id cw1so66238098lbb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Feb 2016 13:35:02 -0800 (PST)
Received: from [10.0.0.42] (179.79-161-153.customer.lyse.net. [79.161.153.179])
        by smtp.googlemail.com with ESMTPSA id y63sm2980138lfd.10.2016.02.06.13.35.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sat, 06 Feb 2016 13:35:00 -0800 (PST)
From: Tom Arild Naess <tanaess@gmail.com>
Subject: Unrecoverable error on raid10
To: linux-btrfs@vger.kernel.org
Message-ID: <56B66704.5070505@gmail.com>
Date: Sat, 6 Feb 2016 22:35:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have quite recently converted my file server to btrfs, and I am in the 
progress of setting up a new backup server with btrfs to be able to 
utilize btrfs send/receive.

FIle server:
> uname -a
Linux main 3.19.0-49-generic #55~14.04.1-Ubuntu SMP Fri Jan 22 11:24:31 
UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

> btrfs fi show /store
Label: none  uuid: 2d84ca51-ec42-4fe3-888a-777cad6e1921
     Total devices 4 FS bytes used 4.35TiB
     devid    1 size 3.64TiB used 2.18TiB path /dev/sdc
     devid    2 size 3.64TiB used 2.18TiB path /dev/sdd
     devid    3 size 3.64TiB used 2.18TiB path /dev/sdb
     devid    4 size 3.64TiB used 2.18TiB path /dev/sda

btrfs-progs v4.1 (custom compiled)

> btrfs fi df /store
Data, RAID10: total=4.35TiB, used=4.35TiB
System, RAID10: total=64.00MiB, used=480.00KiB
Metadata, RAID10: total=6.00GiB, used=4.59GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Backup server:
> uname -a
Linux backup 4.2.5-1-ARCH #1 SMP PREEMPT Tue Oct 27 08:13:28 CET 2015 
x86_64 GNU/Linux

> sudo btrfs fi show /backup
Label: none  uuid: 8825ce78-d620-48f5-9f03-8c4568d3719d
     Total devices 4 FS bytes used 2.46TiB
     devid    1 size 2.73TiB used 1.24TiB path /dev/sdb
     devid    2 size 2.73TiB used 1.24TiB path /dev/sda
     devid    3 size 2.73TiB used 1.24TiB path /dev/sdd
     devid    4 size 2.73TiB used 1.24TiB path /dev/sdc

btrfs-progs v4.3

> btrfs fi df /backup
Data, RAID10: total=2.48TiB, used=2.46TiB
System, RAID10: total=64.00MiB, used=320.00KiB
Metadata, RAID10: total=7.00GiB, used=6.02GiB


Today I balanced and scrubbed the file system on the backup server for 
the first time, since I have run several send/receives containing 
terabytes of data and also delete many sub volumes. The scrub came up 
with one uncorrectable error:

> btrfs scrub start -Bd /backup
scrub device /dev/sdb (id 1) done
     scrub started at Sat Feb  6 04:14:36 2016 and finished after 03:30:41
     total bytes scrubbed: 1.23TiB with 0 errors
scrub device /dev/sda (id 2) done
     scrub started at Sat Feb  6 04:14:36 2016 and finished after 03:27:21
     total bytes scrubbed: 1.23TiB with 1 errors
     error details: csum=1
     corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
scrub device /dev/sdd (id 3) done
     scrub started at Sat Feb  6 04:14:36 2016 and finished after 03:27:18
     total bytes scrubbed: 1.23TiB with 1 errors
     error details: csum=1
     corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
scrub device /dev/sdc (id 4) done
     scrub started at Sat Feb  6 04:14:36 2016 and finished after 03:27:19
     total bytes scrubbed: 1.23TiB with 0 errors
ERROR: there are uncorrectable errors


This an except from the logs while scrubbing:

Feb 06 06:21:20 backup kernel: BTRFS: checksum error at logical 
3531011186688 on dev /dev/sdd, sector 3446072048, root 3811, inode 
127923, offset 6936002560, length 4096, links 1 (path: xxxxxxxx)
Feb 06 06:21:20 backup kernel: BTRFS: checksum error at logical 
3531011186688 on dev /dev/sda, sector 3446072048, root 3811, inode 
127923, offset 6936002560, length 4096, links 1 (path: xxxxxxxx)
Feb 06 06:21:20 backup kernel: BTRFS: unable to fixup (regular) error at 
logical 3531011186688 on dev /dev/sda
Feb 06 06:21:20 backup kernel: BTRFS: bdev /dev/sdd errs: wr 0, rd 0, 
flush 0, corrupt 1, gen 0
Feb 06 06:21:20 backup kernel: BTRFS: unable to fixup (regular) error at 
logical 3531011186688 on dev /dev/sdd
Feb 06 06:21:20 backup kernel: BTRFS: bdev /dev/sda errs: wr 0, rd 0, 
flush 0, corrupt 1, gen 0
Feb 06 06:21:20 backup kernel: BTRFS: unable to fixup (regular) error at 
logical 3531011186688 on dev /dev/sda
Feb 06 06:21:20 backup kernel: BTRFS: unable to fixup (regular) error at 
logical 3531011186688 on dev /dev/sdd

What's strange is that the failed file have a checksum error in the 
exact same spot on both the mirrored copies, which means the file is 
unrecoverable. This is not what I expect from a raid10! Unfortunately I 
do only have one snapshot left on the backup server, so I don't know if 
any of the other snapshots had the same problem.

The file (called xxxxxxxx for privacy) was created in the the last btrfs 
send/receive, but I did not notice any errors during the transfer.


This an except from the logs while trying to read the file afterwards:

Feb 06 13:28:45 backup kernel: BTRFS warning (device sdb): csum failed 
ino 127923 off 6936002560 csum 284124578 expected csum 1756277981


Anyone seen anything like this on their system? I guess this is a bug, 
but I have not been able to find anything like this with Google.



-- 
Tom Arild Næss

