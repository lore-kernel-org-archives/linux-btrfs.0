Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51952 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3KDPMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 10:12:49 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA4FCVoD031736
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 23:12:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] Btrfs: don't wait for the completion of all the ordered extents
Date: Mon, 4 Nov 2013 23:13:25 +0800
Message-Id: <1383578006-22691-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is very likely that there are lots of ordered extents in the filesytem,
if we wait for the completion of all of them when we want to reclaim some
space for the metadata space reservation, we would be blocked for a long
time. The performance would drop down suddenly for a long time.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c  |  4 ++--
 fs/btrfs/extent-tree.c  | 11 ++++++-----
 fs/btrfs/ioctl.c        |  2 +-
 fs/btrfs/ordered-data.c | 22 +++++++++++++++++-----
 fs/btrfs/ordered-data.h |  4 ++--
 fs/btrfs/relocation.c   |  2 +-
 fs/btrfs/super.c        |  2 +-
 fs/btrfs/transaction.c  |  2 +-
 8 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 2a9bd5b..bc55b36 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -400,7 +400,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	btrfs_dev_replace_unlock(dev_replace);
 
-	btrfs_wait_all_ordered_extents(root->fs_info);
+	btrfs_wait_ordered_roots(root->fs_info, -1);
 
 	/* force writing the updated state information to disk */
 	trans = btrfs_start_transaction(root, 0);
@@ -475,7 +475,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
 	}
-	btrfs_wait_all_ordered_extents(root->fs_info);
+	btrfs_wait_ordered_roots(root->fs_info, -1);
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d691e15..410d972 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4000,7 +4000,7 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 		 */
 		btrfs_start_all_delalloc_inodes(root->fs_info, 0);
 		if (!current->journal_info)
-			btrfs_wait_all_ordered_extents(root->fs_info);
+			btrfs_wait_ordered_roots(root->fs_info, -1);
 	}
 }
 
@@ -4032,11 +4032,12 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	long time_left;
 	unsigned long nr_pages;
 	int loops;
+	int items;
 	enum btrfs_reserve_flush_enum flush;
 
 	/* Calc the number of the pages we need flush for space reservation */
-	to_reclaim = calc_reclaim_items_nr(root, to_reclaim);
-	to_reclaim *= EXTENT_SIZE_PER_ITEM;
+	items = calc_reclaim_items_nr(root, to_reclaim);
+	to_reclaim = items * EXTENT_SIZE_PER_ITEM;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -4048,7 +4049,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		if (trans)
 			return;
 		if (wait_ordered)
-			btrfs_wait_all_ordered_extents(root->fs_info);
+			btrfs_wait_ordered_roots(root->fs_info, items);
 		return;
 	}
 
@@ -4087,7 +4088,7 @@ skip_async:
 
 		loops++;
 		if (wait_ordered && !trans) {
-			btrfs_wait_all_ordered_extents(root->fs_info);
+			btrfs_wait_ordered_roots(root->fs_info, items);
 		} else {
 			time_left = schedule_timeout_killable(1);
 			if (time_left)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d46f60..524692d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -574,7 +574,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (ret)
 		return ret;
 
-	btrfs_wait_ordered_extents(root);
+	btrfs_wait_ordered_extents(root, -1);
 
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
 	if (!pending_snapshot)
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index c702cb6..97efc12 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -563,10 +563,11 @@ static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
  * wait for all the ordered extents in a root.  This is done when balancing
  * space between drives.
  */
-void btrfs_wait_ordered_extents(struct btrfs_root *root)
+int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
 {
 	struct list_head splice, works;
 	struct btrfs_ordered_extent *ordered, *next;
+	int count = 0;
 
 	INIT_LIST_HEAD(&splice);
 	INIT_LIST_HEAD(&works);
@@ -574,7 +575,7 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root)
 	mutex_lock(&root->fs_info->ordered_operations_mutex);
 	spin_lock(&root->ordered_extent_lock);
 	list_splice_init(&root->ordered_extents, &splice);
-	while (!list_empty(&splice)) {
+	while (!list_empty(&splice) && nr) {
 		ordered = list_first_entry(&splice, struct btrfs_ordered_extent,
 					   root_extent_list);
 		list_move_tail(&ordered->root_extent_list,
@@ -589,7 +590,11 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root)
 
 		cond_resched();
 		spin_lock(&root->ordered_extent_lock);
+		if (nr != -1)
+			nr--;
+		count++;
 	}
+	list_splice_tail(&splice, &root->ordered_extents);
 	spin_unlock(&root->ordered_extent_lock);
 
 	list_for_each_entry_safe(ordered, next, &works, work_list) {
@@ -599,18 +604,21 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root)
 		cond_resched();
 	}
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
+
+	return count;
 }
 
-void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info)
+void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
 {
 	struct btrfs_root *root;
 	struct list_head splice;
+	int done;
 
 	INIT_LIST_HEAD(&splice);
 
 	spin_lock(&fs_info->ordered_root_lock);
 	list_splice_init(&fs_info->ordered_roots, &splice);
-	while (!list_empty(&splice)) {
+	while (!list_empty(&splice) && nr) {
 		root = list_first_entry(&splice, struct btrfs_root,
 					ordered_root);
 		root = btrfs_grab_fs_root(root);
@@ -619,10 +627,14 @@ void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info)
 			       &fs_info->ordered_roots);
 		spin_unlock(&fs_info->ordered_root_lock);
 
-		btrfs_wait_ordered_extents(root);
+		done = btrfs_wait_ordered_extents(root, nr);
 		btrfs_put_fs_root(root);
 
 		spin_lock(&fs_info->ordered_root_lock);
+		if (nr != -1) {
+			nr -= done;
+			WARN_ON(nr < 0);
+		}
 	}
 	spin_unlock(&fs_info->ordered_root_lock);
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 0c0b356..296f15d 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -195,8 +195,8 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct inode *inode);
-void btrfs_wait_ordered_extents(struct btrfs_root *root);
-void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info);
+int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr);
+void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr);
 void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode);
 void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid);
 void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4a35572..0cec204 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4246,7 +4246,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		err = ret;
 		goto out;
 	}
-	btrfs_wait_all_ordered_extents(fs_info);
+	btrfs_wait_ordered_roots(fs_info, -1);
 
 	while (1) {
 		mutex_lock(&fs_info->cleaner_mutex);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e913328..217ccb9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -921,7 +921,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_wait_all_ordered_extents(fs_info);
+	btrfs_wait_ordered_roots(fs_info, -1);
 
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8c81bdc..0fada5b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1603,7 +1603,7 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
 {
 	if (btrfs_test_opt(fs_info->tree_root, FLUSHONCOMMIT))
-		btrfs_wait_all_ordered_extents(fs_info);
+		btrfs_wait_ordered_roots(fs_info, -1);
 }
 
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
-- 
1.8.1.4

