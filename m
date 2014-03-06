Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaCFFxh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:37 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rUkm009847
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 07/10] Btrfs: don't flush all delalloc inodes when we doesn't get s_umount lock
Date: Thu, 6 Mar 2014 13:55:01 +0800
Message-Id: <1394085304-32589-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We needn't flush all delalloc inodes when we doesn't get s_umount lock,
or we would make the tasks wait for a long time.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- New patch.
---
 fs/btrfs/ctree.h       |  3 ++-
 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/extent-tree.c |  8 ++++----
 fs/btrfs/inode.c       | 34 +++++++++++++++++++---------------
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/relocation.c  |  2 +-
 fs/btrfs/transaction.c |  2 +-
 7 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 277f627..2f3949b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3727,7 +3727,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
-int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput);
+int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
+			       int nr);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index ec1c3f3..9f22905 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -491,7 +491,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * flush all outstanding I/O and inode extent mappings before the
 	 * copy operation is declared as being finished
 	 */
-	ret = btrfs_start_delalloc_roots(root->fs_info, 0);
+	ret = btrfs_start_delalloc_roots(root->fs_info, 0, -1);
 	if (ret) {
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 07e3d14..da43003 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3971,7 +3971,7 @@ static int can_overcommit(struct btrfs_root *root,
 }
 
 static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
-					 unsigned long nr_pages)
+					 unsigned long nr_pages, int nr_items)
 {
 	struct super_block *sb = root->fs_info->sb;
 
@@ -3986,9 +3986,9 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 		 * the filesystem is readonly(all dirty pages are written to
 		 * the disk).
 		 */
-		btrfs_start_delalloc_roots(root->fs_info, 0);
+		btrfs_start_delalloc_roots(root->fs_info, 0, nr_items);
 		if (!current->journal_info)
-			btrfs_wait_ordered_roots(root->fs_info, -1);
+			btrfs_wait_ordered_roots(root->fs_info, nr_items);
 	}
 }
 
@@ -4045,7 +4045,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	while (delalloc_bytes && loops < 3) {
 		max_reclaim = min(delalloc_bytes, to_reclaim);
 		nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
-		btrfs_writeback_inodes_sb_nr(root, nr_pages);
+		btrfs_writeback_inodes_sb_nr(root, nr_pages, items);
 		/*
 		 * We need to wait for the async pages to actually start before
 		 * we do anything.
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8c9522b..4f64216 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8416,7 +8416,8 @@ void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work)
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
  */
-static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
+static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
+				   int nr)
 {
 	struct btrfs_inode *binode;
 	struct inode *inode;
@@ -8450,12 +8451,14 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 			else
 				iput(inode);
 			ret = -ENOMEM;
-			goto out;
+			break;
 		}
 		list_add_tail(&work->list, &works);
 		btrfs_queue_worker(&root->fs_info->flush_workers,
 				   &work->work);
-
+		ret++;
+		if (nr != -1 && ret >= nr)
+			break;
 		cond_resched();
 		spin_lock(&root->delalloc_lock);
 	}
@@ -8465,12 +8468,6 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 		list_del_init(&work->list);
 		btrfs_wait_and_free_delalloc_work(work);
 	}
-	return 0;
-out:
-	list_for_each_entry_safe(work, next, &works, list) {
-		list_del_init(&work->list);
-		btrfs_wait_and_free_delalloc_work(work);
-	}
 
 	if (!list_empty_careful(&splice)) {
 		spin_lock(&root->delalloc_lock);
@@ -8487,7 +8484,9 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
 		return -EROFS;
 
-	ret = __start_delalloc_inodes(root, delay_iput);
+	ret = __start_delalloc_inodes(root, delay_iput, -1);
+	if (ret > 0)
+		ret = 0;
 	/*
 	 * the filemap_flush will queue IO into the worker threads, but
 	 * we have to make sure the IO is actually started and that
@@ -8504,7 +8503,8 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	return ret;
 }
 
-int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput)
+int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
+			       int nr)
 {
 	struct btrfs_root *root;
 	struct list_head splice;
@@ -8517,7 +8517,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput)
 
 	spin_lock(&fs_info->delalloc_root_lock);
 	list_splice_init(&fs_info->delalloc_roots, &splice);
-	while (!list_empty(&splice)) {
+	while (!list_empty(&splice) && nr) {
 		root = list_first_entry(&splice, struct btrfs_root,
 					delalloc_root);
 		root = btrfs_grab_fs_root(root);
@@ -8526,15 +8526,20 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput)
 			       &fs_info->delalloc_roots);
 		spin_unlock(&fs_info->delalloc_root_lock);
 
-		ret = __start_delalloc_inodes(root, delay_iput);
+		ret = __start_delalloc_inodes(root, delay_iput, nr);
 		btrfs_put_fs_root(root);
-		if (ret)
+		if (ret < 0)
 			goto out;
 
+		if (nr != -1) {
+			nr -= ret;
+			WARN_ON(nr < 0);
+		}
 		spin_lock(&fs_info->delalloc_root_lock);
 	}
 	spin_unlock(&fs_info->delalloc_root_lock);
 
+	ret = 0;
 	atomic_inc(&fs_info->async_submit_draining);
 	while (atomic_read(&fs_info->nr_async_submits) ||
 	      atomic_read(&fs_info->async_delalloc_pages)) {
@@ -8543,7 +8548,6 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput)
 		    atomic_read(&fs_info->async_delalloc_pages) == 0));
 	}
 	atomic_dec(&fs_info->async_submit_draining);
-	return 0;
 out:
 	if (!list_empty_careful(&splice)) {
 		spin_lock(&fs_info->delalloc_root_lock);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b7dc0f7..e80b2bd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4879,7 +4879,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SYNC: {
 		int ret;
 
-		ret = btrfs_start_delalloc_roots(root->fs_info, 0);
+		ret = btrfs_start_delalloc_roots(root->fs_info, 0, -1);
 		if (ret)
 			return ret;
 		ret = btrfs_sync_fs(file->f_dentry->d_sb, 1);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 07b3b36..def428a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4248,7 +4248,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	btrfs_info(extent_root->fs_info, "relocating block group %llu flags %llu",
 	       rc->block_group->key.objectid, rc->block_group->flags);
 
-	ret = btrfs_start_delalloc_roots(fs_info, 0);
+	ret = btrfs_start_delalloc_roots(fs_info, 0, -1);
 	if (ret < 0) {
 		err = ret;
 		goto out;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d888f26..cd4deb3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1621,7 +1621,7 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 {
 	if (btrfs_test_opt(fs_info->tree_root, FLUSHONCOMMIT))
-		return btrfs_start_delalloc_roots(fs_info, 1);
+		return btrfs_start_delalloc_roots(fs_info, 1, -1);
 	return 0;
 }
 
-- 
1.8.1.4

