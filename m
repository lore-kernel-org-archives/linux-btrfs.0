Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15080 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759123Ab2FUJUO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 05:20:14 -0400
Message-ID: <4FE2E6F4.4070800@cn.fujitsu.com>
Date: Thu, 21 Jun 2012 17:18:44 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH V2] Btrfs: introduce extent buffer cache for each i-node
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce extent buffer cache for every i-node. By this
way, we can save the search time and reduce the lock contention of the root
because we needn't search the item from the root of b+ tree.

Implementation:
- add two pointers of extent buffer into btrfs_inode struct, one for
  nodes/leaves of fs/file tree, the other for nodes/leaves of the log tree.
- add a variant to tell us that it is still in the b+ tree.
- When we want to search fs/file trees or the relative log trees, we will
  try to search the cached extent buffer at first, if we can not find the
  item, we will do the common search. At some condition, we will jump to
  the common search directly:
  I. a new transaction starts.
  II. the cached extent buffer was cowed.
  III. the cached extent buffer's level is below the level we must lock.
  and so on.
  And beside that, if we can not find the item, and the slot points to the
  first the item or the last item in the leaf, we must jump out the cached
  extent buffer search, and do the common search.
- After the common search (use btrfs_search_slot), we will cache the leaf
  or the level-1 node into the btrfs i-node object.

I have done small file performance (inline file) by sysbench and file creation
test by fs_mark for the patch, and found it can make btrfs 5% ~ 16% faster.

I think as the tree becomes deeper, the performance improvement of this patch
will become bigger.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    3 +
 fs/btrfs/ctree.c       |  591 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/ctree.h       |   40 +++-
 fs/btrfs/dir-item.c    |   28 ++-
 fs/btrfs/extent_io.c   |    2 +-
 fs/btrfs/extent_io.h   |    1 +
 fs/btrfs/file-item.c   |   14 +-
 fs/btrfs/file.c        |    5 +-
 fs/btrfs/inode-item.c  |   11 +-
 fs/btrfs/inode.c       |   46 +++--
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/relocation.c  |    2 +-
 fs/btrfs/super.c       |    3 +-
 fs/btrfs/tree-log.c    |   19 +-
 fs/btrfs/xattr.c       |    2 +-
 15 files changed, 577 insertions(+), 192 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 12394a9..9912575 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -162,6 +162,9 @@ struct btrfs_inode {
 
 	struct btrfs_delayed_node *delayed_node;
 
+	struct extent_buffer *fs_eb;
+	struct extent_buffer *log_eb;
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 15cbc2b..4e8c12f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -989,6 +989,9 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
 	}
+
+	buf->root_objectid = 0;
+
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
 	free_extent_buffer_stale(buf);
@@ -1672,6 +1675,9 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		path->locks[level] = 0;
 		path->nodes[level] = NULL;
 		clean_tree_block(trans, root, mid);
+
+		mid->root_objectid = 0;
+
 		btrfs_tree_unlock(mid);
 		/* once for the path */
 		free_extent_buffer(mid);
@@ -1726,6 +1732,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
+			right->root_objectid = 0;
 			btrfs_tree_unlock(right);
 			del_ptr(trans, root, path, level + 1, pslot + 1, 1);
 			root_sub_used(root, right->len);
@@ -1770,6 +1777,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	}
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
+		mid->root_objectid = 0;
 		btrfs_tree_unlock(mid);
 		del_ptr(trans, root, path, level + 1, pslot, 1);
 		root_sub_used(root, mid->len);
@@ -2270,6 +2278,22 @@ read_block_for_search(struct btrfs_trans_handle *trans,
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
  * helper function for btrfs_search_slot.  This does all of the checks
  * for node-level blocks and does any balancing required based on
@@ -2348,103 +2372,36 @@ done:
 }
 
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
@@ -2462,25 +2419,30 @@ again:
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
@@ -2511,13 +2473,23 @@ cow_done:
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
@@ -2529,14 +2501,14 @@ cow_done:
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
@@ -2546,8 +2518,6 @@ cow_done:
 
 			err = read_block_for_search(trans, root, p,
 						    &b, level, slot, key, 0);
-			if (err == -EAGAIN)
-				goto again;
 			if (err) {
 				ret = err;
 				goto done;
@@ -2555,13 +2525,13 @@ cow_done:
 
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
@@ -2570,7 +2540,7 @@ cow_done:
 						btrfs_set_path_blocking(p);
 						btrfs_tree_read_lock(b);
 						btrfs_clear_path_blocking(p, b,
-								  BTRFS_READ_LOCK);
+							BTRFS_READ_LOCK);
 					}
 					p->locks[level] = BTRFS_READ_LOCK;
 				}
@@ -2580,10 +2550,15 @@ cow_done:
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
@@ -2591,7 +2566,6 @@ cow_done:
 						 p, ins_len, ret == 0);
 				btrfs_clear_path_blocking(p, NULL, 0);
 
-				BUG_ON(err > 0);
 				if (err) {
 					ret = err;
 					goto done;
@@ -2599,7 +2573,8 @@ cow_done:
 			}
 			if (!p->search_for_split)
 				unlock_up(p, level, lowest_unlock,
-					  min_write_lock_level, &write_lock_level);
+					  min_write_lock_level,
+					  write_lock_level);
 			goto done;
 		}
 	}
@@ -2613,6 +2588,332 @@ done:
 		btrfs_set_path_blocking(p);
 	if (ret < 0)
 		btrfs_release_path(p);
+
+	return ret;
+}
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
+	return ret;
+}
+
+static int check_search_result_valid(struct btrfs_path *p, int ins_len,
+				     int start_level, bool is_found)
+{
+	int i;
+
+	if (ins_len < 0 && p->slots[start_level] == 0) {
+		for (i = start_level - 1; i >= 0; i--) {
+			if (p->slots[i] != 0)
+				return 1;
+		}
+		return 0;
+	}
+
+	if (is_found)
+		return 1;
+
+	if (p->slots[start_level] == 0) {
+		for (i = start_level - 1; i >= 0; i--) {
+			if (p->slots[i] != 0)
+				return 1;
+		}
+		return 0;
+	}
+
+	while (start_level >= 0 && !p->locks[start_level])
+		start_level--;
+
+	if (start_level < 0)
+		return 0;
+
+	for (i = start_level; i >= 0; i--) {
+		if (i > 0 &&
+		    p->slots[i] < btrfs_header_nritems(p->nodes[i]) - 1)
+				return 1;
+		if (i == 0 &&
+		    p->slots[i] != btrfs_header_nritems(p->nodes[i]))
+				return 1;
+	}
+	return 0;
+}
+
+static int btrfs_search_cached_extent_buffer(struct btrfs_trans_handle *trans,
+					     struct btrfs_root *root,
+					     struct extent_buffer *cached_eb,
+					     struct btrfs_key *key,
+					     struct btrfs_path *p,
+					     int ins_len, int cow)
+{
+	int ret;
+	int level;
+	int lowest_unlock = 1;
+	int write_lock_level = 0;
+	int min_write_lock_level = 0;
+	int root_lock;
+	u8 lowest_level = 0;
+
+	if (cow && (p->keep_locks || p->lowest_level))
+		return -ERESTART;
+
+	BUG_ON(p->search_commit_root);
+	BUG_ON(!cached_eb);
+
+	lowest_level = p->lowest_level;
+	WARN_ON(lowest_level && ins_len > 0);
+	WARN_ON(p->nodes[0] != NULL);
+
+	if (ins_len < 0) {
+		lowest_unlock = 2;
+		write_lock_level = 1;
+	}
+
+	if (!cow)
+		write_lock_level = -1;
+
+	min_write_lock_level = write_lock_level;
+again:
+	level = btrfs_header_level(cached_eb);
+	if (level < write_lock_level || level < lowest_level)
+		return -ERESTART;
+
+	if (test_bit(EXTENT_BUFFER_STALE, &cached_eb->bflags))
+		return -ERESTART;
+
+	extent_buffer_get(cached_eb);
+
+	root_lock = 0;
+	if (!p->skip_locking) {
+		if (level <= write_lock_level) {
+			btrfs_tree_lock(cached_eb);
+			root_lock = BTRFS_WRITE_LOCK;
+		} else {
+			btrfs_tree_read_lock(cached_eb);
+			root_lock = BTRFS_READ_LOCK;
+		}
+	}
+
+	level = btrfs_header_level(cached_eb);
+	p->nodes[level] = cached_eb;
+	p->locks[level] = root_lock;
+
+	if (root->objectid == BTRFS_TREE_LOG_OBJECTID &&
+	    (btrfs_header_owner(cached_eb) != BTRFS_TREE_LOG_OBJECTID ||
+	     cached_eb->root_objectid != root->root_key.offset ||
+	     btrfs_header_generation(cached_eb) != trans->transid)) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	} else if (root->objectid != cached_eb->root_objectid ||
+		   btrfs_header_owner(cached_eb) != root->objectid ||
+		   (cow &&
+		    btrfs_header_generation(cached_eb) != trans->transid)) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	} else if (level < write_lock_level || level < lowest_level) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	} else if (test_bit(EXTENT_BUFFER_STALE, &cached_eb->bflags)) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	}
+
+	ret = __search_slot(trans, root, cached_eb, key, p, ins_len, cow,
+			    lowest_unlock, &write_lock_level,
+			    min_write_lock_level, lowest_level, false);
+	if (ret == -EAGAIN)
+		goto again;
+
+	if (ret >= 0) {
+		if (!check_search_result_valid(p, ins_len, level, !ret)) {
+			ret = -ERESTART;
+			btrfs_release_path(p);
+		}
+	}
+
+	return ret;
+}
+
+int btrfs_search_slot_cache(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct extent_buffer *cached_eb,
+				struct btrfs_key *key, struct btrfs_path *p,
+				int ins_len, int cow)
+{
+	int ret;
+
+	if (cached_eb) {
+		ret = btrfs_search_cached_extent_buffer(trans, root,
+							cached_eb,
+							key, p,	ins_len, cow);
+		if (ret >= 0)
+			return ret;
+
+		if (ret != -ERESTART)
+			return ret;
+	}
+
+	ret = btrfs_search_slot(trans, root, key, p, ins_len, cow);
+
+	return ret;
+}
+
+int btrfs_search_slot_for_inode(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct inode *inode,
+				struct btrfs_key *key, struct btrfs_path *p,
+				int ins_len, int cow)
+{
+	struct extent_buffer *eb;
+	int cache_level = 0;
+	int ret;
+
+	if (!p->search_commit_root) {
+		spin_lock(&inode->i_lock);
+		if (unlikely(root->objectid == BTRFS_TREE_LOG_OBJECTID))
+			eb = BTRFS_I(inode)->log_eb;
+		else
+			eb = BTRFS_I(inode)->fs_eb;
+
+		if (eb)
+			extent_buffer_get(eb);
+		spin_unlock(&inode->i_lock);
+	} else {
+		eb = NULL;
+	}
+
+	ret = btrfs_search_slot_cache(trans, root, eb, key, p, ins_len, cow);
+	free_extent_buffer(eb);
+	if (ret >= 0 && !p->search_commit_root) {
+		if (ins_len < 0 && p->nodes[1] && p->locks[1])
+			cache_level = 1;
+
+		spin_lock(&inode->i_lock);
+		if (unlikely(root->objectid == BTRFS_TREE_LOG_OBJECTID))
+			eb = BTRFS_I(inode)->log_eb;
+		else
+			eb = BTRFS_I(inode)->fs_eb;
+
+		if (eb == p->nodes[cache_level]) {
+			spin_unlock(&inode->i_lock);
+			goto out;
+		}
+
+		if (unlikely(root->objectid == BTRFS_TREE_LOG_OBJECTID)) {
+			BTRFS_I(inode)->log_eb = p->nodes[cache_level];
+			p->nodes[cache_level]->root_objectid =
+							root->root_key.offset;
+		} else {
+			BTRFS_I(inode)->fs_eb = p->nodes[cache_level];
+			p->nodes[cache_level]->root_objectid = root->objectid;
+		}
+		spin_unlock(&inode->i_lock);
+		free_extent_buffer(eb);
+		extent_buffer_get(p->nodes[cache_level]);
+	}
+out:
 	return ret;
 }
 
@@ -4501,15 +4802,12 @@ void setup_items_for_insert(struct btrfs_trans_handle *trans,
 	}
 }
 
-/*
- * Given a key and some data, insert items into the tree.
- * This does all the path init required, making room in the tree if needed.
- */
-int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    struct btrfs_path *path,
-			    struct btrfs_key *cpu_key, u32 *data_size,
-			    int nr)
+static int __btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct inode *inode,
+				      struct btrfs_path *path,
+				      struct btrfs_key *cpu_key, u32 *data_size,
+				      int nr)
 {
 	int ret = 0;
 	int slot;
@@ -4521,7 +4819,12 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 		total_data += data_size[i];
 
 	total_size = total_data + (nr * sizeof(struct btrfs_item));
-	ret = btrfs_search_slot(trans, root, cpu_key, path, total_size, 1);
+	if (inode)
+		ret = btrfs_search_slot_for_inode(trans, root, inode, cpu_key,
+						  path, total_size, 1);
+	else
+		ret = btrfs_search_slot(trans, root, cpu_key, path, total_size,
+					1);
 	if (ret == 0)
 		return -EEXIST;
 	if (ret < 0)
@@ -4536,6 +4839,32 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 }
 
 /*
+ * Given a key and some data, insert items into the tree.
+ * This does all the path init required, making room in the tree if needed.
+ */
+int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root,
+			     struct btrfs_path *path,
+			     struct btrfs_key *cpu_key, u32 *data_size,
+			     int nr)
+{
+	return __btrfs_insert_empty_items(trans, root, NULL, path, cpu_key,
+					  data_size, nr);
+}
+
+int btrfs_insert_empty_items_for_inode(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct inode *inode,
+				       struct btrfs_path *path,
+				       struct btrfs_key *cpu_key,
+				       u32 *data_size,
+				       int nr)
+{
+	return __btrfs_insert_empty_items(trans, root, inode, path, cpu_key,
+					  data_size, nr);
+}
+
+/*
  * Given a key and some data, insert an item into the tree.
  * This does all the path init required, making room in the tree if needed.
  */
@@ -4625,6 +4954,8 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
 	del_ptr(trans, root, path, 1, path->slots[1], 1);
 
+	leaf->root_objectid = 0;
+
 	/*
 	 * btrfs_free_extent is expensive, we want to make sure we
 	 * aren't holding any locks when we call it
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index db15e9e..716f1e1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2709,6 +2709,11 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow);
+int btrfs_search_slot_for_inode(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct inode *inode,
+				struct btrfs_key *key, struct btrfs_path *p,
+				int ins_len, int cow);
 int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 			  struct btrfs_path *p, u64 time_seq);
 int btrfs_realloc_node(struct btrfs_trans_handle *trans,
@@ -2752,6 +2757,25 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 	return btrfs_insert_empty_items(trans, root, path, key, &data_size, 1);
 }
 
+int btrfs_insert_empty_items_for_inode(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct inode *inode,
+				       struct btrfs_path *path,
+				       struct btrfs_key *cpu_key,
+				       u32 *data_size,
+				       int nr);
+static inline int btrfs_insert_empty_item_for_inode(
+					struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					struct inode *inode,
+					struct btrfs_path *path,
+					struct btrfs_key *key,
+					u32 data_size)
+{
+	return btrfs_insert_empty_items_for_inode(trans, root, inode, path,
+						  key, &data_size, 1);
+}
+
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 			u64 time_seq);
@@ -2829,7 +2853,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_key *location, u8 type, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
-					     struct btrfs_path *path, u64 dir,
+					     struct inode *dir,
+					     struct btrfs_path *path, u64 dirid,
 					     const char *name, int name_len,
 					     int mod);
 struct btrfs_dir_item *
@@ -2851,7 +2876,8 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 			      struct btrfs_dir_item *di);
 int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
-			    struct btrfs_path *path, u64 objectid,
+			    struct inode *inode,
+			    struct btrfs_path *path,
 			    const char *name, u16 name_len,
 			    const void *data, u16 data_len);
 struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
@@ -2876,9 +2902,9 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   const char *name, int name_len,
 			   u64 inode_objectid, u64 ref_objectid, u64 index);
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 *index);
+			struct btrfs_root *root,
+			const char *name, int name_len,
+			struct inode *inode, u64 ref_objectid, u64 *index);
 struct btrfs_inode_ref *
 btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
@@ -2901,13 +2927,13 @@ int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
 			      struct bio *bio, u64 logical_offset, u32 *dst);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     u64 objectid, u64 pos,
+			     struct inode *inode, u64 pos,
 			     u64 disk_offset, u64 disk_num_bytes,
 			     u64 num_bytes, u64 offset, u64 ram_bytes,
 			     u8 compression, u8 encryption, u16 other_encoding);
 int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     struct btrfs_path *path, u64 objectid,
+			     struct btrfs_path *path, struct inode *inode,
 			     u64 bytenr, int mod);
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c1a074d..6a396e6 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -32,6 +32,7 @@
 static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 						   *trans,
 						   struct btrfs_root *root,
+						   struct inode *inode,
 						   struct btrfs_path *path,
 						   struct btrfs_key *cpu_key,
 						   u32 data_size,
@@ -43,7 +44,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 	struct btrfs_item *item;
 	struct extent_buffer *leaf;
 
-	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
+	ret = btrfs_insert_empty_item_for_inode(trans, root, inode, path,
+						cpu_key, data_size);
 	if (ret == -EEXIST) {
 		struct btrfs_dir_item *di;
 		di = btrfs_match_dir_item_name(root, path, name, name_len);
@@ -67,7 +69,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
  */
 int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
-			    struct btrfs_path *path, u64 objectid,
+			    struct inode *inode,
+			    struct btrfs_path *path,
 			    const char *name, u16 name_len,
 			    const void *data, u16 data_len)
 {
@@ -81,13 +84,13 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 
 	BUG_ON(name_len + data_len > BTRFS_MAX_XATTR_SIZE(root));
 
-	key.objectid = objectid;
+	key.objectid = btrfs_ino(inode);
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
 	key.offset = btrfs_name_hash(name, name_len);
 
 	data_size = sizeof(*dir_item) + name_len + data_len;
-	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
-					name, name_len);
+	dir_item = insert_with_overflow(trans, root, inode, path, &key,
+					data_size, name, name_len);
 	if (IS_ERR(dir_item))
 		return PTR_ERR(dir_item);
 	memset(&location, 0, sizeof(location));
@@ -144,7 +147,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_cpu_key_to_disk(&disk_key, location);
 
 	data_size = sizeof(*dir_item) + name_len;
-	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
+	dir_item = insert_with_overflow(trans, root, dir, path, &key, data_size,
 					name, name_len);
 	if (IS_ERR(dir_item)) {
 		ret = PTR_ERR(dir_item);
@@ -184,13 +187,14 @@ out_free:
 }
 
 /*
- * lookup a directory item based on name.  'dir' is the objectid
+ * lookup a directory item based on name.  'dirid' is the objectid
  * we're searching in, and 'mod' tells us if you plan on deleting the
  * item (use mod < 0) or changing the options (use mod > 0)
  */
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
-					     struct btrfs_path *path, u64 dir,
+					     struct inode *dir,
+					     struct btrfs_path *path, u64 dirid,
 					     const char *name, int name_len,
 					     int mod)
 {
@@ -199,12 +203,16 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	int ins_len = mod < 0 ? -1 : 0;
 	int cow = mod != 0;
 
-	key.objectid = dir;
+	key.objectid = dirid;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 
 	key.offset = btrfs_name_hash(name, name_len);
 
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
+	if (dir)
+		ret = btrfs_search_slot_for_inode(trans, root, dir, &key, path,
+						  ins_len, cow);
+	else
+		ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
 		return ERR_PTR(ret);
 	if (ret > 0)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index aaa12c1..9172836 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3753,7 +3753,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	 * because there might be preallocation past i_size
 	 */
 	ret = btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root,
-				       path, btrfs_ino(inode), -1, 0);
+				       path, inode, -1, 0);
 	if (ret < 0) {
 		btrfs_free_path(path);
 		return ret;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 25900af..3803812 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -129,6 +129,7 @@ struct extent_buffer {
 	unsigned long map_start;
 	unsigned long map_len;
 	unsigned long bflags;
+	u64 root_objectid;
 	struct extent_io_tree *tree;
 	spinlock_t refs_lock;
 	atomic_t refs;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 5d158d3..bc90d80 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -38,7 +38,7 @@
 
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     u64 objectid, u64 pos,
+			     struct inode *inode, u64 pos,
 			     u64 disk_offset, u64 disk_num_bytes,
 			     u64 num_bytes, u64 offset, u64 ram_bytes,
 			     u8 compression, u8 encryption, u16 other_encoding)
@@ -48,6 +48,7 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_key file_key;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
+	u64 objectid = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -57,8 +58,8 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
 
 	path->leave_spinning = 1;
-	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
-				      sizeof(*item));
+	ret = btrfs_insert_empty_item_for_inode(trans, root, inode, path,
+						&file_key, sizeof(*item));
 	if (ret < 0)
 		goto out;
 	BUG_ON(ret); /* Can't happen */
@@ -135,7 +136,7 @@ fail:
 
 int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     struct btrfs_path *path, u64 objectid,
+			     struct btrfs_path *path, struct inode *inode,
 			     u64 offset, int mod)
 {
 	int ret;
@@ -143,10 +144,11 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 	int ins_len = mod < 0 ? -1 : 0;
 	int cow = mod != 0;
 
-	file_key.objectid = objectid;
+	file_key.objectid = btrfs_ino(inode);
 	file_key.offset = offset;
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
-	ret = btrfs_search_slot(trans, root, &file_key, path, ins_len, cow);
+	ret = btrfs_search_slot_for_inode(trans, root, inode, &file_key, path,
+					  ins_len, cow);
 	return ret;
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fc0f485..c98a3cb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -611,7 +611,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 
 	while (1) {
 		recow = 0;
-		ret = btrfs_lookup_file_extent(trans, root, path, ino,
+		ret = btrfs_lookup_file_extent(trans, root, path, inode,
 					       search_start, modify_tree);
 		if (ret < 0)
 			break;
@@ -905,7 +905,8 @@ again:
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = split;
 
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	ret = btrfs_search_slot_for_inode(trans, root, inode, &key, path,
+					  -1, 1);
 	if (ret < 0)
 		goto out;
 	if (ret > 0 && path->slots[0] > 0)
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index a13cf1a..db07467 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -78,9 +78,9 @@ btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 *index)
+			struct btrfs_root *root,
+			const char *name, int name_len,
+			struct inode *inode, u64 ref_objectid, u64 *index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -93,7 +93,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	int ret;
 	int del_len = name_len + sizeof(*ref);
 
-	key.objectid = inode_objectid;
+	key.objectid = btrfs_ino(inode);
 	key.offset = ref_objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
 
@@ -103,7 +103,8 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 
 	path->leave_spinning = 1;
 
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	ret = btrfs_search_slot_for_inode(trans, root, inode, &key,
+					  path, -1, 1);
 	if (ret > 0) {
 		ret = -ENOENT;
 		goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6de67a5..3e7394f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -148,8 +148,8 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	datasize = btrfs_file_extent_calc_inline_size(cur_size);
 
 	inode_add_bytes(inode, size);
-	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      datasize);
+	ret = btrfs_insert_empty_item_for_inode(trans, root, inode, path, &key,
+						datasize);
 	if (ret) {
 		err = ret;
 		goto fail;
@@ -1179,7 +1179,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	cow_start = (u64)-1;
 	cur_offset = start;
 	while (1) {
-		ret = btrfs_lookup_file_extent(trans, root, path, ino,
+		ret = btrfs_lookup_file_extent(trans, root, path, inode,
 					       cur_offset, 0);
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, root, ret);
@@ -1812,7 +1812,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = btrfs_ino(inode);
 	ins.offset = file_pos;
 	ins.type = BTRFS_EXTENT_DATA_KEY;
-	ret = btrfs_insert_empty_item(trans, root, path, &ins, sizeof(*fi));
+	ret = btrfs_insert_empty_item_for_inode(trans, root, inode, path,
+						&ins, sizeof(*fi));
 	if (ret)
 		goto out;
 	leaf = path->nodes[0];
@@ -2780,8 +2781,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 
 	path->leave_spinning = 1;
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				    name, name_len, -1);
+	di = btrfs_lookup_dir_item(trans, root, dir, path, dir_ino,
+				   name, name_len, -1);
 	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
 		goto err;
@@ -2797,7 +2798,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	btrfs_release_path(path);
 
-	ret = btrfs_del_inode_ref(trans, root, name, name_len, ino,
+	ret = btrfs_del_inode_ref(trans, root, name, name_len, inode,
 				  dir_ino, &index);
 	if (ret) {
 		printk(KERN_INFO "btrfs failed to delete reference to %.*s, "
@@ -2973,7 +2974,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 
 	if (ret == 0 && S_ISREG(inode->i_mode)) {
 		ret = btrfs_lookup_file_extent(trans, root, path,
-					       ino, (u64)-1, 0);
+					       inode, (u64)-1, 0);
 		if (ret < 0) {
 			err = ret;
 			goto out;
@@ -2989,8 +2990,8 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				dentry->d_name.name, dentry->d_name.len, 0);
+	di = btrfs_lookup_dir_item(trans, root, dir, path, dir_ino,
+				   dentry->d_name.name, dentry->d_name.len, 0);
 	if (IS_ERR(di)) {
 		err = PTR_ERR(di);
 		goto out;
@@ -3116,7 +3117,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
+	di = btrfs_lookup_dir_item(trans, root, dir, path, dir_ino,
 				   name, name_len, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		if (!di)
@@ -3281,7 +3282,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 search_again:
 	path->leave_spinning = 1;
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	ret = btrfs_search_slot_for_inode(trans, root, inode, &key,
+					  path, -1, 1);
 	if (ret < 0) {
 		err = ret;
 		goto out;
@@ -3296,6 +3298,7 @@ search_again:
 		path->slots[0]--;
 	}
 
+	leaf = path->nodes[0];
 	while (1) {
 		fi = NULL;
 		leaf = path->nodes[0];
@@ -3628,7 +3631,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			}
 
 			err = btrfs_insert_file_extent(trans, root,
-					btrfs_ino(inode), cur_offset, 0,
+					inode, cur_offset, 0,
 					0, hole_size, 0, hole_size,
 					0, 0, 0);
 			if (err) {
@@ -3862,8 +3865,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	if (!path)
 		return -ENOMEM;
 
-	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
-				    namelen, 0);
+	di = btrfs_lookup_dir_item(NULL, root, dir, path, btrfs_ino(dir), name,
+				   namelen, 0);
 	if (IS_ERR(di))
 		ret = PTR_ERR(di);
 
@@ -4327,7 +4330,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	key.offset = filp->f_pos;
 	key.objectid = btrfs_ino(inode);
 
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	ret = btrfs_search_slot_for_inode(NULL, root, inode, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
 
@@ -4834,7 +4837,7 @@ fail_dir_item:
 		int err;
 
 		err = btrfs_del_inode_ref(trans, root, name, name_len,
-					  ino, parent_ino, &local_index);
+					  inode, parent_ino, &local_index);
 	}
 	return ret;
 }
@@ -5247,7 +5250,7 @@ again:
 	}
 
 	ret = btrfs_lookup_file_extent(trans, root, path,
-				       objectid, start, trans != NULL);
+				       inode, start, trans != NULL);
 	if (ret < 0) {
 		err = ret;
 		goto out;
@@ -5716,7 +5719,7 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
+	ret = btrfs_lookup_file_extent(trans, root, path, inode,
 				       offset, 0);
 	if (ret < 0)
 		goto out;
@@ -6957,6 +6960,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
 
+	ei->fs_eb = NULL;
+	ei->log_eb = NULL;
+
 	return inode;
 }
 
@@ -7022,6 +7028,8 @@ void btrfs_destroy_inode(struct inode *inode)
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
 	btrfs_remove_delayed_node(inode);
+	free_extent_buffer(BTRFS_I(inode)->fs_eb);
+	free_extent_buffer(BTRFS_I(inode)->log_eb);
 	call_rcu(&inode->i_rcu, btrfs_i_callback);
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e92e57..1718afb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2786,7 +2786,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	}
 
 	dir_id = btrfs_super_root_dir(root->fs_info->super_copy);
-	di = btrfs_lookup_dir_item(trans, root->fs_info->tree_root, path,
+	di = btrfs_lookup_dir_item(trans, root->fs_info->tree_root, NULL, path,
 				   dir_id, "default", 7, 1);
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 646ee21..d149998 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1506,7 +1506,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 		return -ENOMEM;
 
 	bytenr -= BTRFS_I(reloc_inode)->index_cnt;
-	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(reloc_inode),
+	ret = btrfs_lookup_file_extent(NULL, root, path, reloc_inode,
 				       bytenr, 0);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0eb9a4d..382df88 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -698,7 +698,8 @@ static struct dentry *get_default_root(struct super_block *sb,
 	 * to mount.
 	 */
 	dir_id = btrfs_super_root_dir(fs_info->super_copy);
-	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "default", 7, 0);
+	di = btrfs_lookup_dir_item(NULL, root, NULL, path, dir_id, "default",
+				   7, 0);
 	if (IS_ERR(di)) {
 		btrfs_free_path(path);
 		return ERR_CAST(di);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2017d0f..04dec02 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -517,7 +517,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	 * file.  This must be done before the btrfs_drop_extents run
 	 * so we don't try to drop this extent.
 	 */
-	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
+	ret = btrfs_lookup_file_extent(trans, root, path, inode,
 				       start, 0);
 
 	if (ret == 0 &&
@@ -717,7 +717,8 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 		goto out;
 	btrfs_release_path(path);
 
-	di = btrfs_lookup_dir_item(NULL, root, path, dirid, name, name_len, 0);
+	di = btrfs_lookup_dir_item(NULL, root, NULL, path, dirid, name,
+				   name_len, 0);
 	if (di && !IS_ERR(di)) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
 		if (location.objectid != objectid)
@@ -920,7 +921,7 @@ again:
 	btrfs_release_path(path);
 
 	/* look for a conflicing name */
-	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
+	di = btrfs_lookup_dir_item(trans, root, dir, path, btrfs_ino(dir),
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
@@ -1227,8 +1228,9 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	if (key->type == BTRFS_DIR_ITEM_KEY) {
-		dst_di = btrfs_lookup_dir_item(trans, root, path, key->objectid,
-				       name, name_len, 1);
+		dst_di = btrfs_lookup_dir_item(trans, root, NULL, path,
+					       key->objectid, name,
+					       name_len, 1);
 	} else if (key->type == BTRFS_DIR_INDEX_KEY) {
 		dst_di = btrfs_lookup_dir_index_item(trans, root, path,
 						     key->objectid,
@@ -1448,7 +1450,8 @@ again:
 				  name_len);
 		log_di = NULL;
 		if (log && dir_key->type == BTRFS_DIR_ITEM_KEY) {
-			log_di = btrfs_lookup_dir_item(trans, log, log_path,
+			log_di = btrfs_lookup_dir_item(trans, log, dir,
+						       log_path,
 						       dir_key->objectid,
 						       name, name_len, 0);
 		} else if (log && dir_key->type == BTRFS_DIR_INDEX_KEY) {
@@ -2288,7 +2291,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 		goto out_unlock;
 	}
 
-	di = btrfs_lookup_dir_item(trans, log, path, dir_ino,
+	di = btrfs_lookup_dir_item(trans, log, dir, path, dir_ino,
 				   name, name_len, -1);
 	if (IS_ERR(di)) {
 		err = PTR_ERR(di);
@@ -2379,7 +2382,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 	log = root->log_root;
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
-	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(inode),
+	ret = btrfs_del_inode_ref(trans, log, name, name_len, inode,
 				  dirid, &index);
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 	if (ret == -ENOSPC) {
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 3f4e2d6..1dbbe91 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -125,7 +125,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	}
 
 again:
-	ret = btrfs_insert_xattr_item(trans, root, path, btrfs_ino(inode),
+	ret = btrfs_insert_xattr_item(trans, root, inode, path,
 				      name, name_len, value, size);
 	/*
 	 * If we're setting an xattr to a new value but the new value is say
-- 
1.7.6.5
