Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49311 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbKOGft (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Nov 2015 01:35:49 -0500
Date: Sat, 14 Nov 2015 22:35:39 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Where is the disk space?
Message-ID: <20151115063539.GC16363@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20151113174101.GC19249@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151113174101.GC19249@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Nov 13, 2015 at 09:41:01AM -0800, Marc MERLIN wrote:
> root@polgara:/mnt/btrfs_root# du -sh *
> 28G     @
> 28G     @_hourly.20151113_08:04:01
> 4.0K    @_last
> 4.0K    @_last_rw
> 28G     @_rw.20151113_00:02:01
> root@polgara:/mnt/btrfs_root# df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdb5        56G   40G  5.4G  89% /mnt/btrfs_root
> 
> root@polgara:/mnt/btrfs_root# btrfs fi df .
> Data, single: total=39.85GiB, used=38.52GiB
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=6.00GiB, used=579.17MiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=208.00MiB, used=0.00B
> 
> root@polgara:/mnt/btrfs_root# btrfs fi show .
> Label: 'btrfs_root'  uuid: a2a1ed7b-6bfe-4e83-bc10-727126ed17bf
>         Total devices 1 FS bytes used 39.09GiB
>         devid    1 size 55.88GiB used 51.88GiB path /dev/sdb5
> 
> btrfs-progs v4.0-dirty
> root@polgara:/mnt/btrfs_root# 
> 
> root@polgara:/mnt/btrfs_root# btrfs balance start -dusage=80 -v /mnt/btrfs_root
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=80
> Done, had to relocate 1 out of 55 chunks
> 
> Sadly, it's only running 3.17.8 because of complicated reasons, but still, 
> 
> 1) I have 28GB used (modulo a few files between the btrfs send snapshots and
> current status)
> 
> 2) fi show shows I'm using 39GB, not sure where the extra 11GB came from
> 
> 3) fi df agrees with fi show
> 
> 4) regular df agrees on used too, but shows 5GB free instead of 15GB despite
> the filesystem being balanced.
> 
> I did have a bunch of snapshots that I did delete a while ago now, but it
> looks like their blocks aren't being reclaimed.
> 
> Any ideas?
> 

Since you said you have some snapshots in between...I can think of one
case to prove where the space goes,

Say, you have a file with size=10M on a freshly created partition(the total used data space is 10M), and you have a snapshot which owns this file, then you modify the original file by overwrite the range [3M, 5M], and right now you can find that the total used data space increases to 15M or maybe more (because of unaliged write and extent pads to 4K length).

This comes from our COW and extent references implementation, so you get
the benefit of COW, meanwhile have to live with the un-reclaimed space.

It's sort of something I was trying to fix, but I found that my approach
led to other problems so I decided to give it up.

Thanks,

-liubo

> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
