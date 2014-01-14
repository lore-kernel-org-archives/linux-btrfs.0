Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaANNQS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 08:16:18 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0ECUOq6015720
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 20:30:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 3/4] Btrfs: don't mix the ordered extents of all files together during logging the inodes
Date: Tue, 14 Jan 2014 20:31:51 +0800
Message-Id: <1389702712-26638-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
References: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a problem in the old code:
If we failed to log the csum, we would free all the ordered extents in the log list
including those ordered extents that were logged successfully, it would make the
log committer not to wait for the completion of the ordered extents.

This patch doesn't insert the ordered extents that is about to be logged into
a global list, instead, we insert them into a local list. If we log the ordered
extents successfully, we splice them with the global list, or we will throw them
away, then do full sync. It can also reduce the lock contention and the traverse
time of list.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |   39 +++++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.h |    6 +++++-
 fs/btrfs/tree-log.c     |   47 +++++++++++++++--------------------------------
 3 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 396c6d1..739de05 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -417,12 +417,12 @@ out:
 }
 
 /* Needs to either be called under a log transaction or the log_mutex */
-void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode)
+void btrfs_get_logged_extents(struct inode *inode,
+			      struct list_head *logged_list)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct btrfs_ordered_extent *ordered;
 	struct rb_node *n;
-	int index = log->log_transid % 2;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	spin_lock_irq(&tree->lock);
@@ -430,16 +430,39 @@ void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode)
 		ordered = rb_entry(n, struct btrfs_ordered_extent, rb_node);
 		if (test_bit(BTRFS_ORDERED_LOGGED_CSUM, &ordered->flags))
 			continue;
-		spin_lock(&log->log_extents_lock[index]);
-		if (list_empty(&ordered->log_list)) {
-			list_add_tail(&ordered->log_list, &log->logged_list[index]);
-			atomic_inc(&ordered->refs);
-		}
-		spin_unlock(&log->log_extents_lock[index]);
+
+		if (!list_empty(&ordered->log_list))
+			continue;
+
+		list_add_tail(&ordered->log_list, logged_list);
+		atomic_inc(&ordered->refs);
 	}
 	spin_unlock_irq(&tree->lock);
 }
 
+void btrfs_put_logged_extents(struct list_head *logged_list)
+{
+	struct btrfs_ordered_extent *ordered;
+
+	while (!list_empty(logged_list)) {
+		ordered = list_first_entry(logged_list,
+					   struct btrfs_ordered_extent,
+					   log_list);
+		list_del_init(&ordered->log_list);
+		btrfs_put_ordered_extent(ordered);
+	}
+}
+
+void btrfs_submit_logged_extents(struct list_head *logged_list,
+				 struct btrfs_root *log)
+{
+	int index = log->log_transid % 2;
+
+	spin_lock_irq(&log->log_extents_lock[index]);
+	list_splice_tail(logged_list, &log->logged_list[index]);
+	spin_unlock_irq(&log->log_extents_lock[index]);
+}
+
 void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid)
 {
 	struct btrfs_ordered_extent *ordered;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 9b0450f..2468970 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -197,7 +197,11 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				 struct inode *inode);
 int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr);
 void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr);
-void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode);
+void btrfs_get_logged_extents(struct inode *inode,
+			      struct list_head *logged_list);
+void btrfs_put_logged_extents(struct list_head *logged_list);
+void btrfs_submit_logged_extents(struct list_head *logged_list,
+				 struct btrfs_root *log);
 void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid);
 void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid);
 int __init ordered_data_init(void);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9f7fc51..251e6f4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3331,7 +3331,8 @@ static int extent_cmp(void *priv, struct list_head *a, struct list_head *b)
 
 static int log_one_extent(struct btrfs_trans_handle *trans,
 			  struct inode *inode, struct btrfs_root *root,
-			  struct extent_map *em, struct btrfs_path *path)
+			  struct extent_map *em, struct btrfs_path *path,
+			  struct list_head *logged_list)
 {
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_file_extent_item *fi;
@@ -3347,7 +3348,6 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 extent_offset = em->start - em->orig_start;
 	u64 block_len;
 	int ret;
-	int index = log->log_transid % 2;
 	bool skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	ret = __btrfs_drop_extents(trans, log, inode, path, em->start,
@@ -3425,17 +3425,12 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	 * First check and see if our csums are on our outstanding ordered
 	 * extents.
 	 */
-again:
-	spin_lock_irq(&log->log_extents_lock[index]);
-	list_for_each_entry(ordered, &log->logged_list[index], log_list) {
+	list_for_each_entry(ordered, logged_list, log_list) {
 		struct btrfs_ordered_sum *sum;
 
 		if (!mod_len)
 			break;
 
-		if (ordered->inode != inode)
-			continue;
-
 		if (ordered->file_offset + ordered->len <= mod_start ||
 		    mod_start + mod_len <= ordered->file_offset)
 			continue;
@@ -3471,36 +3466,19 @@ again:
 			}
 		}
 
-		/*
-		 * To keep us from looping for the above case of an ordered
-		 * extent that falls inside of the logged extent.
-		 */
 		if (test_and_set_bit(BTRFS_ORDERED_LOGGED_CSUM,
 				     &ordered->flags))
 			continue;
-		atomic_inc(&ordered->refs);
-		spin_unlock_irq(&log->log_extents_lock[index]);
-		/*
-		 * we've dropped the lock, we must either break or
-		 * start over after this.
-		 */
 
 		wait_event(ordered->wait, ordered->csum_bytes_left == 0);
 
 		list_for_each_entry(sum, &ordered->list, list) {
 			ret = btrfs_csum_file_blocks(trans, log, sum);
-			if (ret) {
-				btrfs_put_ordered_extent(ordered);
+			if (ret)
 				goto unlocked;
-			}
 		}
-		btrfs_put_ordered_extent(ordered);
-		goto again;
-
 	}
-	spin_unlock_irq(&log->log_extents_lock[index]);
 unlocked:
-
 	if (!mod_len || ret)
 		return ret;
 
@@ -3536,7 +3514,8 @@ unlocked:
 static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     struct inode *inode,
-				     struct btrfs_path *path)
+				     struct btrfs_path *path,
+				     struct list_head *logged_list)
 {
 	struct extent_map *em, *n;
 	struct list_head extents;
@@ -3594,7 +3573,7 @@ process:
 
 		write_unlock(&tree->lock);
 
-		ret = log_one_extent(trans, inode, root, em, path);
+		ret = log_one_extent(trans, inode, root, em, path, logged_list);
 		write_lock(&tree->lock);
 		clear_em_logging(tree, em);
 		free_extent_map(em);
@@ -3630,6 +3609,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_key max_key;
 	struct btrfs_root *log = root->log_root;
 	struct extent_buffer *src = NULL;
+	LIST_HEAD(logged_list);
 	int err = 0;
 	int ret;
 	int nritems;
@@ -3677,7 +3657,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
-	btrfs_get_logged_extents(log, inode);
+	btrfs_get_logged_extents(inode, &logged_list);
 
 	/*
 	 * a brute force approach to making sure we get the most uptodate
@@ -3797,7 +3777,8 @@ log_extents:
 	btrfs_release_path(path);
 	btrfs_release_path(dst_path);
 	if (fast_search) {
-		ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
+		ret = btrfs_log_changed_extents(trans, root, inode, dst_path,
+						&logged_list);
 		if (ret) {
 			err = ret;
 			goto out_unlock;
@@ -3822,8 +3803,10 @@ log_extents:
 	BTRFS_I(inode)->logged_trans = trans->transid;
 	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->last_sub_trans;
 out_unlock:
-	if (err)
-		btrfs_free_logged_extents(log, log->log_transid);
+	if (unlikely(err))
+		btrfs_put_logged_extents(&logged_list);
+	else
+		btrfs_submit_logged_extents(&logged_list, log);
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 
 	btrfs_free_path(path);
-- 
1.7.1

