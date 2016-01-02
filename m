Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33465 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcABEqf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 23:46:35 -0500
Received: by mail-pf0-f182.google.com with SMTP id q63so138364321pfb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 20:46:35 -0800 (PST)
Received: from localhost (210-84-11-251.dyn.iinet.net.au. [210.84.11.251])
        by smtp.gmail.com with ESMTPSA id sy5sm110630052pac.5.2016.01.01.20.46.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Jan 2016 20:46:34 -0800 (PST)
Date: Sat, 2 Jan 2016 15:46:30 +1100
From: Alistair Grant <akgrant0710@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send fail and check hang
Message-ID: <20160102044630.GA10269@alistair-xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When trying to send a snapshot I'm now getting errors such as:

ERROR: failed to open backups/xps13/@home/@home.20151229_13:43:09/alistair/.mozilla/firefox/yu3bxg7y.default/cookies.sqlite. No such file or directory

and

ERROR: could not find parent subvolume

This script has been running without a problem for several weeks.

I can reboot the system and the filesystem mounts without a problem.  I
can also navigate through the existing snapshots and access files
without any problem (these are all read-only snapshots, so I'm not
attempting to write anything).  There are no obvious errors in the
system log (I checked the log manually, and also have Marc Merlin's sec
script running to monitor for errors).

I tried running a read-only btrfs check, however it is hanging while
checking fs roots:

> sudo umount /srv/d2root
> sudo btrfs check /dev/sda
checking filesystem on /dev/sda
UUID: d8daaa62-afa2-4654-b7de-22fdc8456e03
checking extents
checking free space cache
checking fs roots
^C

Disk IO was several MB/s during the initial part of the check and
dropped to 0 on checking fs roots.  I left it for about 10 minutes
before interrupting.

The same happens for /dev/sdb.

General system information:

uname -a
Linux alarmpi 4.1.15-1-ARCH #1 SMP Tue Dec 15 18:39:32 MST 2015 armv7l
GNU/Linux


btrfs --version
btrfs-progs v4.3.1



mount | grep btrfs
/dev/sda on /srv/d2root type btrfs (rw,noatime,compress-force=zlib,space_cache)


> sudo btrfs fi show /srv/d2root
Label: 'data2'  uuid: d8daaa62-afa2-4654-b7de-22fdc8456e03
	Total devices 2 FS bytes used 117.34GiB
	devid    1 size 1.82TiB used 118.03GiB path /dev/sda
	devid    2 size 1.82TiB used 118.03GiB path /dev/sdb



> sudo btrfs fi df /srv/d2root
Data, RAID1: total=117.00GiB, used=116.76GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=1.00GiB, used=595.36MiB
GlobalReserve, single: total=208.00MiB, used=0.00B


> sudo btrfs fi usage /srv/d2root
Overall:
    Device size:		   3.64TiB
    Device allocated:		 236.06GiB
    Device unallocated:		   3.41TiB
    Device missing:		     0.00B
    Used:			 234.68GiB
    Free (estimated):		   1.70TiB	(min: 1.70TiB)
    Data ratio:			      2.00
    Metadata ratio:		      2.00
    Global reserve:		 208.00MiB	(used: 0.00B)

Data,RAID1: Size:117.00GiB, Used:116.76GiB
   /dev/sda	 117.00GiB
   /dev/sdb	 117.00GiB

Metadata,RAID1: Size:1.00GiB, Used:595.36MiB
   /dev/sda	   1.00GiB
   /dev/sdb	   1.00GiB

System,RAID1: Size:32.00MiB, Used:48.00KiB
   /dev/sda	  32.00MiB
   /dev/sdb	  32.00MiB

Unallocated:
   /dev/sda	   1.70TiB
   /dev/sdb	   1.70TiB


Help!

Many Thanks,
Alistair

