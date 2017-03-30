Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33648 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754231AbdC3Aft (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 20:35:49 -0400
Date: Wed, 29 Mar 2017 17:34:44 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 1/5] btrfs: scrub: Introduce full stripe lock for
 RAID56
Message-ID: <20170330003444.GA15452@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
 <20170329013322.1323-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170329013322.1323-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 09:33:18AM +0800, Qu Wenruo wrote:
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
> ---
>  fs/btrfs/ctree.h       |  17 ++++
>  fs/btrfs/extent-tree.c |   2 +
>  fs/btrfs/scrub.c       | 212 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 231 insertions(+)
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
> index be5477676cc8..e4d48997d927 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -131,6 +131,7 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
>  	if (atomic_dec_and_test(&cache->count)) {
>  		WARN_ON(cache->pinned > 0);
>  		WARN_ON(cache->reserved > 0);
> +		WARN_ON(!RB_EMPTY_ROOT(&cache->full_stripe_locks_root.root));

It's also necessary to free objects left in the rbtree because we may get here
due to -ENOMEM in unlock_full_stripe.

>  		kfree(cache->free_space_ctl);
>  		kfree(cache);
>  	}
> @@ -9917,6 +9918,7 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
>  	btrfs_init_free_space_ctl(cache);
>  	atomic_set(&cache->trimming, 0);
>  	mutex_init(&cache->free_space_lock);
> +	btrfs_init_full_stripe_locks_tree(&cache->full_stripe_locks_root);
>  
>  	return cache;
>  }
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index b0251eb1239f..ab33b9a8aac2 100644
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
> @@ -349,6 +356,211 @@ static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
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
> + * Thanks to the chaos of scrub structures, we need to get it all
> + * by ourselves, using btrfs_map_sblock().
> + */
> +static int get_full_stripe_logical(struct btrfs_fs_info *fs_info, u64 bytenr,
> +				   u64 *bytenr_ret)
> +{
> +	struct btrfs_bio *bbio = NULL;
> +	u64 len;
> +	int ret;
> +
> +	/* Just use map_sblock() to get full stripe logical */
> +	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, bytenr,
> +			       &len, &bbio, 0, 1);
> +	if (ret || !bbio || !bbio->raid_map)
> +		goto error;
> +	*bytenr_ret = bbio->raid_map[0];

If only the start logical address of a full stripe is needed, we could
get it by aligning
(bytenr - block_group_start) to (nr_data_stripes * stripe_len).

> +	btrfs_put_bbio(bbio);
> +	return 0;
> +error:
> +	btrfs_put_bbio(bbio);
> +	if (ret)
> +		return ret;
> +	return -EIO;
> +}
> +
> +/*
> + * To lock a full stripe to avoid concurrency of recovery and read
> + * It's only used for profiles with parities(RAID5/6), for other profiles it
> + * does nothing
> + *
> + * Return 0 if we locked full stripe covering @bytenr, with a mutex hold.
> + * So caller must call unlock_full_stripe() at the same context.
> + *
> + * Return <0 if encounters error.
> + */
> +static int lock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr)
> +{
> +	struct btrfs_block_group_cache *bg_cache;
> +	struct btrfs_full_stripe_locks_tree *locks_root;
> +	struct full_stripe_lock *existing;
> +	u64 fstripe_start;
> +	int ret = 0;
> +
> +	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
> +	if (!bg_cache)
> +		return -ENOENT;
> +

When starting to scrub a chunk, we've already increased a ref for block group,
could you please put a ASSERT to catch it?

> +	/* Profiles not based on parity don't need full stripe lock */
> +	if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_RAID56_MASK))
> +		goto out;
> +	locks_root = &bg_cache->full_stripe_locks_root;
> +
> +	ret = get_full_stripe_logical(fs_info, bytenr, &fstripe_start);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* Now insert the full stripe lock */
> +	mutex_lock(&locks_root->lock);
> +	existing = insert_full_stripe_lock(locks_root, fstripe_start);
> +	mutex_unlock(&locks_root->lock);
> +	if (IS_ERR(existing)) {
> +		ret = PTR_ERR(existing);
> +		goto out;
> +	}
> +	mutex_lock(&existing->mutex);
> +out:
> +	btrfs_put_block_group(bg_cache);
> +	return ret;
> +}
> +
> +/*
> + * Unlock a full stripe.
> + * NOTE: Caller must ensure it's the same context calling corresponding
> + * lock_full_stripe().
> + *
> + * Return 0 if we unlock full stripe without problem.
> + * Return <0 for error
> + */
> +static int unlock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr)
> +{
> +	struct btrfs_block_group_cache *bg_cache;
> +	struct btrfs_full_stripe_locks_tree *locks_root;
> +	struct full_stripe_lock *fstripe_lock;
> +	u64 fstripe_start;
> +	bool freeit = false;
> +	int ret = 0;
> +
> +	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
> +	if (!bg_cache)
> +		return -ENOENT;

Ditto.

> +	if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_RAID56_MASK))
> +		goto out;
> +
> +	locks_root = &bg_cache->full_stripe_locks_root;
> +	ret = get_full_stripe_logical(fs_info, bytenr, &fstripe_start);
> +	if (ret < 0)
> +		goto out;
> +
> +	mutex_lock(&locks_root->lock);
> +	fstripe_lock = search_full_stripe_lock(locks_root, fstripe_start);
> +	/* Unparied unlock_full_stripe() detected */

* unpaired *

> +	if (WARN_ON(!fstripe_lock)) {
> +		ret = -ENOENT;
> +		mutex_unlock(&locks_root->lock);
> +		goto out;
> +	}
> +
> +	if (fstripe_lock->refs == 0) {
> +		WARN_ON(1);
> +		btrfs_warn(fs_info, "full stripe lock at %llu refcount underflow",
> +			fstripe_lock->logical);
> +	} else
> +		fstripe_lock->refs--;

This is error-prone, could you please change it to the following?

} else {
	fstripe_lock->refs--;
}

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> +	if (fstripe_lock->refs == 0) {
> +		rb_erase(&fstripe_lock->node, &locks_root->root);
> +		freeit = true;
> +	}
> +	mutex_unlock(&locks_root->lock);
> +
> +	mutex_unlock(&fstripe_lock->mutex);
> +	if (freeit)
> +		kfree(fstripe_lock);
> +out:
> +	btrfs_put_block_group(bg_cache);
> +	return ret;
> +}
> +
> +/*
>   * used for workers that require transaction commits (i.e., for the
>   * NOCOW case)
>   */
> -- 
> 2.12.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
