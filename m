Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48803 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3BFChH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 21:37:07 -0500
Date: Wed, 6 Feb 2013 10:34:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Moshe <moshe@zadarastorage.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs wastes disk space after snapshot deletetion.
Message-ID: <20130206023418.GC2278@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <997C7B3B2B234B0ABBD6CFA921215298@moshePC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <997C7B3B2B234B0ABBD6CFA921215298@moshePC>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 04, 2013 at 11:08:01AM +0200, Moshe wrote:
> Hello,
> 
> If I write large sequential file on snapshot, then create another
> snapshot, overwrite file with small amount of data and delete first
> snapshot, second snapshot has very large data extent and only small
> part of it is used.
> For example if I use following sequence:
> mkfs.btrfs /dev/sdn
> mount -o noatime,nodatacow,nospace_cache /dev/sdn /mnt/b
> btrfs sub snap /mnt/b /mnt/b/snap1
> dd if=/dev/zero of=/mnt/b/snap1/t count=15000 bs=65535
> sync
> btrfs sub snap /mnt/b/snap1 /mnt/b/snap2
> dd if=/dev/zero of=/mnt/b/snap2/t seek=3 count=1 bs=2048
> sync
> btrfs sub delete /mnt/b/snap1
> btrfs-debug-tree /dev/sdn
> I see following data extents
> item 6 key (257 EXTENT_DATA 0) itemoff 3537 itemsize 53
>    extent data disk byte 1103101952 nr 194641920
>    extent data offset 0 nr 4096 ram 194641920
>    extent compression 0
> item 7 key (257 EXTENT_DATA 4096) itemoff 3484 itemsize 53
>    extent data disk byte 2086129664 nr 4096
>    extent data offset 0 nr 4096 ram 4096
>    extent compression 0
> 
> In item 6: only 4096 from 194641920 are in use. Rest of space is wasted.
> 
> If I defragment like: btrfs filesystem defragment /mnt/b/snap2/t it
> release wasted space. But I can't use defragment because if I have
> few snapshots I need to run defragment on each snapshot and it
> disconnect relation between snapshot and create multiple copies of
> same data.

Well, just for this case, you can try our experimental feature for your
test, 'snapshot-aware defrag', which is designed for this kind of problems.

It's still floating on the ML, and I've no idea when it'll land in
upstream.

Currently the latest patch is V6, and NOTE: if you want to use
autodefrag(which is recommended), you'd like to apply the v6 patch along
with another patch for autodefrag, otherwise it may crash your box.

FYI,
- snapshot-aware defrag
	https://patchwork.kernel.org/patch/2058911/
- autodefrag fix
	https://patchwork.kernel.org/patch/2058921/

thanks,
liubo

> 
> In our test that create and delete snapshots while writing data, we
> end up with few GBs of disk space wasted.
> 
> Is it possible to limit size of allocated data extents?
> Is it possible to defragment subvolume without breaking snapshots relations?
> Any other idea how to recover wasted space?
> 
> Thanks,
> Moshe Melnikov
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
