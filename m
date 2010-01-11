From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use per-cpu pools for reserving metadata space
Date: Mon, 11 Jan 2010 11:42:21 -0500
Message-ID: <20100111164220.GA2360@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently every time we do a metadata reservation we have to take the spin lock
on the metadata space info structure and then calculate how much space we have
and then do the reservation and so-on.  This isn't terrible, but on beefier
boxes this begins to cause problems.  The other thing is that this lets us run
right up to the edge of the space.

Enter the per-cpu pools.  Instead of calculating out how much space we have
left for every reservation, we only do it when we read/add new block groups to
the space info, or whenever we commit the transaction.  Then we only take 80% of
the free space and distribute it among all the cpu's evenly (or according to
usage once everything gets going).  This will allow us to play a little fast and
loose with our reservation stuff.

All reservations just increment the pool's reserved count, and then as
allocations occur we add those to the pool's used count.  If a pool doesn't have
enough space to handle its reserved amount and used amount we simply try to
steal from other pools, and then start flushing delalloc and other such things
that we've always done.

Testing this gives us no regressions in the single CPU case, and then gives us a
10% jump in dbench on a box with 16 CPUs.

I'm hoping that this new approach will let us do things like throttle the worst
case scenario calculation based on how much we reserve versus how much is used.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h        |   11 +-
 fs/btrfs/disk-io.c      |   17 ++
 fs/btrfs/extent-tree.c  |  565 ++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/inode.c        |    1 +
 fs/btrfs/ordered-data.c |    1 +
 fs/btrfs/transaction.c  |    2 +
 6 files changed, 446 insertions(+), 151 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8c57180..1a4014b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -666,6 +666,13 @@ struct btrfs_block_group_item {
 	__le64 flags;
 } __attribute__ ((__packed__));
 
+struct btrfs_reserved_space_pool {
+	u64 total_bytes;
+	u64 reserved_bytes;
+	u64 used_bytes;
+	spinlock_t lock;
+};
+
 struct btrfs_space_info {
 	u64 flags;
 
@@ -688,8 +695,6 @@ struct btrfs_space_info {
 				   chunks for this space */
 	int force_alloc;	/* set if we need to force a chunk alloc for
 				   this space */
-	int force_delalloc;	/* make people start doing filemap_flush until
-				   we're under a threshold */
 
 	struct list_head list;
 
@@ -980,6 +985,7 @@ struct btrfs_fs_info {
 	unsigned metadata_ratio;
 
 	void *bdev_holder;
+	struct btrfs_reserved_space_pool *reserved_space_pool;
 };
 
 /*
@@ -2051,6 +2057,7 @@ void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
+void btrfs_init_space_pools(struct btrfs_fs_info *fs_info);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02b6afb..d02a6ea 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1575,6 +1575,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	struct btrfs_root *log_tree_root;
 
 	int ret;
+	int i;
 	int err = -EINVAL;
 
 	struct btrfs_super_block *disk_super;
@@ -1917,8 +1918,23 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	csum_root->track_dirty = 1;
 
+	fs_info->reserved_space_pool =
+		alloc_percpu(struct btrfs_reserved_space_pool);
+	if (!fs_info->reserved_space_pool)
+		goto fail_csum_root;
+
+	for_each_possible_cpu(i) {
+		struct btrfs_reserved_space_pool *pool;
+		pool = per_cpu_ptr(fs_info->reserved_space_pool, i);
+		spin_lock_init(&pool->lock);
+		pool->total_bytes = 0;
+		pool->reserved_bytes = 0;
+		pool->used_bytes = 0;
+	}
+
 	btrfs_read_block_groups(extent_root);
 
+	btrfs_init_space_pools(fs_info);
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 	fs_info->data_alloc_profile = (u64)-1;
@@ -2442,6 +2458,7 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(root->fs_info->csum_root->commit_root);
 
 	btrfs_free_block_groups(root->fs_info);
+	free_percpu(fs_info->reserved_space_pool);
 
 	del_fs_roots(fs_info);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c2f3cee..05eac97 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2660,6 +2660,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		found->full = 0;
 		spin_unlock(&found->lock);
 		*space_info = found;
+		btrfs_init_space_pools(info);
 		return 0;
 	}
 	found = kzalloc(sizeof(*found), GFP_NOFS);
@@ -2667,6 +2668,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&found->block_groups);
+	init_waitqueue_head(&found->flush_wait);
 	init_rwsem(&found->groups_sem);
 	spin_lock_init(&found->lock);
 	found->flags = flags;
@@ -2681,6 +2683,10 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	*space_info = found;
 	list_add_rcu(&found->list, &info->space_info);
 	atomic_set(&found->caching_threads, 0);
+
+	if (flags & BTRFS_BLOCK_GROUP_METADATA)
+		btrfs_init_space_pools(info);
+
 	return 0;
 }
 
@@ -2815,63 +2821,20 @@ static u64 calculate_bytes_needed(struct btrfs_root *root, int num_items)
 int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
 					  struct inode *inode, int num_items)
 {
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_space_info *meta_sinfo;
-	u64 num_bytes;
-	u64 alloc_target;
-	bool bug = false;
-
-	/* get the space info for where the metadata will live */
-	alloc_target = btrfs_get_alloc_profile(root, 0);
-	meta_sinfo = __find_space_info(info, alloc_target);
-
-	num_bytes = calculate_bytes_needed(root->fs_info->extent_root,
-					   num_items);
-
-	spin_lock(&meta_sinfo->lock);
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
 	if (BTRFS_I(inode)->reserved_extents <=
 	    BTRFS_I(inode)->outstanding_extents) {
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
-		spin_unlock(&meta_sinfo->lock);
 		return 0;
 	}
-	spin_unlock(&BTRFS_I(inode)->accounting_lock);
-
 	BTRFS_I(inode)->reserved_extents--;
-	BUG_ON(BTRFS_I(inode)->reserved_extents < 0);
-
-	if (meta_sinfo->bytes_delalloc < num_bytes) {
-		bug = true;
-		meta_sinfo->bytes_delalloc = 0;
-	} else {
-		meta_sinfo->bytes_delalloc -= num_bytes;
-	}
-	spin_unlock(&meta_sinfo->lock);
+	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
-	BUG_ON(bug);
+	btrfs_unreserve_metadata_space(root, num_items);
 
 	return 0;
 }
 
-static void check_force_delalloc(struct btrfs_space_info *meta_sinfo)
-{
-	u64 thresh;
-
-	thresh = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
-		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
-		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
-		meta_sinfo->bytes_may_use;
-
-	thresh = meta_sinfo->total_bytes - thresh;
-	thresh *= 80;
-	do_div(thresh, 100);
-	if (thresh <= meta_sinfo->bytes_delalloc)
-		meta_sinfo->force_delalloc = 1;
-	else
-		meta_sinfo->force_delalloc = 0;
-}
-
 struct async_flush {
 	struct btrfs_root *root;
 	struct btrfs_space_info *info;
@@ -2900,10 +2863,18 @@ static noinline void flush_delalloc_async(struct btrfs_work *work)
 	kfree(async);
 }
 
-static void wait_on_flush(struct btrfs_space_info *info)
+static void wait_on_flush(struct btrfs_root *root, struct btrfs_space_info *info)
 {
 	DEFINE_WAIT(wait);
-	u64 used;
+	u64 num_bytes;
+	u64 free;
+	int i;
+
+	/*
+	 * Number of CPU's * the maximum number of reservations that anybody
+	 * would ever want to use
+	 */
+	num_bytes = calculate_bytes_needed(root, nr_cpu_ids * 5);
 
 	while (1) {
 		prepare_to_wait(&info->flush_wait, &wait,
@@ -2914,14 +2885,28 @@ static void wait_on_flush(struct btrfs_space_info *info)
 			break;
 		}
 
-		used = info->bytes_used + info->bytes_reserved +
-			info->bytes_pinned + info->bytes_readonly +
-			info->bytes_super + info->bytes_root +
-			info->bytes_may_use + info->bytes_delalloc;
-		if (used < info->total_bytes) {
+		free = 0;
+		for_each_possible_cpu(i) {
+			struct btrfs_reserved_space_pool *pool;
+			pool = per_cpu_ptr(root->fs_info->reserved_space_pool, i);
+			spin_lock(&pool->lock);
+			if (pool->used_bytes + pool->reserved_bytes >=
+			    pool->total_bytes) {
+				spin_unlock(&pool->lock);
+				continue;
+			}
+			free += pool->total_bytes - pool->used_bytes -
+				pool->reserved_bytes;
+			spin_unlock(&pool->lock);
+			if (free > num_bytes)
+				break;
+		}
+
+		if (free > num_bytes) {
 			spin_unlock(&info->lock);
 			break;
 		}
+
 		spin_unlock(&info->lock);
 		schedule();
 	}
@@ -2946,7 +2931,7 @@ static void flush_delalloc(struct btrfs_root *root,
 	spin_unlock(&info->lock);
 
 	if (wait) {
-		wait_on_flush(info);
+		wait_on_flush(root, info);
 		return;
 	}
 
@@ -2960,7 +2945,7 @@ static void flush_delalloc(struct btrfs_root *root,
 
 	btrfs_queue_worker(&root->fs_info->enospc_workers,
 			   &async->work);
-	wait_on_flush(info);
+	wait_on_flush(root, info);
 	return;
 
 flush:
@@ -2990,6 +2975,7 @@ static int maybe_allocate_chunk(struct btrfs_root *root,
 	 */
 	min_metadata = min((u64)10 * 1024 * 1024 * 1024,
 			     div64_u64(free_space * 5, 100));
+	spin_lock(&info->lock);
 	if (info->total_bytes >= min_metadata) {
 		spin_unlock(&info->lock);
 		return 0;
@@ -3026,8 +3012,6 @@ static int maybe_allocate_chunk(struct btrfs_root *root,
 			     4096 + 2 * 1024 * 1024,
 			     info->flags, 0);
 	btrfs_end_transaction(trans, root);
-	if (ret)
-		goto out;
 out:
 	spin_lock(&info->lock);
 	info->allocating_chunk = 0;
@@ -3045,72 +3029,135 @@ out:
 int btrfs_reserve_metadata_for_delalloc(struct btrfs_root *root,
 					struct inode *inode, int num_items)
 {
+	struct btrfs_reserved_space_pool *pool;
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_space_info *meta_sinfo;
+	struct btrfs_space_info *meta_sinfo = NULL;
+	bool chunk_allocated = false;
+	bool delalloc_flushed = false;
+	bool inode_flushed = false;
+	u64 realloc_bytes = 0;
 	u64 num_bytes;
-	u64 used;
 	u64 alloc_target;
-	int flushed = 0;
-	int force_delalloc;
+	int retries = 0;
+	int i;
 
-	/* get the space info for where the metadata will live */
-	alloc_target = btrfs_get_alloc_profile(root, 0);
-	meta_sinfo = __find_space_info(info, alloc_target);
+	num_bytes = calculate_bytes_needed(root, num_items);
+
+	pool = per_cpu_ptr(info->reserved_space_pool,
+			   raw_smp_processor_id());
 
-	num_bytes = calculate_bytes_needed(root->fs_info->extent_root,
-					   num_items);
 again:
-	spin_lock(&meta_sinfo->lock);
+	spin_lock(&pool->lock);
 
-	force_delalloc = meta_sinfo->force_delalloc;
+	if (realloc_bytes >= num_bytes) {
+		pool->total_bytes += realloc_bytes;
+		spin_lock(&BTRFS_I(inode)->accounting_lock);
+		BTRFS_I(inode)->reserved_extents++;
+		spin_unlock(&BTRFS_I(inode)->accounting_lock);
+		spin_unlock(&pool->lock);
+		return 0;
+	}
 
-	if (unlikely(!meta_sinfo->bytes_root))
-		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
+	if (!retries)
+		pool->reserved_bytes += num_bytes;
 
-	if (!flushed)
-		meta_sinfo->bytes_delalloc += num_bytes;
+	/*
+	 * Fast path, we have plent of space in this pool to use, go ahead and
+	 * use it and move on.
+	 */
+	if (pool->reserved_bytes + pool->used_bytes <= pool->total_bytes) {
+		spin_lock(&BTRFS_I(inode)->accounting_lock);
+		BTRFS_I(inode)->reserved_extents++;
+		spin_unlock(&BTRFS_I(inode)->accounting_lock);
+		spin_unlock(&pool->lock);
+		return 0;
+	}
 
-	used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
-		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
-		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
-		meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
+	retries++;
+	spin_unlock(&pool->lock);
 
-	if (used > meta_sinfo->total_bytes) {
-		flushed++;
+	/*
+	 * Ok didn't find anything, try and steal from somebody elses pool.
+	 */
+	for_each_possible_cpu(i) {
+		struct btrfs_reserved_space_pool *tmp_pool;
+		u64 free_bytes;
 
-		if (flushed == 1) {
-			if (maybe_allocate_chunk(root, meta_sinfo))
-				goto again;
-			flushed++;
-		} else {
-			spin_unlock(&meta_sinfo->lock);
+		tmp_pool = per_cpu_ptr(info->reserved_space_pool, i);
+		if (pool == tmp_pool)
+			continue;
+
+		spin_lock(&tmp_pool->lock);
+
+		if (tmp_pool->reserved_bytes + tmp_pool->used_bytes >=
+		    tmp_pool->total_bytes) {
+			spin_unlock(&tmp_pool->lock);
+			continue;
 		}
 
-		if (flushed == 2) {
-			filemap_flush(inode->i_mapping);
-			goto again;
-		} else if (flushed == 3) {
-			flush_delalloc(root, meta_sinfo);
+		free_bytes = tmp_pool->total_bytes - tmp_pool->used_bytes -
+			tmp_pool->reserved_bytes;
+
+		/*
+		 * If this pool has reserved bytes, but still has alot of free
+		 * space, only take half of the free space.  The idea here is
+		 * that
+		 *
+		 * 1) If only one processor is doing the work then the others
+		 * won't have alot of reserved bytes, and we can steal all of
+		 * their free space.
+		 *
+		 * 2) If all the processors are doing work, then we don't want
+		 * to steal a whole lot from them, but on the other hand we
+		 * don't want to have to keep stealing small amounts from
+		 * everybody, so take half the space and hope that this
+		 * processor will be back to use more space.
+		 */
+		if (tmp_pool->reserved_bytes > num_bytes &&
+		    num_bytes < free_bytes && num_bytes <= (free_bytes >> 1))
+			free_bytes = free_bytes >> 1;
+
+		realloc_bytes += free_bytes;
+		tmp_pool->total_bytes -= free_bytes;
+		spin_unlock(&tmp_pool->lock);
+
+		if (num_bytes <= realloc_bytes);
 			goto again;
-		}
-		spin_lock(&meta_sinfo->lock);
-		meta_sinfo->bytes_delalloc -= num_bytes;
-		spin_unlock(&meta_sinfo->lock);
-		printk(KERN_ERR "enospc, has %d, reserved %d\n",
-		       BTRFS_I(inode)->outstanding_extents,
-		       BTRFS_I(inode)->reserved_extents);
-		dump_space_info(meta_sinfo, 0, 0);
-		return -ENOSPC;
 	}
 
-	BTRFS_I(inode)->reserved_extents++;
-	check_force_delalloc(meta_sinfo);
-	spin_unlock(&meta_sinfo->lock);
-
-	if (!flushed && force_delalloc)
+	if (!inode_flushed) {
+		inode_flushed = true;
 		filemap_flush(inode->i_mapping);
+		goto again;
+	}
 
-	return 0;
+	if (!meta_sinfo) {
+		/* get the space info for where the metadata will live */
+		alloc_target = btrfs_get_alloc_profile(root, 0);
+		meta_sinfo = __find_space_info(info, alloc_target);
+	}
+
+	if (!delalloc_flushed) {
+		delalloc_flushed = true;
+		flush_delalloc(root, meta_sinfo);
+		goto again;
+	}
+
+	if (!chunk_allocated) {
+		chunk_allocated = true;
+		btrfs_wait_ordered_extents(root, 0);
+		maybe_allocate_chunk(root, meta_sinfo);
+		goto again;
+	}
+
+	spin_lock(&pool->lock);
+	pool->reserved_bytes -= calculate_bytes_needed(root, num_items);
+	if (realloc_bytes)
+		pool->total_bytes += realloc_bytes;
+	spin_unlock(&pool->lock);
+
+	printk(KERN_ERR "delalloc reserve ran out of space!!!!\n");
+	return -ENOSPC;
 }
 
 /*
@@ -3124,28 +3171,54 @@ again:
  */
 int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items)
 {
+	struct btrfs_reserved_space_pool *pool;
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_space_info *meta_sinfo;
+	struct btrfs_space_info *meta_sinfo = NULL;
 	u64 num_bytes;
-	u64 alloc_target;
-	bool bug = false;
+	u64 alloc_target = btrfs_get_alloc_profile(root, 0);
+	int i;
 
-	/* get the space info for where the metadata will live */
-	alloc_target = btrfs_get_alloc_profile(root, 0);
+	num_bytes = calculate_bytes_needed(root, num_items);
+
+	pool = per_cpu_ptr(info->reserved_space_pool, raw_smp_processor_id());
 	meta_sinfo = __find_space_info(info, alloc_target);
 
-	num_bytes = calculate_bytes_needed(root, num_items);
+	spin_lock(&pool->lock);
+	if (num_bytes <= pool->reserved_bytes) {
+		pool->reserved_bytes -= num_bytes;
+		spin_unlock(&pool->lock);
+		if (waitqueue_active(&meta_sinfo->flush_wait))
+			wake_up(&meta_sinfo->flush_wait);
+		return 0;
+	}
 
-	spin_lock(&meta_sinfo->lock);
-	if (meta_sinfo->bytes_may_use < num_bytes) {
-		bug = true;
-		meta_sinfo->bytes_may_use = 0;
-	} else {
-		meta_sinfo->bytes_may_use -= num_bytes;
+	num_bytes -= pool->reserved_bytes;
+	pool->reserved_bytes = 0;
+	spin_unlock(&pool->lock);
+
+	/*
+	 * Ok we could have moved processors in between the reservation and
+	 * here, so lets just take the reserved space away from the first pool
+	 * we find.
+	 */
+	for_each_possible_cpu(i) {
+		pool = per_cpu_ptr(info->reserved_space_pool, i);
+		spin_lock(&pool->lock);
+		if (num_bytes <= pool->reserved_bytes) {
+			pool->reserved_bytes -= num_bytes;
+			spin_unlock(&pool->lock);
+			return 0;
+		}
+
+		num_bytes -= pool->reserved_bytes;
+		pool->reserved_bytes = 0;
+		spin_unlock(&pool->lock);
 	}
-	spin_unlock(&meta_sinfo->lock);
 
-	BUG_ON(bug);
+	if (waitqueue_active(&meta_sinfo->flush_wait))
+		wake_up(&meta_sinfo->flush_wait);
+
+	WARN_ON(num_bytes);
 
 	return 0;
 }
@@ -3165,58 +3238,220 @@ int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items)
  */
 int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items)
 {
+	struct btrfs_reserved_space_pool *pool;
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_space_info *meta_sinfo;
+	struct btrfs_space_info *meta_sinfo = NULL;
+	bool chunk_allocated = false;
+	bool delalloc_flushed = false;
+	bool committed = false;
+	u64 realloc_bytes = 0;
 	u64 num_bytes;
-	u64 used;
 	u64 alloc_target;
 	int retries = 0;
-
-	/* get the space info for where the metadata will live */
-	alloc_target = btrfs_get_alloc_profile(root, 0);
-	meta_sinfo = __find_space_info(info, alloc_target);
+	int i;
 
 	num_bytes = calculate_bytes_needed(root, num_items);
+
+	pool = per_cpu_ptr(info->reserved_space_pool, raw_smp_processor_id());
+
 again:
-	spin_lock(&meta_sinfo->lock);
+	spin_lock(&pool->lock);
 
-	if (unlikely(!meta_sinfo->bytes_root))
-		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
+	/*
+	 * If we've managed to acquire enough bytes from other pools then add it
+	 * to our total bytes and exit.
+	 */
+	if (realloc_bytes >= num_bytes) {
+		pool->total_bytes += realloc_bytes;
+		spin_unlock(&pool->lock);
+		return 0;
+	}
 
 	if (!retries)
-		meta_sinfo->bytes_may_use += num_bytes;
+		pool->reserved_bytes += num_bytes;
 
-	used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
-		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
-		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
-		meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
+	/*
+	 * Fast path, we have plent of space in this pool to use, go ahead and
+	 * use it and move on.
+	 */
+	if (pool->reserved_bytes + pool->used_bytes <= pool->total_bytes) {
+		spin_unlock(&pool->lock);
+		return 0;
+	}
 
-	if (used > meta_sinfo->total_bytes) {
-		retries++;
-		if (retries == 1) {
-			if (maybe_allocate_chunk(root, meta_sinfo))
-				goto again;
-			retries++;
-		} else {
-			spin_unlock(&meta_sinfo->lock);
+	retries++;
+	spin_unlock(&pool->lock);
+
+	/*
+	 * Ok don't have enough space, try and steal from somebody elses pool.
+	 */
+	for_each_possible_cpu(i) {
+		struct btrfs_reserved_space_pool *tmp_pool;
+		u64 free_bytes;
+
+		tmp_pool = per_cpu_ptr(info->reserved_space_pool, i);
+		if (tmp_pool == pool)
+			continue;
+
+		spin_lock(&tmp_pool->lock);
+
+		if (tmp_pool->reserved_bytes + tmp_pool->used_bytes >=
+		    tmp_pool->total_bytes) {
+			spin_unlock(&tmp_pool->lock);
+			continue;
 		}
 
-		if (retries == 2) {
-			flush_delalloc(root, meta_sinfo);
+		free_bytes = tmp_pool->total_bytes - tmp_pool->used_bytes -
+			tmp_pool->reserved_bytes;
+
+		/* Only take 1/2 of the free space if its more than enough */
+		if (tmp_pool->reserved_bytes > num_bytes &&
+		    num_bytes < free_bytes && num_bytes <= (free_bytes >> 1))
+			free_bytes = free_bytes >> 1;
+
+		realloc_bytes += free_bytes;
+		tmp_pool->total_bytes -= free_bytes;
+		spin_unlock(&tmp_pool->lock);
+
+		if (num_bytes <= realloc_bytes)
 			goto again;
-		}
-		spin_lock(&meta_sinfo->lock);
-		meta_sinfo->bytes_may_use -= num_bytes;
-		spin_unlock(&meta_sinfo->lock);
+	}
 
-		dump_space_info(meta_sinfo, 0, 0);
-		return -ENOSPC;
+	if (!meta_sinfo) {
+		/* get the space info for where the metadata will live */
+		alloc_target = btrfs_get_alloc_profile(root, 0);
+		meta_sinfo = __find_space_info(info, alloc_target);
 	}
 
-	check_force_delalloc(meta_sinfo);
+	if (!chunk_allocated) {
+		chunk_allocated = true;
+		if (maybe_allocate_chunk(root, meta_sinfo))
+			goto again;
+	}
+
+	if (!delalloc_flushed) {
+		delalloc_flushed = true;
+		flush_delalloc(root, meta_sinfo);
+		goto again;
+	}
+
+	if (!committed && !current->journal_info) {
+		struct btrfs_trans_handle *trans;
+		committed = true;
+		trans = btrfs_start_transaction(root, 1);
+		btrfs_commit_transaction(trans, root);
+		goto again;
+	}
+
+	/* Oh well, we couldn't beg/borrow/steal enough space, just exit. */
+	spin_lock(&pool->lock);
+	pool->reserved_bytes -= num_bytes;
+	if (realloc_bytes)
+		pool->total_bytes += realloc_bytes;
+	spin_unlock(&pool->lock);
+
+	return -ENOSPC;
+}
+
+void btrfs_init_space_pools(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *meta_sinfo = NULL;
+	struct btrfs_reserved_space_pool *pool;
+	u64 total;
+	u64 per_pool;
+	u64 used;
+	u64 alloc_target;
+	int i;
+
+	/* get the space info for where the metadata will live */
+	alloc_target = btrfs_get_alloc_profile(fs_info->extent_root, 0);
+	meta_sinfo = __find_space_info(fs_info, alloc_target);
+
+	/*
+	 * This can happen during mount where we haven't quite set everything up
+	 * yet.
+	 */
+	if (!meta_sinfo)
+		return;
+
+	spin_lock(&meta_sinfo->lock);
+
+	if (unlikely(!meta_sinfo->bytes_root))
+		meta_sinfo->bytes_root =
+			calculate_bytes_needed(fs_info->extent_root, 6);
+
+	used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
+		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
+		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
+		meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
+
+	/*
+	 * Only use 80% of the free metadata space for reservation, so we have
+	 * some spill-over room.
+	 */
+	total = meta_sinfo->total_bytes - used;
 	spin_unlock(&meta_sinfo->lock);
+	total *= 80;
+	total = div64_u64(total, 100);
 
-	return 0;
+	per_pool = div64_u64(total, nr_cpu_ids);
+	for_each_possible_cpu(i) {
+		pool = per_cpu_ptr(fs_info->reserved_space_pool, i);
+		spin_lock(&pool->lock);
+		pool->used_bytes = 0;
+
+		/*
+		 * Ok the idea here is that we want to skew the spreading of the
+		 * available space based on how it's being used across the
+		 * processors.  So here's how this works
+		 *
+		 * 1) if the total number of bytes we have is more than this
+		 * pool has reserved, and this pool has reserved bytes, just
+		 * give it the number of reserved bytes it has.
+		 *
+		 * 2) if the pool has no reserved bytes, give it the per_pool
+		 * amount.  You could just give it 0, and in some cases it works
+		 * fine (single threaded cases), and in some cases it doesn't
+		 * (multi-threaded cases).  Giving it 0 versus not in the single
+		 * threaded case doesn't make a difference, so give it hte per
+		 * pool.
+		 *
+		 * 3) if total is less than the per pool amount, just give the
+		 * pool the rest of the space.
+		 */
+		if (total >= pool->reserved_bytes) {
+			if (pool->reserved_bytes) {
+				pool->total_bytes = pool->reserved_bytes;
+				total -= pool->reserved_bytes;
+			} else if (total >= per_pool) {
+				pool->total_bytes = per_pool;
+				total -= per_pool;
+			} else {
+				pool->total_bytes = total;
+				total = 0;
+			}
+		} else {
+			if (total >= per_pool) {
+				pool->total_bytes = per_pool;
+				total -= per_pool;
+			} else {
+				pool->total_bytes = total;
+				total = 0;
+			}
+		}
+		spin_unlock(&pool->lock);
+	}
+
+	/*
+	 * If there's any space left over, just give it to the guy that we're
+	 * currently on, since we're likely to be doing work soon anyway.
+	 */
+	if (total) {
+		pool = per_cpu_ptr(fs_info->reserved_space_pool, raw_smp_processor_id());
+		spin_lock(&pool->lock);
+		pool->total_bytes += total;
+		spin_unlock(&pool->lock);
+	}
 }
 
 /*
@@ -4626,6 +4861,7 @@ again:
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 {
+	struct btrfs_reserved_space_pool *pool;
 	struct btrfs_block_group_cache *cache;
 	int ret = 0;
 
@@ -4642,6 +4878,30 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 	update_reserved_extents(cache, len, 0);
 	btrfs_put_block_group(cache);
 
+	pool = per_cpu_ptr(root->fs_info->reserved_space_pool,
+			   raw_smp_processor_id());
+	spin_lock(&pool->lock);
+	if (pool->used_bytes < len) {
+		int i;
+		spin_unlock(&pool->lock);
+		for_each_possible_cpu(i) {
+			if (i == raw_smp_processor_id())
+				continue;
+			pool = per_cpu_ptr(root->fs_info->reserved_space_pool,
+					   i);
+			spin_lock(&pool->lock);
+			if (pool->used_bytes >= len) {
+				pool->used_bytes -= len;
+				spin_unlock(&pool->lock);
+				break;
+			}
+			spin_unlock(&pool->lock);
+		}
+	} else {
+		pool->used_bytes -= len;
+		spin_unlock(&pool->lock);
+	}
+
 	return ret;
 }
 
@@ -4939,6 +5199,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size)
 {
+	struct btrfs_reserved_space_pool *pool;
 	struct btrfs_key ins;
 	int ret;
 	struct extent_buffer *buf;
@@ -4950,6 +5211,12 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		return ERR_PTR(ret);
 	}
 
+	pool = per_cpu_ptr(root->fs_info->reserved_space_pool,
+			   raw_smp_processor_id());
+	spin_lock(&pool->lock);
+	pool->used_bytes += ins.offset;
+	spin_unlock(&pool->lock);
+
 	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
 				    blocksize, level);
 	return buf;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b383e53..b5a36b3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1340,6 +1340,7 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 
 		if (bits & EXTENT_DO_ACCOUNTING) {
 			spin_lock(&BTRFS_I(inode)->accounting_lock);
+			BUG_ON(!BTRFS_I(inode)->outstanding_extents);
 			BTRFS_I(inode)->outstanding_extents--;
 			spin_unlock(&BTRFS_I(inode)->accounting_lock);
 			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5799bc4..031dcc5 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -307,6 +307,7 @@ int btrfs_remove_ordered_extent(struct inode *inode,
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
 
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
+	BUG_ON(!BTRFS_I(inode)->outstanding_extents);
 	BTRFS_I(inode)->outstanding_extents--;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 	btrfs_unreserve_metadata_for_delalloc(BTRFS_I(inode)->root,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c207e8c..37f755a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1056,6 +1056,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_prepare_extent_commit(trans, root);
 
+	btrfs_init_space_pools(root->fs_info);
+
 	cur_trans = root->fs_info->running_transaction;
 	spin_lock(&root->fs_info->new_trans_lock);
 	root->fs_info->running_transaction = NULL;
-- 
1.5.4.3

