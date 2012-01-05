From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC][PATCH 3/3] Btrfs: improve truncation of btrfs
Date: Thu, 5 Jan 2012 10:15:50 -0500
Message-ID: <20120105151502.GC1843@localhost.localdomain>
References: <4F05602E.3030907@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F05602E.3030907@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 05, 2012 at 04:32:46PM +0800, Miao Xie wrote:
> The original truncation of btrfs has a bug, that is the orphan item will not be
> dropped when the truncation fails. This bug will trigger BUG() when unlink that
> truncated file. And besides that, if the user does pre-allocation for the file
> which is truncated unsuccessfully, after re-mount(umount-mount, not -o remount),
> the pre-allocated extent will be dropped.
> 
> This patch modified the relative functions of the truncation, and makes the
> truncation update i_size and disk_i_size of i-nodes every time we drop the file
> extent successfully, and set them to the real value. By this way, we needn't
> add orphan items to guarantee the consistency of the meta-data.
> 
> By this patch, it is possible that the file may not be truncated to the size
> that the user expects(may be <= the orignal size and >= the expected one), so I
> think it is better that we shouldn't lose the data that lies within the range
> <the expected size, the real size>, because the user may take it for granted
> that the data in that extent is not lost. In order to implement it, we just
> write out all the dirty pages which are beyond the expected size of the file.
> This operation will spend lots of time if there are many dirty pages. It is
> also the only disadvantage of this patch. (Maybe I'm overcautious, we needn't
> hold that data.)
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c |  159 +++++++++++++++++-------------------------------------
>  1 files changed, 49 insertions(+), 110 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index df6060f..9ace01b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -88,7 +88,7 @@ static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
>  };
>  
>  static int btrfs_setsize(struct inode *inode, loff_t newsize);
> -static int btrfs_truncate(struct inode *inode);
> +static int btrfs_truncate(struct inode *inode, loff_t newsize);
>  static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end);
>  static noinline int cow_file_range(struct inode *inode,
>  				   struct page *locked_page,
> @@ -2230,7 +2230,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  			 * btrfs_delalloc_reserve_space to catch offenders.
>  			 */
>  			mutex_lock(&inode->i_mutex);
> -			ret = btrfs_truncate(inode);
> +			ret = btrfs_truncate(inode, inode->i_size);
>  			mutex_unlock(&inode->i_mutex);
>  		} else {
>  			nr_unlink++;
> @@ -2993,7 +2993,7 @@ static int btrfs_release_and_test_inline_data_extent(
>  		return 0;
>  
>  	/*
> -	 * Truncate inline items is special, we have done it by
> +	 * Truncate inline items is special, we will do it by
>  	 *   btrfs_truncate_page();
>  	 */
>  	if (offset < new_size)
> @@ -3121,9 +3121,9 @@ static int btrfs_release_and_test_data_extent(struct btrfs_trans_handle *trans,
>   * will kill all the items on this inode, including the INODE_ITEM_KEY.
>   */
>  int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
> -			        struct btrfs_root *root,
> -			        struct inode *inode,
> -			        u64 new_size, u32 min_type)
> +			       struct btrfs_root *root,
> +			       struct inode *inode,
> +			       u64 new_size, u32 min_type)
>  {
>  	struct btrfs_path *path;
>  	struct extent_buffer *leaf;
> @@ -3131,6 +3131,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  	struct btrfs_key found_key;
>  	u64 mask = root->sectorsize - 1;
>  	u64 ino = btrfs_ino(inode);
> +	u64 old_size = i_size_read(inode);
>  	u32 found_type;
>  	int pending_del_nr = 0;
>  	int pending_del_slot = 0;
> @@ -3138,6 +3139,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  	int err = 0;
>  
>  	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
> +	BUG_ON(new_size & mask);
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
> @@ -3190,6 +3192,13 @@ search_again:
>  			ret = btrfs_release_and_test_data_extent(trans, root,
>  						path, inode, found_key.offset,
>  						new_size);
> +			if (root->ref_cows ||
> +			    root == root->fs_info->tree_root) {
> +				if (ret && found_key.offset < old_size)
> +					i_size_write(inode, found_key.offset);
> +				else if (!ret)
> +					i_size_write(inode, new_size);
> +			}
>  			if (!ret)
>  				break;
>  		}
> @@ -3247,12 +3256,10 @@ out:
>  static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
>  {
>  	struct inode *inode = mapping->host;
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
>  	struct btrfs_ordered_extent *ordered;
>  	struct extent_state *cached_state = NULL;
>  	char *kaddr;
> -	u32 blocksize = root->sectorsize;
>  	pgoff_t index = from >> PAGE_CACHE_SHIFT;
>  	unsigned offset = from & (PAGE_CACHE_SIZE-1);
>  	struct page *page;
> @@ -3261,8 +3268,6 @@ static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
>  	u64 page_start;
>  	u64 page_end;
>  
> -	if ((offset & (blocksize - 1)) == 0)
> -		goto out;
>  	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
>  	if (ret)
>  		goto out;
> @@ -3329,6 +3334,7 @@ again:
>  	}
>  	ClearPageChecked(page);
>  	set_page_dirty(page);
> +	i_size_write(inode, from);
>  	unlock_extent_cached(io_tree, page_start, page_end, &cached_state,
>  			     GFP_NOFS);
>  
> @@ -3459,7 +3465,9 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
>  		ret = btrfs_update_inode(trans, root, inode);
>  		btrfs_end_transaction_throttle(trans, root);
>  	} else {
> -
> +		btrfs_wait_ordered_range(inode,
> +					 newsize & ~(root->sectorsize - 1),
> +					 (u64)-1);
>  		/*
>  		 * We're truncating a file that used to have good data down to
>  		 * zero. Make sure it gets into the ordered flush list so that
> @@ -3469,8 +3477,8 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
>  			BTRFS_I(inode)->ordered_data_close = 1;
>  
>  		/* we don't support swapfiles, so vmtruncate shouldn't fail */
> -		truncate_setsize(inode, newsize);
> -		ret = btrfs_truncate(inode);
> +		truncate_pagecache(inode, oldsize, newsize);
> +		ret = btrfs_truncate(inode, newsize);
>  	}
>  
>  	return ret;
> @@ -6522,87 +6530,43 @@ out:
>  	return ret;
>  }
>  
> -static int btrfs_truncate(struct inode *inode)
> +static int btrfs_truncate(struct inode *inode, loff_t newsize)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	struct btrfs_block_rsv *rsv;
>  	int ret;
>  	int err = 0;
>  	struct btrfs_trans_handle *trans;
>  	unsigned long nr;
>  	u64 mask = root->sectorsize - 1;
> -	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
> -
> -	ret = btrfs_truncate_page(inode->i_mapping, inode->i_size);
> -	if (ret)
> -		return ret;
> -
> -	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
> -	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
>  
>  	/*
>  	 * Yes ladies and gentelment, this is indeed ugly.  The fact is we have
> -	 * 3 things going on here
> +	 * 2 things going on here
>  	 *
> -	 * 1) We need to reserve space for our orphan item and the space to
> -	 * delete our orphan item.  Lord knows we don't want to have a dangling
> -	 * orphan item because we didn't reserve space to remove it.
> +	 * 1) We need to reserve space to update our inode.
>  	 *
> -	 * 2) We need to reserve space to update our inode.
> -	 *
> -	 * 3) We need to have something to cache all the space that is going to
> +	 * 2) We need to have something to cache all the space that is going to
>  	 * be free'd up by the truncate operation, but also have some slack
>  	 * space reserved in case it uses space during the truncate (thank you
>  	 * very much snapshotting).
>  	 *
> -	 * And we need these to all be seperate.  The fact is we can use alot of
> -	 * space doing the truncate, and we have no earthly idea how much space
> -	 * we will use, so we need the truncate reservation to be seperate so it
> -	 * doesn't end up using space reserved for updating the inode or
> -	 * removing the orphan item.  We also need to be able to stop the
> -	 * transaction and start a new one, which means we need to be able to
> -	 * update the inode several times, and we have no idea of knowing how
> -	 * many times that will be, so we can't just reserve 1 item for the
> -	 * entirety of the opration, so that has to be done seperately as well.
> -	 * Then there is the orphan item, which does indeed need to be held on
> -	 * to for the whole operation, and we need nobody to touch this reserved
> -	 * space except the orphan code.
> -	 *
> -	 * So that leaves us with
> -	 *
> -	 * 1) root->orphan_block_rsv - for the orphan deletion.
> -	 * 2) rsv - for the truncate reservation, which we will steal from the
> -	 * transaction reservation.
> -	 * 3) fs_info->trans_block_rsv - this will have 1 items worth left for
> -	 * updating the inode.
> +	 * And we need these to all be seperate.  The fact is we can use a lot
> +	 * of space doing the truncate, and we have no earthly idea how much
> +	 * space we will use, so we need the truncate reservation to be
> +	 * seperate. We also need to be able to stop the transaction and start
> +	 * a new one, which means we need to be able to update the inode several
> +	 * times, and we have no idea of knowing how many times that will be,
> +	 * so we can't just reserve 1 item for the entirety of the operation,
> +	 * so that has to be done seperately as well.
>  	 */
> -	rsv = btrfs_alloc_block_rsv(root);
> -	if (!rsv)
> -		return -ENOMEM;
> -	rsv->size = min_size;
>  
>  	/*
>  	 * 1 for the truncate slack space
> -	 * 1 for the orphan item we're going to add
> -	 * 1 for the orphan item deletion
>  	 * 1 for updating the inode.
>  	 */
> -	trans = btrfs_start_transaction(root, 4);
> -	if (IS_ERR(trans)) {
> -		err = PTR_ERR(trans);
> -		goto out;
> -	}
> -
> -	/* Migrate the slack space for the truncate to our reserve */
> -	ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv, rsv,
> -				      min_size);
> -	BUG_ON(ret);
> -
> -	ret = btrfs_orphan_add(trans, inode);
> -	if (ret) {
> -		btrfs_end_transaction(trans, root);
> -		goto out;
> -	}
> +	trans = btrfs_start_transaction(root, 2);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
>  
>  	/*
>  	 * setattr is responsible for setting the ordered_data_close flag,
> @@ -6621,26 +6585,12 @@ static int btrfs_truncate(struct inode *inode)
>  	 * using truncate to replace the contents of the file will
>  	 * end up with a zero length file after a crash.
>  	 */
> -	if (inode->i_size == 0 && BTRFS_I(inode)->ordered_data_close)
> +	if (newsize == 0 && BTRFS_I(inode)->ordered_data_close)
>  		btrfs_add_ordered_operation(trans, root, inode);
>  
>  	while (1) {
> -		ret = btrfs_block_rsv_refill(root, rsv, min_size);
> -		if (ret) {
> -			/*
> -			 * This can only happen with the original transaction we
> -			 * started above, every other time we shouldn't have a
> -			 * transaction started yet.
> -			 */
> -			if (ret == -EAGAIN)
> -				goto end_trans;
> -			err = ret;
> -			break;
> -		}
> -

Taking this part out is wrong, we need to have this slack space to account for
any COW that truncate does.  Other than that this looks pretty good.  Thanks,

Josef
