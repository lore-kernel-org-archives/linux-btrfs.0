Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935050Ab2JYJam (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 05:30:42 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9P9Ud3X030676
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 17:30:39 +0800
Message-ID: <508906D7.2090402@cn.fujitsu.com>
Date: Thu, 25 Oct 2012 17:31:03 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs: make ordered operations be handled by multi-task
References: <5089045D.8050801@cn.fujitsu.com>
In-Reply-To: <5089045D.8050801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The process of the ordered operations is similar to the delalloc inode flush, so
we handle them by flush workers.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |   46 ++++++++++++++++++++++++++++++----------------
 fs/btrfs/ordered-data.h |    2 +-
 fs/btrfs/transaction.c  |   18 ++++++++++++++----
 3 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 7772f02..ab2a3c0 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -519,13 +519,17 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
  * extra check to make sure the ordered operation list really is empty
  * before we return
  */
-void btrfs_run_ordered_operations(struct btrfs_root *root, int wait)
+int btrfs_run_ordered_operations(struct btrfs_root *root, int wait)
 {
 	struct btrfs_inode *btrfs_inode;
 	struct inode *inode;
 	struct list_head splice;
+	struct list_head works;
+	struct btrfs_delalloc_work *work, *next;
+	int ret = 0;
 
 	INIT_LIST_HEAD(&splice);
+	INIT_LIST_HEAD(&works);
 
 	mutex_lock(&root->fs_info->ordered_operations_mutex);
 	spin_lock(&root->fs_info->ordered_extent_lock);
@@ -533,6 +537,7 @@ again:
 	list_splice_init(&root->fs_info->ordered_operations, &splice);
 
 	while (!list_empty(&splice)) {
+
 		btrfs_inode = list_entry(splice.next, struct btrfs_inode,
 				   ordered_operations);
 
@@ -549,15 +554,26 @@ again:
 			list_add_tail(&BTRFS_I(inode)->ordered_operations,
 			      &root->fs_info->ordered_operations);
 		}
+
+		if (!inode)
+			continue;
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 
-		if (inode) {
-			if (wait)
-				btrfs_wait_ordered_range(inode, 0, (u64)-1);
-			else
-				filemap_flush(inode->i_mapping);
-			btrfs_add_delayed_iput(inode);
+		work = btrfs_alloc_delalloc_work(inode, wait, 1);
+		if (!work) {
+			if (list_empty(&BTRFS_I(inode)->ordered_operations))
+				list_add_tail(&btrfs_inode->ordered_operations,
+					      &splice);
+			spin_lock(&root->fs_info->ordered_extent_lock);
+			list_splice_tail(&splice,
+					 &root->fs_info->ordered_operations);
+			spin_unlock(&root->fs_info->ordered_extent_lock);
+			ret = -ENOMEM;
+			goto out;
 		}
+		list_add_tail(&work->list, &works);
+		btrfs_queue_worker(&root->fs_info->flush_workers,
+				   &work->work);
 
 		cond_resched();
 		spin_lock(&root->fs_info->ordered_extent_lock);
@@ -566,7 +582,13 @@ again:
 		goto again;
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
+out:
+	list_for_each_entry_safe(work, next, &works, list) {
+		list_del_init(&work->list);
+		btrfs_wait_and_free_delalloc_work(work);
+	}
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
+	return ret;
 }
 
 /*
@@ -934,15 +956,6 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	if (last_mod < root->fs_info->last_trans_committed)
 		return;
 
-	/*
-	 * the transaction is already committing.  Just start the IO and
-	 * don't bother with all of this list nonsense
-	 */
-	if (trans && root->fs_info->running_transaction->blocked) {
-		btrfs_wait_ordered_range(inode, 0, (u64)-1);
-		return;
-	}
-
 	spin_lock(&root->fs_info->ordered_extent_lock);
 	if (list_empty(&BTRFS_I(inode)->ordered_operations)) {
 		list_add_tail(&BTRFS_I(inode)->ordered_operations,
@@ -959,6 +972,7 @@ int __init ordered_data_init(void)
 				     NULL);
 	if (!btrfs_ordered_extent_cache)
 		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index dd27a0b..e8dcec6 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -186,7 +186,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr, u32 *sum);
-void btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
+int btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
 void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct inode *inode);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4aed529..621790e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1414,15 +1414,21 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_transaction *prev_trans = NULL;
 	DEFINE_WAIT(wait);
-	int ret = -EIO;
+	int ret;
 	int should_grow = 0;
 	unsigned long now = get_seconds();
 	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
 
-	btrfs_run_ordered_operations(root, 0);
+	ret = btrfs_run_ordered_operations(root, 0);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto cleanup_transaction;
+	}
 
-	if (cur_trans->aborted)
+	if (cur_trans->aborted) {
+		ret = cur_trans->aborted;
 		goto cleanup_transaction;
+	}
 
 	/* make a pass through all the delayed refs we have so far
 	 * any runnings procs may add more while we are here
@@ -1525,7 +1531,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		 * it here and no for sure that nothing new will be added
 		 * to the list
 		 */
-		btrfs_run_ordered_operations(root, 1);
+		ret = btrfs_run_ordered_operations(root, 1);
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
+			goto cleanup_transaction;
+		}
 
 		prepare_to_wait(&cur_trans->writer_wait, &wait,
 				TASK_UNINTERRUPTIBLE);
-- 
1.6.5.2

