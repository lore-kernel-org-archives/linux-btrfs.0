Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CF0C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 14:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 559102084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 14:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbfCYOVU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:21:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:47470 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfCYOVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 10:21:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBD91ACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 14:21:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E92DFDA825; Mon, 25 Mar 2019 15:22:30 +0100 (CET)
Date:   Mon, 25 Mar 2019 15:22:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH v3 07/12] btrfs: replace pending/pinned chunks lists with
 io tree
Message-ID: <20190325142230.GE10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
References: <20190325123132.27835-1-nborisov@suse.com>
 <20190325123132.27835-8-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325123132.27835-8-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 02:31:27PM +0200, Nikolay Borisov wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> The pending chunks list contains chunks that are allocated in the
> current transaction but haven't been created yet. The pinned chunks
> list contains chunks that are being released in the current transaction.
> Both describe chunks that are not reflected on disk as in use but are
> unavailable just the same.
> 
> The pending chunks list is anchored by the transaction handle, which
> means that we need to hold a reference to a transaction when working
> with the list.
> 
> We use these lists to ensure that we don't end up discarding chunks
> that are allocated or released in the current transaction.  What we r

unfinished sentence?

> 
> The way we use them is by iterating over both lists to perform
> comparisons on the stripes they describe for each device. This is
> backwards and requires that we keep a transaction handle open while
> we're trimming.
> 
> This patchset adds an extent_io_tree to btrfs_device that maintains
> the allocation state of the device.  Extents are set dirty when
> chunks are first allocated -- when the extent maps are added to the
> mapping tree. They're cleared when last removed -- when the extent
> maps are removed from the mapping tree. This matches the lifespan
> of the pending and pinned chunks list and allows us to do trims
> on unallocated space safely without pinning the transaction for what
> may be a lengthy operation. We can also use this io tree to mark
> which chunks have already been trimmed so we don't repeat the operation.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.h            |  6 ---
>  fs/btrfs/disk-io.c          | 11 -----
>  fs/btrfs/extent-tree.c      | 28 -----------
>  fs/btrfs/extent_io.c        |  2 +-
>  fs/btrfs/extent_io.h        |  6 ++-
>  fs/btrfs/extent_map.c       | 36 ++++++++++++++
>  fs/btrfs/extent_map.h       |  1 -
>  fs/btrfs/free-space-cache.c |  4 --
>  fs/btrfs/transaction.c      |  9 ----
>  fs/btrfs/transaction.h      |  1 -
>  fs/btrfs/volumes.c          | 96 +++++++++++++------------------------
>  fs/btrfs/volumes.h          |  2 +
>  12 files changed, 76 insertions(+), 126 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 880b5abd8ecc..0b25c2f1b77d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1152,12 +1152,6 @@ struct btrfs_fs_info {
>  	struct mutex unused_bg_unpin_mutex;
>  	struct mutex delete_unused_bgs_mutex;
>  
> -	/*
> -	 * Chunks that can't be freed yet (under a trim/discard operation)
> -	 * and will be latter freed. Protected by fs_info->chunk_mutex.
> -	 */
> -	struct list_head pinned_chunks;
> -
>  	/* Cached block sizes */
>  	u32 nodesize;
>  	u32 sectorsize;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 81183694f8ea..813fc21b2b0b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2789,8 +2789,6 @@ int open_ctree(struct super_block *sb,
>  	init_waitqueue_head(&fs_info->async_submit_wait);
>  	init_waitqueue_head(&fs_info->delayed_iputs_wait);
>  
> -	INIT_LIST_HEAD(&fs_info->pinned_chunks);
> -
>  	/* Usable values until the real ones are cached from the superblock */
>  	fs_info->nodesize = 4096;
>  	fs_info->sectorsize = 4096;
> @@ -4065,15 +4063,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  
>  	btrfs_free_stripe_hash_table(fs_info);
>  	btrfs_free_ref_cache(fs_info);
> -
> -	while (!list_empty(&fs_info->pinned_chunks)) {
> -		struct extent_map *em;
> -
> -		em = list_first_entry(&fs_info->pinned_chunks,
> -				      struct extent_map, list);
> -		list_del_init(&em->list);
> -		free_extent_map(em);
> -	}
>  }
>  
>  int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index dcda3c4de240..eb4b7f2b10a1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10946,10 +10946,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  	memcpy(&key, &block_group->key, sizeof(key));
>  
>  	mutex_lock(&fs_info->chunk_mutex);
> -	if (!list_empty(&em->list)) {
> -		/* We're in the transaction->pending_chunks list. */
> -		free_extent_map(em);
> -	}
>  	spin_lock(&block_group->lock);
>  	block_group->removed = 1;
>  	/*
> @@ -10976,25 +10972,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  	 * the transaction commit has completed.
>  	 */
>  	remove_em = (atomic_read(&block_group->trimming) == 0);
> -	/*
> -	 * Make sure a trimmer task always sees the em in the pinned_chunks list
> -	 * if it sees block_group->removed == 1 (needs to lock block_group->lock
> -	 * before checking block_group->removed).
> -	 */
> -	if (!remove_em) {
> -		/*
> -		 * Our em might be in trans->transaction->pending_chunks which
> -		 * is protected by fs_info->chunk_mutex ([lock|unlock]_chunks),
> -		 * and so is the fs_info->pinned_chunks list.
> -		 *
> -		 * So at this point we must be holding the chunk_mutex to avoid
> -		 * any races with chunk allocation (more specifically at
> -		 * volumes.c:contains_pending_extent()), to ensure it always
> -		 * sees the em, either in the pending_chunks list or in the
> -		 * pinned_chunks list.
> -		 */
> -		list_move_tail(&em->list, &fs_info->pinned_chunks);
> -	}
>  	spin_unlock(&block_group->lock);
>  
>  	if (remove_em) {
> @@ -11002,11 +10979,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  
>  		em_tree = &fs_info->mapping_tree.map_tree;
>  		write_lock(&em_tree->lock);
> -		/*
> -		 * The em might be in the pending_chunks list, so make sure the
> -		 * chunk mutex is locked, since remove_extent_mapping() will
> -		 * delete us from that list.
> -		 */
>  		remove_extent_mapping(em_tree, em);
>  		write_unlock(&em_tree->lock);
>  		/* once for the tree */
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0e953c469224..ff3f8443e180 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -918,7 +918,7 @@ static void cache_state(struct extent_state *state,
>   * [start, end] is inclusive This takes the tree lock.
>   */
>  
> -static int __must_check
> +int __must_check
>  __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  		 unsigned bits, unsigned exclusive_bits,
>  		 u64 *failed_start, struct extent_state **cached_state,
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 0fda249e5982..4bcc203b5431 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -329,7 +329,11 @@ int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
>  int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  		   unsigned bits, u64 *failed_start,
>  		   struct extent_state **cached_state, gfp_t mask);
> -
> +int
> +__set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> +		 unsigned bits, unsigned exclusive_bits,
> +		 u64 *failed_start, struct extent_state **cached_state,
> +		 gfp_t mask, struct extent_changeset *changeset);
>  static inline int set_extent_bits(struct extent_io_tree *tree, u64 start,
>  		u64 end, unsigned bits)
>  {
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 928f729c55ba..0820f6fcf3a6 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -4,6 +4,7 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include "ctree.h"
> +#include "volumes.h"
>  #include "extent_map.h"
>  #include "compression.h"
>  
> @@ -336,6 +337,37 @@ static inline void setup_extent_mapping(struct extent_map_tree *tree,
>  	else
>  		try_merge_map(tree, em);
>  }
> +static void extent_map_device_set_bits(struct extent_map *em, unsigned bits)
> +{
> +	struct map_lookup *map = em->map_lookup;
> +	u64 stripe_size = em->orig_block_len;
> +	int i;
> +
> +	for (i = 0; i < map->num_stripes; i++) {
> +		struct btrfs_bio_stripe *stripe = &map->stripes[i];
> +		struct btrfs_device *device = stripe->dev;
> +
> +		__set_extent_bit(&device->alloc_state, stripe->physical,
> +				 stripe->physical + stripe_size - 1, bits,
> +				 0, NULL, NULL, GFP_NOWAIT, NULL);
> +	}
> +}
> +
> +static void extent_map_device_clear_bits(struct extent_map *em, unsigned bits)
> +{
> +	struct map_lookup *map = em->map_lookup;
> +	u64 stripe_size = em->orig_block_len;
> +	int i;
> +
> +	for (i = 0; i < map->num_stripes; i++) {
> +		struct btrfs_bio_stripe *stripe = &map->stripes[i];
> +		struct btrfs_device *device = stripe->dev;
> +
> +		__clear_extent_bit(&device->alloc_state, stripe->physical,
> +				   stripe->physical + stripe_size - 1, bits,
> +				   0, 0, NULL, GFP_NOWAIT, NULL);
> +	}
> +}
>  
>  /**
>   * add_extent_mapping - add new extent map to the extent tree
> @@ -357,6 +389,8 @@ int add_extent_mapping(struct extent_map_tree *tree,
>  		goto out;
>  
>  	setup_extent_mapping(tree, em, modified);
> +	if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
> +		extent_map_device_set_bits(em, CHUNK_ALLOCATED);
>  out:
>  	return ret;
>  }
> @@ -438,6 +472,8 @@ void remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
>  	rb_erase_cached(&em->rb_node, &tree->map);
>  	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
>  		list_del_init(&em->list);
> +	if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
> +		extent_map_device_clear_bits(em, CHUNK_ALLOCATED);
>  	RB_CLEAR_NODE(&em->rb_node);
>  }
>  
> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> index 473f039fcd7c..72b46833f236 100644
> --- a/fs/btrfs/extent_map.h
> +++ b/fs/btrfs/extent_map.h
> @@ -91,7 +91,6 @@ void replace_extent_mapping(struct extent_map_tree *tree,
>  			    struct extent_map *cur,
>  			    struct extent_map *new,
>  			    int modified);
> -
>  struct extent_map *alloc_extent_map(void);
>  void free_extent_map(struct extent_map *em);
>  int __init extent_map_init(void);
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 74aa552f4793..207fb50dcc7a 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -3366,10 +3366,6 @@ void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *block_group)
>  		em = lookup_extent_mapping(em_tree, block_group->key.objectid,
>  					   1);
>  		BUG_ON(!em); /* logic error, can't happen */
> -		/*
> -		 * remove_extent_mapping() will delete us from the pinned_chunks
> -		 * list, which is protected by the chunk mutex.
> -		 */
>  		remove_extent_mapping(em_tree, em);
>  		write_unlock(&em_tree->lock);
>  		mutex_unlock(&fs_info->chunk_mutex);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index b32769998bbb..e5404326fc55 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -50,14 +50,6 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
>  			btrfs_err(transaction->fs_info,
>  				  "pending csums is %llu",
>  				  transaction->delayed_refs.pending_csums);
> -		while (!list_empty(&transaction->pending_chunks)) {
> -			struct extent_map *em;
> -
> -			em = list_first_entry(&transaction->pending_chunks,
> -					      struct extent_map, list);
> -			list_del_init(&em->list);
> -			free_extent_map(em);
> -		}
>  		/*
>  		 * If any block groups are found in ->deleted_bgs then it's
>  		 * because the transaction was aborted and a commit did not
> @@ -235,7 +227,6 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
>  	spin_lock_init(&cur_trans->delayed_refs.lock);
>  
>  	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
> -	INIT_LIST_HEAD(&cur_trans->pending_chunks);
>  	INIT_LIST_HEAD(&cur_trans->dev_update_list);
>  	INIT_LIST_HEAD(&cur_trans->switch_commits);
>  	INIT_LIST_HEAD(&cur_trans->dirty_bgs);
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 2bd76f681520..4419a4a0294b 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -51,7 +51,6 @@ struct btrfs_transaction {
>  	wait_queue_head_t writer_wait;
>  	wait_queue_head_t commit_wait;
>  	struct list_head pending_snapshots;
> -	struct list_head pending_chunks;
>  	struct list_head dev_update_list;
>  	struct list_head switch_commits;
>  	struct list_head dirty_bgs;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 39a107bdde06..a06f1e3c63b9 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -335,6 +335,8 @@ void btrfs_free_device(struct btrfs_device *device)
>  {
>  	WARN_ON(!list_empty(&device->post_commit_list));
>  	rcu_string_free(device->name);
> +	if (!in_softirq())
> +		extent_io_tree_release(&device->alloc_state);
>  	bio_put(device->flush_bio);
>  	kfree(device);
>  }
> @@ -411,6 +413,7 @@ static struct btrfs_device *__alloc_device(void)
>  	btrfs_device_data_ordered_init(dev);
>  	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
>  	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
> +	extent_io_tree_init(NULL, &dev->alloc_state, 0, NULL);
>  
>  	return dev;
>  }
> @@ -1269,6 +1272,9 @@ static void btrfs_close_one_device(struct btrfs_device *device)
>  	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
>  		fs_devices->missing_devices--;
>  
> +	/* Remove alloc state now since it cannot be done in RCU context */
> +	extent_io_tree_release(&device->alloc_state);
> +
>  	btrfs_close_bdev(device);
>  
>  	new_device = btrfs_alloc_device(NULL, &device->devid,
> @@ -1505,58 +1511,29 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
>  	return device;
>  }
>  
> -static int contains_pending_extent(struct btrfs_transaction *transaction,
> -				   struct btrfs_device *device,
> -				   u64 *start, u64 len)
> -{
> -	struct btrfs_fs_info *fs_info = device->fs_info;
> -	struct extent_map *em;
> -	struct list_head *search_list = &fs_info->pinned_chunks;
> -	int ret = 0;
> -	u64 physical_start = *start;
> -
> -	if (transaction)
> -		search_list = &transaction->pending_chunks;
> -again:
> -	list_for_each_entry(em, search_list, list) {
> -		struct map_lookup *map;
> -		int i;
> -
> -		map = em->map_lookup;
> -		for (i = 0; i < map->num_stripes; i++) {
> -			u64 end;
> -
> -			if (map->stripes[i].dev != device)
> -				continue;
> -			if (map->stripes[i].physical >= physical_start + len ||
> -			    map->stripes[i].physical + em->orig_block_len <=
> -			    physical_start)
> -				continue;
> -			/*
> -			 * Make sure that while processing the pinned list we do
> -			 * not override our *start with a lower value, because
> -			 * we can have pinned chunks that fall within this
> -			 * device hole and that have lower physical addresses
> -			 * than the pending chunks we processed before. If we
> -			 * do not take this special care we can end up getting
> -			 * 2 pending chunks that start at the same physical
> -			 * device offsets because the end offset of a pinned
> -			 * chunk can be equal to the start offset of some
> -			 * pending chunk.
> -			 */
> -			end = map->stripes[i].physical + em->orig_block_len;
> -			if (end > *start) {
> -				*start = end;
> -				ret = 1;
> -			}
> +/*
> + * Tries to find a chunk that intersects [start, start +len] range and when one
> + * such is found, records the end of it in *start
> + */
> +#define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
> +static bool contains_pending_extent(struct btrfs_device *device, u64 *start,
> +				    u64 len)
> +{
> +	u64 physical_start, physical_end;
> +	lockdep_assert_held(&device->fs_info->chunk_mutex);
> +
> +	if (!find_first_extent_bit(&device->alloc_state, *start,
> +				   &physical_start, &physical_end,
> +				   CHUNK_ALLOCATED, NULL)) {
> +
> +		if (in_range(physical_start, *start, len) ||
> +		    in_range(*start, physical_start,
> +			     physical_end - physical_start)) {
> +			*start = physical_end + 1;
> +			return true;
>  		}
>  	}
> -	if (search_list != &fs_info->pinned_chunks) {
> -		search_list = &fs_info->pinned_chunks;
> -		goto again;
> -	}
> -
> -	return ret;
> +	return false;
>  }
>  
>  
> @@ -1667,15 +1644,12 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
>  			 * Have to check before we set max_hole_start, otherwise
>  			 * we could end up sending back this offset anyway.
>  			 */
> -			if (contains_pending_extent(transaction, device,
> -						    &search_start,
> +			if (contains_pending_extent(device, &search_start,
>  						    hole_size)) {
> -				if (key.offset >= search_start) {
> +				if (key.offset >= search_start)
>  					hole_size = key.offset - search_start;
> -				} else {
> -					WARN_ON_ONCE(1);
> +				else
>  					hole_size = 0;
> -				}
>  			}
>  
>  			if (hole_size > max_hole_size) {
> @@ -1716,8 +1690,7 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
>  	if (search_end > search_start) {
>  		hole_size = search_end - search_start;
>  
> -		if (contains_pending_extent(transaction, device, &search_start,
> -					    hole_size)) {
> +		if (contains_pending_extent(device, &search_start, hole_size)) {
>  			btrfs_release_path(path);
>  			goto again;
>  		}
> @@ -4759,7 +4732,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>  	 * in-memory chunks are synced to disk so that the loop below sees them
>  	 * and relocates them accordingly.
>  	 */
> -	if (contains_pending_extent(trans->transaction, device, &start, diff)) {
> +	if (contains_pending_extent(device, &start, diff)) {
>  		mutex_unlock(&fs_info->chunk_mutex);
>  		ret = btrfs_commit_transaction(trans);
>  		if (ret)
> @@ -5201,9 +5174,6 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  		free_extent_map(em);
>  		goto error;
>  	}
> -
> -	list_add_tail(&em->list, &trans->transaction->pending_chunks);
> -	refcount_inc(&em->refs);
>  	write_unlock(&em_tree->lock);
>  
>  	ret = btrfs_make_block_group(trans, 0, type, start, chunk_size);
> @@ -5236,8 +5206,6 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	free_extent_map(em);
>  	/* One for the tree reference */
>  	free_extent_map(em);
> -	/* One for the pending_chunks list reference */
> -	free_extent_map(em);
>  error:
>  	kfree(devices_info);
>  	return ret;
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index a0f09aad3770..49dc737d8a54 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -134,6 +134,8 @@ struct btrfs_device {
>  	/* Counter to record the change of device stats */
>  	atomic_t dev_stats_ccnt;
>  	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
> +
> +	struct extent_io_tree alloc_state;
>  };
>  
>  /*
> -- 
> 2.17.1
