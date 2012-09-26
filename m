Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28444 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab2IZL10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 07:27:26 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8QBROfV025688
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 19:27:24 +0800
Message-ID: <5062E6A4.3060008@cn.fujitsu.com>
Date: Wed, 26 Sep 2012 19:27:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC][PATCH V2 1/4] Btrfs: restructure btrfs_search_slot()
References: <5062E563.7090105@cn.fujitsu.com>
In-Reply-To: <5062E563.7090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

we splited btrfs_search_slot(), and pick up some code that is used to search
the tree to make a new function, which can search the tree from any node that
we specified. We will use it in the next patch.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |  317 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 197 insertions(+), 120 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d183f6..3da5280 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2409,104 +2409,53 @@ done:
 	return ret;
 }
 
+static int check_nodes_need_balance(struct btrfs_root *root,
+				    struct btrfs_path *p,
+				    struct extent_buffer *b,
+				    int level, int ins_len)
+{
+	if ((p->search_for_split || ins_len > 0) && btrfs_header_nritems(b) >=
+	    BTRFS_NODEPTRS_PER_BLOCK(root) - 3)
+		return 1;
+
+	if (ins_len < 0 &&
+	    btrfs_header_nritems(b) < BTRFS_NODEPTRS_PER_BLOCK(root) / 2)
+		return 1;
+
+	return 0;
+}
+
 /*
- * look for key in the tree.  path is filled in with nodes along the way
- * if key is found, we return zero and you can find the item in the leaf
- * level of the path (level 0)
+ * look for key from the specified node/leaf in the tree.  path is filled in
+ * with nodes along the way if key is found, we return zero and you can find
+ * the item in the leaf level of the path (level 0).
  *
  * If the key isn't found, the path points to the slot where it should
- * be inserted, and 1 is returned.  If there are other errors during the
- * search a negative error number is returned.
+ * be inserted, and 1 is returned.
  *
- * if ins_len > 0, nodes and leaves will be split as we walk down the
- * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
- * possible)
+ * Note: If we don't search the tree from its root, though we also return 1
+ * when the key isn't found, this returned value - 1 - doesn't mean
+ * the expected item is not in the tree, just tell us the expected item is
+ * not in the current branch. So we must deal with this case in the caller
+ * carefully.
+ *
+ * If we need re-search the specified branch, -EAGAIN will returned. And
+ * if we don't search the tree from the root, we need restart the search
+ * from the root at some cases. At those cases, we will return -ERESTART.
+ * If there are other errors during the search the other negative error number
+ * is returned.
  */
-int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_path *p, int
-		      ins_len, int cow)
+static int __search_slot(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root, struct extent_buffer *b,
+			 struct btrfs_key *key, struct btrfs_path *p,
+			 int ins_len, int cow, int lowest_unlock,
+			 int *write_lock_level, int min_write_lock_level,
+			 u8 lowest_level, bool search_from_root)
 {
-	struct extent_buffer *b;
 	int slot;
+	int level;
 	int ret;
 	int err;
-	int level;
-	int lowest_unlock = 1;
-	int root_lock;
-	/* everything at write_lock_level or lower must be write locked */
-	int write_lock_level = 0;
-	u8 lowest_level = 0;
-	int min_write_lock_level;
-
-	lowest_level = p->lowest_level;
-	WARN_ON(lowest_level && ins_len > 0);
-	WARN_ON(p->nodes[0] != NULL);
-
-	if (ins_len < 0) {
-		lowest_unlock = 2;
-
-		/* when we are removing items, we might have to go up to level
-		 * two as we update tree pointers  Make sure we keep write
-		 * for those levels as well
-		 */
-		write_lock_level = 2;
-	} else if (ins_len > 0) {
-		/*
-		 * for inserting items, make sure we have a write lock on
-		 * level 1 so we can update keys
-		 */
-		write_lock_level = 1;
-	}
-
-	if (!cow)
-		write_lock_level = -1;
-
-	if (cow && (p->keep_locks || p->lowest_level))
-		write_lock_level = BTRFS_MAX_LEVEL;
-
-	min_write_lock_level = write_lock_level;
-
-again:
-	/*
-	 * we try very hard to do read locks on the root
-	 */
-	root_lock = BTRFS_READ_LOCK;
-	level = 0;
-	if (p->search_commit_root) {
-		/*
-		 * the commit roots are read only
-		 * so we always do read locks
-		 */
-		b = root->commit_root;
-		extent_buffer_get(b);
-		level = btrfs_header_level(b);
-		if (!p->skip_locking)
-			btrfs_tree_read_lock(b);
-	} else {
-		if (p->skip_locking) {
-			b = btrfs_root_node(root);
-			level = btrfs_header_level(b);
-		} else {
-			/* we don't know the level of the root node
-			 * until we actually have it read locked
-			 */
-			b = btrfs_read_lock_root_node(root);
-			level = btrfs_header_level(b);
-			if (level <= write_lock_level) {
-				/* whoops, must trade for write lock */
-				btrfs_tree_read_unlock(b);
-				free_extent_buffer(b);
-				b = btrfs_lock_root_node(root);
-				root_lock = BTRFS_WRITE_LOCK;
-
-				/* the level might have changed, check again */
-				level = btrfs_header_level(b);
-			}
-		}
-	}
-	p->nodes[level] = b;
-	if (!p->skip_locking)
-		p->locks[level] = root_lock;
 
 	while (b) {
 		level = btrfs_header_level(b);
@@ -2524,25 +2473,30 @@ again:
 			if (!should_cow_block(trans, root, b))
 				goto cow_done;
 
+			if (!search_from_root &&
+			    (level + 1 >= BTRFS_MAX_LEVEL ||
+			     !p->nodes[level + 1])) {
+				ret = -ERESTART;
+				goto done;
+			}
+
 			btrfs_set_path_blocking(p);
 
 			/*
 			 * must have write locks on this node and the
 			 * parent
 			 */
-			if (level + 1 > write_lock_level) {
-				write_lock_level = level + 1;
-				btrfs_release_path(p);
-				goto again;
+			if (level + 1 > *write_lock_level) {
+				*write_lock_level = level + 1;
+				ret = -EAGAIN;
+				goto done;
 			}
 
-			err = btrfs_cow_block(trans, root, b,
+			ret = btrfs_cow_block(trans, root, b,
 					      p->nodes[level + 1],
 					      p->slots[level + 1], &b);
-			if (err) {
-				ret = err;
+			if (ret)
 				goto done;
-			}
 		}
 cow_done:
 		BUG_ON(!cow && ins_len);
@@ -2573,13 +2527,23 @@ cow_done:
 				slot -= 1;
 			}
 			p->slots[level] = slot;
-			err = setup_nodes_for_search(trans, root, p, b, level,
-					     ins_len, &write_lock_level);
-			if (err == -EAGAIN)
-				goto again;
-			if (err) {
-				ret = err;
-				goto done;
+			if (!search_from_root &&
+			    (level + 1 >= BTRFS_MAX_LEVEL ||
+			     !p->nodes[level + 1])) {
+				err = check_nodes_need_balance(root, p, b,
+							       level, ins_len);
+				if (err) {
+					ret = -ERESTART;
+					goto done;
+				}
+			} else {
+				err = setup_nodes_for_search(trans, root, p, b,
+							     level, ins_len,
+							     write_lock_level);
+				if (err) {
+					ret = err;
+					goto done;
+				}
 			}
 			b = p->nodes[level];
 			slot = p->slots[level];
@@ -2591,14 +2555,14 @@ cow_done:
 			 * on the parent
 			 */
 			if (slot == 0 && cow &&
-			    write_lock_level < level + 1) {
-				write_lock_level = level + 1;
-				btrfs_release_path(p);
-				goto again;
+			    *write_lock_level < level + 1) {
+				*write_lock_level = level + 1;
+				ret = -EAGAIN;
+				goto done;
 			}
 
 			unlock_up(p, level, lowest_unlock,
-				  min_write_lock_level, &write_lock_level);
+				  min_write_lock_level, write_lock_level);
 
 			if (level == lowest_level) {
 				if (dec)
@@ -2608,8 +2572,6 @@ cow_done:
 
 			err = read_block_for_search(trans, root, p,
 						    &b, level, slot, key, 0);
-			if (err == -EAGAIN)
-				goto again;
 			if (err) {
 				ret = err;
 				goto done;
@@ -2617,13 +2579,13 @@ cow_done:
 
 			if (!p->skip_locking) {
 				level = btrfs_header_level(b);
-				if (level <= write_lock_level) {
+				if (level <= *write_lock_level) {
 					err = btrfs_try_tree_write_lock(b);
 					if (!err) {
 						btrfs_set_path_blocking(p);
 						btrfs_tree_lock(b);
 						btrfs_clear_path_blocking(p, b,
-								  BTRFS_WRITE_LOCK);
+							BTRFS_WRITE_LOCK);
 					}
 					p->locks[level] = BTRFS_WRITE_LOCK;
 				} else {
@@ -2632,7 +2594,7 @@ cow_done:
 						btrfs_set_path_blocking(p);
 						btrfs_tree_read_lock(b);
 						btrfs_clear_path_blocking(p, b,
-								  BTRFS_READ_LOCK);
+							BTRFS_READ_LOCK);
 					}
 					p->locks[level] = BTRFS_READ_LOCK;
 				}
@@ -2642,10 +2604,15 @@ cow_done:
 			p->slots[level] = slot;
 			if (ins_len > 0 &&
 			    btrfs_leaf_free_space(root, b) < ins_len) {
-				if (write_lock_level < 1) {
-					write_lock_level = 1;
-					btrfs_release_path(p);
-					goto again;
+				if (*write_lock_level < 1) {
+					*write_lock_level = 1;
+					ret = -EAGAIN;
+					goto done;
+				}
+
+				if (!search_from_root && !p->nodes[1]) {
+					ret = -ERESTART;
+					goto done;
 				}
 
 				btrfs_set_path_blocking(p);
@@ -2653,7 +2620,6 @@ cow_done:
 						 p, ins_len, ret == 0);
 				btrfs_clear_path_blocking(p, NULL, 0);
 
-				BUG_ON(err > 0);
 				if (err) {
 					ret = err;
 					goto done;
@@ -2661,7 +2627,8 @@ cow_done:
 			}
 			if (!p->search_for_split)
 				unlock_up(p, level, lowest_unlock,
-					  min_write_lock_level, &write_lock_level);
+					  min_write_lock_level,
+					  write_lock_level);
 			goto done;
 		}
 	}
@@ -2675,6 +2642,116 @@ done:
 		btrfs_set_path_blocking(p);
 	if (ret < 0)
 		btrfs_release_path(p);
+
+	return ret;
+}
+
+
+/*
+ * look for key in the tree.  path is filled in with nodes along the way
+ * if key is found, we return zero and you can find the item in the leaf
+ * level of the path (level 0)
+ *
+ * If the key isn't found, the path points to the slot where it should
+ * be inserted, and 1 is returned.  If there are other errors during the
+ * search a negative error number is returned.
+ *
+ * if ins_len > 0, nodes and leaves will be split as we walk down the
+ * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
+ * possible)
+ */
+int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
+		      *root, struct btrfs_key *key, struct btrfs_path *p, int
+		      ins_len, int cow)
+{
+	struct extent_buffer *b;
+	int ret;
+	int level;
+	int lowest_unlock = 1;
+	int root_lock;
+	/* everything at write_lock_level or lower must be write locked */
+	int write_lock_level = 0;
+	u8 lowest_level = 0;
+	int min_write_lock_level;
+
+	lowest_level = p->lowest_level;
+	WARN_ON(lowest_level && ins_len > 0);
+	WARN_ON(p->nodes[0] != NULL);
+
+	if (ins_len < 0) {
+		lowest_unlock = 2;
+
+		/* when we are removing items, we might have to go up to level
+		 * two as we update tree pointers  Make sure we keep write
+		 * for those levels as well
+		 */
+		write_lock_level = 2;
+	} else if (ins_len > 0) {
+		/*
+		 * for inserting items, make sure we have a write lock on
+		 * level 1 so we can update keys
+		 */
+		write_lock_level = 1;
+	}
+
+	if (!cow)
+		write_lock_level = -1;
+
+	if (cow && (p->keep_locks || p->lowest_level))
+		write_lock_level = BTRFS_MAX_LEVEL;
+
+	min_write_lock_level = write_lock_level;
+
+again:
+	/*
+	 * we try very hard to do read locks on the root
+	 */
+	root_lock = BTRFS_READ_LOCK;
+	level = 0;
+	if (p->search_commit_root) {
+		/*
+		 * the commit roots are read only
+		 * so we always do read locks
+		 */
+		b = root->commit_root;
+		extent_buffer_get(b);
+		level = btrfs_header_level(b);
+		if (!p->skip_locking)
+			btrfs_tree_read_lock(b);
+	} else {
+		if (p->skip_locking) {
+			b = btrfs_root_node(root);
+			level = btrfs_header_level(b);
+		} else {
+			/* we don't know the level of the root node
+			 * until we actually have it read locked
+			 */
+			b = btrfs_read_lock_root_node(root);
+			level = btrfs_header_level(b);
+			if (level <= write_lock_level) {
+				/* whoops, must trade for write lock */
+				btrfs_tree_read_unlock(b);
+				free_extent_buffer(b);
+				b = btrfs_lock_root_node(root);
+				root_lock = BTRFS_WRITE_LOCK;
+
+				/* the level might have changed, check again */
+				level = btrfs_header_level(b);
+			}
+		}
+	}
+	p->nodes[level] = b;
+	if (!p->skip_locking)
+		p->locks[level] = root_lock;
+
+	ret = __search_slot(trans, root, b, key, p, ins_len, cow,
+			    lowest_unlock, &write_lock_level,
+			    min_write_lock_level, lowest_level, true);
+	if (ret == -EAGAIN)
+		goto again;
+
+	BUG_ON(ret == -ERESTART);
+
 	return ret;
 }
 
-- 
1.7.10.2

