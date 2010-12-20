From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] can not allocate space for caching data
Date: Mon, 20 Dec 2010 10:41:17 -0500
Message-ID: <1292859261-sup-570@think>
References: <4D0F4B26.7030406@cn.fujitsu.com> <1292848998-sup-5155@think> <4D0F566A.2020103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	"Yan, Zheng" <yanzheng@21cn.com>
To: miaox <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D0F566A.2020103@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2010-12-20 08:13:14 -0500:
> On Mon, 20 Dec 2010 07:44:06 -0500, Chris Mason wrote:
> > Excerpts from Miao Xie's message of 2010-12-20 07:25:10 -0500:
> >> Hi, Chris
> >>
> >> There is something wrong with this patch:
> >>
> >> commit 83a50de97fe96aca82389e061862ed760ece2283
> >> Author: Chris Mason<chris.mason@oracle.com>
> >> Date:   Mon Dec 13 15:06:46 2010 -0500
> >>
> >>      Btrfs: prevent RAID level downgrades when space is low
> >>
> >>      The extent allocator has code that allows us to fill
> >>      allocations from any available block group, even if it doesn't
> >>      match the raid level we've requested.
> >>
> >> Btrfs has added the space of single chunks and raid0 chunks into the space
> >> information, so when we use btrfs_check_data_free_space() to check if there
> >> is some space for storing file data, this function may return true. So we
> >> write the data into the cache successfully. But, the extent allocator can
> >> not allocate any space to store that cached data, and then the file system
> >> panic.
> >>
> >> I think we subtract that space from the space information, or split the space
> >> information into two types, one is used to manage the chunks with duplication,
> >> the other manages the other chunks.
> >
> > Ok, do you have a test case that triggers this?  I'll work out a patch.
> > Yan Zheng's original idea of 'the chunks should be readonly' should help
> > us deduct them from the total.
> 
> # mkfs.btrfs -d raid1 /dev/sda9 /dev/sda10
> # mount /dev/sda9 /mnt
> # dd if=/dev/zero of=/mnt/tmpfile0 bs=4K count=999999999999999999
>    (fill the file system)
> # umount /mnt
> # mount /dev/sda9 /mnt
> # dd if=/dev/zero of=/mnt/tmpfile1 bs=4K count=1000
> # sync

Looks like we've got an off by one bug in set_block_group_ro, which is
why our block group isn't getting set to ro.  With this patch, we're
properly setting the block group ro, and the enospc accounting is done
correctly.

It should also be able to replace my commit above.  Please take a look,
Zheng does this look correct to you?

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 227e581..6f7d758 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7970,13 +7970,14 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache)
 
 	if (sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned +
 	    sinfo->bytes_may_use + sinfo->bytes_readonly +
-	    cache->reserved_pinned + num_bytes < sinfo->total_bytes) {
+	    cache->reserved_pinned + num_bytes <= sinfo->total_bytes) {
 		sinfo->bytes_readonly += num_bytes;
 		sinfo->bytes_reserved += cache->reserved_pinned;
 		cache->reserved_pinned = 0;
 		cache->ro = 1;
 		ret = 0;
 	}
+
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
 	return ret;
