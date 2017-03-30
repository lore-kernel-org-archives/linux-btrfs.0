Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30888 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932913AbdC3QuV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 12:50:21 -0400
Date: Thu, 30 Mar 2017 09:49:21 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/5] btrfs: scrub: Introduce full stripe lock for
 RAID56
Message-ID: <20170330164920.GA8963@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170330063251.16872-1-quwenruo@cn.fujitsu.com>
 <20170330063251.16872-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170330063251.16872-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 30, 2017 at 02:32:47PM +0800, Qu Wenruo wrote:
> Unlike mirror based profiles, RAID5/6 recovery needs to read out the
> whole full stripe.
> 
> And if we don't do proper protect, it can easily cause race condition.
> 
> Introduce 2 new functions: lock_full_stripe() and unlock_full_stripe()
> for RAID5/6.
> Which stores a rb_tree of mutex for full stripes, so scrub callers can
> use them to lock a full stripe to avoid race.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ctree.h       |  17 ++++
>  fs/btrfs/extent-tree.c |  11 +++
>  fs/btrfs/scrub.c       | 217 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 245 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 29b7fc28c607..9fe56da21fed 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -538,6 +538,14 @@ struct btrfs_io_ctl {
>  	unsigned check_crcs:1;
>  };
>  
> +/*
> + * Tree to record all locked full stripes of a RAID5/6 block group
> + */
> +struct btrfs_full_stripe_locks_tree {
> +	struct rb_root root;
> +	struct mutex lock;
> +};
> +
>  struct btrfs_block_group_cache {
>  	struct btrfs_key key;
>  	struct btrfs_block_group_item item;
> @@ -648,6 +656,9 @@ struct btrfs_block_group_cache {
>  	 * Protected by free_space_lock.
>  	 */
>  	int needs_free_space;
> +
> +	/* Record locked full stripes for RAID5/6 block group */
> +	struct btrfs_full_stripe_locks_tree full_stripe_locks_root;
>  };
>  
>  /* delayed seq elem */
> @@ -3647,6 +3658,12 @@ int btrfs_scrub_cancel_dev(struct btrfs_fs_info *info,
>  			   struct btrfs_device *dev);
>  int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
>  			 struct btrfs_scrub_progress *progress);
> +static inline void btrfs_init_full_stripe_locks_tree(
> +			struct btrfs_full_stripe_locks_tree *locks_root)
> +{
> +	locks_root->root = RB_ROOT;
> +	mutex_init(&locks_root->lock);
> +}
>  
>  /* dev-replace.c */
>  void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index be5477676cc8..5f51ce81f484 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -131,6 +131,16 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
>  	if (atomic_dec_and_test(&cache->count)) {
>  		WARN_ON(cache->pinned > 0);
>  		WARN_ON(cache->reserved > 0);
> +
> +		/*
> +		 * If not empty, someone is still holding mutex of
> +		 * full_stripe_lock, which can only be released by caller.
> +		 * And it will definitely cause use-after-free when caller
> +		 * tries to release full stripe lock.
> +		 *
> +		 * No better way to resolve, but only to warn.
> +		 */
> +		WARN_ON(!RB_EMPTY_ROOT(&cache->full_stripe_locks_root.root));
>  		kfree(cache->free_space_ctl);
>  		kfree(cache);
>  	}
> @@ -9917,6 +9927,7 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
>  	btrfs_init_free_space_ctl(cache);
>  	atomic_set(&cache->trimming, 0);
>  	mutex_init(&cache->free_space_lock);
> +	btrfs_init_full_stripe_locks_tree(&cache->full_stripe_locks_root);
>  
>  	return cache;
>  }
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index b0251eb1239f..5fc99a92b4ff 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -240,6 +240,13 @@ struct scrub_warning {
>  	struct btrfs_device	*dev;
>  };
>  
> +struct full_stripe_lock {
> +	struct rb_node node;
> +	u64 logical;
> +	u64 refs;
> +	struct mutex mutex;
> +};
> +
>  static void scrub_pending_bio_inc(struct scrub_ctx *sctx);
>  static void scrub_pending_bio_dec(struct scrub_ctx *sctx);
>  static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx);
> @@ -349,6 +356,216 @@ static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
>  }
>  
>  /*
> + * Insert new full stripe lock into full stripe locks tree
> + *
> + * Return pointer to existing or newly inserted full_stripe_lock structure if
> + * everything works well.
> + * Return ERR_PTR(-ENOMEM) if we failed to allocate memory
> + *
> + * NOTE: caller must hold full_stripe_locks_root->lock before calling this
> + * function
> + */
> +static struct full_stripe_lock *insert_full_stripe_lock(
> +		struct btrfs_full_stripe_locks_tree *locks_root,
> +		u64 fstripe_logical)
> +{
> +	struct rb_node **p;
> +	struct rb_node *parent = NULL;
> +	struct full_stripe_lock *entry;
> +	struct full_stripe_lock *ret;
> +
> +	WARN_ON(!mutex_is_locked(&locks_root->lock));
> +
> +	p = &locks_root->root.rb_node;
> +	while (*p) {
> +		parent = *p;
> +		entry = rb_entry(parent, struct full_stripe_lock, node);
> +		if (fstripe_logical < entry->logical) {
> +			p = &(*p)->rb_left;
> +		} else if (fstripe_logical > entry->logical) {
> +			p = &(*p)->rb_right;
> +		} else {
> +			entry->refs++;
> +			return entry;
> +		}
> +	}
> +
> +	/* Insert new lock */
> +	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
> +	if (!ret)
> +		return ERR_PTR(-ENOMEM);
> +	ret->logical = fstripe_logical;
> +	ret->refs = 1;
> +	mutex_init(&ret->mutex);
> +
> +	rb_link_node(&ret->node, parent, p);
> +	rb_insert_color(&ret->node, &locks_root->root);
> +	return ret;
> +}
> +
> +/*
> + * Search for a full stripe lock of a block group
> + *
> + * Return pointer to existing full stripe lock if found
> + * Return NULL if not found
> + */
> +static struct full_stripe_lock *search_full_stripe_lock(
> +		struct btrfs_full_stripe_locks_tree *locks_root,
> +		u64 fstripe_logical)
> +{
> +	struct rb_node *node;
> +	struct full_stripe_lock *entry;
> +
> +	WARN_ON(!mutex_is_locked(&locks_root->lock));
> +
> +	node = locks_root->root.rb_node;
> +	while (node) {
> +		entry = rb_entry(node, struct full_stripe_lock, node);
> +		if (fstripe_logical < entry->logical)
> +			node = node->rb_left;
> +		else if (fstripe_logical > entry->logical)
> +			node = node->rb_right;
> +		else
> +			return entry;
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * Helper to get full stripe logical from a normal bytenr.
> + *
> + * Caller must ensure @cache is a RAID56 block group.
> + */
> +static u64 get_full_stripe_logical(struct btrfs_block_group_cache *cache,
> +				   u64 bytenr)
> +{
> +	u64 ret;
> +
> +	/*
> +	 * round_down() can only handle power of 2, while RAID56 full
> +	 * stripe len can be 64KiB * n, so need manual round down.
> +	 */
> +	ret = (bytenr - cache->key.objectid) / cache->full_stripe_len *
> +	      cache->full_stripe_len + cache->key.objectid;

Can you please use div_u64 instead?  '/' would cause building errors.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
