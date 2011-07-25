From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] another reader/writer lock for btrfs metadata
Date: Mon, 25 Jul 2011 14:34:49 -0400
Message-ID: <1311618006-sup-1777@shiny>
Content-Type: text/plain; charset=UTF-8
Cc: "Tejun Heo" <tj@kernel.org>
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've updated the integration-test branch to use this code instead.  It
is a shiny new reader/writer lock built around rw spinlocks.  I've
removed all the adaptive spinning and started trusting the hints btrfs
already has about when blocks should block or spin.

Most of the time, we're able to use only read locks on the higher levels
of the btree, and most of the time we're able to use these locks
spinning.  This gives us a healthy boost in performance in pretty much
all workloads.  dbench is one minor exception where we are about 5%
slower on my box.

For Ric's empty file creation test, we go from an average of 99,000
files/sec up to 133,000 files/sec for the first 57 million files.  The
old code keeps slowing down as more files are added.  The new code keeps
going at 130K or so until we're 99% full.

Pure readonly tests are even better.  My parallel stat test was 3x
faster.

Patch below.  This is pushed out to a rebased integration-test branch.
Make sure the kernel.org mirror has finished updating before you pull.

Tejun, I'm sure this isn't what you had in mind.  But if you still have
access to the box you were benchmarking w/mutexes I'd be curious to hear
the results.

-chris

>From 1e8cf07853ce1169cb8ebfe8893074d144e2a356 Mon Sep 17 00:00:00 2001
From: Chris Mason <chris.mason@oracle.com>
Date: Sat, 16 Jul 2011 15:23:14 -0400
Subject: [PATCH 1/2] Btrfs: switch the btrfs tree locks to reader/writer

The btrfs metadata btree is the source of significant
lock contention, especially in the root node.   This
commit changes our locking to use a reader/writer
lock.

The lock is built on top of rw spinlocks, and it
extends the lock tracking to remember if we have a
read lock or a write lock when we go to blocking.  Atomics
count the number of blocking readers or writers at any
given time.

It removes all of the adaptive spinning from the old code
and uses only the spinning/blocking hints inside of btrfs
to decide when it should continue spinning.

In read heavy workloads this is dramatically faster.  In write
heavy workloads we're still faster because of less contention
on the root node lock.

We suffer slightly in dbench because we schedule more often
during write locks, but all other benchmarks so far are improved.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/ctree.c         |  261 +++++++++++++++++++++++++++++++++----------
 fs/btrfs/ctree.h         |    2 +-
 fs/btrfs/delayed-inode.c |    2 +-
 fs/btrfs/extent-tree.c   |   20 ++--
 fs/btrfs/extent_io.c     |   11 ++-
 fs/btrfs/extent_io.h     |   24 +++-
 fs/btrfs/locking.c       |  280 ++++++++++++++++++++++++----------------------
 fs/btrfs/locking.h       |   36 ++++++-
 fs/btrfs/tree-log.c      |    6 +-
 9 files changed, 425 insertions(+), 217 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d243128..5fc86a4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -54,8 +54,13 @@ noinline void btrfs_set_path_blocking(struct btrfs_path *p)
 {
 	int i;
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
-		if (p->nodes[i] && p->locks[i])
-			btrfs_set_lock_blocking(p->nodes[i]);
+		if (!p->nodes[i] || !p->locks[i])
+			continue;
+		btrfs_set_lock_blocking_rw(p->nodes[i], p->locks[i]);
+		if (p->locks[i] == BTRFS_READ_LOCK)
+			p->locks[i] = BTRFS_READ_LOCK_BLOCKING;
+		else if (p->locks[i] == BTRFS_WRITE_LOCK)
+			p->locks[i] = BTRFS_WRITE_LOCK_BLOCKING;
 	}
 }
 
@@ -68,7 +73,7 @@ noinline void btrfs_set_path_blocking(struct btrfs_path *p)
  * for held
  */
 noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
-					struct extent_buffer *held)
+					struct extent_buffer *held, int held_rw)
 {
 	int i;
 
@@ -80,18 +85,23 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 	 * the path blocking.
 	 */
 	if (held)
-		btrfs_set_lock_blocking(held);
+		btrfs_set_lock_blocking_rw(held, held_rw);
 	btrfs_set_path_blocking(p);
 #endif
 
 	for (i = BTRFS_MAX_LEVEL - 1; i >= 0; i--) {
-		if (p->nodes[i] && p->locks[i])
-			btrfs_clear_lock_blocking(p->nodes[i]);
+		if (p->nodes[i] && p->locks[i]) {
+			btrfs_clear_lock_blocking_rw(p->nodes[i], p->locks[i]);
+			if (p->locks[i] == BTRFS_WRITE_LOCK_BLOCKING)
+				p->locks[i] = BTRFS_WRITE_LOCK;
+			else if (p->locks[i] == BTRFS_READ_LOCK_BLOCKING)
+				p->locks[i] = BTRFS_READ_LOCK;
+		}
 	}
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (held)
-		btrfs_clear_lock_blocking(held);
+		btrfs_clear_lock_blocking_rw(held, held_rw);
 #endif
 }
 
@@ -119,7 +129,7 @@ noinline void btrfs_release_path(struct btrfs_path *p)
 		if (!p->nodes[i])
 			continue;
 		if (p->locks[i]) {
-			btrfs_tree_unlock(p->nodes[i]);
+			btrfs_tree_unlock_rw(p->nodes[i], p->locks[i]);
 			p->locks[i] = 0;
 		}
 		free_extent_buffer(p->nodes[i]);
@@ -167,6 +177,25 @@ struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
 	return eb;
 }
 
+/* loop around taking references on and locking the root node of the
+ * tree until you end up with a lock on the root.  A locked buffer
+ * is returned, with a reference held.
+ */
+struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
+{
+	struct extent_buffer *eb;
+
+	while (1) {
+		eb = btrfs_root_node(root);
+		btrfs_tree_read_lock(eb);
+		if (eb == root->node)
+			break;
+		btrfs_tree_read_unlock(eb);
+		free_extent_buffer(eb);
+	}
+	return eb;
+}
+
 /* cowonly root (everything not a reference counted cow subvolume), just get
  * put onto a simple dirty list.  transaction.c walks this to make sure they
  * get properly updated on disk.
@@ -862,7 +891,8 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 	mid = path->nodes[level];
 
-	WARN_ON(!path->locks[level]);
+	WARN_ON(path->locks[level] != BTRFS_WRITE_LOCK &&
+		path->locks[level] != BTRFS_WRITE_LOCK_BLOCKING);
 	WARN_ON(btrfs_header_generation(mid) != trans->transid);
 
 	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
@@ -1360,7 +1390,7 @@ static noinline void unlock_up(struct btrfs_path *path, int level,
 
 		t = path->nodes[i];
 		if (i >= lowest_unlock && i > skip_level && path->locks[i]) {
-			btrfs_tree_unlock(t);
+			btrfs_tree_unlock_rw(t, path->locks[i]);
 			path->locks[i] = 0;
 		}
 	}
@@ -1387,7 +1417,7 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
 			continue;
 		if (!path->locks[i])
 			continue;
-		btrfs_tree_unlock(path->nodes[i]);
+		btrfs_tree_unlock_rw(path->nodes[i], path->locks[i]);
 		path->locks[i] = 0;
 	}
 }
@@ -1436,6 +1466,8 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 			 * we can trust our generation number
 			 */
 			free_extent_buffer(tmp);
+			btrfs_set_path_blocking(p);
+
 			tmp = read_tree_block(root, blocknr, blocksize, gen);
 			if (tmp && btrfs_buffer_uptodate(tmp, gen)) {
 				*eb_ret = tmp;
@@ -1491,20 +1523,27 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 static int
 setup_nodes_for_search(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_path *p,
-		       struct extent_buffer *b, int level, int ins_len)
+		       struct extent_buffer *b, int level, int ins_len,
+		       int *write_lock_level)
 {
 	int ret;
 	if ((p->search_for_split || ins_len > 0) && btrfs_header_nritems(b) >=
 	    BTRFS_NODEPTRS_PER_BLOCK(root) - 3) {
 		int sret;
 
+		if (*write_lock_level < level + 1) {
+			*write_lock_level = level + 1;
+			btrfs_release_path(p);
+			goto again;
+		}
+
 		sret = reada_for_balance(root, p, level);
 		if (sret)
 			goto again;
 
 		btrfs_set_path_blocking(p);
 		sret = split_node(trans, root, p, level);
-		btrfs_clear_path_blocking(p, NULL);
+		btrfs_clear_path_blocking(p, NULL, 0);
 
 		BUG_ON(sret > 0);
 		if (sret) {
@@ -1516,13 +1555,19 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 		   BTRFS_NODEPTRS_PER_BLOCK(root) / 2) {
 		int sret;
 
+		if (*write_lock_level < level + 1) {
+			*write_lock_level = level + 1;
+			btrfs_release_path(p);
+			goto again;
+		}
+
 		sret = reada_for_balance(root, p, level);
 		if (sret)
 			goto again;
 
 		btrfs_set_path_blocking(p);
 		sret = balance_level(trans, root, p, level);
-		btrfs_clear_path_blocking(p, NULL);
+		btrfs_clear_path_blocking(p, NULL, 0);
 
 		if (sret) {
 			ret = sret;
@@ -1566,27 +1611,78 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	int err;
 	int level;
 	int lowest_unlock = 1;
+	int root_lock;
+	/* everything at write_lock_level or lower must be write locked */
+	int write_lock_level = 0;
 	u8 lowest_level = 0;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
 	WARN_ON(p->nodes[0] != NULL);
 
-	if (ins_len < 0)
+	if (ins_len < 0) {
 		lowest_unlock = 2;
 
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
 again:
+	/*
+	 * we try very hard to do read locks on the root
+	 */
+	root_lock = BTRFS_READ_LOCK;
+	level = 0;
 	if (p->search_commit_root) {
+		/*
+		 * the commit roots are read only
+		 * so we always do read locks
+		 */
 		b = root->commit_root;
 		extent_buffer_get(b);
+		level = btrfs_header_level(b);
 		if (!p->skip_locking)
-			btrfs_tree_lock(b);
+			btrfs_tree_read_lock(b);
 	} else {
-		if (p->skip_locking)
+		if (p->skip_locking) {
 			b = btrfs_root_node(root);
-		else
-			b = btrfs_lock_root_node(root);
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
 	}
+	p->nodes[level] = b;
+	if (!p->skip_locking)
+		p->locks[level] = root_lock;
 
 	while (b) {
 		level = btrfs_header_level(b);
@@ -1595,10 +1691,6 @@ again:
 		 * setup the path here so we can release it under lock
 		 * contention with the cow code
 		 */
-		p->nodes[level] = b;
-		if (!p->skip_locking)
-			p->locks[level] = 1;
-
 		if (cow) {
 			/*
 			 * if we don't really need to cow this block
@@ -1610,6 +1702,16 @@ again:
 
 			btrfs_set_path_blocking(p);
 
+			/*
+			 * must have write locks on this node and the
+			 * parent
+			 */
+			if (level + 1 > write_lock_level) {
+				write_lock_level = level + 1;
+				btrfs_release_path(p);
+				goto again;
+			}
+
 			err = btrfs_cow_block(trans, root, b,
 					      p->nodes[level + 1],
 					      p->slots[level + 1], &b);
@@ -1622,10 +1724,7 @@ cow_done:
 		BUG_ON(!cow && ins_len);
 
 		p->nodes[level] = b;
-		if (!p->skip_locking)
-			p->locks[level] = 1;
-
-		btrfs_clear_path_blocking(p, NULL);
+		btrfs_clear_path_blocking(p, NULL, 0);
 
 		/*
 		 * we have a lock on b and as long as we aren't changing
@@ -1651,7 +1750,7 @@ cow_done:
 			}
 			p->slots[level] = slot;
 			err = setup_nodes_for_search(trans, root, p, b, level,
-						     ins_len);
+					     ins_len, &write_lock_level);
 			if (err == -EAGAIN)
 				goto again;
 			if (err) {
@@ -1661,6 +1760,19 @@ cow_done:
 			b = p->nodes[level];
 			slot = p->slots[level];
 
+			/*
+			 * slot 0 is special, if we change the key
+			 * we have to update the parent pointer
+			 * which means we must have a write lock
+			 * on the parent
+			 */
+			if (slot == 0 && cow &&
+			    write_lock_level < level + 1) {
+				write_lock_level = level + 1;
+				btrfs_release_path(p);
+				goto again;
+			}
+
 			unlock_up(p, level, lowest_unlock);
 
 			if (level == lowest_level) {
@@ -1679,23 +1791,42 @@ cow_done:
 			}
 
 			if (!p->skip_locking) {
-				btrfs_clear_path_blocking(p, NULL);
-				err = btrfs_try_spin_lock(b);
-
-				if (!err) {
-					btrfs_set_path_blocking(p);
-					btrfs_tree_lock(b);
-					btrfs_clear_path_blocking(p, b);
+				level = btrfs_header_level(b);
+				if (level <= write_lock_level) {
+					err = btrfs_try_tree_write_lock(b);
+					if (!err) {
+						btrfs_set_path_blocking(p);
+						btrfs_tree_lock(b);
+						btrfs_clear_path_blocking(p, b,
+								  BTRFS_WRITE_LOCK);
+					}
+					p->locks[level] = BTRFS_WRITE_LOCK;
+				} else {
+					err = btrfs_try_tree_read_lock(b);
+					if (!err) {
+						btrfs_set_path_blocking(p);
+						btrfs_tree_read_lock(b);
+						btrfs_clear_path_blocking(p, b,
+								  BTRFS_READ_LOCK);
+					}
+					p->locks[level] = BTRFS_READ_LOCK;
 				}
+				p->nodes[level] = b;
 			}
 		} else {
 			p->slots[level] = slot;
 			if (ins_len > 0 &&
 			    btrfs_leaf_free_space(root, b) < ins_len) {
+				if (write_lock_level < 1) {
+					write_lock_level = 1;
+					btrfs_release_path(p);
+					goto again;
+				}
+
 				btrfs_set_path_blocking(p);
 				err = split_leaf(trans, root, key,
 						 p, ins_len, ret == 0);
-				btrfs_clear_path_blocking(p, NULL);
+				btrfs_clear_path_blocking(p, NULL, 0);
 
 				BUG_ON(err > 0);
 				if (err) {
@@ -1976,7 +2107,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	add_root_to_dirty_list(root);
 	extent_buffer_get(c);
 	path->nodes[level] = c;
-	path->locks[level] = 1;
+	path->locks[level] = BTRFS_WRITE_LOCK;
 	path->slots[level] = 0;
 	return 0;
 }
@@ -3819,11 +3950,11 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 
 	WARN_ON(!path->keep_locks);
 again:
-	cur = btrfs_lock_root_node(root);
+	cur = btrfs_read_lock_root_node(root);
 	level = btrfs_header_level(cur);
 	WARN_ON(path->nodes[level]);
 	path->nodes[level] = cur;
-	path->locks[level] = 1;
+	path->locks[level] = BTRFS_READ_LOCK;
 
 	if (btrfs_header_generation(cur) < min_trans) {
 		ret = 1;
@@ -3913,12 +4044,12 @@ find_next_key:
 		cur = read_node_slot(root, cur, slot);
 		BUG_ON(!cur);
 
-		btrfs_tree_lock(cur);
+		btrfs_tree_read_lock(cur);
 
-		path->locks[level - 1] = 1;
+		path->locks[level - 1] = BTRFS_READ_LOCK;
 		path->nodes[level - 1] = cur;
 		unlock_up(path, level, 1);
-		btrfs_clear_path_blocking(path, NULL);
+		btrfs_clear_path_blocking(path, NULL, 0);
 	}
 out:
 	if (ret == 0)
@@ -4034,6 +4165,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 	int ret;
 	int old_spinning = path->leave_spinning;
 	int force_blocking = 0;
+	int next_rw_lock = 0;
 
 	nritems = btrfs_header_nritems(path->nodes[0]);
 	if (nritems == 0)
@@ -4051,6 +4183,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 again:
 	level = 1;
 	next = NULL;
+	next_rw_lock = 0;
 	btrfs_release_path(path);
 
 	path->keep_locks = 1;
@@ -4096,11 +4229,12 @@ again:
 		}
 
 		if (next) {
-			btrfs_tree_unlock(next);
+			btrfs_tree_unlock_rw(next, next_rw_lock);
 			free_extent_buffer(next);
 		}
 
 		next = c;
+		next_rw_lock = path->locks[level];
 		ret = read_block_for_search(NULL, root, path, &next, level,
 					    slot, &key);
 		if (ret == -EAGAIN)
@@ -4112,15 +4246,22 @@ again:
 		}
 
 		if (!path->skip_locking) {
-			ret = btrfs_try_spin_lock(next);
+			ret = btrfs_try_tree_read_lock(next);
 			if (!ret) {
 				btrfs_set_path_blocking(path);
-				btrfs_tree_lock(next);
-				if (!force_blocking)
-					btrfs_clear_path_blocking(path, next);
+				btrfs_tree_read_lock(next);
+				if (!force_blocking) {
+					btrfs_clear_path_blocking(path, next,
+							  BTRFS_READ_LOCK);
+				}
+			}
+			if (force_blocking) {
+				btrfs_set_lock_blocking_rw(next,
+							   BTRFS_READ_LOCK);
+				next_rw_lock = BTRFS_READ_LOCK_BLOCKING;
+			} else {
+				next_rw_lock = BTRFS_READ_LOCK;
 			}
-			if (force_blocking)
-				btrfs_set_lock_blocking(next);
 		}
 		break;
 	}
@@ -4129,14 +4270,13 @@ again:
 		level--;
 		c = path->nodes[level];
 		if (path->locks[level])
-			btrfs_tree_unlock(c);
+			btrfs_tree_unlock_rw(c, path->locks[level]);
 
 		free_extent_buffer(c);
 		path->nodes[level] = next;
 		path->slots[level] = 0;
 		if (!path->skip_locking)
-			path->locks[level] = 1;
-
+			path->locks[level] = next_rw_lock;
 		if (!level)
 			break;
 
@@ -4151,16 +4291,21 @@ again:
 		}
 
 		if (!path->skip_locking) {
-			btrfs_assert_tree_locked(path->nodes[level]);
-			ret = btrfs_try_spin_lock(next);
+			ret = btrfs_try_tree_read_lock(next);
 			if (!ret) {
 				btrfs_set_path_blocking(path);
-				btrfs_tree_lock(next);
+				btrfs_tree_read_lock(next);
 				if (!force_blocking)
-					btrfs_clear_path_blocking(path, next);
+					btrfs_clear_path_blocking(path, next,
+							  BTRFS_READ_LOCK);
+			}
+			if (force_blocking) {
+				btrfs_set_lock_blocking_rw(next,
+						   BTRFS_READ_LOCK);
+				next_rw_lock = BTRFS_READ_LOCK_BLOCKING;
+			} else {
+				next_rw_lock = BTRFS_READ_LOCK;
 			}
-			if (force_blocking)
-				btrfs_set_lock_blocking(next);
 		}
 	}
 	ret = 0;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3063f21..40235e1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2333,7 +2333,7 @@ struct btrfs_path *btrfs_alloc_path(void);
 void btrfs_free_path(struct btrfs_path *p);
 void btrfs_set_path_blocking(struct btrfs_path *p);
 void btrfs_clear_path_blocking(struct btrfs_path *p,
-			       struct extent_buffer *held);
+			       struct extent_buffer *held, int held_rw);
 void btrfs_unlock_up_safe(struct btrfs_path *p, int level);
 
 int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 98c68e6..b52c672 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -735,7 +735,7 @@ static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
 	}
 
 	/* reset all the locked nodes in the patch to spinning locks. */
-	btrfs_clear_path_blocking(path, NULL);
+	btrfs_clear_path_blocking(path, NULL, 0);
 
 	/* insert the keys of the items */
 	ret = setup_items_for_insert(trans, root, path, keys, data_size,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f06e375..98dff7d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5919,7 +5919,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 			return 1;
 
 		if (path->locks[level] && !wc->keep_locks) {
-			btrfs_tree_unlock(eb);
+			btrfs_tree_unlock_rw(eb, path->locks[level]);
 			path->locks[level] = 0;
 		}
 		return 0;
@@ -5943,7 +5943,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 	 * keep the tree lock
 	 */
 	if (path->locks[level] && level > 0) {
-		btrfs_tree_unlock(eb);
+		btrfs_tree_unlock_rw(eb, path->locks[level]);
 		path->locks[level] = 0;
 	}
 	return 0;
@@ -6056,7 +6056,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	BUG_ON(level != btrfs_header_level(next));
 	path->nodes[level] = next;
 	path->slots[level] = 0;
-	path->locks[level] = 1;
+	path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 	wc->level = level;
 	if (wc->level == 1)
 		wc->reada_slot = 0;
@@ -6127,7 +6127,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			BUG_ON(level == 0);
 			btrfs_tree_lock(eb);
 			btrfs_set_lock_blocking(eb);
-			path->locks[level] = 1;
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						       eb->start, eb->len,
@@ -6136,8 +6136,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 			BUG_ON(wc->refs[level] == 0);
 			if (wc->refs[level] == 1) {
-				btrfs_tree_unlock(eb);
-				path->locks[level] = 0;
+				btrfs_tree_unlock_rw(eb, path->locks[level]);
 				return 1;
 			}
 		}
@@ -6159,7 +6158,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 		    btrfs_header_generation(eb) == trans->transid) {
 			btrfs_tree_lock(eb);
 			btrfs_set_lock_blocking(eb);
-			path->locks[level] = 1;
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 		}
 		clean_tree_block(trans, root, eb);
 	}
@@ -6238,7 +6237,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
 				return 0;
 
 			if (path->locks[level]) {
-				btrfs_tree_unlock(path->nodes[level]);
+				btrfs_tree_unlock_rw(path->nodes[level],
+						     path->locks[level]);
 				path->locks[level] = 0;
 			}
 			free_extent_buffer(path->nodes[level]);
@@ -6290,7 +6290,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		path->nodes[level] = btrfs_lock_root_node(root);
 		btrfs_set_lock_blocking(path->nodes[level]);
 		path->slots[level] = 0;
-		path->locks[level] = 1;
+		path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 		memset(&wc->update_progress, 0,
 		       sizeof(wc->update_progress));
 	} else {
@@ -6458,7 +6458,7 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 	level = btrfs_header_level(node);
 	path->nodes[level] = node;
 	path->slots[level] = 0;
-	path->locks[level] = 1;
+	path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 	wc->refs[parent_level] = 1;
 	wc->flags[parent_level] = BTRFS_BLOCK_FLAG_FULL_BACKREF;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 76ecbb8..5392c3b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3017,8 +3017,15 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 		return NULL;
 	eb->start = start;
 	eb->len = len;
-	spin_lock_init(&eb->lock);
-	init_waitqueue_head(&eb->lock_wq);
+	rwlock_init(&eb->lock);
+	atomic_set(&eb->write_locks, 0);
+	atomic_set(&eb->read_locks, 0);
+	atomic_set(&eb->blocking_readers, 0);
+	atomic_set(&eb->blocking_writers, 0);
+	atomic_set(&eb->spinning_readers, 0);
+	atomic_set(&eb->spinning_writers, 0);
+	init_waitqueue_head(&eb->write_lock_wq);
+	init_waitqueue_head(&eb->read_lock_wq);
 
 #if LEAK_DEBUG
 	spin_lock_irqsave(&leak_lock, flags);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b5f120c..21a7ca9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -128,14 +128,26 @@ struct extent_buffer {
 	struct rcu_head rcu_head;
 	atomic_t refs;
 
-	/* the spinlock is used to protect most operations */
-	spinlock_t lock;
+	/* count of read lock holders on the extent buffer */
+	atomic_t write_locks;
+	atomic_t read_locks;
+	atomic_t blocking_writers;
+	atomic_t blocking_readers;
+	atomic_t spinning_readers;
+	atomic_t spinning_writers;
+
+	/* protects write locks */
+	rwlock_t lock;
+
+	/* readers use lock_wq while they wait for the write
+	 * lock holders to unlock
+	 */
+	wait_queue_head_t write_lock_wq;
 
-	/*
-	 * when we keep the lock held while blocking, waiters go onto
-	 * the wq
+	/* writers use read_lock_wq while they wait for readers
+	 * to unlock
 	 */
-	wait_queue_head_t lock_wq;
+	wait_queue_head_t read_lock_wq;
 };
 
 static inline void extent_set_compress_type(unsigned long *bio_flags,
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 66fa43d..d77b67c 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -24,185 +24,197 @@
 #include "extent_io.h"
 #include "locking.h"
 
-static inline void spin_nested(struct extent_buffer *eb)
-{
-	spin_lock(&eb->lock);
-}
+void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
 
 /*
- * Setting a lock to blocking will drop the spinlock and set the
- * flag that forces other procs who want the lock to wait.  After
- * this you can safely schedule with the lock held.
+ * if we currently have a spinning reader or writer lock
+ * (indicated by the rw flag) this will bump the count
+ * of blocking holders and drop the spinlock.
  */
-void btrfs_set_lock_blocking(struct extent_buffer *eb)
+void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
 {
-	if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags)) {
-		set_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags);
-		spin_unlock(&eb->lock);
+	if (rw == BTRFS_WRITE_LOCK) {
+		if (atomic_read(&eb->blocking_writers) == 0) {
+			WARN_ON(atomic_read(&eb->spinning_writers) != 1);
+			atomic_dec(&eb->spinning_writers);
+			btrfs_assert_tree_locked(eb);
+			atomic_inc(&eb->blocking_writers);
+			write_unlock(&eb->lock);
+		}
+	} else if (rw == BTRFS_READ_LOCK) {
+		btrfs_assert_tree_read_locked(eb);
+		atomic_inc(&eb->blocking_readers);
+		WARN_ON(atomic_read(&eb->spinning_readers) == 0);
+		atomic_dec(&eb->spinning_readers);
+		read_unlock(&eb->lock);
 	}
-	/* exit with the spin lock released and the bit set */
+	return;
 }
 
 /*
- * clearing the blocking flag will take the spinlock again.
- * After this you can't safely schedule
+ * if we currently have a blocking lock, take the spinlock
+ * and drop our blocking count
  */
-void btrfs_clear_lock_blocking(struct extent_buffer *eb)
+void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 {
-	if (test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags)) {
-		spin_nested(eb);
-		clear_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags);
-		smp_mb__after_clear_bit();
+	if (rw == BTRFS_WRITE_LOCK_BLOCKING) {
+		BUG_ON(atomic_read(&eb->blocking_writers) != 1);
+		write_lock(&eb->lock);
+		WARN_ON(atomic_read(&eb->spinning_writers));
+		atomic_inc(&eb->spinning_writers);
+		if (atomic_dec_and_test(&eb->blocking_writers))
+			wake_up(&eb->write_lock_wq);
+	} else if (rw == BTRFS_READ_LOCK_BLOCKING) {
+		BUG_ON(atomic_read(&eb->blocking_readers) == 0);
+		read_lock(&eb->lock);
+		atomic_inc(&eb->spinning_readers);
+		if (atomic_dec_and_test(&eb->blocking_readers))
+			wake_up(&eb->read_lock_wq);
 	}
-	/* exit with the spin lock held */
+	return;
 }
 
 /*
- * unfortunately, many of the places that currently set a lock to blocking
- * don't end up blocking for very long, and often they don't block
- * at all.  For a dbench 50 run, if we don't spin on the blocking bit
- * at all, the context switch rate can jump up to 400,000/sec or more.
- *
- * So, we're still stuck with this crummy spin on the blocking bit,
- * at least until the most common causes of the short blocks
- * can be dealt with.
+ * take a spinning read lock.  This will wait for any blocking
+ * writers
  */
-static int btrfs_spin_on_block(struct extent_buffer *eb)
+void btrfs_tree_read_lock(struct extent_buffer *eb)
 {
-	int i;
-
-	for (i = 0; i < 512; i++) {
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 1;
-		if (need_resched())
-			break;
-		cpu_relax();
+again:
+	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
+	read_lock(&eb->lock);
+	if (atomic_read(&eb->blocking_writers)) {
+		read_unlock(&eb->lock);
+		wait_event(eb->write_lock_wq,
+			   atomic_read(&eb->blocking_writers) == 0);
+		goto again;
 	}
-	return 0;
+	atomic_inc(&eb->read_locks);
+	atomic_inc(&eb->spinning_readers);
 }
 
 /*
- * This is somewhat different from trylock.  It will take the
- * spinlock but if it finds the lock is set to blocking, it will
- * return without the lock held.
- *
- * returns 1 if it was able to take the lock and zero otherwise
- *
- * After this call, scheduling is not safe without first calling
- * btrfs_set_lock_blocking()
+ * returns 1 if we get the read lock and 0 if we don't
+ * this won't wait for blocking writers
  */
-int btrfs_try_spin_lock(struct extent_buffer *eb)
+int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 {
-	int i;
+	if (atomic_read(&eb->blocking_writers))
+		return 0;
 
-	if (btrfs_spin_on_block(eb)) {
-		spin_nested(eb);
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 1;
-		spin_unlock(&eb->lock);
+	read_lock(&eb->lock);
+	if (atomic_read(&eb->blocking_writers)) {
+		read_unlock(&eb->lock);
+		return 0;
 	}
-	/* spin for a bit on the BLOCKING flag */
-	for (i = 0; i < 2; i++) {
-		cpu_relax();
-		if (!btrfs_spin_on_block(eb))
-			break;
-
-		spin_nested(eb);
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 1;
-		spin_unlock(&eb->lock);
-	}
-	return 0;
+	atomic_inc(&eb->read_locks);
+	atomic_inc(&eb->spinning_readers);
+	return 1;
 }
 
 /*
- * the autoremove wake function will return 0 if it tried to wake up
- * a process that was already awake, which means that process won't
- * count as an exclusive wakeup.  The waitq code will continue waking
- * procs until it finds one that was actually sleeping.
- *
- * For btrfs, this isn't quite what we want.  We want a single proc
- * to be notified that the lock is ready for taking.  If that proc
- * already happen to be awake, great, it will loop around and try for
- * the lock.
- *
- * So, btrfs_wake_function always returns 1, even when the proc that we
- * tried to wake up was already awake.
+ * returns 1 if we get the read lock and 0 if we don't
+ * this won't wait for blocking writers or readers
  */
-static int btrfs_wake_function(wait_queue_t *wait, unsigned mode,
-			       int sync, void *key)
+int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 {
-	autoremove_wake_function(wait, mode, sync, key);
+	if (atomic_read(&eb->blocking_writers) ||
+	    atomic_read(&eb->blocking_readers))
+		return 0;
+	write_lock(&eb->lock);
+	if (atomic_read(&eb->blocking_writers) ||
+	    atomic_read(&eb->blocking_readers)) {
+		write_unlock(&eb->lock);
+		return 0;
+	}
+	atomic_inc(&eb->write_locks);
+	atomic_inc(&eb->spinning_writers);
 	return 1;
 }
 
 /*
- * returns with the extent buffer spinlocked.
- *
- * This will spin and/or wait as required to take the lock, and then
- * return with the spinlock held.
- *
- * After this call, scheduling is not safe without first calling
- * btrfs_set_lock_blocking()
+ * drop a spinning read lock
+ */
+void btrfs_tree_read_unlock(struct extent_buffer *eb)
+{
+	btrfs_assert_tree_read_locked(eb);
+	WARN_ON(atomic_read(&eb->spinning_readers) == 0);
+	atomic_dec(&eb->spinning_readers);
+	atomic_dec(&eb->read_locks);
+	read_unlock(&eb->lock);
+}
+
+/*
+ * drop a blocking read lock
+ */
+void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
+{
+	btrfs_assert_tree_read_locked(eb);
+	WARN_ON(atomic_read(&eb->blocking_readers) == 0);
+	if (atomic_dec_and_test(&eb->blocking_readers))
+		wake_up(&eb->read_lock_wq);
+	atomic_dec(&eb->read_locks);
+}
+
+/*
+ * take a spinning write lock.  This will wait for both
+ * blocking readers or writers
  */
 int btrfs_tree_lock(struct extent_buffer *eb)
 {
-	DEFINE_WAIT(wait);
-	wait.func = btrfs_wake_function;
-
-	if (!btrfs_spin_on_block(eb))
-		goto sleep;
-
-	while(1) {
-		spin_nested(eb);
-
-		/* nobody is blocking, exit with the spinlock held */
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 0;
-
-		/*
-		 * we have the spinlock, but the real owner is blocking.
-		 * wait for them
-		 */
-		spin_unlock(&eb->lock);
-
-		/*
-		 * spin for a bit, and if the blocking flag goes away,
-		 * loop around
-		 */
-		cpu_relax();
-		if (btrfs_spin_on_block(eb))
-			continue;
-sleep:
-		prepare_to_wait_exclusive(&eb->lock_wq, &wait,
-					  TASK_UNINTERRUPTIBLE);
-
-		if (test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			schedule();
-
-		finish_wait(&eb->lock_wq, &wait);
+again:
+	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
+	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
+	write_lock(&eb->lock);
+	if (atomic_read(&eb->blocking_readers)) {
+		write_unlock(&eb->lock);
+		wait_event(eb->read_lock_wq,
+			   atomic_read(&eb->blocking_readers) == 0);
+		goto again;
 	}
+	if (atomic_read(&eb->blocking_writers)) {
+		write_unlock(&eb->lock);
+		wait_event(eb->write_lock_wq,
+			   atomic_read(&eb->blocking_writers) == 0);
+		goto again;
+	}
+	WARN_ON(atomic_read(&eb->spinning_writers));
+	atomic_inc(&eb->spinning_writers);
+	atomic_inc(&eb->write_locks);
 	return 0;
 }
 
+/*
+ * drop a spinning or a blocking write lock.
+ */
 int btrfs_tree_unlock(struct extent_buffer *eb)
 {
-	/*
-	 * if we were a blocking owner, we don't have the spinlock held
-	 * just clear the bit and look for waiters
-	 */
-	if (test_and_clear_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-		smp_mb__after_clear_bit();
-	else
-		spin_unlock(&eb->lock);
-
-	if (waitqueue_active(&eb->lock_wq))
-		wake_up(&eb->lock_wq);
+	int blockers = atomic_read(&eb->blocking_writers);
+
+	BUG_ON(blockers > 1);
+
+	btrfs_assert_tree_locked(eb);
+	atomic_dec(&eb->write_locks);
+
+	if (blockers) {
+		WARN_ON(atomic_read(&eb->spinning_writers));
+		atomic_dec(&eb->blocking_writers);
+		smp_wmb();
+		wake_up(&eb->write_lock_wq);
+	} else {
+		WARN_ON(atomic_read(&eb->spinning_writers) != 1);
+		atomic_dec(&eb->spinning_writers);
+		write_unlock(&eb->lock);
+	}
 	return 0;
 }
 
 void btrfs_assert_tree_locked(struct extent_buffer *eb)
 {
-	if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-		assert_spin_locked(&eb->lock);
+	BUG_ON(!atomic_read(&eb->write_locks));
+}
+
+void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
+{
+	BUG_ON(!atomic_read(&eb->read_locks));
 }
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 5c33a56..17247dd 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -19,11 +19,43 @@
 #ifndef __BTRFS_LOCKING_
 #define __BTRFS_LOCKING_
 
+#define BTRFS_WRITE_LOCK 1
+#define BTRFS_READ_LOCK 2
+#define BTRFS_WRITE_LOCK_BLOCKING 3
+#define BTRFS_READ_LOCK_BLOCKING 4
+
 int btrfs_tree_lock(struct extent_buffer *eb);
 int btrfs_tree_unlock(struct extent_buffer *eb);
 int btrfs_try_spin_lock(struct extent_buffer *eb);
 
-void btrfs_set_lock_blocking(struct extent_buffer *eb);
-void btrfs_clear_lock_blocking(struct extent_buffer *eb);
+void btrfs_tree_read_lock(struct extent_buffer *eb);
+void btrfs_tree_read_unlock(struct extent_buffer *eb);
+void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb);
+void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw);
+void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw);
 void btrfs_assert_tree_locked(struct extent_buffer *eb);
+int btrfs_try_tree_read_lock(struct extent_buffer *eb);
+int btrfs_try_tree_write_lock(struct extent_buffer *eb);
+
+static inline void btrfs_tree_unlock_rw(struct extent_buffer *eb, int rw)
+{
+	if (rw == BTRFS_WRITE_LOCK || rw == BTRFS_WRITE_LOCK_BLOCKING)
+		btrfs_tree_unlock(eb);
+	else if (rw == BTRFS_READ_LOCK_BLOCKING)
+		btrfs_tree_read_unlock_blocking(eb);
+	else if (rw == BTRFS_READ_LOCK)
+		btrfs_tree_read_unlock(eb);
+	else
+		BUG();
+}
+
+static inline void btrfs_set_lock_blocking(struct extent_buffer *eb)
+{
+	btrfs_set_lock_blocking_rw(eb, BTRFS_WRITE_LOCK);
+}
+
+static inline void btrfs_clear_lock_blocking(struct extent_buffer *eb)
+{
+	btrfs_clear_lock_blocking_rw(eb, BTRFS_WRITE_LOCK_BLOCKING);
+}
 #endif
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4ce8a9f..ac278dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1730,8 +1730,8 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 				btrfs_read_buffer(next, ptr_gen);
 
 				btrfs_tree_lock(next);
-				clean_tree_block(trans, root, next);
 				btrfs_set_lock_blocking(next);
+				clean_tree_block(trans, root, next);
 				btrfs_wait_tree_block_writeback(next);
 				btrfs_tree_unlock(next);
 
@@ -1796,8 +1796,8 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				next = path->nodes[*level];
 
 				btrfs_tree_lock(next);
-				clean_tree_block(trans, root, next);
 				btrfs_set_lock_blocking(next);
+				clean_tree_block(trans, root, next);
 				btrfs_wait_tree_block_writeback(next);
 				btrfs_tree_unlock(next);
 
@@ -1864,8 +1864,8 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 			next = path->nodes[orig_level];
 
 			btrfs_tree_lock(next);
-			clean_tree_block(trans, log, next);
 			btrfs_set_lock_blocking(next);
+			clean_tree_block(trans, log, next);
 			btrfs_wait_tree_block_writeback(next);
 			btrfs_tree_unlock(next);
 
-- 
1.7.4.1
