Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:39404 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754152AbdCGAhM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 19:37:12 -0500
Date: Tue, 7 Mar 2017 01:36:43 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lists@colorremedies.com
Subject: Re: [PATCH v2 0/6] Chunk level degradable check
Message-ID: <20170307003643.a625476u7ltxjxxh@angband.pl>
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 06, 2017 at 04:58:49PM +0800, Qu Wenruo wrote:
> Btrfs currently uses num_tolerated_disk_barrier_failures to do global
> check for tolerated missing device.
> 
> Although the one-size-fit-all solution is quite safe, it's too strict if
> data and metadata has different duplication level.
> 
> For example, if one use Single data and RAID1 metadata for 2 disks, it
> means any missing device will make the fs unable to be degraded mounted.
> 
> But in fact, some times all single chunks may be in the existing device
> and in that case, we should allow it to be rw degraded mounted.
[...]
> This patchset will introduce a new per-chunk degradable check for btrfs,
> allow above case to succeed, and it's quite small anyway.

I've tested it quite extensively.

As Dmitrii already tested the common case of a raid1/raid10 degraded mount,
I concentrated mostly on cases where the answer is negative.  For example:
raid1 (A,B).  Pull out A.  Add C, start resync but interrupt it halfway. 
Pull out B.  Obviously, C doesn't have every chunk, but this doesn't come
from a naive count; Qu's patch handles this case correctly.

So far, so good.

Not so for -draid5 -mraid1, unfortunately:

[/mnt/btr2/scratch]# btrfs fi us /mnt/vol1
WARNING: RAID56 detected, not implemented
Overall:
    Device size:		  12.00GiB
    Device allocated:		   2.02GiB
    Device unallocated:		   9.98GiB
    Device missing:		     0.00B
    Used:			   7.12MiB
    Free (estimated):		     0.00B	(min: 8.00EiB)
    Data ratio:			      0.00
    Metadata ratio:		      2.00
    Global reserve:		  16.00MiB	(used: 0.00B)

Data,RAID5: Size:2.02GiB, Used:1.21GiB
   /dev/loop0	   1.01GiB
   /dev/loop1	   1.01GiB
   /dev/loop2	   1.01GiB

Metadata,RAID1: Size:1.00GiB, Used:3.55MiB
   /dev/loop0	   1.00GiB
   /dev/loop2	   1.00GiB

System,RAID1: Size:8.00MiB, Used:16.00KiB
   /dev/loop1	   8.00MiB
   /dev/loop2	   8.00MiB

Unallocated:
   /dev/loop0	   1.99GiB
   /dev/loop1	   2.98GiB
   /dev/loop2	   1.98GiB
[/mnt/btr2/scratch]# umount /mnt/vol1
[/mnt/btr2/scratch]# losetup -D                                                                        ✔
[/mnt/btr2/scratch]# losetup -f rb
[/mnt/btr2/scratch]# losetup -f rc
[/mnt/btr2/scratch]# mount -noatime,degraded /dev/loop0 /mnt/vol1
[/mnt/btr2/scratch]# btrfs fi us /mnt/vol1
WARNING: RAID56 detected, not implemented
Overall:
    Device size:		  12.00GiB
    Device allocated:		   2.02GiB
    Device unallocated:		   9.98GiB
    Device missing:		     0.00B
    Used:			   7.12MiB
    Free (estimated):		     0.00B	(min: 8.00EiB)
    Data ratio:			      0.00
    Metadata ratio:		      2.00
    Global reserve:		  16.00MiB	(used: 0.00B)

Data,RAID5: Size:2.02GiB, Used:1.21GiB
   /dev/loop0	   1.01GiB
   /dev/loop0	   1.01GiB
   /dev/loop1	   1.01GiB

Metadata,RAID1: Size:1.00GiB, Used:3.55MiB
   /dev/loop0	   1.00GiB
   /dev/loop1	   1.00GiB

System,RAID1: Size:8.00MiB, Used:16.00KiB
   /dev/loop0	   8.00MiB
   /dev/loop1	   8.00MiB

Unallocated:
   /dev/loop0	   1.99GiB
   /dev/loop0	   2.98GiB
   /dev/loop1	   1.98GiB

Write something, mount degraded again.  Massive data corruption, both on
plain reads and on scrub, unrecoverable.


Obviously, this problem is somewhere with RAID5 rather than this patch set,
but the safety check can't be removed before that is fixed.


-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
