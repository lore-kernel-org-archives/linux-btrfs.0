Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaCFFxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:39 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rUkn009847
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 10/10] Btrfs: reclaim the reserved metadata space at background
Date: Thu, 6 Mar 2014 13:55:04 +0800
Message-Id: <1394085304-32589-10-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before applying this patch, the task had to reclaim the metadata space
by itself if the metadata space was not enough. And When the task started
the space reclamation, all the other tasks which wanted to reserve the
metadata space were blocked. At some cases, they would be blocked for
a long time, it made the performance fluctuate wildly.

So we introduce the background metadata space reclamation, when the space
is about to be exhausted, we insert a reclaim work into the workqueue, the
worker of the workqueue helps us to reclaim the reserved space at the
background. By this way, the tasks needn't reclaim the space by themselves at
most cases, and even if the tasks have to reclaim the space or are blocked
for the space reclamation, they will get enough space more quickly.

We needn't worry about the early enospc problem because all the reclaim work
is serialized by the lock.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
I just do some simple test now, I'll do more performance test and send out
the result.

Changelog v1 -> v2:
- change the reclaim size.
---
 fs/btrfs/ctree.h       |  6 +++
 fs/btrfs/disk-io.c     |  3 ++
 fs/btrfs/extent-tree.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/super.c       |  1 +
 4 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ec47aa9..21f156b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -33,6 +33,7 @@
 #include <asm/kmap_types.h>
 #include <linux/pagemap.h>
 #include <linux/btrfs.h>
+#include <linux/workqueue.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -1305,6 +1306,8 @@ struct btrfs_stripe_hash_table {
 
 #define BTRFS_STRIPE_HASH_TABLE_BITS 11
 
+void btrfs_init_async_reclaim_work(struct work_struct *work);
+
 /* fs_info */
 struct reloc_control;
 struct btrfs_device;
@@ -1681,6 +1684,9 @@ struct btrfs_fs_info {
 
 	struct semaphore uuid_tree_rescan_sem;
 	unsigned int update_uuid_tree_gen:1;
+
+	/* Used to reclaim the metadata space in the background. */
+	struct work_struct async_reclaim_work;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2bb0bbd..d77516e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2237,6 +2237,7 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->balance_cancel_req, 0);
 	fs_info->balance_ctl = NULL;
 	init_waitqueue_head(&fs_info->balance_wait_q);
+	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
 
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
@@ -3580,6 +3581,8 @@ int close_ctree(struct btrfs_root *root)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_cleanup_defrag_inodes(fs_info);
 
+	cancel_work_sync(&fs_info->async_reclaim_work);
+
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_commit_super(root);
 		if (ret)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index da43003..6640d28 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4200,6 +4200,98 @@ static int flush_space(struct btrfs_root *root,
 
 	return ret;
 }
+
+static inline u64
+btrfs_calc_reclaim_metadata_size(struct btrfs_root *root,
+				 struct btrfs_space_info *space_info)
+{
+	u64 used;
+	u64 expected;
+	u64 to_reclaim;
+
+	to_reclaim = min_t(u64, num_online_cpus() * 1024 * 1024,
+				16 * 1024 * 1024);
+	spin_lock(&space_info->lock);
+	if (can_overcommit(root, space_info, to_reclaim,
+			   BTRFS_RESERVE_FLUSH_ALL)) {
+		to_reclaim = 0;
+		goto out;
+	}
+
+	used = space_info->bytes_used + space_info->bytes_reserved +
+	       space_info->bytes_pinned + space_info->bytes_readonly +
+	       space_info->bytes_may_use;
+	if (can_overcommit(root, space_info, 1024 * 1024,
+			   BTRFS_RESERVE_FLUSH_ALL))
+		expected = div_factor_fine(space_info->total_bytes, 95);
+	else
+		expected = div_factor_fine(space_info->total_bytes, 90);
+	to_reclaim = used - expected;
+out:
+	spin_unlock(&space_info->lock);
+
+	return to_reclaim;
+}
+
+static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
+					struct btrfs_fs_info *fs_info, u64 used)
+{
+	return (used >= div_factor_fine(space_info->total_bytes, 95) &&
+		!btrfs_fs_closing(fs_info) &&
+		!test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state));
+}
+
+static int btrfs_need_do_async_reclaim(struct btrfs_space_info *space_info,
+				       struct btrfs_fs_info *fs_info)
+{
+	u64 used;
+
+	spin_lock(&space_info->lock);
+	used = space_info->bytes_used + space_info->bytes_reserved +
+	       space_info->bytes_pinned + space_info->bytes_readonly +
+	       space_info->bytes_may_use;
+	if (need_do_async_reclaim(space_info, fs_info, used)) {
+		spin_unlock(&space_info->lock);
+		return 1;
+	}
+	spin_unlock(&space_info->lock);
+
+	return 0;
+}
+
+static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
+{
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_space_info *space_info;
+	u64 to_reclaim;
+	int flush_state;
+
+	fs_info = container_of(work, struct btrfs_fs_info, async_reclaim_work);
+	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
+
+	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info->fs_root,
+						      space_info);
+	if (!to_reclaim)
+		return;
+
+	flush_state = FLUSH_DELAYED_ITEMS_NR;
+	do {
+		flush_space(fs_info->fs_root, space_info, to_reclaim,
+			    to_reclaim, flush_state);
+		flush_state++;
+		if (!btrfs_need_do_async_reclaim(space_info, fs_info))
+			return;
+	} while (flush_state <= COMMIT_TRANS);
+
+	if (btrfs_need_do_async_reclaim(space_info, fs_info))
+		queue_work(system_unbound_wq, work);
+}
+
+void btrfs_init_async_reclaim_work(struct work_struct *work)
+{
+	INIT_WORK(work, btrfs_async_reclaim_metadata_space);
+}
+
 /**
  * reserve_metadata_bytes - try to reserve bytes from the block_rsv's space
  * @root - the root we're allocating for
@@ -4307,8 +4399,13 @@ again:
 	if (ret && flush != BTRFS_RESERVE_NO_FLUSH) {
 		flushing = true;
 		space_info->flush = 1;
+	} else if (!ret && space_info->flags & BTRFS_BLOCK_GROUP_METADATA) {
+		used += orig_bytes;
+		if (need_do_async_reclaim(space_info, root->fs_info, used) &&
+		    !work_busy(&root->fs_info->async_reclaim_work))
+			queue_work(system_unbound_wq,
+				   &root->fs_info->async_reclaim_work);
 	}
-
 	spin_unlock(&space_info->lock);
 
 	if (!ret || flush == BTRFS_RESERVE_NO_FLUSH)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 97cc241..7cc7423 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1401,6 +1401,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		 * this also happens on 'umount -rf' or on shutdown, when
 		 * the filesystem is busy.
 		 */
+		cancel_work_sync(&fs_info->async_reclaim_work);
 
 		/* wait for the uuid_scan task to finish */
 		down(&fs_info->uuid_tree_rescan_sem);
-- 
1.8.1.4

