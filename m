Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52889 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3IROwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 10:52:44 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2EB447C0645
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 08:52:44 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id xHToaH7TtoITwLVY (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 08:52:43 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: kill delay_iput arg to the wait_ordered functions V2
Date: Wed, 18 Sep 2013 10:52:41 -0400
Message-ID: <1379515961-1353-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a left over of how we used to wait for ordered extents, which was to
grab the inode and then run filemap flush on it.  However if we have an ordered
extent then we already are holding a ref on the inode, and we just use
btrfs_start_ordered_extent anyway, so there is no reason to have an extra ref on
the inode to start work on the ordered extent.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: accidently removed a btrfs_put_ordered_extent which isn't good.

 fs/btrfs/dev-replace.c  |    4 ++--
 fs/btrfs/extent-tree.c  |    6 +++---
 fs/btrfs/ioctl.c        |    2 +-
 fs/btrfs/ordered-data.c |   24 +++---------------------
 fs/btrfs/ordered-data.h |    5 ++---
 fs/btrfs/relocation.c   |    2 +-
 fs/btrfs/super.c        |    2 +-
 fs/btrfs/transaction.c  |    2 +-
 8 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index af800ef..5d84443 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -400,7 +400,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	btrfs_dev_replace_unlock(dev_replace);
 
-	btrfs_wait_all_ordered_extents(root->fs_info, 0);
+	btrfs_wait_all_ordered_extents(root->fs_info);
 
 	/* force writing the updated state information to disk */
 	trans = btrfs_start_transaction(root, 0);
@@ -475,7 +475,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
 	}
-	btrfs_wait_all_ordered_extents(root->fs_info, 0);
+	btrfs_wait_all_ordered_extents(root->fs_info);
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 07f7f69..88c6db6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3991,7 +3991,7 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 		 */
 		btrfs_start_all_delalloc_inodes(root->fs_info, 0);
 		if (!current->journal_info)
-			btrfs_wait_all_ordered_extents(root->fs_info, 0);
+			btrfs_wait_all_ordered_extents(root->fs_info);
 	}
 }
 
@@ -4021,7 +4021,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	if (delalloc_bytes == 0) {
 		if (trans)
 			return;
-		btrfs_wait_all_ordered_extents(root->fs_info, 0);
+		btrfs_wait_all_ordered_extents(root->fs_info);
 		return;
 	}
 
@@ -4049,7 +4049,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 
 		loops++;
 		if (wait_ordered && !trans) {
-			btrfs_wait_all_ordered_extents(root->fs_info, 0);
+			btrfs_wait_all_ordered_extents(root->fs_info);
 		} else {
 			time_left = schedule_timeout_killable(1);
 			if (time_left)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1a5b946..fd6557e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -574,7 +574,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (ret)
 		return ret;
 
-	btrfs_wait_ordered_extents(root, 0);
+	btrfs_wait_ordered_extents(root);
 
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
 	if (!pending_snapshot)
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 966b413..c702cb6 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -563,11 +563,10 @@ static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
  * wait for all the ordered extents in a root.  This is done when balancing
  * space between drives.
  */
-void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
+void btrfs_wait_ordered_extents(struct btrfs_root *root)
 {
 	struct list_head splice, works;
 	struct btrfs_ordered_extent *ordered, *next;
-	struct inode *inode;
 
 	INIT_LIST_HEAD(&splice);
 	INIT_LIST_HEAD(&works);
@@ -580,15 +579,6 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 					   root_extent_list);
 		list_move_tail(&ordered->root_extent_list,
 			       &root->ordered_extents);
-		/*
-		 * the inode may be getting freed (in sys_unlink path).
-		 */
-		inode = igrab(ordered->inode);
-		if (!inode) {
-			cond_resched_lock(&root->ordered_extent_lock);
-			continue;
-		}
-
 		atomic_inc(&ordered->refs);
 		spin_unlock(&root->ordered_extent_lock);
 
@@ -605,21 +595,13 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 	list_for_each_entry_safe(ordered, next, &works, work_list) {
 		list_del_init(&ordered->work_list);
 		wait_for_completion(&ordered->completion);
-
-		inode = ordered->inode;
 		btrfs_put_ordered_extent(ordered);
-		if (delay_iput)
-			btrfs_add_delayed_iput(inode);
-		else
-			iput(inode);
-
 		cond_resched();
 	}
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
 }
 
-void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info,
-				    int delay_iput)
+void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *root;
 	struct list_head splice;
@@ -637,7 +619,7 @@ void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info,
 			       &fs_info->ordered_roots);
 		spin_unlock(&fs_info->ordered_root_lock);
 
-		btrfs_wait_ordered_extents(root, delay_iput);
+		btrfs_wait_ordered_extents(root);
 		btrfs_put_fs_root(root);
 
 		spin_lock(&fs_info->ordered_root_lock);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index d9a5aa0..0c0b356 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -195,9 +195,8 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct inode *inode);
-void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput);
-void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info,
-				    int delay_iput);
+void btrfs_wait_ordered_extents(struct btrfs_root *root);
+void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info);
 void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode);
 void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid);
 void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 09b2b9a..a5a2632 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4246,7 +4246,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		err = ret;
 		goto out;
 	}
-	btrfs_wait_all_ordered_extents(fs_info, 0);
+	btrfs_wait_all_ordered_extents(fs_info);
 
 	while (1) {
 		mutex_lock(&fs_info->cleaner_mutex);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 58cb83f..b341da3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -921,7 +921,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_wait_all_ordered_extents(fs_info, 1);
+	btrfs_wait_all_ordered_extents(fs_info);
 
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cac4a3f..e7a9535 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1603,7 +1603,7 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
 {
 	if (btrfs_test_opt(fs_info->tree_root, FLUSHONCOMMIT))
-		btrfs_wait_all_ordered_extents(fs_info, 1);
+		btrfs_wait_all_ordered_extents(fs_info);
 }
 
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
-- 
1.7.7.6

