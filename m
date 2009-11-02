From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 1/8] Avoid superfluous tree-log writeout
Date: Mon, 02 Nov 2009 17:19:45 +0800
Message-ID: <4AEEA431.1070301@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We allow two log transactions at a time, but use same flag
to mark dirty tree-log btree blocks. So we may flush dirty
blocks belonging to newer log transaction when committing a
log transaction. This patch fixes the issue by using two
flags to mark dirty tree-log btree blocks.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/disk-io.c 3/fs/btrfs/disk-io.c
--- 1/fs/btrfs/disk-io.c	2009-10-15 09:33:17.811423754 +0800
+++ 3/fs/btrfs/disk-io.c	2009-10-14 14:41:34.000000000 +0800
@@ -982,12 +982,12 @@ int btrfs_free_log_root_tree(struct btrf
 
 	while (1) {
 		ret = find_first_extent_bit(&log_root_tree->dirty_log_pages,
-				    0, &start, &end, EXTENT_DIRTY);
+				0, &start, &end, EXTENT_DIRTY | EXTENT_NEW);
 		if (ret)
 			break;
 
-		clear_extent_dirty(&log_root_tree->dirty_log_pages,
-				   start, end, GFP_NOFS);
+		clear_extent_bits(&log_root_tree->dirty_log_pages, start, end,
+				  EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
 	}
 	eb = fs_info->log_root_tree->node;
 
diff -urp 1/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-10-21 20:42:19.806223422 +0800
+++ 3/fs/btrfs/extent-tree.c	2009-10-14 13:27:51.000000000 +0800
@@ -4850,8 +4850,16 @@ struct extent_buffer *btrfs_init_new_buf
 	btrfs_set_buffer_uptodate(buf);
 
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
-		set_extent_dirty(&root->dirty_log_pages, buf->start,
-			 buf->start + buf->len - 1, GFP_NOFS);
+		/*
+		 * we allow two log transactions at a time, use different
+		 * EXENT bit to differentiate dirty pages.
+		 */
+		if (root->log_transid % 2 == 0)
+			set_extent_dirty(&root->dirty_log_pages, buf->start,
+					buf->start + buf->len - 1, GFP_NOFS);
+		else
+			set_extent_new(&root->dirty_log_pages, buf->start,
+					buf->start + buf->len - 1, GFP_NOFS);
 	} else {
 		set_extent_dirty(&trans->transaction->dirty_pages, buf->start,
 			 buf->start + buf->len - 1, GFP_NOFS);
diff -urp 1/fs/btrfs/transaction.c 3/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-10-15 09:33:17.893417499 +0800
+++ 3/fs/btrfs/transaction.c	2009-10-14 13:27:51.000000000 +0800
@@ -347,7 +347,7 @@ int btrfs_end_transaction_throttle(struc
  * those extents are sent to disk but does not wait on them
  */
 int btrfs_write_marked_extents(struct btrfs_root *root,
-			       struct extent_io_tree *dirty_pages)
+			       struct extent_io_tree *dirty_pages, int mark)
 {
 	int ret;
 	int err = 0;
@@ -360,7 +360,7 @@ int btrfs_write_marked_extents(struct bt
 
 	while (1) {
 		ret = find_first_extent_bit(dirty_pages, start, &start, &end,
-					    EXTENT_DIRTY);
+					    mark);
 		if (ret)
 			break;
 		while (start <= end) {
@@ -406,7 +406,7 @@ int btrfs_write_marked_extents(struct bt
  * on all the pages and clear them from the dirty pages state tree
  */
 int btrfs_wait_marked_extents(struct btrfs_root *root,
-			      struct extent_io_tree *dirty_pages)
+			      struct extent_io_tree *dirty_pages, int mark)
 {
 	int ret;
 	int err = 0;
@@ -418,12 +418,12 @@ int btrfs_wait_marked_extents(struct btr
 	unsigned long index;
 
 	while (1) {
-		ret = find_first_extent_bit(dirty_pages, 0, &start, &end,
-					    EXTENT_DIRTY);
+		ret = find_first_extent_bit(dirty_pages, start, &start, &end,
+					    mark);
 		if (ret)
 			break;
 
-		clear_extent_dirty(dirty_pages, start, end, GFP_NOFS);
+		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
 		while (start <= end) {
 			index = start >> PAGE_CACHE_SHIFT;
 			start = (u64)(index + 1) << PAGE_CACHE_SHIFT;
@@ -453,13 +453,13 @@ int btrfs_wait_marked_extents(struct btr
  * those extents are on disk for transaction or log commit
  */
 int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
-					struct extent_io_tree *dirty_pages)
+				struct extent_io_tree *dirty_pages, int mark)
 {
 	int ret;
 	int ret2;
 
-	ret = btrfs_write_marked_extents(root, dirty_pages);
-	ret2 = btrfs_wait_marked_extents(root, dirty_pages);
+	ret = btrfs_write_marked_extents(root, dirty_pages, mark);
+	ret2 = btrfs_wait_marked_extents(root, dirty_pages, mark);
 	return ret || ret2;
 }
 
@@ -472,7 +472,8 @@ int btrfs_write_and_wait_transaction(str
 		return filemap_write_and_wait(btree_inode->i_mapping);
 	}
 	return btrfs_write_and_wait_marked_extents(root,
-					   &trans->transaction->dirty_pages);
+					   &trans->transaction->dirty_pages,
+					   EXTENT_DIRTY);
 }
 
 /*
diff -urp 1/fs/btrfs/transaction.h 3/fs/btrfs/transaction.h
--- 1/fs/btrfs/transaction.h	2009-10-15 09:33:17.894417497 +0800
+++ 3/fs/btrfs/transaction.h	2009-10-14 13:27:51.000000000 +0800
@@ -107,10 +107,10 @@ void btrfs_throttle(struct btrfs_root *r
 int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
-					struct extent_io_tree *dirty_pages);
+				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_write_marked_extents(struct btrfs_root *root,
-					struct extent_io_tree *dirty_pages);
+				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_wait_marked_extents(struct btrfs_root *root,
-					struct extent_io_tree *dirty_pages);
+				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
 #endif
diff -urp 1/fs/btrfs/tree-log.c 3/fs/btrfs/tree-log.c
--- 1/fs/btrfs/tree-log.c	2009-10-15 09:33:17.896417074 +0800
+++ 3/fs/btrfs/tree-log.c	2009-10-14 14:42:01.000000000 +0800
@@ -1977,10 +1977,11 @@ int btrfs_sync_log(struct btrfs_trans_ha
 {
 	int index1;
 	int index2;
+	int mark;
 	int ret;
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = root->fs_info->log_root_tree;
-	u64 log_transid = 0;
+	unsigned long log_transid = 0;
 
 	mutex_lock(&root->log_mutex);
 	index1 = root->log_transid % 2;
@@ -2014,24 +2015,29 @@ int btrfs_sync_log(struct btrfs_trans_ha
 		goto out;
 	}
 
+	log_transid = root->log_transid;
+	if (log_transid % 2 == 0)
+		mark = EXTENT_DIRTY;
+	else
+		mark = EXTENT_NEW;
+
 	/* we start IO on  all the marked extents here, but we don't actually
 	 * wait for them until later.
 	 */
-	ret = btrfs_write_marked_extents(log, &log->dirty_log_pages);
+	ret = btrfs_write_marked_extents(log, &log->dirty_log_pages, mark);
 	BUG_ON(ret);
 
 	btrfs_set_root_node(&log->root_item, log->node);
 
 	root->log_batch = 0;
-	log_transid = root->log_transid;
 	root->log_transid++;
 	log->log_transid = root->log_transid;
 	root->log_start_pid = 0;
 	smp_mb();
 	/*
-	 * log tree has been flushed to disk, new modifications of
-	 * the log will be written to new positions. so it's safe to
-	 * allow log writers to go in.
+	 * IO has been started, blocks of the log tree have WRITTEN flag set
+	 * in their headers. new modifications of the log will be written to
+	 * new positions. so it's safe to allow log writers to go in.
 	 */
 	mutex_unlock(&root->log_mutex);
 
@@ -2052,7 +2058,7 @@ int btrfs_sync_log(struct btrfs_trans_ha
 
 	index2 = log_root_tree->log_transid % 2;
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
-		btrfs_wait_marked_extents(log, &log->dirty_log_pages);
+		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		wait_log_commit(trans, log_root_tree,
 				log_root_tree->log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
@@ -2072,16 +2078,17 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	 * check the full commit flag again
 	 */
 	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
-		btrfs_wait_marked_extents(log, &log->dirty_log_pages);
+		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = -EAGAIN;
 		goto out_wake_log_root;
 	}
 
 	ret = btrfs_write_and_wait_marked_extents(log_root_tree,
-				&log_root_tree->dirty_log_pages);
+				&log_root_tree->dirty_log_pages,
+				EXTENT_DIRTY | EXTENT_NEW);
 	BUG_ON(ret);
-	btrfs_wait_marked_extents(log, &log->dirty_log_pages);
+	btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 
 	btrfs_set_super_log_root(&root->fs_info->super_for_commit,
 				log_root_tree->node->start);
@@ -2147,12 +2154,12 @@ int btrfs_free_log(struct btrfs_trans_ha
 
 	while (1) {
 		ret = find_first_extent_bit(&log->dirty_log_pages,
-				    0, &start, &end, EXTENT_DIRTY);
+				0, &start, &end, EXTENT_DIRTY | EXTENT_NEW);
 		if (ret)
 			break;
 
-		clear_extent_dirty(&log->dirty_log_pages,
-				   start, end, GFP_NOFS);
+		clear_extent_bits(&log->dirty_log_pages, start, end,
+				  EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
 	}
 
 	if (log->log_transid > 0) {
