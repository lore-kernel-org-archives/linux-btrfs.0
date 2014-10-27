Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18179 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbaJ0Bk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 21:40:27 -0400
Message-ID: <544DA288.8040907@cn.fujitsu.com>
Date: Mon, 27 Oct 2014 09:40:24 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Jasper Verberk <jverberk@hotmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Problem converting data raid0 to raid1: enospc errors during
 balance
References: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl>
In-Reply-To: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Although I'm not completely sure, but it seems that, you really ran out 
of space.

[1] Your array won't hold raid1 for 1.97T data
Your array used up 1.97T raid0 data, it takes 1.97T for raid0.
But if converted to 1.97T, it will occupy 1.97T X2 = 3.94T.
Your array are only 2.73T, it is too small to contain the data.

[2]No unallocated free space
When doing convert, btrfs will *NOT* convert the data/metadata in-place, 
it allocate chunk and move data,
which means, if btrfs wants to convert it needs to allocate some raid1 
data chunk for the convert,
and then copy the raid0 data to raid1 data chunk.

However, your 'btrfs fi show' output shows that there is no unallocated 
free space for raid1 data chunk allocation.
(2.75T space all used up for chunk allocation).
Although your 'btrfs fi df' shows there is still about 800G free space, 
that's just free space inside data/medata chunk,
and chunk allocation needs completely free space, which is not allocated 
for any chunk type.
If you really want to free some space from the unused space, you can try 
balance with -d/-m options,
but it won't really do much help on your case due to [1].

[Conculsion]
So the ENOSPC error is not a false alert.
Add more devices (easiest but expensive) or free up some space and then 
use balance with -d/-m
to free up some free space(balance speed maybe slow) seems to be the 
only 2 ways to finish your RAID1
setup.

Thanks,
Qu


-------- Original Message --------
Subject: Problem converting data raid0 to raid1: enospc errors during 
balance
From: Jasper Verberk <jverberk@hotmail.com>
To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
Date: 2014年10月24日 21:32
> Hello,
>
> I'm trying to change my 4 disk btrfs data from raid0 to raid1. The metadata is allready in raid1 and now I'm trying to also make the data raid1.
>
> I'm getting the following errors and I got told on irc to go report this as a bug.
>
> Hoping there is anybody that can give me a hand here in solving it.
>
>
> -------------------------------
> Command I issued was:
>
>    btrfs balance start -dconvert=raid1,soft /data
> -------------------------------
>
> -------------------------------
> Error I got:
>
>    ERROR: error during balancing '/data' - No space left on device
>    There may be more info in syslog - try dmesg | tail
> -------------------------------
>
> -------------------------------
> Last lines of dmesg:
>
> [60098.584459] BTRFS info (device sdc): relocating block group 18282971136 flags 9
> [60102.422310] BTRFS info (device sdc): relocating block group 5398069248 flags 9
> [60102.776406] BTRFS info (device sdc): relocating block group 1103101952 flags 9
> [60103.168554] BTRFS info (device sdc): relocating block group 4194304 flags 4
> [60103.619552] BTRFS info (device sdc): relocating block group 0 flags 2
> [60104.040776] BTRFS info (device sdc): 1046 enospc errors during balance
> -------------------------------
>
> -------------------------------
> Further info:
>
> root@BlackMesa:/mnt# btrfs fi show
> Label: 'data'  uuid: a1e36575-0843-45ab-850e-618a5d8a4b7e
>          Total devices 4 FS bytes used 2.75TiB
>          devid    1 size 2.73TiB used 1.94TiB path /dev/sdb
>          devid    2 size 2.73TiB used 1.94TiB path /dev/sdd
>          devid    3 size 2.73TiB used 1.94TiB path /dev/sdc
>          devid    4 size 2.73TiB used 1.94TiB path /dev/sde
>
>
> root@BlackMesa:/mnt# btrfs fi df /data
> Data, RAID1: total=2.85TiB, used=790.46GiB
> Data, RAID0: total=2.04TiB, used=1.97TiB
> System, RAID1: total=8.00MiB, used=612.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.39GiB
> unknown, single: total=512.00MiB, used=0.00
>
> root@BlackMesa:/mnt# uname -a
> Linux BlackMesa 3.17-1-amd64 #1 SMP Debian 3.17-1~exp1 (2014-10-14) x86_64 GNU/Linux
>
> root@BlackMesa:/mnt# btrfs --version
> Btrfs v3.14.1
> -------------------------------
>
> -------------------------------
> And this is what happens when I try to make an image:
>
> root@BlackMesa:/mnt# btrfs-image -c9 -t4 /dev/sdb /home/jasper/dump.image
> btrfs-image: disk-io.c:155: readahead_tree_block: Assertion `!(ret)' failed.
> Aborted
> ------------------------------- 		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

