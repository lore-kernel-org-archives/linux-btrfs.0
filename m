Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65530 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab3G3D7X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 23:59:23 -0400
Message-ID: <51F73A56.8050105@cn.fujitsu.com>
Date: Tue, 30 Jul 2013 12:00:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup arguments to extent_clear_unlock_delalloc
References: <1375111380-19817-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1375111380-19817-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 29 Jul 2013 11:23:00 -0400, Josef Bacik wrote:
> This patch removes the io_tree argument for extent_clear_unlock_delalloc since
> we always use &BTRFS_I(inode)->io_tree, and it separates out the extent tree
> operations from the page operations.  This way we just pass in the extent bits
> we want to clear and then pass in the operations we want done to the pages.
> This is because I'm going to fix what extent bits we clear in some cases and
> rather than add a bunch of new flags we'll just use the actual extent bits we
> want to clear.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/extent_io.c |   32 ++++-------
>  fs/btrfs/extent_io.h |   21 +++----
>  fs/btrfs/inode.c     |  162 ++++++++++++++++++++------------------------------
>  3 files changed, 85 insertions(+), 130 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index cc685dd..deaea9c 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1678,31 +1678,21 @@ out_failed:
>  	return found;
>  }
>  
> -int extent_clear_unlock_delalloc(struct inode *inode,
> -				struct extent_io_tree *tree,
> -				u64 start, u64 end, struct page *locked_page,
> -				unsigned long op)
> +int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
> +				 struct page *locked_page,
> +				 unsigned long clear_bits,
> +				 unsigned long page_ops)
>  {
> +	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
>  	int ret;
>  	struct page *pages[16];
>  	unsigned long index = start >> PAGE_CACHE_SHIFT;
>  	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
>  	unsigned long nr_pages = end_index - index + 1;
>  	int i;
> -	unsigned long clear_bits = 0;
> -
> -	if (op & EXTENT_CLEAR_UNLOCK)
> -		clear_bits |= EXTENT_LOCKED;
> -	if (op & EXTENT_CLEAR_DIRTY)
> -		clear_bits |= EXTENT_DIRTY;
> -
> -	if (op & EXTENT_CLEAR_DELALLOC)
> -		clear_bits |= EXTENT_DELALLOC;
>  
>  	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
> -	if (!(op & (EXTENT_CLEAR_UNLOCK_PAGE | EXTENT_CLEAR_DIRTY |
> -		    EXTENT_SET_WRITEBACK | EXTENT_END_WRITEBACK |
> -		    EXTENT_SET_PRIVATE2)))
> +	if (page_ops == 0)
>  		return 0;
>  
>  	while (nr_pages > 0) {
> @@ -1711,20 +1701,20 @@ int extent_clear_unlock_delalloc(struct inode *inode,
>  				     nr_pages, ARRAY_SIZE(pages)), pages);
>  		for (i = 0; i < ret; i++) {
>  
> -			if (op & EXTENT_SET_PRIVATE2)
> +			if (page_ops & PAGE_SET_PRIVATE2)
>  				SetPagePrivate2(pages[i]);
>  
>  			if (pages[i] == locked_page) {
>  				page_cache_release(pages[i]);
>  				continue;
>  			}
> -			if (op & EXTENT_CLEAR_DIRTY)
> +			if (page_ops & PAGE_CLEAR_DIRTY)
>  				clear_page_dirty_for_io(pages[i]);
> -			if (op & EXTENT_SET_WRITEBACK)
> +			if (page_ops & PAGE_SET_WRITEBACK)
>  				set_page_writeback(pages[i]);
> -			if (op & EXTENT_END_WRITEBACK)
> +			if (page_ops & PAGE_END_WRITEBACK)
>  				end_page_writeback(pages[i]);
> -			if (op & EXTENT_CLEAR_UNLOCK_PAGE)
> +			if (page_ops & PAGE_UNLOCK)
>  				unlock_page(pages[i]);
>  			page_cache_release(pages[i]);
>  		}
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index f7544af..c450620 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -44,14 +44,11 @@
>  #define EXTENT_BUFFER_DUMMY 9
>  
>  /* these are flags for extent_clear_unlock_delalloc */
> -#define EXTENT_CLEAR_UNLOCK_PAGE 0x1
> -#define EXTENT_CLEAR_UNLOCK	 0x2
> -#define EXTENT_CLEAR_DELALLOC	 0x4
> -#define EXTENT_CLEAR_DIRTY	 0x8
> -#define EXTENT_SET_WRITEBACK	 0x10
> -#define EXTENT_END_WRITEBACK	 0x20
> -#define EXTENT_SET_PRIVATE2	 0x40
> -#define EXTENT_CLEAR_ACCOUNTING  0x80
> +#define PAGE_UNLOCK		(1 << 0)
> +#define PAGE_CLEAR_DIRTY	(1 << 1)
> +#define PAGE_SET_WRITEBACK	(1 << 2)
> +#define PAGE_END_WRITEBACK	(1 << 3)
> +#define PAGE_SET_PRIVATE2	(1 << 4)
>  
>  /*
>   * page->private values.  Every page that is controlled by the extent
> @@ -328,10 +325,10 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
>  		      unsigned long *map_len);
>  int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
>  int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
> -int extent_clear_unlock_delalloc(struct inode *inode,
> -				struct extent_io_tree *tree,
> -				u64 start, u64 end, struct page *locked_page,
> -				unsigned long op);
> +int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
> +				 struct page *locked_page,
> +				 unsigned long bits_to_clear,
> +				 unsigned long page_ops);
>  struct bio *
>  btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
>  		gfp_t gfp_flags);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3f94b21..a60be02 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -489,13 +489,13 @@ cont:
>  			 * we don't need to create any more async work items.
>  			 * Unlock and free up our temp pages.
>  			 */
> -			extent_clear_unlock_delalloc(inode,
> -			     &BTRFS_I(inode)->io_tree,
> -			     start, end, NULL,
> -			     EXTENT_CLEAR_UNLOCK_PAGE | EXTENT_CLEAR_DIRTY |
> -			     EXTENT_CLEAR_DELALLOC |
> -			     EXTENT_SET_WRITEBACK | EXTENT_END_WRITEBACK);
> -
> +			extent_clear_unlock_delalloc(inode, start, end, NULL,
> +						     EXTENT_DIRTY |
> +						     EXTENT_DELALLOC,
> +						     PAGE_UNLOCK |
> +						     PAGE_CLEAR_DIRTY |
> +						     PAGE_SET_WRITEBACK |
> +						     PAGE_END_WRITEBACK);
>  			btrfs_end_transaction(trans, root);
>  			goto free_pages_out;
>  		}
> @@ -592,13 +592,10 @@ free_pages_out:
>  	goto out;
>  
>  cleanup_and_out:
> -	extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
> -				     start, end, NULL,
> -				     EXTENT_CLEAR_UNLOCK_PAGE |
> -				     EXTENT_CLEAR_DIRTY |
> -				     EXTENT_CLEAR_DELALLOC |
> -				     EXTENT_SET_WRITEBACK |
> -				     EXTENT_END_WRITEBACK);
> +	extent_clear_unlock_delalloc(inode, start, end, NULL,
> +				     EXTENT_DIRTY | EXTENT_DELALLOC,
> +				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
> +				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
>  	if (!trans || IS_ERR(trans))
>  		btrfs_error(root->fs_info, ret, "Failed to join transaction");
>  	else
> @@ -770,16 +767,12 @@ retry:
>  		/*
>  		 * clear dirty, set writeback and unlock the pages.
>  		 */
> -		extent_clear_unlock_delalloc(inode,
> -				&BTRFS_I(inode)->io_tree,
> -				async_extent->start,
> +		extent_clear_unlock_delalloc(inode, async_extent->start,
>  				async_extent->start +
>  				async_extent->ram_size - 1,
> -				NULL, EXTENT_CLEAR_UNLOCK_PAGE |
> -				EXTENT_CLEAR_UNLOCK |
> -				EXTENT_CLEAR_DELALLOC |
> -				EXTENT_CLEAR_DIRTY | EXTENT_SET_WRITEBACK);
> -
> +				NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
> +				EXTENT_DIRTY, PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
> +				PAGE_SET_WRITEBACK);
>  		ret = btrfs_submit_compressed_write(inode,
>  				    async_extent->start,
>  				    async_extent->ram_size,
> @@ -798,16 +791,13 @@ out:
>  out_free_reserve:
>  	btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
>  out_free:
> -	extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
> -				     async_extent->start,
> +	extent_clear_unlock_delalloc(inode, async_extent->start,
>  				     async_extent->start +
>  				     async_extent->ram_size - 1,
> -				     NULL, EXTENT_CLEAR_UNLOCK_PAGE |
> -				     EXTENT_CLEAR_UNLOCK |
> -				     EXTENT_CLEAR_DELALLOC |
> -				     EXTENT_CLEAR_DIRTY |
> -				     EXTENT_SET_WRITEBACK |
> -				     EXTENT_END_WRITEBACK);
> +				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
> +				     EXTENT_DIRTY, PAGE_UNLOCK |
> +				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
> +				     PAGE_END_WRITEBACK);
>  	kfree(async_extent);
>  	goto again;
>  }
> @@ -892,15 +882,11 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
>  		ret = cow_file_range_inline(trans, root, inode,
>  					    start, end, 0, 0, NULL);
>  		if (ret == 0) {
> -			extent_clear_unlock_delalloc(inode,
> -				     &BTRFS_I(inode)->io_tree,
> -				     start, end, NULL,
> -				     EXTENT_CLEAR_UNLOCK_PAGE |
> -				     EXTENT_CLEAR_UNLOCK |
> -				     EXTENT_CLEAR_DELALLOC |
> -				     EXTENT_CLEAR_DIRTY |
> -				     EXTENT_SET_WRITEBACK |
> -				     EXTENT_END_WRITEBACK);
> +			extent_clear_unlock_delalloc(inode, start, end, NULL,
> +				     EXTENT_LOCKED | EXTENT_DELALLOC |
> +				     EXTENT_DIRTY, PAGE_UNLOCK |
> +				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
> +				     PAGE_END_WRITEBACK);
>  
>  			*nr_written = *nr_written +
>  			     (end - start + PAGE_CACHE_SIZE) / PAGE_CACHE_SIZE;
> @@ -990,13 +976,13 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
>  		 * Do set the Private2 bit so we know this page was properly
>  		 * setup for writepage
>  		 */
> -		op = unlock ? EXTENT_CLEAR_UNLOCK_PAGE : 0;
> -		op |= EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
> -			EXTENT_SET_PRIVATE2;
> +		op = unlock ? PAGE_UNLOCK : 0;
> +		op |= PAGE_SET_PRIVATE2;
>  
> -		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
> -					     start, start + ram_size - 1,
> -					     locked_page, op);
> +		extent_clear_unlock_delalloc(inode, start,
> +					     start + ram_size - 1, locked_page,
> +					     EXTENT_LOCKED | EXTENT_DELALLOC,
> +					     op);
>  		disk_num_bytes -= cur_alloc_size;
>  		num_bytes -= cur_alloc_size;
>  		alloc_hint = ins.objectid + ins.offset;
> @@ -1008,16 +994,11 @@ out:
>  out_reserve:
>  	btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
>  out_unlock:
> -	extent_clear_unlock_delalloc(inode,
> -		     &BTRFS_I(inode)->io_tree,
> -		     start, end, locked_page,
> -		     EXTENT_CLEAR_UNLOCK_PAGE |
> -		     EXTENT_CLEAR_UNLOCK |
> -		     EXTENT_CLEAR_DELALLOC |
> -		     EXTENT_CLEAR_DIRTY |
> -		     EXTENT_SET_WRITEBACK |
> -		     EXTENT_END_WRITEBACK);
> -
> +	extent_clear_unlock_delalloc(inode, start, end, locked_page,
> +				     EXTENT_LOCKED | EXTENT_DIRTY |
> +				     EXTENT_DELALLOC, PAGE_UNLOCK |
> +				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
> +				     PAGE_END_WRITEBACK);
>  	goto out;
>  }
>  
> @@ -1033,15 +1014,12 @@ static noinline int cow_file_range(struct inode *inode,
>  
>  	trans = btrfs_join_transaction(root);
>  	if (IS_ERR(trans)) {
> -		extent_clear_unlock_delalloc(inode,
> -			     &BTRFS_I(inode)->io_tree,
> -			     start, end, locked_page,
> -			     EXTENT_CLEAR_UNLOCK_PAGE |
> -			     EXTENT_CLEAR_UNLOCK |
> -			     EXTENT_CLEAR_DELALLOC |
> -			     EXTENT_CLEAR_DIRTY |
> -			     EXTENT_SET_WRITEBACK |
> -			     EXTENT_END_WRITEBACK);
> +		extent_clear_unlock_delalloc(inode, start, end, locked_page,
> +					     EXTENT_LOCKED | EXTENT_DELALLOC |
> +					     EXTENT_DIRTY, PAGE_UNLOCK |
> +					     PAGE_CLEAR_DIRTY |
> +					     PAGE_SET_WRITEBACK |
> +					     PAGE_END_WRITEBACK);
>  		return PTR_ERR(trans);
>  	}
>  	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
> @@ -1221,15 +1199,12 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  
>  	path = btrfs_alloc_path();
>  	if (!path) {
> -		extent_clear_unlock_delalloc(inode,
> -			     &BTRFS_I(inode)->io_tree,
> -			     start, end, locked_page,
> -			     EXTENT_CLEAR_UNLOCK_PAGE |
> -			     EXTENT_CLEAR_UNLOCK |
> -			     EXTENT_CLEAR_DELALLOC |
> -			     EXTENT_CLEAR_DIRTY |
> -			     EXTENT_SET_WRITEBACK |
> -			     EXTENT_END_WRITEBACK);
> +		extent_clear_unlock_delalloc(inode, start, end, locked_page,
> +					     EXTENT_LOCKED | EXTENT_DELALLOC |
> +					     EXTENT_DIRTY, PAGE_UNLOCK |
> +					     PAGE_CLEAR_DIRTY |
> +					     PAGE_SET_WRITEBACK |
> +					     PAGE_END_WRITEBACK);
>  		return -ENOMEM;
>  	}
>  
> @@ -1241,15 +1216,12 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  		trans = btrfs_join_transaction(root);
>  
>  	if (IS_ERR(trans)) {
> -		extent_clear_unlock_delalloc(inode,
> -			     &BTRFS_I(inode)->io_tree,
> -			     start, end, locked_page,
> -			     EXTENT_CLEAR_UNLOCK_PAGE |
> -			     EXTENT_CLEAR_UNLOCK |
> -			     EXTENT_CLEAR_DELALLOC |
> -			     EXTENT_CLEAR_DIRTY |
> -			     EXTENT_SET_WRITEBACK |
> -			     EXTENT_END_WRITEBACK);
> +		extent_clear_unlock_delalloc(inode, start, end, locked_page,
> +					     EXTENT_LOCKED | EXTENT_DELALLOC |
> +					     EXTENT_DIRTY, PAGE_UNLOCK |
> +					     PAGE_CLEAR_DIRTY |
> +					     PAGE_SET_WRITEBACK |
> +					     PAGE_END_WRITEBACK);
>  		btrfs_free_path(path);
>  		return PTR_ERR(trans);
>  	}
> @@ -1428,11 +1400,11 @@ out_check:
>  			}
>  		}
>  
> -		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
> -				cur_offset, cur_offset + num_bytes - 1,
> -				locked_page, EXTENT_CLEAR_UNLOCK_PAGE |
> -				EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
> -				EXTENT_SET_PRIVATE2);
> +		extent_clear_unlock_delalloc(inode, cur_offset,
> +					     cur_offset + num_bytes - 1,
> +					     locked_page, EXTENT_LOCKED |
> +					     EXTENT_DELALLOC, PAGE_UNLOCK |
> +					     PAGE_SET_PRIVATE2);
>  		cur_offset = extent_end;
>  		if (cur_offset > end)
>  			break;
> @@ -1460,16 +1432,12 @@ error:
>  		ret = err;
>  
>  	if (ret && cur_offset < end)
> -		extent_clear_unlock_delalloc(inode,
> -			     &BTRFS_I(inode)->io_tree,
> -			     cur_offset, end, locked_page,
> -			     EXTENT_CLEAR_UNLOCK_PAGE |
> -			     EXTENT_CLEAR_UNLOCK |
> -			     EXTENT_CLEAR_DELALLOC |
> -			     EXTENT_CLEAR_DIRTY |
> -			     EXTENT_SET_WRITEBACK |
> -			     EXTENT_END_WRITEBACK);
> -
> +		extent_clear_unlock_delalloc(inode, cur_offset, end,
> +					     locked_page, EXTENT_LOCKED |
> +					     EXTENT_DELALLOC | EXTENT_DIRTY,
> +					     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
> +					     PAGE_SET_WRITEBACK |
> +					     PAGE_END_WRITEBACK);
>  	btrfs_free_path(path);
>  	return ret;
>  }
> 

