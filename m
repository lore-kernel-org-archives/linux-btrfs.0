From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC] remove delalloc accounting for
	__btrfs_remove_ordered_extent
Date: Thu, 25 Feb 2010 15:44:45 -0500
Message-ID: <20100225204444.GE10960@localhost.localdomain>
References: <20100224071205.GA14237@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100224071205.GA14237@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2010 at 03:12:05PM +0800, Shaohua Li wrote:
> I got below oops when doing file write with mount option max_extent=1M
> It appears the accouting is already done in set/clear/split/merge hooks and
> I don't see reason why we need do accouting in __btrfs_remove_ordered_extent
> again. Below patch makes my test work but please double check.
> 
> [  185.776309] Pid: 3368, comm: btrfs-endio-wri Not tainted 2.6.33-rc8-00165-g446ce07 #668 0M017G/Studio Slim 540s
> [  185.776353] RIP: 0010:[<ffffffffa000ca13>]  [<ffffffffa000ca13>] btrfs_unreserve_metadata_for_delalloc+0xc0/0x101 [btrfs]
> [  185.776427] RSP: 0018:ffff88012614bbd0  EFLAGS: 00010286
> [  185.776460] RAX: 00000000ffffffff RBX: ffff88012771c960 RCX: 0000000000000000
> [  185.776496] RDX: ffffffffa000c9dd RSI: ffff8801295d3800 RDI: 0000000000000001
> [  185.776532] RBP: ffff88012614bc00 R08: ffff88012614bb90 R09: 0000000000000000
> [  185.776568] R10: ffff88012614bbc0 R11: 0000000000000043 R12: ffff88012990a9b8
> [  185.776603] R13: 000000000001a000 R14: ffff88012990a900 R15: ffff88012771c950
> [  185.776640] FS:  0000000000000000(0000) GS:ffff880005880000(0000) knlGS:0000000000000000
> [  185.776678] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  185.776711] CR2: 0000003de9123f40 CR3: 00000001249b6000 CR4: 00000000000406e0
> [  185.776747] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  185.776795] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  185.776845] Process btrfs-endio-wri (pid: 3368, threadinfo ffff88012614a000, task ffff880128b34240)
> [  185.776910] Stack:
> [  185.776946]  ffff88012614bbf0 ffff88012771c960 ffff8801249d4840 ffff88012771c7c0
> [  185.777050] <0> ffff88012771c950 0000000100000000 ffff88012614bc30 ffffffffa003559e
> [  185.777203] <0> 0000000000000001 ffff8801249d4840 ffff88012771c960 0000000100000000
> [  185.777388] Call Trace:
> [  185.777438]  [<ffffffffa003559e>] __btrfs_remove_ordered_extent+0x72/0x126 [btrfs]
> [  185.777511]  [<ffffffffa003593f>] btrfs_ordered_update_i_size+0x2ed/0x33a [btrfs]
> [  185.777585]  [<ffffffffa0028c9e>] btrfs_finish_ordered_io+0x196/0x1d8 [btrfs]
> [  185.777636]  [<ffffffff810d39d1>] ? test_clear_page_writeback+0xfa/0x10c
> [  185.777695]  [<ffffffffa0028cfa>] btrfs_writepage_end_io_hook+0x1a/0x1c [btrfs]
> [  185.777765]  [<ffffffffa0039ef8>] end_bio_extent_writepage+0xae/0x159 [btrfs]
> [  185.777815]  [<ffffffff81130e56>] bio_endio+0x2b/0x2d
> [  185.777868]  [<ffffffffa001bcea>] end_workqueue_fn+0x111/0x120 [btrfs]
> [  185.777923]  [<ffffffffa00427e5>] worker_loop+0x1b9/0x547 [btrfs]
> [  185.777977]  [<ffffffffa004262c>] ? worker_loop+0x0/0x547 [btrfs]
> [  185.778024]  [<ffffffff8107f9b9>] kthread+0x7f/0x87
> [  185.778071]  [<ffffffff8102f954>] kernel_thread_helper+0x4/0x10
> [  185.778119]  [<ffffffff8105a8e1>] ? finish_task_switch+0x50/0xc2
> [  185.778166]  [<ffffffff8161a5a9>] ? _raw_spin_unlock_irq+0x1b/0x36
> [  185.778212]  [<ffffffff8161ae6d>] ? restore_args+0x0/0x30
> [  185.778257]  [<ffffffff8107f93a>] ? kthread+0x0/0x87
> [  185.778300]  [<ffffffff8102f950>] ? kernel_thread_helper+0x0/0x10
> [  185.778345] Code: 3b 43 f8 7f 12 4c 89 ff e8 cf db 60 e1 4c 89 e7 e8 c7 db 60 e1 eb 46 4c 89 ff e8 bd db 60 e1 8b 43 f4 ff c8 89 43 f4 85 c0 79 04 <0f> 0b eb fe 49 8b 46 48 4c 39 e8 73 0c 49 c7 46 48 00 00 00 00
> [  185.779620] RIP  [<ffffffffa000ca13>] btrfs_unreserve_metadata_for_delalloc+0xc0/0x101 [btrfs]
> [  185.779710]  RSP <ffff88012614bbd0>
> [  185.779765] ---[ end trace daf2ed048f53f7f0 ]---
> [  185.779812] note: btrfs-endio-wri[3368] exited with preempt_count
> 

Ok here is my patch, but theres a catch.  I've recently redone how we deal with
metadata reservations for delalloc, but its not been pulled in yet.  However I
fixed the problem on top of that patch, and although its not needed for the fix,
my fix wont apply properly without it.  The other thing is theres a random patch
in between the two of them.  So here are 3 patches, 1 is needed because my fix
is applied on the other one, and 1 isnt needed at all and was just there.
Hopefully you will be able to apply this nice and cleanly against your tree and
test it.  If not let me know and I will move things around so you can just apply
the fix itself.  I've tested this pretty heavily locally and I think we're good,
I'd just like to have more testing.  Thanks,

Josef


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0f2db97..5c2b9cc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -667,6 +667,13 @@ struct btrfs_block_group_item {
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
 
@@ -689,8 +696,6 @@ struct btrfs_space_info {
 				   chunks for this space */
 	int force_alloc;	/* set if we need to force a chunk alloc for
 				   this space */
-	int force_delalloc;	/* make people start doing filemap_flush until
-				   we're under a threshold */
 
 	struct list_head list;
 
@@ -985,6 +990,7 @@ struct btrfs_fs_info {
 	unsigned metadata_ratio;
 
 	void *bdev_holder;
+	struct btrfs_reserved_space_pool *reserved_space_pool;
 };
 
 /*
@@ -2049,9 +2055,9 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items);
 int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items);
 int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
-					  struct inode *inode, int num_items);
+					  struct inode *inode, u64 bytes);
 int btrfs_reserve_metadata_for_delalloc(struct btrfs_root *root,
-					struct inode *inode, int num_items);
+					struct inode *inode, u64 bytes);
 int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes);
 void btrfs_free_reserved_data_space(struct btrfs_root *root,
@@ -2060,6 +2066,7 @@ void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
+void btrfs_init_space_pools(struct btrfs_fs_info *fs_info);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 94debaf..3d0007f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1521,6 +1521,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	struct btrfs_root *log_tree_root;
 
 	int ret;
+	int i;
 	int err = -EINVAL;
 
 	struct btrfs_super_block *disk_super;
@@ -1866,8 +1867,23 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
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
@@ -2403,6 +2419,7 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(root->fs_info->csum_root->commit_root);
 
 	btrfs_free_block_groups(root->fs_info);
+	free_percpu(fs_info->reserved_space_pool);
 
 	del_fs_roots(fs_info);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 12a2d23..32b409d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2665,6 +2665,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		found->full = 0;
 		spin_unlock(&found->lock);
 		*space_info = found;
+		btrfs_init_space_pools(info);
 		return 0;
 	}
 	found = kzalloc(sizeof(*found), GFP_NOFS);
@@ -2672,6 +2673,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&found->block_groups);
+	init_waitqueue_head(&found->flush_wait);
 	init_rwsem(&found->groups_sem);
 	spin_lock_init(&found->lock);
 	found->flags = flags;
@@ -2686,6 +2688,10 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	*space_info = found;
 	list_add_rcu(&found->list, &info->space_info);
 	atomic_set(&found->caching_threads, 0);
+
+	if (flags & BTRFS_BLOCK_GROUP_METADATA)
+		btrfs_init_space_pools(info);
+
 	return 0;
 }
 
@@ -2818,65 +2824,27 @@ static u64 calculate_bytes_needed(struct btrfs_root *root, int num_items)
  * we have extents, this function does nothing.
  */
 int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
-					  struct inode *inode, int num_items)
+					  struct inode *inode, u64 bytes)
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
+	int num_items;
 
-	num_bytes = calculate_bytes_needed(root->fs_info->extent_root,
-					   num_items);
+	num_items = (int)div64_u64(bytes + root->fs_info->max_extent - 1,
+				   root->fs_info->max_extent);
 
-	spin_lock(&meta_sinfo->lock);
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
 	if (BTRFS_I(inode)->reserved_extents <=
 	    BTRFS_I(inode)->outstanding_extents) {
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
-		spin_unlock(&meta_sinfo->lock);
 		return 0;
 	}
+	BTRFS_I(inode)->reserved_extents -= num_items;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
-	BTRFS_I(inode)->reserved_extents--;
-	BUG_ON(BTRFS_I(inode)->reserved_extents < 0);
-
-	if (meta_sinfo->bytes_delalloc < num_bytes) {
-		bug = true;
-		meta_sinfo->bytes_delalloc = 0;
-	} else {
-		meta_sinfo->bytes_delalloc -= num_bytes;
-	}
-	spin_unlock(&meta_sinfo->lock);
-
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
@@ -2905,10 +2873,18 @@ static noinline void flush_delalloc_async(struct btrfs_work *work)
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
@@ -2919,14 +2895,28 @@ static void wait_on_flush(struct btrfs_space_info *info)
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
@@ -2951,7 +2941,7 @@ static void flush_delalloc(struct btrfs_root *root,
 	spin_unlock(&info->lock);
 
 	if (wait) {
-		wait_on_flush(info);
+		wait_on_flush(root, info);
 		return;
 	}
 
@@ -2965,7 +2955,7 @@ static void flush_delalloc(struct btrfs_root *root,
 
 	btrfs_queue_worker(&root->fs_info->enospc_workers,
 			   &async->work);
-	wait_on_flush(info);
+	wait_on_flush(root, info);
 	return;
 
 flush:
@@ -2995,6 +2985,7 @@ static int maybe_allocate_chunk(struct btrfs_root *root,
 	 */
 	min_metadata = min((u64)10 * 1024 * 1024 * 1024,
 			     div64_u64(free_space * 5, 100));
+	spin_lock(&info->lock);
 	if (info->total_bytes >= min_metadata) {
 		spin_unlock(&info->lock);
 		return 0;
@@ -3031,8 +3022,6 @@ static int maybe_allocate_chunk(struct btrfs_root *root,
 			     4096 + 2 * 1024 * 1024,
 			     info->flags, 0);
 	btrfs_end_transaction(trans, root);
-	if (ret)
-		goto out;
 out:
 	spin_lock(&info->lock);
 	info->allocating_chunk = 0;
@@ -3048,74 +3037,140 @@ out:
  * Reserve metadata space for delalloc.
  */
 int btrfs_reserve_metadata_for_delalloc(struct btrfs_root *root,
-					struct inode *inode, int num_items)
+					struct inode *inode, u64 bytes)
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
+	int num_items;
+	int retries = 0;
+	int i;
 
-	/* get the space info for where the metadata will live */
-	alloc_target = btrfs_get_alloc_profile(root, 0);
-	meta_sinfo = __find_space_info(info, alloc_target);
+	num_items = (int)div64_u64(bytes + root->fs_info->max_extent - 1,
+				   root->fs_info->max_extent);
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
+		BTRFS_I(inode)->reserved_extents += num_items;
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
+		BTRFS_I(inode)->reserved_extents += num_items;
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
+		btrfs_wait_ordered_extents(root, 0, 0);
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
@@ -3129,28 +3184,54 @@ again:
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
@@ -3170,58 +3251,220 @@ int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items)
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
+	}
+
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
 	}
 
-	check_force_delalloc(meta_sinfo);
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
@@ -4638,6 +4881,7 @@ again:
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 {
+	struct btrfs_reserved_space_pool *pool;
 	struct btrfs_block_group_cache *cache;
 	int ret = 0;
 
@@ -4654,6 +4898,30 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
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
 
@@ -4967,6 +5235,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size)
 {
+	struct btrfs_reserved_space_pool *pool;
 	struct btrfs_key ins;
 	int ret;
 	struct extent_buffer *buf;
@@ -4978,6 +5247,12 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
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
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c0c462f..740735c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -853,7 +853,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	/* do the reserve before the mutex lock in case we have to do some
 	 * flushing.  We wouldn't deadlock, but this is more polite.
 	 */
-	err = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	err = btrfs_reserve_metadata_for_delalloc(root, inode, count);
 	if (err)
 		goto out_nolock;
 
@@ -973,7 +973,7 @@ out:
 	mutex_unlock(&inode->i_mutex);
 	if (ret)
 		err = ret;
-	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+	btrfs_unreserve_metadata_for_delalloc(root, inode, count);
 
 out_nolock:
 	kfree(pages);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bc7e4d9..7162f91 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1230,19 +1230,40 @@ static int btrfs_split_extent_hook(struct inode *inode,
 
 	size = orig->end - orig->start + 1;
 	if (size > root->fs_info->max_extent) {
-		u64 num_extents;
-		u64 new_size;
+		u64 left_extents, right_extents;
+		u64 orig_extents;
+		u64 left_size, right_size;
 
-		new_size = orig->end - split + 1;
-		num_extents = div64_u64(size + root->fs_info->max_extent - 1,
+		left_size = orig->end - split + 1;
+		right_size = split - orig->start;
+		left_extents = div64_u64(left_size + root->fs_info->max_extent - 1,
+					root->fs_info->max_extent);
+		right_extents = div64_u64(right_size + root->fs_info->max_extent - 1,
+					root->fs_info->max_extent);
+		orig_extents = div64_u64(size + root->fs_info->max_extent - 1,
 					root->fs_info->max_extent);
 
 		/*
-		 * if we break a large extent up then leave oustanding_extents
-		 * be, since we've already accounted for the large extent.
+		 * If we are splitting off a max_extent multiple of space, then
+		 * we don't need to account for another extent.  However if we
+		 * take off less than a max_extent, we need to add another
+		 * outstanding_extent, because we will likely still have the
+		 * original amount of extents needed for the big chunk left
+		 * over.
+		 *
+		 * Think of it this way.  We have 4 outstanding extents for the
+		 * original giant chunk of data.  If we split off a max_extent
+		 * sized chunk, then the remaining chunk has 3 outstanding
+		 * extens, and the new little chunk has 1 outstanding extents
+		 * worth, so we're even.
+		 *
+		 * But if we carve off < max_extent, thats its own extent still.
+		 * So the left over chunk still needs 4 extents to describe it
+		 * on disk, and the chunk we just split off needs 1 extent, so
+		 * thats 5 total extents, so we need to add 1 to
+		 * outstanding_extents.
 		 */
-		if (div64_u64(new_size + root->fs_info->max_extent - 1,
-			      root->fs_info->max_extent) < num_extents)
+		if (left_extents + right_extents == orig_extents)
 			return 0;
 	}
 
@@ -1264,18 +1285,16 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 				   struct extent_state *other)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 new_size, old_size;
-	u64 num_extents;
+	u64 new_size, size1, size2;
+	u64 extents1, extents2;
 
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
 		return 0;
 
-	old_size = other->end - other->start + 1;
-	if (new->start < other->start)
-		new_size = other->end - new->start + 1;
-	else
-		new_size = new->end - other->start + 1;
+	size1 = other->end - other->start + 1;
+	size2 = new->end - new->start + 1;
+	new_size = size1 + size2;
 
 	/* we're not bigger than the max, unreserve the space and go */
 	if (new_size <= root->fs_info->max_extent) {
@@ -1285,14 +1304,23 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 		return 0;
 	}
 
+	extents1 = div64_u64(size1 + root->fs_info->max_extent - 1,
+			     root->fs_info->max_extent);
+	extents2 = div64_u64(size2 + root->fs_info->max_extent - 1,
+			     root->fs_info->max_extent);
+
 	/*
-	 * If we grew by another max_extent, just return, we want to keep that
-	 * reserved amount.
+	 * So if the number of extents required for the two chunks of space we
+	 * are merging equals the number of extents we need for the entire space
+	 * we now have, just return.
+	 *
+	 * The idea here is if max extent is say 1M, and the first chunk was
+	 * exactly 1M and the second chunk was 4k, we now need 2 extents to
+	 * cover that area, so we keep the reservation we got from adding the 4k
+	 * extent.
 	 */
-	num_extents = div64_u64(old_size + root->fs_info->max_extent - 1,
-				root->fs_info->max_extent);
 	if (div64_u64(new_size + root->fs_info->max_extent - 1,
-		      root->fs_info->max_extent) > num_extents)
+		      root->fs_info->max_extent) == extents1 + extents2)
 		return 0;
 
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
@@ -1318,9 +1346,12 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 	 */
 	if (!(old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
+		int extents = (int)div64_u64(end - start + 1 +
+					     root->fs_info->max_extent - 1,
+					     root->fs_info->max_extent);
 
 		spin_lock(&BTRFS_I(inode)->accounting_lock);
-		BTRFS_I(inode)->outstanding_extents++;
+		BTRFS_I(inode)->outstanding_extents += extents;
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		btrfs_delalloc_reserve_space(root, inode, end - start + 1);
 		spin_lock(&root->fs_info->delalloc_lock);
@@ -1350,10 +1381,22 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 
 		if (bits & EXTENT_DO_ACCOUNTING) {
+			int extents = (int)
+				div64_u64(state->end - state->start + 1 +
+					  root->fs_info->max_extent - 1,
+					  root->fs_info->max_extent);
+			int bug = 0;
 			spin_lock(&BTRFS_I(inode)->accounting_lock);
-			BTRFS_I(inode)->outstanding_extents--;
+			if (BTRFS_I(inode)->outstanding_extents >= extents)
+				BTRFS_I(inode)->outstanding_extents -= extents;
+			else
+				bug = 1;
 			spin_unlock(&BTRFS_I(inode)->accounting_lock);
-			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+			BUG_ON(bug);
+			btrfs_unreserve_metadata_for_delalloc(root, inode,
+							      state->end -
+							      state->start
+							      + 1);
 		}
 
 		spin_lock(&root->fs_info->delalloc_lock);
@@ -3100,7 +3143,7 @@ static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
 	if (ret)
 		goto out;
 
-	ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	ret = btrfs_reserve_metadata_for_delalloc(root, inode, PAGE_CACHE_SIZE);
 	if (ret)
 		goto out;
 
@@ -3109,7 +3152,7 @@ again:
 	page = grab_cache_page(mapping, index);
 	if (!page) {
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
-		btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+		btrfs_unreserve_metadata_for_delalloc(root, inode, PAGE_CACHE_SIZE);
 		goto out;
 	}
 
@@ -3173,7 +3216,7 @@ again:
 out_unlock:
 	if (ret)
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
-	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+	btrfs_unreserve_metadata_for_delalloc(root, inode, PAGE_CACHE_SIZE);
 	unlock_page(page);
 	page_cache_release(page);
 out:
@@ -5086,7 +5129,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto out;
 	}
 
-	ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	ret = btrfs_reserve_metadata_for_delalloc(root, inode, PAGE_CACHE_SIZE);
 	if (ret) {
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
 		ret = VM_FAULT_SIGBUS;
@@ -5170,7 +5213,7 @@ again:
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
 
 out_unlock:
-	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+	btrfs_unreserve_metadata_for_delalloc(root, inode, PAGE_CACHE_SIZE);
 	if (!ret)
 		return VM_FAULT_LOCKED;
 	unlock_page(page);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 31c6117..c0ac302 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1274,6 +1274,49 @@ out:
 	return ret;
 }
 
+long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_space_args space_args;
+	struct btrfs_ioctl_space_info space;
+	struct btrfs_ioctl_space_info *dest;
+	struct btrfs_space_info *info;
+	int ret = 0;
+
+	if (copy_from_user(&space_args,
+			   (struct btrfs_ioctl_space_args __user *)arg,
+			   sizeof(space_args)))
+		return -EFAULT;
+
+	space_args.total_spaces = 0;
+	dest = (struct btrfs_ioctl_space_info *)
+		(arg + sizeof(struct btrfs_ioctl_space_args));
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(info, &root->fs_info->space_info, list) {
+		if (!space_args.space_slots) {
+			space_args.total_spaces++;
+			continue;
+		}
+		if (space_args.total_spaces >= space_args.space_slots)
+			break;
+		space.flags = info->flags;
+		space.total_bytes = info->total_bytes;
+		space.used_bytes = info->bytes_used;
+		if (copy_to_user(dest, &space, sizeof(space))) {
+			ret = -EFAULT;
+			break;
+		}
+		dest++;
+		space_args.total_spaces++;
+	}
+	rcu_read_unlock();
+
+	if (copy_to_user(arg, &space_args, sizeof(space_args)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 /*
  * there are many ways the trans_start and trans_end ioctls can lead
  * to deadlocks.  They should only be used by applications that
@@ -1338,6 +1381,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_SPACE_INFO:
+		return btrfs_ioctl_space_info(root, argp);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index bc49914..2dcc498 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -36,6 +36,18 @@ struct btrfs_ioctl_clone_range_args {
   __u64 dest_offset;
 };
 
+struct btrfs_ioctl_space_info {
+	u32 flags;
+	u64 total_bytes;
+	u64 used_bytes;
+};
+
+struct btrfs_ioctl_space_args {
+	u64 space_slots;
+	u64 total_spaces;
+	struct btrfs_ioctl_space_info spaces[0];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -67,4 +79,6 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
 				struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 18, \
+				    struct btrfs_ioctl_space_args)
 #endif
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 724d73f..30b2c9c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -303,7 +303,9 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry)
 {
 	struct btrfs_ordered_inode_tree *tree;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct rb_node *node;
+	int bug = 0;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	node = &entry->rb_node;
@@ -311,13 +313,22 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	tree->last = NULL;
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
 
+	/*
+	 * Since we limit ordered extents to root->max_extent we can just
+	 * subtract 1 from outstanding extents, and send max_extent to
+	 * unreserve_metadata_for_delalloc and everything will be a-ok.
+	 */
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
-	BTRFS_I(inode)->outstanding_extents--;
+	if (BTRFS_I(inode)->outstanding_extents)
+		BTRFS_I(inode)->outstanding_extents--;
+	else
+		bug = 1;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
-	btrfs_unreserve_metadata_for_delalloc(BTRFS_I(inode)->root,
-					      inode, 1);
+	BUG_ON(bug);
+	btrfs_unreserve_metadata_for_delalloc(root, inode,
+					      root->fs_info->max_extent);
 
-	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
 
 	/*
@@ -329,7 +340,7 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	    !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
 	}
-	spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->fs_info->ordered_extent_lock);
 
 	return 0;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b2acc79..877b3c9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1060,6 +1060,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_prepare_extent_commit(trans, root);
 
+	btrfs_init_space_pools(root->fs_info);
+
 	cur_trans = root->fs_info->running_transaction;
 	spin_lock(&root->fs_info->new_trans_lock);
 	root->fs_info->running_transaction = NULL;
