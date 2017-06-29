Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41759 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753069AbdF2SZQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 14:25:16 -0400
Date: Thu, 29 Jun 2017 20:24:04 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, suy.fnst@cn.fujitsu.com, fdmanana@gmail.com,
        nborisov@suse.com, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: fix integer overflow in calc_reclaim_items_nr
Message-ID: <20170629182404.GM2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629182015.3000-1-dsterba@suse.com>
 <20170629182015.3000-2-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629182015.3000-2-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore this mail, not intended to be sent. Extra -1 on the
command line also picked the top patch.

On Thu, Jun 29, 2017 at 08:20:15PM +0200, David Sterba wrote:
> From: Chris Mason <clm@fb.com>
> 
> Dave Jones hit a WARN_ON(nr < 0) in btrfs_wait_ordered_roots() with
> v4.12-rc6.  This was because commit 70e7af244 made it possible for
> calc_reclaim_items_nr() to return a negative number.  It's not really a
> bug in that commit, it just didn't go far enough down the stack to find
> all the possible 64->32 bit overflows.
> 
> This switches calc_reclaim_items_nr() to return a u64 and changes everyone
> that uses the results of that math to u64 as well.
> 
> Reported-by: Dave Jones <davej@codemonkey.org.uk>
> Fixes: 70e7af2 ("Btrfs: fix delalloc accounting leak caused by u32 overflow")
> Signed-off-by: Chris Mason <clm@fb.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/dev-replace.c  |  4 ++--
>  fs/btrfs/extent-tree.c  | 12 ++++++------
>  fs/btrfs/ioctl.c        |  2 +-
>  fs/btrfs/ordered-data.c | 17 ++++++++---------
>  fs/btrfs/ordered-data.h |  4 ++--
>  fs/btrfs/qgroup.c       |  2 +-
>  fs/btrfs/relocation.c   |  2 +-
>  fs/btrfs/scrub.c        |  2 +-
>  fs/btrfs/super.c        |  2 +-
>  fs/btrfs/transaction.c  |  2 +-
>  10 files changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 5fe1ca8abc70..bee3edeea7a3 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -388,7 +388,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  	if (ret)
>  		btrfs_err(fs_info, "kobj add dev failed %d", ret);
>  
> -	btrfs_wait_ordered_roots(fs_info, -1, 0, (u64)-1);
> +	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
>  
>  	/* force writing the updated state information to disk */
>  	trans = btrfs_start_transaction(root, 0);
> @@ -507,7 +507,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>  		return ret;
>  	}
> -	btrfs_wait_ordered_roots(fs_info, -1, 0, (u64)-1);
> +	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
>  
>  	trans = btrfs_start_transaction(root, 0);
>  	if (IS_ERR(trans)) {
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a3339acec28c..375f8c728d91 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4288,7 +4288,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
>  
>  			if (need_commit > 0) {
>  				btrfs_start_delalloc_roots(fs_info, 0, -1);
> -				btrfs_wait_ordered_roots(fs_info, -1, 0,
> +				btrfs_wait_ordered_roots(fs_info, U64_MAX, 0,
>  							 (u64)-1);
>  			}
>  
> @@ -4748,14 +4748,14 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_fs_info *fs_info,
>  	}
>  }
>  
> -static inline int calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
> +static inline u64 calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
>  					u64 to_reclaim)
>  {
>  	u64 bytes;
> -	int nr;
> +	u64 nr;
>  
>  	bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> -	nr = (int)div64_u64(to_reclaim, bytes);
> +	nr = div64_u64(to_reclaim, bytes);
>  	if (!nr)
>  		nr = 1;
>  	return nr;
> @@ -4774,15 +4774,15 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>  	struct btrfs_trans_handle *trans;
>  	u64 delalloc_bytes;
>  	u64 max_reclaim;
> +	u64 items;
>  	long time_left;
>  	unsigned long nr_pages;
>  	int loops;
> -	int items;
>  	enum btrfs_reserve_flush_enum flush;
>  
>  	/* Calc the number of the pages we need flush for space reservation */
>  	items = calc_reclaim_items_nr(fs_info, to_reclaim);
> -	to_reclaim = (u64)items * EXTENT_SIZE_PER_ITEM;
> +	to_reclaim = items * EXTENT_SIZE_PER_ITEM;
>  
>  	trans = (struct btrfs_trans_handle *)current->journal_info;
>  	block_rsv = &fs_info->delalloc_block_rsv;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b4e9941efb60..fa1b78cf25f6 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -689,7 +689,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  	if (ret)
>  		goto dec_and_free;
>  
> -	btrfs_wait_ordered_extents(root, -1, 0, (u64)-1);
> +	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
>  
>  	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
>  			     BTRFS_BLOCK_RSV_TEMP);
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 7b40e2e7292a..a3aca495e33e 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -663,7 +663,7 @@ static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
>   * wait for all the ordered extents in a root.  This is done when balancing
>   * space between drives.
>   */
> -int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
> +u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
>  			       const u64 range_start, const u64 range_len)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> @@ -671,7 +671,7 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
>  	LIST_HEAD(skipped);
>  	LIST_HEAD(works);
>  	struct btrfs_ordered_extent *ordered, *next;
> -	int count = 0;
> +	u64 count = 0;
>  	const u64 range_end = range_start + range_len;
>  
>  	mutex_lock(&root->ordered_extent_mutex);
> @@ -701,7 +701,7 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
>  
>  		cond_resched();
>  		spin_lock(&root->ordered_extent_lock);
> -		if (nr != -1)
> +		if (nr != U64_MAX)
>  			nr--;
>  		count++;
>  	}
> @@ -720,13 +720,13 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
>  	return count;
>  }
>  
> -int btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
> -			      const u64 range_start, const u64 range_len)
> +u64 btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
> +			     const u64 range_start, const u64 range_len)
>  {
>  	struct btrfs_root *root;
>  	struct list_head splice;
> -	int done;
> -	int total_done = 0;
> +	u64 total_done = 0;
> +	u64 done;
>  
>  	INIT_LIST_HEAD(&splice);
>  
> @@ -748,9 +748,8 @@ int btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
>  		total_done += done;
>  
>  		spin_lock(&fs_info->ordered_root_lock);
> -		if (nr != -1) {
> +		if (nr != U64_MAX) {
>  			nr -= done;
> -			WARN_ON(nr < 0);
>  		}
>  	}
>  	list_splice_tail(&splice, &fs_info->ordered_roots);
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index e0c1d5b8d859..56c4c0ee6381 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -200,9 +200,9 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
>  				struct btrfs_ordered_extent *ordered);
>  int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
>  			   u32 *sum, int len);
> -int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
> +u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
>  			       const u64 range_start, const u64 range_len);
> -int btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
> +u64 btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
>  			      const u64 range_start, const u64 range_len);
>  void btrfs_get_logged_extents(struct btrfs_inode *inode,
>  			      struct list_head *logged_list,
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index fc9dffaa9524..4ce351efe281 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2405,7 +2405,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>  				ret = btrfs_start_delalloc_inodes(root, 0);
>  				if (ret)
>  					return ret;
> -				btrfs_wait_ordered_extents(root, -1, 0, (u64)-1);
> +				btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
>  				trans = btrfs_join_transaction(root);
>  				if (IS_ERR(trans))
>  					return PTR_ERR(trans);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index dc69b6ba29af..65661d1aae4e 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4373,7 +4373,7 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>  
>  	btrfs_wait_block_group_reservations(rc->block_group);
>  	btrfs_wait_nocow_writers(rc->block_group);
> -	btrfs_wait_ordered_roots(fs_info, -1,
> +	btrfs_wait_ordered_roots(fs_info, U64_MAX,
>  				 rc->block_group->key.objectid,
>  				 rc->block_group->key.offset);
>  
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 738e784ba20d..0cebeb5eb5d0 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3836,7 +3836,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
>  			 */
>  			btrfs_wait_block_group_reservations(cache);
>  			btrfs_wait_nocow_writers(cache);
> -			ret = btrfs_wait_ordered_roots(fs_info, -1,
> +			ret = btrfs_wait_ordered_roots(fs_info, U64_MAX,
>  						       cache->key.objectid,
>  						       cache->key.offset);
>  			if (ret > 0) {
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index ba2cb7f96986..74e47794e63f 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1177,7 +1177,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  		return 0;
>  	}
>  
> -	btrfs_wait_ordered_roots(fs_info, -1, 0, (u64)-1);
> +	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
>  
>  	trans = btrfs_attach_transaction_barrier(root);
>  	if (IS_ERR(trans)) {
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 309b73da756b..f615d59b0489 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1923,7 +1923,7 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
>  static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
>  {
>  	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
> -		btrfs_wait_ordered_roots(fs_info, -1, 0, (u64)-1);
> +		btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
>  }
>  
>  static inline void
> -- 
> 2.13.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
