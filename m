Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frodo.1stsolutions.be ([192.168.250.215])
	by SC01.hds.spamcleaner.be  with ESMTP id t61HFQZv019100-t61HFQZw019100
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jul 2015 19:15:26 +0200
Message-Id: <55943C4A020000AF000DA3F7@frodo.1stsolutions.be>
Date: Wed, 01 Jul 2015 19:15:22 +0200
From: "Roel Niesen" <Roel.Niesen@1stsolutions.be>
To: <linux-btrfs@vger.kernel.org>
Subject: urgent: disk space problem
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm using 8 2TB disk  in RAID10 for data and meta.
Zo a native usable spavce of 7.3TB is acceptable (logical).

I created 1 volume with all disk and mount them on /btrfs.

2 folders are created:
iscsi = containing iscsi volumes
samba= contiing folders for Samba.

When I do a du -h /btfs I use 4.8TB of disk, but btrfs is telling me the filesystem is full.

btrfs fi sh:
root@sanos1:~# btrfs fi sh
Label: none  uuid: f07e804e-c5a8-468c-8d84-5e3cc92991e9
        Total devices 8 FS bytes used 7.19TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sdb
        devid    2 size 1.82TiB used 1.82TiB path /dev/sdc
        devid    3 size 1.82TiB used 1.82TiB path /dev/sdd
        devid    4 size 1.82TiB used 1.82TiB path /dev/sde
        devid    5 size 1.82TiB used 1.82TiB path /dev/sdf
        devid    6 size 1.82TiB used 1.82TiB path /dev/sdg
        devid    7 size 1.82TiB used 1.82TiB path /dev/sdh
        devid    8 size 1.82TiB used 1.82TiB path /dev/sdi

Btrfs v3.18.2

btrfs fi df /btrfs:
root@sanos1:~# btrfs fi df /btrfs
Data, RAID10: total=7.26TiB, used=7.18TiB
System, RAID10: total=43.75MiB, used=2.09MiB
Metadata, RAID10: total=11.61GiB, used=10.75GiB
GlobalReserve, single: total=512.00MiB, used=2.33MiB

df -h:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       455G  4.2G  428G   1% /
none            4.0K     0  4.0K   0% /sys/fs/cgroup
udev            1.9G   12K  1.9G   1% /dev
tmpfs           382M   12M  370M   4% /run
none            5.0M     0  5.0M   0% /run/lock
none            1.9G     0  1.9G   0% /run/shm
none            100M     0  100M   0% /run/user
/dev/sdb        7.3T  7.2T   91G  99% /btrfs


du -h /btrfs:
4.8T    /btrfs

uname:
Linux sanos1 3.18.5 #2 SMP Thu Feb 5 08:06:40 CET 2015 x86_64 x86_64 x86_64 GNU/Linux

btrfs -version:
Btrfs v3.18.2

distribution:
14.04.2 LTS, Trusty Tahr

Question:
Where is mu 2.4TB disk space and because btrfs is full, everything is slow now?

Thanks.



-- 
Met vriendelijke groeten,
Best regards,
 
Roel Niesen
1st Solutions
Become One


