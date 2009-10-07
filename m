From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: async delalloc flushing under space pressure
Date: Wed, 7 Oct 2009 14:23:18 -0400
Message-ID: <20091007182317.GB10911@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch moves the delalloc flushing that occurs when we are under space
pressure off to a async thread pool.  This helps since we only free up
metadata space when we actually insert the extent item, which means it takes
quite a while for space to be free'ed up if we wait on all ordered extents.
However, if space is freed up due to inline extents being inserted, we can
wake people who are waiting up early, and they can finish their work.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |   13 ++++---
 fs/btrfs/disk-io.c     |    5 +++
 fs/btrfs/extent-tree.c |   81 +++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 88 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 61599dc..2aeb3a8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -687,17 +687,17 @@ struct btrfs_space_info {
 
 	struct list_head list;
 
+	/* for controlling how we free up space for allocations */
+	wait_queue_head_t allocate_wait;
+	wait_queue_head_t flush_wait;
+	int allocating_chunk;
+	int flushing;
+
 	/* for block groups in our same type */
 	struct list_head block_groups;
 	spinlock_t lock;
 	struct rw_semaphore groups_sem;
 	atomic_t caching_threads;
-
-	int allocating_chunk;
-	wait_queue_head_t wait;
-
-	int flushing;
-	wait_queue_head_t flush_wait;
 };
 
 /*
@@ -909,6 +909,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_meta_write_workers;
 	struct btrfs_workers endio_write_workers;
 	struct btrfs_workers submit_workers;
+	struct btrfs_workers enospc_workers;
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
 	 * the cow mechanism and make them safe to write.  It happens
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4e271bd..7a37715 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1717,6 +1717,8 @@ printk("thread pool is %d\n", fs_info->thread_pool_size);
 	btrfs_init_workers(&fs_info->submit_workers, "submit",
 			   min_t(u64, fs_devices->num_devices,
 			   fs_info->thread_pool_size));
+	btrfs_init_workers(&fs_info->enospc_workers, "enospc",
+			   fs_info->thread_pool_size);
 
 	/* a higher idle thresh on the submit workers makes it much more
 	 * likely that bios will be send down in a sane order to the
@@ -1763,6 +1765,7 @@ printk("thread pool is %d\n", fs_info->thread_pool_size);
 	btrfs_start_workers(&fs_info->endio_meta_workers, 1);
 	btrfs_start_workers(&fs_info->endio_meta_write_workers, 1);
 	btrfs_start_workers(&fs_info->endio_write_workers, 1);
+	btrfs_start_workers(&fs_info->enospc_workers, 1);
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
@@ -1973,6 +1976,7 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->submit_workers);
+	btrfs_stop_workers(&fs_info->enospc_workers);
 fail_iput:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
@@ -2376,6 +2380,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->submit_workers);
+	btrfs_stop_workers(&fs_info->enospc_workers);
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 22be623..97e7ec9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2866,9 +2866,67 @@ static void check_force_delalloc(struct btrfs_space_info *meta_sinfo)
 		meta_sinfo->force_delalloc = 0;
 }
 
+struct async_flush {
+	struct btrfs_root *root;
+	struct btrfs_space_info *info;
+	struct btrfs_work work;
+};
+
+static noinline void flush_delalloc_async(struct btrfs_work *work)
+{
+	struct async_flush *async;
+	struct btrfs_root *root;
+	struct btrfs_space_info *info;
+
+	async = container_of(work, struct async_flush, work);
+	root = async->root;
+	info = async->info;
+
+	printk(KERN_ERR "root is %p, info is %p\n", root, info);
+	btrfs_start_delalloc_inodes(root);
+	wake_up(&info->flush_wait);
+	btrfs_wait_ordered_extents(root, 0);
+
+	spin_lock(&info->lock);
+	info->flushing = 0;
+	spin_unlock(&info->lock);
+	wake_up(&info->flush_wait);
+
+	kfree(async);
+}
+
+static void wait_on_flush(struct btrfs_space_info *info)
+{
+	DEFINE_WAIT(wait);
+	u64 used;
+
+	while (1) {
+		prepare_to_wait(&info->flush_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		spin_lock(&info->lock);
+		if (!info->flushing) {
+			spin_unlock(&info->lock);
+			break;
+		}
+
+		used = info->bytes_used + info->bytes_reserved +
+			info->bytes_pinned + info->bytes_readonly +
+			info->bytes_super + info->bytes_root +
+			info->bytes_may_use + info->bytes_delalloc;
+		if (used < info->total_bytes) {
+			spin_unlock(&info->lock);
+			break;
+		}
+		spin_unlock(&info->lock);
+		schedule();
+	}
+	finish_wait(&info->flush_wait, &wait);
+}
+
 static void flush_delalloc(struct btrfs_root *root,
 				 struct btrfs_space_info *info)
 {
+	struct async_flush *async;
 	bool wait = false;
 
 	spin_lock(&info->lock);
@@ -2883,11 +2941,24 @@ static void flush_delalloc(struct btrfs_root *root,
 	spin_unlock(&info->lock);
 
 	if (wait) {
-		wait_event(info->flush_wait,
-			   !info->flushing);
+		wait_on_flush(info);
 		return;
 	}
 
+	async = kzalloc(sizeof(*async), GFP_NOFS);
+	if (!async)
+		goto flush;
+
+	async->root = root;
+	async->info = info;
+	async->work.func = flush_delalloc_async;
+
+	btrfs_queue_worker(&root->fs_info->enospc_workers,
+			   &async->work);
+	wait_on_flush(info);
+	return;
+
+flush:
 	btrfs_start_delalloc_inodes(root);
 	btrfs_wait_ordered_extents(root, 0);
 
@@ -2928,7 +2999,7 @@ static int maybe_allocate_chunk(struct btrfs_root *root,
 	if (!info->allocating_chunk) {
 		info->force_alloc = 1;
 		info->allocating_chunk = 1;
-		init_waitqueue_head(&info->wait);
+		init_waitqueue_head(&info->allocate_wait);
 	} else {
 		wait = true;
 	}
@@ -2936,7 +3007,7 @@ static int maybe_allocate_chunk(struct btrfs_root *root,
 	spin_unlock(&info->lock);
 
 	if (wait) {
-		wait_event(info->wait,
+		wait_event(info->allocate_wait,
 			   !info->allocating_chunk);
 		return 1;
 	}
@@ -2958,7 +3029,7 @@ out:
 	spin_lock(&info->lock);
 	info->allocating_chunk = 0;
 	spin_unlock(&info->lock);
-	wake_up(&info->wait);
+	wake_up(&info->allocate_wait);
 
 	if (ret)
 		return 0;
-- 
1.5.4.3

