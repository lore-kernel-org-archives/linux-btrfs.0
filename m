Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab2F1Djx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 23:39:53 -0400
Message-ID: <4FEBD0EC.6070802@cn.fujitsu.com>
Date: Thu, 28 Jun 2012 11:35:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix dio write vs buffered read race V2
References: <1340718176-4999-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1340718176-4999-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 26 Jun 2012 09:42:56 -0400, Josef Bacik wrote:
> From: Josef Bacik <josef@redhat.com>
> 
> Miao pointed out there's a problem with mixing dio writes and buffered
> reads.  If the read happens between us invalidating the page range and
> actually locking the extent we can bring in pages into page cache.  Then
> once the write finishes if somebody tries to read again it will just find
> uptodate pages and we'll read stale data.  So we need to lock the extent and
> check for uptodate bits in the range.  If there are uptodate bits we need to
> unlock and invalidate again.  This will keep this race from happening since
> we will hold the extent locked until we create the ordered extent, and then
> teh read side always waits for ordered extents.  Thanks,

This patch still can not work well. It is because we don't update i_size in time.
	Writer		Worker		Reader
	lock_extent
	do direct io
	end io
			finish io
			unlock_extent
					lock_extent
					check the pos is beyond EOF or not
					  beyond EOF, zero the page and set it uptodate
					unlock_extent
	update i_size

So I think we must update the i_size in time, and I wrote a small patch to do it:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 77d4ae8..7f05f77 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5992,6 +5992,7 @@ static void btrfs_endio_direct_write(struct bio *bio, int err)
 	struct btrfs_ordered_extent *ordered = NULL;
 	u64 ordered_offset = dip->logical_offset;
 	u64 ordered_bytes = dip->bytes;
+	u64 i_size;
 	int ret;
 
 	if (err)
@@ -6003,6 +6004,11 @@ again:
 	if (!ret)
 		goto out_test;
 
+	/* We don't worry the file truncation because we hold i_mutex now. */
+	i_size = ordered->file_offset + ordered->len;
+	if (i_size > i_size_read(inode))
+		i_size_write(inode, ordered->file_offset + ordered->len);
+
 	ordered->work.func = finish_ordered_fn;
 	ordered->work.flags = 0;
 	btrfs_queue_worker(&root->fs_info->endio_write_workers,

----
After applying your patch(the second version) and this patch, all my test passed. 

But I still think updating the pages is a good way to fix this problem, because it needn't
invalidate the page again and again, and doesn't waste lots of time. Beside that there is no
rule to say the direct io should not touch the page, so I think since we can not invalidate the pages at once just update them. And the race problem between aio and dio can be fixed completely.

Thanks
Miao

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> V1->V2
> -Use invalidate_inode_pages2_range since it will actually unmap existing pages
> -Do a filemap_write_and_wait_range in case of mmap
>  fs/btrfs/inode.c |   42 +++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9d8c45d..a430549 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6360,12 +6360,48 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
>  		 */
>  		ordered = btrfs_lookup_ordered_range(inode, lockstart,
>  						     lockend - lockstart + 1);
> -		if (!ordered)
> +
> +		/*
> +		 * We need to make sure there are no buffered pages in this
> +		 * range either, we could have raced between the invalidate in
> +		 * generic_file_direct_write and locking the extent.  The
> +		 * invalidate needs to happen so that reads after a write do not
> +		 * get stale data.
> +		 */
> +		if (!ordered && (!writing ||
> +		    !test_range_bit(&BTRFS_I(inode)->io_tree,
> +				    lockstart, lockend, EXTENT_UPTODATE, 0,
> +				    cached_state)))
>  			break;
> +
>  		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
>  				     &cached_state, GFP_NOFS);
> -		btrfs_start_ordered_extent(inode, ordered, 1);
> -		btrfs_put_ordered_extent(ordered);
> +
> +		if (ordered) {
> +			btrfs_start_ordered_extent(inode, ordered, 1);
> +			btrfs_put_ordered_extent(ordered);
> +		} else {
> +			/* Screw you mmap */
> +			ret = filemap_write_and_wait_range(file->f_mapping,
> +							   lockstart,
> +							   lockend);
> +			if (ret)
> +				goto out;
> +
> +			/*
> +			 * If we found a page that couldn't be invalidated just
> +			 * fall back to buffered.
> +			 */
> +			ret = invalidate_inode_pages2_range(file->f_mapping,
> +					lockstart >> PAGE_CACHE_SHIFT,
> +					lockend >> PAGE_CACHE_SHIFT);
> +			if (ret) {
> +				if (ret == -EBUSY)
> +					ret = 0;
> +				goto out;
> +			}
> +		}
> +
>  		cond_resched();
>  	}
>  

