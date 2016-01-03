Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35266 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcACDkD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 22:40:03 -0500
Received: by mail-pf0-f180.google.com with SMTP id 78so185496723pfw.2
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 19:40:02 -0800 (PST)
Received: from localhost (203-214-36-148.dyn.iinet.net.au. [203.214.36.148])
        by smtp.gmail.com with ESMTPSA id i66sm78103218pfj.28.2016.01.02.19.40.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Jan 2016 19:40:01 -0800 (PST)
Date: Sun, 3 Jan 2016 14:39:57 +1100
From: Alistair Grant <akgrant0710@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send fail and check hang
Message-ID: <20160103033957.GA18124@alistair-xps13>
References: <20160102044630.GA10269@alistair-xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160102044630.GA10269@alistair-xps13>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 02, 2016 at 03:46:30PM +1100, Alistair Grant wrote:
> 
> When trying to send a snapshot I'm now getting errors such as:
> 
> ERROR: failed to open backups/xps13/@home/@home.20151229_13:43:09/alistair/.mozilla/firefox/yu3bxg7y.default/cookies.sqlite. No such file or directory
>
> [snip...]
> 
> General system information:
> 
> uname -a
> Linux alarmpi 4.1.15-1-ARCH #1 SMP Tue Dec 15 18:39:32 MST 2015 armv7l
> GNU/Linux
> 
> 
> btrfs --version
> btrfs-progs v4.3.1
> 
> 
> 
> mount | grep btrfs
> /dev/sda on /srv/d2root type btrfs (rw,noatime,compress-force=zlib,space_cache)
> 
> 
> > sudo btrfs fi show /srv/d2root
> Label: 'data2'  uuid: d8daaa62-afa2-4654-b7de-22fdc8456e03
> 	Total devices 2 FS bytes used 117.34GiB
> 	devid    1 size 1.82TiB used 118.03GiB path /dev/sda
> 	devid    2 size 1.82TiB used 118.03GiB path /dev/sdb
> 
> 
> 
> > sudo btrfs fi df /srv/d2root
> Data, RAID1: total=117.00GiB, used=116.76GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=1.00GiB, used=595.36MiB
> GlobalReserve, single: total=208.00MiB, used=0.00B
> 
> 
> > sudo btrfs fi usage /srv/d2root
> Overall:
>     Device size:		   3.64TiB
>     Device allocated:		 236.06GiB
>     Device unallocated:		   3.41TiB
>     Device missing:		     0.00B
>     Used:			 234.68GiB
>     Free (estimated):		   1.70TiB	(min: 1.70TiB)
>     Data ratio:			      2.00
>     Metadata ratio:		      2.00
>     Global reserve:		 208.00MiB	(used: 0.00B)
> 
> Data,RAID1: Size:117.00GiB, Used:116.76GiB
>    /dev/sda	 117.00GiB
>    /dev/sdb	 117.00GiB
> 
> Metadata,RAID1: Size:1.00GiB, Used:595.36MiB
>    /dev/sda	   1.00GiB
>    /dev/sdb	   1.00GiB
> 
> System,RAID1: Size:32.00MiB, Used:48.00KiB
>    /dev/sda	  32.00MiB
>    /dev/sdb	  32.00MiB
> 
> Unallocated:
>    /dev/sda	   1.70TiB
>    /dev/sdb	   1.70TiB


I've figured out a workaround for the errors, but I don't understand why
the workaround is needed.

The error that I was getting from the btrfs receive process was:

ERROR: failed to open backups/xps13/@home/@home.20151229_07:57:44/alistair/.mozilla/firefox/yu3bxg7y.default/cookies.sqlite.  No such file or directory

It can be avoided by changing the receive command (which has worked fine
until now) from:

btrfs receive /srv/d2backups/xps13/@home

to:

btrfs receive /srv/d2root/backups/xps13/@home

(not shown in the commands is that while testing I wrote the output from
btrfs send to a file and manually copied it across to the destination
machine.  Normally it is piped through ssh.)

These are the same directory:

(As an added complication, there appears to be a bug somewhere in
4.1.15-1-ARCH as the mount command isn't displaying the subvolume)

> mount | grep btrfs
/dev/sda on /srv/d2backups type btrfs (rw,noatime,compress-force=zlib,space_cache)
/dev/sda on /srv/d2root type btrfs (rw,noatime,compress-force=zlib,space_cache)

The original mount commands were:

> sudo mount -t btrfs -o compress-force=zlib,noatime,subvol=backups
> LABEL=data2 /srv/d2backups
> sudo mount -t btrfs -o compress-force=zlib,noatime LABEL=data2
> /srv/d2root

And can be confirmed by:

> ls /srv/d2root
backups/  snapshots/
> ls /srv/d2root/backups
alistair-srv/  xps13/
> ls /srv/d2backups
alistair-srv/  xps13/

Version information about the destination machine is in my original
message below.

In case information about the source machine is useful:

> uname -a
Linux alistair-xps13 4.2.0-22-generic #27-Ubuntu SMP Thu Dec 17 22:57:08
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

> btrfs --version
btrfs-progs v4.0

The send command was:

sudo btrfs send -p '@home.20151229_07:57:44' -c '@home.20151229_07:57:44' '@home.20160103_13:16:29'

> mount | grep btrfs
/dev/sda4 on /home type btrfs (rw,noatime,compress=zlib,ssd,space_cache,autodefrag,subvolid=257,subvol=/@home)
/dev/sda4 on /srv/home type btrfs (rw,noatime,compress=zlib,ssd,space_cache,autodefrag,subvolid=5,subvol=/)

I don't believe there have been any recent updates to the kernel or
btrfs progs on either machine.

If you would like any more information, please let me know.

Thanks,
Alistair


