Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27944 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaAXHfE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 02:35:04 -0500
Date: Fri, 24 Jan 2014 15:34:48 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
Message-ID: <20140124073448.GC31638@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390500472-15144-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 23, 2014 at 01:07:52PM -0500, Josef Bacik wrote:
> On one of our gluster clusters we noticed some pretty big lag spikes.  This
> turned out to be because our transaction commit was taking like 3 minutes to
> complete.  This is because we have like 30 gigs of metadata, so our global
> reserve would end up being the max which is like 512 mb.  So our throttling code
> would allow a ridiculous amount of delayed refs to build up and then they'd all
> get run at transaction commit time, and for a cold mounted file system that
> could take up to 3 minutes to run.  So fix the throttling to be based on both
> the size of the global reserve and how long it takes us to run delayed refs.
> This patch tracks the time it takes to run delayed refs and then only allows 1
> seconds worth of outstanding delayed refs at a time.  This way it will auto-tune
> itself from cold cache up to when everything is in memory and it no longer has
> to go to disk.  This makes our transaction commits take much less time to run.
> Thanks,

Which version of btrfs is the patch made for?

I checked the code and it doesn't seem to be btrfs-next, either...we don't
have a __btrfs_run_delayed_refs(). 

-liubo

> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/ctree.h       |  3 +++
>  fs/btrfs/disk-io.c     |  2 +-
>  fs/btrfs/extent-tree.c | 41 ++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/transaction.c |  4 ++--
>  4 files changed, 46 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 3cebb4a..ca6bcc3 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1360,6 +1360,7 @@ struct btrfs_fs_info {
>  
>  	u64 generation;
>  	u64 last_trans_committed;
> +	u64 avg_delayed_ref_runtime;
>  
>  	/*
>  	 * this is updated to the current trans every time a full commit
> @@ -3172,6 +3173,8 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_root *root,
>  
>  int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
>  				       struct btrfs_root *root);
> +int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
> +				       struct btrfs_root *root);
>  void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
>  int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  			   struct btrfs_root *root, unsigned long count);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index ed23127..f0e7bbe 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2185,7 +2185,7 @@ int open_ctree(struct super_block *sb,
>  	fs_info->free_chunk_space = 0;
>  	fs_info->tree_mod_log = RB_ROOT;
>  	fs_info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
> -
> +	fs_info->avg_delayed_ref_runtime = div64_u64(NSEC_PER_SEC, 64);
>  	/* readahead state */
>  	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
>  	spin_lock_init(&fs_info->reada_lock);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c77156c..b532259 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2322,8 +2322,10 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  	struct btrfs_delayed_ref_head *locked_ref = NULL;
>  	struct btrfs_delayed_extent_op *extent_op;
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +	ktime_t start = ktime_get();
>  	int ret;
>  	unsigned long count = 0;
> +	unsigned long actual_count = 0;
>  	int must_insert_reserved = 0;
>  
>  	delayed_refs = &trans->transaction->delayed_refs;
> @@ -2452,6 +2454,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  				 &delayed_refs->href_root);
>  			spin_unlock(&delayed_refs->lock);
>  		} else {
> +			actual_count++;
>  			ref->in_tree = 0;
>  			rb_erase(&ref->rb_node, &locked_ref->ref_root);
>  		}
> @@ -2502,6 +2505,26 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  		count++;
>  		cond_resched();
>  	}
> +
> +	/*
> +	 * We don't want to include ref heads since we can have empty ref heads
> +	 * and those will drastically skew our runtime down since we just do
> +	 * accounting, no actual extent tree updates.
> +	 */
> +	if (actual_count > 0) {
> +		u64 runtime = ktime_to_ns(ktime_sub(ktime_get(), start));
> +		u64 avg;
> +
> +		/*
> +		 * We weigh the current average higher than our current runtime
> +		 * to avoid large swings in the average.
> +		 */
> +		spin_lock(&delayed_refs->lock);
> +		avg = fs_info->avg_delayed_ref_runtime * 3 + runtime;
> +		avg = div64_u64(avg, 4);
> +		fs_info->avg_delayed_ref_runtime = avg;
> +		spin_unlock(&delayed_refs->lock);
> +	}
>  	return 0;
>  }
>  
> @@ -2600,7 +2623,7 @@ static inline u64 heads_to_leaves(struct btrfs_root *root, u64 heads)
>  	return div64_u64(num_bytes, BTRFS_LEAF_DATA_SIZE(root));
>  }
>  
> -int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
> +int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
>  				       struct btrfs_root *root)
>  {
>  	struct btrfs_block_rsv *global_rsv;
> @@ -2629,6 +2652,22 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> +int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
> +				       struct btrfs_root *root)
> +{
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	u64 num_entries =
> +		atomic_read(&trans->transaction->delayed_refs.num_entries);
> +	u64 avg_runtime;
> +
> +	smp_mb();
> +	avg_runtime = fs_info->avg_delayed_ref_runtime;
> +	if (num_entries * avg_runtime >= NSEC_PER_SEC)
> +		return 1;
> +
> +	return btrfs_check_space_for_delayed_refs(trans, root);
> +}
> +
>  /*
>   * this starts processing the delayed reference count updates and
>   * extent insertions we have queued up so far.  count can be
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index fd14464..5e2bfda 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -645,7 +645,7 @@ static int should_end_transaction(struct btrfs_trans_handle *trans,
>  				  struct btrfs_root *root)
>  {
>  	if (root->fs_info->global_block_rsv.space_info->full &&
> -	    btrfs_should_throttle_delayed_refs(trans, root))
> +	    btrfs_check_space_for_delayed_refs(trans, root))
>  		return 1;
>  
>  	return !!btrfs_block_rsv_check(root, &root->fs_info->global_block_rsv, 5);
> @@ -710,7 +710,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  
>  	trans->delayed_ref_updates = 0;
>  	if (!trans->sync && btrfs_should_throttle_delayed_refs(trans, root)) {
> -		cur = max_t(unsigned long, cur, 1);
> +		cur = max_t(unsigned long, cur, 32);
>  		trans->delayed_ref_updates = 0;
>  		btrfs_run_delayed_refs(trans, root, cur);
>  	}
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
