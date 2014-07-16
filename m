Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1991 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbaGPJeV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 05:34:21 -0400
Message-ID: <53C64787.70700@cn.fujitsu.com>
Date: Wed, 16 Jul 2014 17:36:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix abnormal long waiting in fsync
References: <1405416674-17208-1-git-send-email-bo.li.liu@oracle.com> <1405496225-22416-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1405496225-22416-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 16 Jul 2014 15:37:05 +0800, Liu Bo wrote:
> xfstests generic/127 detected this problem.
> 
> With commit 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8, now fsync will only flush
> data within the passed range.  This is the cause of the above problem,
> -- btrfs's fsync has a stage called 'sync log' which will wait for all the
> ordered extents it've recorded to finish.
> 
> In xfstests/generic/127, with mixed operations such as truncate, fallocate,
> punch hole, and mapwrite, we get some pre-allocated extents, and mapwrite will
> mmap, and then msync.  And I find that msync will wait for quite a long time
> (about 20s in my case), thanks to ftrace, it turns out that the previous
> fallocate calls 'btrfs_wait_ordered_range()' to flush dirty pages, but as the
> range of dirty pages may be larger than 'btrfs_wait_ordered_range()' wants,
> there can be some ordered extents created but not getting corresponding pages
> flushed, then they're left in memory until we fsync which runs into the
> stage 'sync log', and fsync will just wait for the system writeback thread
> to flush those pages and get ordered extents finished, so the latency is
> inevitable.
> 
> This adds a flush similar to btrfs_start_ordered_extent() in
> btrfs_wait_logged_extents() to fix that.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: 
>    Move flush part into btrfs_wait_logged_extents() to get the flush range
>    more precise.
> 
>  fs/btrfs/ordered-data.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index e12441c..3b52a76 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -484,8 +484,16 @@ void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid)
>  					   log_list);
>  		list_del_init(&ordered->log_list);
>  		spin_unlock_irq(&log->log_extents_lock[index]);
> +
> +		WARN_ON(!ordered->inode);
> +		if (!test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags))
> +			filemap_fdatawrite_range(ordered->inode->i_mapping,
> +				ordered->file_offset,
> +				ordered->file_offset + ordered->len - 1);

I can use bytes_left to filter the ordered extents that have been written out.

The other is OK.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> +
>  		wait_event(ordered->wait, test_bit(BTRFS_ORDERED_IO_DONE,
>  						   &ordered->flags));
> +
>  		btrfs_put_ordered_extent(ordered);
>  		spin_lock_irq(&log->log_extents_lock[index]);
>  	}
> 

