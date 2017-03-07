Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:49655 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756583AbdCGXna (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 18:43:30 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v27MDqi8026511
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 22:13:53 GMT
Date: Tue, 7 Mar 2017 14:11:31 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v6 2/2] btrfs: Handle delalloc error correctly to avoid
 ordered extent hang
Message-ID: <20170307221131.GH12408@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170306025547.1858-1-quwenruo@cn.fujitsu.com>
 <20170306025547.1858-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170306025547.1858-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 06, 2017 at 10:55:47AM +0800, Qu Wenruo wrote:
> [BUG]
> If run_delalloc_range() returns error and there is already some ordered
> extents created, btrfs will be hanged with the following backtrace:
> 
> Call Trace:
>  __schedule+0x2d4/0xae0
>  schedule+0x3d/0x90
>  btrfs_start_ordered_extent+0x160/0x200 [btrfs]
>  ? wake_atomic_t_function+0x60/0x60
>  btrfs_run_ordered_extent_work+0x25/0x40 [btrfs]
>  btrfs_scrubparity_helper+0x1c1/0x620 [btrfs]
>  btrfs_flush_delalloc_helper+0xe/0x10 [btrfs]
>  process_one_work+0x2af/0x720
>  ? process_one_work+0x22b/0x720
>  worker_thread+0x4b/0x4f0
>  kthread+0x10f/0x150
>  ? process_one_work+0x720/0x720
>  ? kthread_create_on_node+0x40/0x40
>  ret_from_fork+0x2e/0x40
> 
> [CAUSE]
> 
> |<------------------ delalloc range --------------------------->|
> | OE 1 | OE 2 | ... | OE n |
> |<>|                       |<---------- cleanup range --------->|
>  ||
>  \_=> First page handled by end_extent_writepage() in __extent_writepage()
> 
> The problem is caused by error handler of run_delalloc_range(), which
> doesn't handle any created ordered extents, leaving them waiting on
> btrfs_finish_ordered_io() to finish.
> 
> However after run_delalloc_range() returns error, __extent_writepage()
> won't submit bio, so btrfs_writepage_end_io_hook() won't be triggered
> except the first page, and btrfs_finish_ordered_io() won't be triggered
> for created ordered extents either.
> 
> So OE 2~n will hang forever, and if OE 1 is larger than one page, it
> will also hang.
> 
> [FIX]
> Introduce btrfs_cleanup_ordered_extents() function to cleanup created
> ordered extents and finish them manually.
> 
> The function is based on existing
> btrfs_endio_direct_write_update_ordered() function, and modify it to
> act just like btrfs_writepage_endio_hook() but handles specified range
> other than one page.
> 
> After fix, delalloc error will be handled like:
> 
> |<------------------ delalloc range --------------------------->|
> | OE 1 | OE 2 | ... | OE n |
> |<>|<--------  ----------->|<------ old error handler --------->|
>  ||          ||
>  ||          \_=> Cleaned up by cleanup_ordered_extents()
>  \_=> First page handled by end_extent_writepage() in __extent_writepage()
>

Looks good, some nitpicks below.

> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> changelog:
> v2:
>   Add BTRFS_ORDERED_SKIP_METADATA flag to avoid double reducing
>   outstanding extents, which is already done by
>   extent_clear_unlock_delalloc() with EXTENT_DO_ACCOUNT control bit
> v3:
>   Skip first page to avoid underflow ordered->bytes_left.
>   Fix range passed in cow_file_range() which doesn't cover the whole
>   extent.
>   Expend extent_clear_unlock_delalloc() range to allow them to handle
>   metadata release.
> v4:
>   Don't use extra bit to skip metadata freeing for ordered extent,
>   but only handle btrfs_reloc_clone_csums() error just before processing
>   next extent.
>   This makes error handle much easier for run_delalloc_nocow().
> v5:
>   Variant gramma and comment fixes suggested by Filipe Manana
>   Enhanced commit message to focus on the generic error handler bug,
>   pointed out by Filipe Manana
>   Adding missing wq/func user in __endio_write_update_ordered(), pointed
>   out by Filipe Manana.
>   Enhanced commit message with ascii art to explain the bug more easily.
>   Fix a bug which can leads to corrupted extent allocation, exposed by
>   Filipe Manana.
> v6:
>   Split the metadata underflow fix to another patch.
>   Use better comment and btrfs_cleanup_ordered_extent() implementation
>   from Filipe Manana.
> ---
>  fs/btrfs/inode.c | 62 ++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 47 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1d83d504f2e5..9b03eb9b27d0 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -115,6 +115,30 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
>  				       u64 ram_bytes, int compress_type,
>  				       int type);
>  
> +static void __endio_write_update_ordered(struct inode *inode,
> +					 u64 offset, u64 bytes,
> +					 bool uptodate);
> +
> +/*
> + * Cleanup all submitted ordered extents in specified range to handle errors
> + * from the fill_dellaloc() callback.
> + *
> + * NOTE: caller must ensure that when an error happens, it can not call
> + * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
> + * and EXTENT_DELALLOC simultaneously, because that causes the reserved metadata
> + * to be released, which we want to happen only when finishing the ordered
> + * extent (btrfs_finish_ordered_io()). Also note that the caller of the
> + * fill_dealloc() callback already does proper cleanup for the first page of

fill_delalloc()

> + * the range, that is, it invokes the callback writepage_end_io_hook() for the
> + * range of the first page.
> + */
> +static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
> +						 u64 offset, u64 bytes)
> +{
> +	return __endio_write_update_ordered(inode, offset + PAGE_SIZE,
> +					    bytes - PAGE_SIZE, false);
> +}
> +
>  static int btrfs_dirty_inode(struct inode *inode);
>  
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> @@ -1536,6 +1560,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
>  		ret = cow_file_range_async(inode, locked_page, start, end,
>  					   page_started, nr_written);
>  	}
> +	if (ret)
> +		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
>  	return ret;
>  }
>  
> @@ -8142,17 +8168,26 @@ static void btrfs_endio_direct_read(struct bio *bio)
>  	bio_put(bio);
>  }
>  
> -static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
> -						    const u64 offset,
> -						    const u64 bytes,
> -						    const int uptodate)
> +static void __endio_write_update_ordered(struct inode *inode,
> +					 u64 offset, u64 bytes,
> +					 bool uptodate)

Not serious, but why const was killed?

With that fixed, you can have 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct btrfs_ordered_extent *ordered = NULL;
> +	struct btrfs_workqueue *wq;
> +	btrfs_work_func_t func;
>  	u64 ordered_offset = offset;
>  	u64 ordered_bytes = bytes;
>  	int ret;
>  
> +	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
> +		wq = fs_info->endio_freespace_worker;
> +		func = btrfs_freespace_write_helper;
> +	} else {
> +		wq = fs_info->endio_write_workers;
> +		func = btrfs_endio_write_helper;
> +	}
> +
>  again:
>  	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
>  						   &ordered_offset,
> @@ -8161,9 +8196,8 @@ static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
>  	if (!ret)
>  		goto out_test;
>  
> -	btrfs_init_work(&ordered->work, btrfs_endio_write_helper,
> -			finish_ordered_fn, NULL, NULL);
> -	btrfs_queue_work(fs_info->endio_write_workers, &ordered->work);
> +	btrfs_init_work(&ordered->work, func, finish_ordered_fn, NULL, NULL);
> +	btrfs_queue_work(wq, &ordered->work);
>  out_test:
>  	/*
>  	 * our bio might span multiple ordered extents.  If we haven't
> @@ -8181,10 +8215,8 @@ static void btrfs_endio_direct_write(struct bio *bio)
>  	struct btrfs_dio_private *dip = bio->bi_private;
>  	struct bio *dio_bio = dip->dio_bio;
>  
> -	btrfs_endio_direct_write_update_ordered(dip->inode,
> -						dip->logical_offset,
> -						dip->bytes,
> -						!bio->bi_error);
> +	__endio_write_update_ordered(dip->inode, dip->logical_offset,
> +				     dip->bytes, !bio->bi_error);
>  
>  	kfree(dip);
>  
> @@ -8545,10 +8577,10 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
>  		io_bio = NULL;
>  	} else {
>  		if (write)
> -			btrfs_endio_direct_write_update_ordered(inode,
> +			__endio_write_update_ordered(inode,
>  						file_offset,
>  						dio_bio->bi_iter.bi_size,
> -						0);
> +						false);
>  		else
>  			unlock_extent(&BTRFS_I(inode)->io_tree, file_offset,
>  			      file_offset + dio_bio->bi_iter.bi_size - 1);
> @@ -8683,11 +8715,11 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  			 */
>  			if (dio_data.unsubmitted_oe_range_start <
>  			    dio_data.unsubmitted_oe_range_end)
> -				btrfs_endio_direct_write_update_ordered(inode,
> +				__endio_write_update_ordered(inode,
>  					dio_data.unsubmitted_oe_range_start,
>  					dio_data.unsubmitted_oe_range_end -
>  					dio_data.unsubmitted_oe_range_start,
> -					0);
> +					false);
>  		} else if (ret >= 0 && (size_t)ret < count)
>  			btrfs_delalloc_release_space(inode, offset,
>  						     count - (size_t)ret);
> -- 
> 2.12.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
