From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 03/12] Btrfs: Shrink delay allocated space in a synchronized
 way
Date: Mon, 19 Apr 2010 18:45:55 +0800
Message-ID: <4BCC3463.3050508@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Shrink delay allocated space in a synchronized manner is more
controllable than flushing all delay allocated space in an async
thread.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 3/fs/btrfs/ctree.h 4/fs/btrfs/ctree.h
--- 3/fs/btrfs/ctree.h	2010-04-18 08:13:15.457699211 +0800
+++ 4/fs/btrfs/ctree.h	2010-04-18 08:13:51.602699293 +0800
@@ -699,10 +699,6 @@ struct btrfs_space_info {
 
 	struct list_head list;
 
-	/* for controlling how we free up space for allocations */
-	wait_queue_head_t flush_wait;
-	int flushing;
-
 	/* for block groups in our same type */
 	struct list_head block_groups[BTRFS_NR_RAID_TYPES];
 	spinlock_t lock;
@@ -927,7 +923,6 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_meta_write_workers;
 	struct btrfs_workers endio_write_workers;
 	struct btrfs_workers submit_workers;
-	struct btrfs_workers enospc_workers;
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
 	 * the cow mechanism and make them safe to write.  It happens
@@ -2311,6 +2306,7 @@ int btrfs_truncate_inode_items(struct bt
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
+int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state);
 int btrfs_writepages(struct address_space *mapping,
diff -urp 3/fs/btrfs/disk-io.c 4/fs/btrfs/disk-io.c
--- 3/fs/btrfs/disk-io.c	2010-04-14 14:49:56.559944000 +0800
+++ 4/fs/btrfs/disk-io.c	2010-04-18 08:13:51.604699991 +0800
@@ -1768,9 +1768,6 @@ struct btrfs_root *open_ctree(struct sup
 			   min_t(u64, fs_devices->num_devices,
 			   fs_info->thread_pool_size),
 			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->enospc_workers, "enospc",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
 
 	/* a higher idle thresh on the submit workers makes it much more
 	 * likely that bios will be send down in a sane order to the
@@ -1818,7 +1815,6 @@ struct btrfs_root *open_ctree(struct sup
 	btrfs_start_workers(&fs_info->endio_meta_workers, 1);
 	btrfs_start_workers(&fs_info->endio_meta_write_workers, 1);
 	btrfs_start_workers(&fs_info->endio_write_workers, 1);
-	btrfs_start_workers(&fs_info->enospc_workers, 1);
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
@@ -2049,7 +2045,6 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->enospc_workers);
 fail_iput:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
@@ -2482,7 +2477,6 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->enospc_workers);
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
diff -urp 3/fs/btrfs/extent-tree.c 4/fs/btrfs/extent-tree.c
--- 3/fs/btrfs/extent-tree.c	2010-04-18 08:13:15.463699138 +0800
+++ 4/fs/btrfs/extent-tree.c	2010-04-18 08:13:51.608702224 +0800
@@ -73,6 +73,9 @@ static void dump_space_info(struct btrfs
 static int maybe_allocate_chunk(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_space_info *sinfo, u64 num_bytes);
+static int shrink_delalloc(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct btrfs_space_info *sinfo, u64 to_reclaim);
 
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
@@ -2689,7 +2692,6 @@ static int update_space_info(struct btrf
 	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
 		INIT_LIST_HEAD(&found->block_groups[i]);
 	init_rwsem(&found->groups_sem);
-	init_waitqueue_head(&found->flush_wait);
 	spin_lock_init(&found->lock);
 	found->flags = flags & (BTRFS_BLOCK_GROUP_DATA |
 				BTRFS_BLOCK_GROUP_SYSTEM |
@@ -2903,105 +2905,6 @@ static void check_force_delalloc(struct 
 		meta_sinfo->force_delalloc = 0;
 }
 
-struct async_flush {
-	struct btrfs_root *root;
-	struct btrfs_space_info *info;
-	struct btrfs_work work;
-};
-
-static noinline void flush_delalloc_async(struct btrfs_work *work)
-{
-	struct async_flush *async;
-	struct btrfs_root *root;
-	struct btrfs_space_info *info;
-
-	async = container_of(work, struct async_flush, work);
-	root = async->root;
-	info = async->info;
-
-	btrfs_start_delalloc_inodes(root, 0);
-	wake_up(&info->flush_wait);
-	btrfs_wait_ordered_extents(root, 0, 0);
-
-	spin_lock(&info->lock);
-	info->flushing = 0;
-	spin_unlock(&info->lock);
-	wake_up(&info->flush_wait);
-
-	kfree(async);
-}
-
-static void wait_on_flush(struct btrfs_space_info *info)
-{
-	DEFINE_WAIT(wait);
-	u64 used;
-
-	while (1) {
-		prepare_to_wait(&info->flush_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-		spin_lock(&info->lock);
-		if (!info->flushing) {
-			spin_unlock(&info->lock);
-			break;
-		}
-
-		used = info->bytes_used + info->bytes_reserved +
-			info->bytes_pinned + info->bytes_readonly +
-			info->bytes_super + info->bytes_root +
-			info->bytes_may_use + info->bytes_delalloc;
-		if (used < info->total_bytes) {
-			spin_unlock(&info->lock);
-			break;
-		}
-		spin_unlock(&info->lock);
-		schedule();
-	}
-	finish_wait(&info->flush_wait, &wait);
-}
-
-static void flush_delalloc(struct btrfs_root *root,
-				 struct btrfs_space_info *info)
-{
-	struct async_flush *async;
-	bool wait = false;
-
-	spin_lock(&info->lock);
-
-	if (!info->flushing)
-		info->flushing = 1;
-	else
-		wait = true;
-
-	spin_unlock(&info->lock);
-
-	if (wait) {
-		wait_on_flush(info);
-		return;
-	}
-
-	async = kzalloc(sizeof(*async), GFP_NOFS);
-	if (!async)
-		goto flush;
-
-	async->root = root;
-	async->info = info;
-	async->work.func = flush_delalloc_async;
-
-	btrfs_queue_worker(&root->fs_info->enospc_workers,
-			   &async->work);
-	wait_on_flush(info);
-	return;
-
-flush:
-	btrfs_start_delalloc_inodes(root, 0);
-	btrfs_wait_ordered_extents(root, 0, 0);
-
-	spin_lock(&info->lock);
-	info->flushing = 0;
-	spin_unlock(&info->lock);
-	wake_up(&info->flush_wait);
-}
-
 /*
  * Reserve metadata space for delalloc.
  */
@@ -3054,7 +2957,7 @@ again:
 			filemap_flush(inode->i_mapping);
 			goto again;
 		} else if (flushed == 3) {
-			flush_delalloc(root, meta_sinfo);
+			shrink_delalloc(NULL, root, meta_sinfo, num_bytes);
 			goto again;
 		}
 		spin_lock(&meta_sinfo->lock);
@@ -3167,7 +3070,7 @@ again:
 		}
 
 		if (retries == 2) {
-			flush_delalloc(root, meta_sinfo);
+			shrink_delalloc(NULL, root, meta_sinfo, num_bytes);
 			goto again;
 		}
 		spin_lock(&meta_sinfo->lock);
@@ -3193,7 +3096,7 @@ int btrfs_check_data_free_space(struct b
 {
 	struct btrfs_space_info *data_sinfo;
 	u64 used;
-	int ret = 0, committed = 0, flushed = 0;
+	int ret = 0, committed = 0;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
@@ -3213,13 +3116,6 @@ again:
 	if (used + bytes > data_sinfo->total_bytes) {
 		struct btrfs_trans_handle *trans;
 
-		if (!flushed) {
-			spin_unlock(&data_sinfo->lock);
-			flush_delalloc(root, data_sinfo);
-			flushed = 1;
-			goto again;
-		}
-
 		/*
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
@@ -3463,6 +3359,55 @@ static int maybe_allocate_chunk(struct b
 	return ret == 1 ? 1 : 0;
 }
 
+/*
+ * shrink metadata reservation for delalloc
+ */
+static int shrink_delalloc(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct btrfs_space_info *sinfo, u64 to_reclaim)
+{
+	u64 reserved;
+	u64 max_reclaim;
+	u64 reclaimed = 0;
+	int pause = 1;
+	int ret;
+
+	spin_lock(&sinfo->lock);
+	reserved = sinfo->bytes_delalloc;
+	spin_unlock(&sinfo->lock);
+
+	if (reserved == 0)
+		return 0;
+
+	max_reclaim = min(reserved, to_reclaim);
+
+	while (1) {
+		ret = btrfs_start_one_delalloc_inode(root, trans ? 1 : 0);
+		if (!ret) {
+			__set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(pause);
+			pause <<= 1;
+			if (pause > HZ / 10)
+				pause = HZ / 10;
+		} else {
+			pause = 1;
+		}
+
+		spin_lock(&sinfo->lock);
+		if (reserved > sinfo->bytes_delalloc)
+			reclaimed = reserved - sinfo->bytes_delalloc;
+		reserved = sinfo->bytes_delalloc;
+		spin_unlock(&sinfo->lock);
+
+		if (reserved == 0 || reclaimed >= max_reclaim)
+			break;
+
+		if (trans && trans->transaction->blocked)
+			return -EAGAIN;
+	}
+	return reclaimed >= to_reclaim;
+}
+
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc,
diff -urp 3/fs/btrfs/inode.c 4/fs/btrfs/inode.c
--- 3/fs/btrfs/inode.c	2010-04-14 14:49:57.534934000 +0800
+++ 4/fs/btrfs/inode.c	2010-04-18 08:13:48.183698829 +0800
@@ -5610,6 +5610,38 @@ int btrfs_start_delalloc_inodes(struct b
 	return 0;
 }
 
+int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput)
+{
+	struct btrfs_inode *binode;
+	struct inode *inode = NULL;
+
+	spin_lock(&root->fs_info->delalloc_lock);
+	while (!list_empty(&root->fs_info->delalloc_inodes)) {
+		binode = list_entry(root->fs_info->delalloc_inodes.next,
+				    struct btrfs_inode, delalloc_inodes);
+		inode = igrab(&binode->vfs_inode);
+		if (inode) {
+			list_move_tail(&binode->delalloc_inodes,
+				       &root->fs_info->delalloc_inodes);
+			break;
+		}
+
+		list_del_init(&binode->delalloc_inodes);
+		cond_resched_lock(&root->fs_info->delalloc_lock);
+	}
+	spin_unlock(&root->fs_info->delalloc_lock);
+
+	if (inode) {
+		write_inode_now(inode, 0);
+		if (delay_iput)
+			btrfs_add_delayed_iput(inode);
+		else
+			iput(inode);
+		return 1;
+	}
+	return 0;
+}
+
 static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 			 const char *symname)
 {
