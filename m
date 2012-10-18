Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:33914 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2JRFnz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 01:43:55 -0400
Message-ID: <507F970E.4070403@jan-o-sch.net>
Date: Thu, 18 Oct 2012 07:43:42 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] __tree_mod_log_rewind  makes extent buffers larger than
 leafsize
References: <507ECE60.7090309@oracle.com>
In-Reply-To: <507ECE60.7090309@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi liubo,

On Wed, October 17, 2012 at 17:27 (+0200), Liu Bo wrote:
> Hi Jan,
> 
> Here is the steps,
> 
> 1. apply the three patches onto the latest btrfs

Can you give me a commit id? They don't apply to cmason/master as of today.
Patch 1 looks reversed, by the way.

I'd comment on patch 2, but it's hard to comment on something in a tar archive.
You probably wanted to add "add++" where you added "add = 0" for the second time.

> 2. run the script 'debug.sh'[1]
>    (NOTE: edit the script and the fio job file[2] to get device and mount point right before running it)
> 
> 3. it will crash after a few seconds. [3]
> 
> 
> thanks,
> liubo
> 
> 
> [1]:
> $ cat debug.sh 
> #!/bin/bash
> 
> D=/dev/sda5
> M=/mnt/btrfs
> 
> umount $M $D
> mkfs.btrfs $D
> 
> mount $D $M -o autodefrag
> 
> fio fio_sync_random_write_4k_config &
> 
> for ((i=0; i<20; i++))
> do
> 	btrfs sub snap $M $M/s_$i
> 	sleep 2
> done &
> 
> [2]
> $ cat fio_sync_random_write_4k_config 
> [global]
> direct=0
> ioengine=sync
> size=800M
> bs=4k
> numjobs=1
> group_reporting
> invalidate=0
> end_fsync=1
> overwrite=0
> directory=/mnt/btrfs
> 
> 
> [job_sub0]
> startdelay=0
> rw=randwrite
> filename=foo
> 
> [3]
> [   71.980881] device fsid bc47c36a-7e90-453d-aa6b-8c4a12e30dc0 devid 1 transid 4 /dev/sda5
> [   71.984162] btrfs: enabling auto defrag
> [   71.984168] btrfs: disk space caching is enabled
> [   72.051464] root last_snapshot 5
> [   95.789404] root last_snapshot 6
> [  100.229357] root last_snapshot 7
> [  103.252999] record_old_file_extents: ino 257 new file_pos 38273024 len 1048576 bytenr 2387300352 disk_len 1048576
> [  103.255989] record_extent_backrefs file_pos 38273024 len 1048576
> [  103.348648] eb->start 66080768 eb->len 4096 eb->level 1 nritems 66 n 176 rm 110 add 0

Even the first line tells us there's something wrong. n shouldn't exceed 124
with 4k leaves. If you lower the debug output restriction (n > 130) we might
already see through here.

A guess is that we've probably queued some MOD_LOG_MOVE_KEYS operations that
should have modified n.

Thanks,
-Jan
