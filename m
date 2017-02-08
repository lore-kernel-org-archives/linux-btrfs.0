Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14168 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751698AbdBHDtK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 22:49:10 -0500
Subject: Re: understanding disk space usage
To: Vasco Visser <vasco.visser@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
Date: Wed, 8 Feb 2017 11:48:04 +0800
MIME-Version: 1.0
In-Reply-To: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/08/2017 12:44 AM, Vasco Visser wrote:
> Hello,
>
> My system is or seems to be running out of disk space but I can't find
> out how or why. Might be a BTRFS peculiarity, hence posting on this
> list. Most indicators seem to suggest I'm filling up, but I can't
> trace the disk usage to files on the FS.
>
> The issue is on my root filesystem on a 28GiB ssd partition (commands
> below issued when booted into single user mode):
>
>
> $ df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda3              28G   26G  2.1G  93% /
>
>
> $ btrfs --version
> btrfs-progs v4.4
>
>
> $ btrfs fi usage /
> Overall:
>     Device size:  27.94GiB
>     Device allocated:  27.94GiB
>     Device unallocated:   1.00MiB

So from chunk level, your fs is already full.

And balance won't success since there is no unallocated space at all.
The first 1M of btrfs is always reserved and won't be allocated, and 1M 
is too small for btrfs to allocate a chunk.

>     Device missing:     0.00B
>     Used:  25.03GiB
>     Free (estimated):   2.37GiB (min: 2.37GiB)
>     Data ratio:      1.00
>     Metadata ratio:      1.00
>     Global reserve: 256.00MiB (used: 0.00B)
> Data,single: Size:26.69GiB, Used:24.32GiB

You still have 2G data space, so you can still write things.

>    /dev/sda3  26.69GiB
> Metadata,single: Size:1.22GiB, Used:731.45MiB

Metadata has has less space when considering "Global reserve".
In fact the used space would be 987M.

But it's still OK for normal write.

>    /dev/sda3   1.22GiB
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/sda3  32.00MiB

System chunk can hardly be used up.

> Unallocated:
>    /dev/sda3   1.00MiB
>
>
> $ btrfs fi df /
> Data, single: total=26.69GiB, used=24.32GiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=1.22GiB, used=731.48MiB
> GlobalReserve, single: total=256.00MiB, used=0.00B
>
>
> However:
> $ mount -o bind / /mnt
> $ sudo du -hs /mnt
> 9.3G /mnt
>
>
> Try to balance:
> $ btrfs balance start /
> ERROR: error during balancing '/': No space left on device
>
>
> Am I really filling up? What can explain the huge discrepancy with the
> output of du (no open file descriptors on deleted files can explain
> this in single user mode) and the FS stats?

Just don't believe the vanilla df output for btrfs.

For btrfs, unlike other fs like ext4/xfs, which allocates chunk 
dynamically and has different metadata/data profile, we can only get a 
clear view of the fs from both chunk level(allocated/unallocated) and 
extent level(total/used).

In your case, your fs doesn't have any unallocated space, this make 
balance unable to work at all.

And your data/metadata usage is quite high, although both has small 
available space left, the fs should be writable for some time, but not long.

To proceed, add a larger device to current fs, and do a balance or just 
delete the 28G partition then btrfs will handle the rest well.

Thanks,
Qu

>
> Any advice on possible causes and how to proceed?
>
>
> --
> Vasco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


