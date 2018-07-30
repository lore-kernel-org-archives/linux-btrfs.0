Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbeG3Huz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 03:50:55 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4C24AE21
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2018 06:17:29 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: locking: Allow btrfs_tree_lock() to return error to avoid deadlock
Date: Mon, 30 Jul 2018 14:17:23 +0800
Message-Id: <20180730061723.13290-2-wqu@suse.com>
In-Reply-To: <20180730061723.13290-1-wqu@suse.com>
References: <20180730061723.13290-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
For certains crafted image, whose csum root leaf has missing backref, if
we try to trigger write with data csum, it could cause deadlock with the
following kernel WARN_ON():
------
WARNING: CPU: 1 PID: 41 at fs/btrfs/locking.c:230 btrfs_tree_lock+0x3e2/0x400
CPU: 1 PID: 41 Comm: kworker/u4:1 Not tainted 4.18.0-rc1+ #8
Workqueue: btrfs-endio-write btrfs_endio_write_helper
RIP: 0010:btrfs_tree_lock+0x3e2/0x400
Call Trace:
 btrfs_alloc_tree_block+0x39f/0x770
 __btrfs_cow_block+0x285/0x9e0
 btrfs_cow_block+0x191/0x2e0
 btrfs_search_slot+0x492/0x1160
 btrfs_lookup_csum+0xec/0x280
 btrfs_csum_file_blocks+0x2be/0xa60
 add_pending_csums+0xaf/0xf0
 btrfs_finish_ordered_io+0x74b/0xc90
 finish_ordered_fn+0x15/0x20
 normal_work_helper+0xf6/0x500
 btrfs_endio_write_helper+0x12/0x20
 process_one_work+0x302/0x770
 worker_thread+0x81/0x6d0
 kthread+0x180/0x1d0
 ret_from_fork+0x35/0x40
---[ end trace 2e85051acb5f6dc1 ]---
------

[CAUSE]
That crafted image has missing backref for csum tree root leaf.
And when we try to allocate new tree block, since there is no
EXTENT/METADATA_ITEM for csum tree root, btrfs consider it's free slot
and use it.

However we have already locked csum tree root leaf by ourselves, thus we
will ourselves to release read/write lock, and causing deadlock.

[FIX]
This patch will allow btrfs_tree_lock() to return error number, so
most callers can exit gracefully.
(Some caller doesn't really expect btrfs_tree_lock() to return error,
and in that case, we use BUG_ON())

Since such problem can only happen in crafted image, we will still
trigger kernel warning, but with a little more meaningful warning
message.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=200405
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c           | 57 +++++++++++++++++++++++++++++++-------
 fs/btrfs/extent-tree.c     | 28 +++++++++++++++----
 fs/btrfs/extent_io.c       |  8 ++++--
 fs/btrfs/free-space-tree.c |  4 ++-
 fs/btrfs/locking.c         | 12 ++++++--
 fs/btrfs/locking.h         |  2 +-
 fs/btrfs/qgroup.c          |  4 ++-
 fs/btrfs/relocation.c      | 13 +++++++--
 fs/btrfs/tree-log.c        | 14 ++++++++--
 9 files changed, 114 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4bc326df472e..6e695f4cd931 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -161,10 +161,12 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root)
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
 {
 	struct extent_buffer *eb;
+	int ret;
 
 	while (1) {
 		eb = btrfs_root_node(root);
-		btrfs_tree_lock(eb);
+		ret = btrfs_tree_lock(eb);
+		BUG_ON(ret < 0);
 		if (eb == root->node)
 			break;
 		btrfs_tree_unlock(eb);
@@ -1584,6 +1586,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	for (i = start_slot; i <= end_slot; i++) {
 		struct btrfs_key first_key;
 		int close = 1;
+		int ret;
 
 		btrfs_node_key(parent, &disk_key, i);
 		if (!progress_passed && comp_keys(&disk_key, progress) < 0)
@@ -1637,7 +1640,11 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		if (search_start == 0)
 			search_start = last_block;
 
-		btrfs_tree_lock(cur);
+		ret = btrfs_tree_lock(cur);
+		if (ret < 0) {
+			free_extent_buffer(cur);
+			return ret;
+		}
 		btrfs_set_lock_blocking(cur);
 		err = __btrfs_cow_block(trans, root, cur, parent, i,
 					&cur, search_start,
@@ -1853,7 +1860,11 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			goto enospc;
 		}
 
-		btrfs_tree_lock(child);
+		ret = btrfs_tree_lock(child);
+		if (ret < 0) {
+			free_extent_buffer(child);
+			goto enospc;
+		}
 		btrfs_set_lock_blocking(child);
 		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
 		if (ret) {
@@ -1891,7 +1902,12 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		left = NULL;
 
 	if (left) {
-		btrfs_tree_lock(left);
+		ret = btrfs_tree_lock(left);
+		if (ret < 0) {
+			free_extent_buffer(left);
+			left = NULL;
+			goto enospc;
+		}
 		btrfs_set_lock_blocking(left);
 		wret = btrfs_cow_block(trans, root, left,
 				       parent, pslot - 1, &left);
@@ -1906,7 +1922,12 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		right = NULL;
 
 	if (right) {
-		btrfs_tree_lock(right);
+		ret = btrfs_tree_lock(right);
+		if (ret < 0) {
+			free_extent_buffer(right);
+			right = NULL;
+			goto enospc;
+		}
 		btrfs_set_lock_blocking(right);
 		wret = btrfs_cow_block(trans, root, right,
 				       parent, pslot + 1, &right);
@@ -2069,7 +2090,11 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	if (left) {
 		u32 left_nr;
 
-		btrfs_tree_lock(left);
+		ret = btrfs_tree_lock(left);
+		if (ret < 0) {
+			free_extent_buffer(left);
+			return ret;
+		}
 		btrfs_set_lock_blocking(left);
 
 		left_nr = btrfs_header_nritems(left);
@@ -2124,7 +2149,11 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	if (right) {
 		u32 right_nr;
 
-		btrfs_tree_lock(right);
+		ret = btrfs_tree_lock(right);
+		if (ret < 0) {
+			free_extent_buffer(right);
+			return ret;
+		}
 		btrfs_set_lock_blocking(right);
 
 		right_nr = btrfs_header_nritems(right);
@@ -2874,7 +2903,9 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 					err = btrfs_try_tree_write_lock(b);
 					if (!err) {
 						btrfs_set_path_blocking(p);
-						btrfs_tree_lock(b);
+						ret = btrfs_tree_lock(b);
+						if (ret < 0)
+							goto done;
 						btrfs_clear_path_blocking(p, b,
 								  BTRFS_WRITE_LOCK);
 					}
@@ -3773,7 +3804,9 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (IS_ERR(right))
 		return 1;
 
-	btrfs_tree_lock(right);
+	ret = btrfs_tree_lock(right);
+	if (ret < 0)
+		goto out_free;
 	btrfs_set_lock_blocking(right);
 
 	free_space = btrfs_leaf_free_space(fs_info, right);
@@ -3811,6 +3844,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 				right, free_space, left_nritems, min_slot);
 out_unlock:
 	btrfs_tree_unlock(right);
+out_free:
 	free_extent_buffer(right);
 	return 1;
 }
@@ -4007,7 +4041,9 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (IS_ERR(left))
 		return 1;
 
-	btrfs_tree_lock(left);
+	ret = btrfs_tree_lock(left);
+	if (ret < 0)
+		goto out_free;
 	btrfs_set_lock_blocking(left);
 
 	free_space = btrfs_leaf_free_space(fs_info, left);
@@ -4037,6 +4073,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 			       max_slot);
 out:
 	btrfs_tree_unlock(left);
+out_free:
 	free_extent_buffer(left);
 	return ret;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3578fa5b30ef..da615ebc072e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8297,14 +8297,19 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *buf;
+	int ret;
 
 	buf = btrfs_find_create_tree_block(fs_info, bytenr);
 	if (IS_ERR(buf))
 		return buf;
+	ret = btrfs_tree_lock(buf);
+	if (ret < 0) {
+		free_extent_buffer(buf);
+		return ERR_PTR(ret);
+	}
 
 	btrfs_set_header_generation(buf, trans->transid);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
-	btrfs_tree_lock(buf);
 	clean_tree_block(fs_info, buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
 
@@ -8721,7 +8726,9 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 					       level - 1);
 		reada = 1;
 	}
-	btrfs_tree_lock(next);
+	ret = btrfs_tree_lock(next);
+	if (ret < 0)
+		goto out_free;
 	btrfs_set_lock_blocking(next);
 
 	ret = btrfs_lookup_extent_info(trans, fs_info, bytenr, level - 1, 1,
@@ -8781,7 +8788,9 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 			free_extent_buffer(next);
 			return -EIO;
 		}
-		btrfs_tree_lock(next);
+		ret = btrfs_tree_lock(next);
+		if (ret < 0)
+			goto out_free;
 		btrfs_set_lock_blocking(next);
 	}
 
@@ -8839,6 +8848,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 
 out_unlock:
 	btrfs_tree_unlock(next);
+out_free:
 	free_extent_buffer(next);
 
 	return ret;
@@ -8887,7 +8897,8 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 		 */
 		if (!path->locks[level]) {
 			BUG_ON(level == 0);
-			btrfs_tree_lock(eb);
+			ret = btrfs_tree_lock(eb);
+			BUG_ON(ret < 0);
 			btrfs_set_lock_blocking(eb);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
@@ -8929,7 +8940,8 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 		/* make block locked assertion in clean_tree_block happy */
 		if (!path->locks[level] &&
 		    btrfs_header_generation(eb) == trans->transid) {
-			btrfs_tree_lock(eb);
+			ret = btrfs_tree_lock(eb);
+			BUG_ON(ret < 0);
 			btrfs_set_lock_blocking(eb);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 		}
@@ -9107,7 +9119,11 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 
 		level = btrfs_header_level(root->node);
 		while (1) {
-			btrfs_tree_lock(path->nodes[level]);
+			ret = btrfs_tree_lock(path->nodes[level]);
+			if (ret < 0) {
+				err = ret;
+				goto out_end_trans;
+			}
 			btrfs_set_lock_blocking(path->nodes[level]);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cce6087d6880..3ba02aac6dd5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3545,7 +3545,9 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 	if (!btrfs_try_tree_write_lock(eb)) {
 		flush = 1;
 		flush_write_bio(epd);
-		btrfs_tree_lock(eb);
+		ret = btrfs_tree_lock(eb);
+		if (ret < 0)
+			return ret;
 	}
 
 	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags)) {
@@ -3558,7 +3560,9 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		}
 		while (1) {
 			wait_on_extent_buffer_writeback(eb);
-			btrfs_tree_lock(eb);
+			ret = btrfs_tree_lock(eb);
+			if (ret < 0)
+				return ret;
 			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
 				break;
 			btrfs_tree_unlock(eb);
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index b5950aacd697..948bbc45638a 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1242,7 +1242,9 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 
 	list_del(&free_space_root->dirty_list);
 
-	btrfs_tree_lock(free_space_root->node);
+	ret = btrfs_tree_lock(free_space_root->node);
+	if (ret < 0)
+		goto abort;
 	clean_tree_block(fs_info, free_space_root->node);
 	btrfs_tree_unlock(free_space_root->node);
 	btrfs_free_tree_block(trans, free_space_root, free_space_root->node,
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 1da768e5ef75..aa4a3362a9f1 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -224,10 +224,18 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
 /*
  * take a spinning write lock.  This will wait for both
  * blocking readers or writers
+ *
+ * Return 0 if we successfully locked the tree block
+ * Return <0 if some selftest failed (mostly due to extent tree corruption)
  */
-void btrfs_tree_lock(struct extent_buffer *eb)
+int btrfs_tree_lock(struct extent_buffer *eb)
 {
-	WARN_ON(eb->lock_owner == current->pid);
+	if (unlikely(eb->lock_owner == current->pid)) {
+		WARN(1,
+"tree block %llu already locked by current (pid=%llu), refuse to lock",
+		     eb->start, current->pid);
+		return -EUCLEAN;
+	}
 again:
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
 	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 29135def468e..7394d7ba2ff9 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -11,7 +11,7 @@
 #define BTRFS_WRITE_LOCK_BLOCKING 3
 #define BTRFS_READ_LOCK_BLOCKING 4
 
-void btrfs_tree_lock(struct extent_buffer *eb);
+int btrfs_tree_lock(struct extent_buffer *eb);
 void btrfs_tree_unlock(struct extent_buffer *eb);
 
 void btrfs_tree_read_lock(struct extent_buffer *eb);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1874a6d2e6f5..ec4351fd7537 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1040,7 +1040,9 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 
 	list_del(&quota_root->dirty_list);
 
-	btrfs_tree_lock(quota_root->node);
+	ret = btrfs_tree_lock(quota_root->node);
+	if (ret < 0)
+		goto out;
 	clean_tree_block(fs_info, quota_root->node);
 	btrfs_tree_unlock(quota_root->node);
 	btrfs_free_tree_block(trans, quota_root, quota_root->node, 0, 1);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index be94c65bb4d2..a2fc0bd83a40 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1877,7 +1877,11 @@ int replace_path(struct btrfs_trans_handle *trans,
 				free_extent_buffer(eb);
 				break;
 			}
-			btrfs_tree_lock(eb);
+			ret = btrfs_tree_lock(eb);
+			if (ret < 0) {
+				free_extent_buffer(eb);
+				break;
+			}
 			if (cow) {
 				ret = btrfs_cow_block(trans, dest, eb, parent,
 						      slot, &eb);
@@ -2788,7 +2792,12 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 			err = -EIO;
 			goto next;
 		}
-		btrfs_tree_lock(eb);
+		ret = btrfs_tree_lock(eb);
+		if (ret < 0) {
+			free_extent_buffer(eb);
+			err = ret;
+			goto next;
+		}
 		btrfs_set_lock_blocking(eb);
 
 		if (!node->eb) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f8220ec02036..173bc15a7cd1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2588,7 +2588,11 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 				}
 
 				if (trans) {
-					btrfs_tree_lock(next);
+					ret = btrfs_tree_lock(next);
+					if (ret < 0) {
+						free_extent_buffer(next);
+						return ret;
+					}
 					btrfs_set_lock_blocking(next);
 					clean_tree_block(fs_info, next);
 					btrfs_wait_tree_block_writeback(next);
@@ -2672,7 +2676,9 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				next = path->nodes[*level];
 
 				if (trans) {
-					btrfs_tree_lock(next);
+					ret = btrfs_tree_lock(next);
+					if (ret < 0)
+						return ret;
 					btrfs_set_lock_blocking(next);
 					clean_tree_block(fs_info, next);
 					btrfs_wait_tree_block_writeback(next);
@@ -2754,7 +2760,9 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 			next = path->nodes[orig_level];
 
 			if (trans) {
-				btrfs_tree_lock(next);
+				ret = btrfs_tree_lock(next);
+				if (ret < 0)
+					goto out;
 				btrfs_set_lock_blocking(next);
 				clean_tree_block(fs_info, next);
 				btrfs_wait_tree_block_writeback(next);
-- 
2.18.0

