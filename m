From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 2/2] Btrfs: switch to reader/writer locks for metadata
Date: Tue, 19 Jul 2011 13:33:45 -0400
Message-ID: <1311096777-sup-5422@shiny>
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs: switch the btrfs tree locks to reader/writer

The btrfs metadata btree is the source of significant
lock contention, especially in the root node.   This
commit changes our locking to use a reader/writer
lock.

The lock is built on top of mutexes, which are much faster
for dealing with heavy write contention.  We don't try
very hard to be fair, from a latency point of view
allowing the readers to come in is very important.

In read heavy workloads this is dramatically faster.  In write
heavy workloads we're often faster because of less contention
on the root node lock.

We suffer slightly in dbench because we schedule more often
during write locks.  This still has some adaptive spinning
in the btrfs code, which I'm trying to get rid of long term.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8c83c88..441d945 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -119,7 +119,7 @@ noinline void btrfs_release_path(struct btrfs_path *p)
 		if (!p->nodes[i])
 			continue;
 		if (p->locks[i]) {
-			btrfs_tree_unlock(p->nodes[i]);
+			btrfs_tree_unlock_rw(p->nodes[i], p->locks[i]);
 			p->locks[i] = 0;
 		}
 		free_extent_buffer(p->nodes[i]);
@@ -167,6 +167,25 @@ struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
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
@@ -862,7 +881,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 	mid = path->nodes[level];
 
-	WARN_ON(!path->locks[level]);
+	WARN_ON(path->locks[level] != BTRFS_WRITE_LOCK);
 	WARN_ON(btrfs_header_generation(mid) != trans->transid);
 
 	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
@@ -1360,7 +1379,7 @@ static noinline void unlock_up(struct btrfs_path *path, int level,
 
 		t = path->nodes[i];
 		if (i >= lowest_unlock && i > skip_level && path->locks[i]) {
-			btrfs_tree_unlock(t);
+			btrfs_tree_unlock_rw(t, path->locks[i]);
 			path->locks[i] = 0;
 		}
 	}
@@ -1387,7 +1406,7 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
 			continue;
 		if (!path->locks[i])
 			continue;
-		btrfs_tree_unlock(path->nodes[i]);
+		btrfs_tree_unlock_rw(path->nodes[i], path->locks[i]);
 		path->locks[i] = 0;
 	}
 }
@@ -1491,13 +1510,20 @@ read_block_for_search(struct btrfs_trans_handle *trans,
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
@@ -1516,6 +1542,12 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
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
@@ -1566,27 +1598,78 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
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
@@ -1595,10 +1678,6 @@ again:
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
@@ -1608,7 +1687,15 @@ again:
 			if (!should_cow_block(trans, root, b))
 				goto cow_done;
 
-			btrfs_set_path_blocking(p);
+			/*
+			 * must have write locks on this node and the
+			 * parent
+			 */
+			if (level + 1 > write_lock_level) {
+				write_lock_level = level + 1;
+				btrfs_release_path(p);
+				goto again;
+			}
 
 			err = btrfs_cow_block(trans, root, b,
 					      p->nodes[level + 1],
@@ -1622,10 +1709,6 @@ cow_done:
 		BUG_ON(!cow && ins_len);
 
 		p->nodes[level] = b;
-		if (!p->skip_locking)
-			p->locks[level] = 1;
-
-		btrfs_clear_path_blocking(p, NULL);
 
 		/*
 		 * we have a lock on b and as long as we aren't changing
@@ -1651,7 +1734,7 @@ cow_done:
 			}
 			p->slots[level] = slot;
 			err = setup_nodes_for_search(trans, root, p, b, level,
-						     ins_len);
+					     ins_len, &write_lock_level);
 			if (err == -EAGAIN)
 				goto again;
 			if (err) {
@@ -1661,6 +1744,19 @@ cow_done:
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
@@ -1679,19 +1775,26 @@ cow_done:
 			}
 
 			if (!p->skip_locking) {
-				btrfs_clear_path_blocking(p, NULL);
-				err = btrfs_try_spin_lock(b);
-
-				if (!err) {
-					btrfs_set_path_blocking(p);
+				level = btrfs_header_level(b);
+				if (level <= write_lock_level) {
 					btrfs_tree_lock(b);
-					btrfs_clear_path_blocking(p, b);
+					p->locks[level] = BTRFS_WRITE_LOCK;
+				} else {
+					btrfs_tree_read_lock(b);
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
@@ -3819,11 +3922,11 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 
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
@@ -3913,9 +4016,9 @@ find_next_key:
 		cur = read_node_slot(root, cur, slot);
 		BUG_ON(!cur);
 
-		btrfs_tree_lock(cur);
+		btrfs_tree_read_lock(cur);
 
-		path->locks[level - 1] = 1;
+		path->locks[level - 1] = BTRFS_READ_LOCK;
 		path->nodes[level - 1] = cur;
 		unlock_up(path, level, 1);
 		btrfs_clear_path_blocking(path, NULL);
@@ -4034,6 +4137,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 	int ret;
 	int old_spinning = path->leave_spinning;
 	int force_blocking = 0;
+	int next_rw_lock = 0;
 
 	nritems = btrfs_header_nritems(path->nodes[0]);
 	if (nritems == 0)
@@ -4051,6 +4155,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 again:
 	level = 1;
 	next = NULL;
+	next_rw_lock = 0;
 	btrfs_release_path(path);
 
 	path->keep_locks = 1;
@@ -4096,11 +4201,12 @@ again:
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
@@ -4111,17 +4217,8 @@ again:
 			goto done;
 		}
 
-		if (!path->skip_locking) {
-			ret = btrfs_try_spin_lock(next);
-			if (!ret) {
-				btrfs_set_path_blocking(path);
-				btrfs_tree_lock(next);
-				if (!force_blocking)
-					btrfs_clear_path_blocking(path, next);
-			}
-			if (force_blocking)
-				btrfs_set_lock_blocking(next);
-		}
+		if (!path->skip_locking)
+			btrfs_tree_read_lock(next);
 		break;
 	}
 	path->slots[level] = slot;
@@ -4129,13 +4226,13 @@ again:
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
+			path->locks[level] = BTRFS_READ_LOCK;
 
 		if (!level)
 			break;
@@ -4150,18 +4247,8 @@ again:
 			goto done;
 		}
 
-		if (!path->skip_locking) {
-			btrfs_assert_tree_locked(path->nodes[level]);
-			ret = btrfs_try_spin_lock(next);
-			if (!ret) {
-				btrfs_set_path_blocking(path);
-				btrfs_tree_lock(next);
-				if (!force_blocking)
-					btrfs_clear_path_blocking(path, next);
-			}
-			if (force_blocking)
-				btrfs_set_lock_blocking(next);
-		}
+		if (!path->skip_locking)
+			btrfs_tree_read_lock(next);
 	}
 	ret = 0;
 done:
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ff3402a..1860fa8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5929,7 +5929,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 			return 1;
 
 		if (path->locks[level] && !wc->keep_locks) {
-			btrfs_tree_unlock(eb);
+			btrfs_tree_unlock_rw(eb, path->locks[level]);
 			path->locks[level] = 0;
 		}
 		return 0;
@@ -5953,7 +5953,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 	 * keep the tree lock
 	 */
 	if (path->locks[level] && level > 0) {
-		btrfs_tree_unlock(eb);
+		btrfs_tree_unlock_rw(eb, path->locks[level]);
 		path->locks[level] = 0;
 	}
 	return 0;
@@ -6066,7 +6066,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	BUG_ON(level != btrfs_header_level(next));
 	path->nodes[level] = next;
 	path->slots[level] = 0;
-	path->locks[level] = 1;
+	path->locks[level] = BTRFS_WRITE_LOCK;
 	wc->level = level;
 	if (wc->level == 1)
 		wc->reada_slot = 0;
@@ -6137,7 +6137,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			BUG_ON(level == 0);
 			btrfs_tree_lock(eb);
 			btrfs_set_lock_blocking(eb);
-			path->locks[level] = 1;
+			path->locks[level] = BTRFS_WRITE_LOCK;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						       eb->start, eb->len,
@@ -6146,8 +6146,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 			BUG_ON(wc->refs[level] == 0);
 			if (wc->refs[level] == 1) {
-				btrfs_tree_unlock(eb);
-				path->locks[level] = 0;
+				btrfs_tree_unlock_rw(eb, path->locks[level]);
 				return 1;
 			}
 		}
@@ -6169,7 +6168,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 		    btrfs_header_generation(eb) == trans->transid) {
 			btrfs_tree_lock(eb);
 			btrfs_set_lock_blocking(eb);
-			path->locks[level] = 1;
+			path->locks[level] = BTRFS_WRITE_LOCK;
 		}
 		clean_tree_block(trans, root, eb);
 	}
@@ -6248,7 +6247,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
 				return 0;
 
 			if (path->locks[level]) {
-				btrfs_tree_unlock(path->nodes[level]);
+				btrfs_tree_unlock_rw(path->nodes[level],
+						     path->locks[level]);
 				path->locks[level] = 0;
 			}
 			free_extent_buffer(path->nodes[level]);
@@ -6300,7 +6300,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		path->nodes[level] = btrfs_lock_root_node(root);
 		btrfs_set_lock_blocking(path->nodes[level]);
 		path->slots[level] = 0;
-		path->locks[level] = 1;
+		path->locks[level] = BTRFS_WRITE_LOCK;
 		memset(&wc->update_progress, 0,
 		       sizeof(wc->update_progress));
 	} else {
@@ -6468,7 +6468,7 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 	level = btrfs_header_level(node);
 	path->nodes[level] = node;
 	path->slots[level] = 0;
-	path->locks[level] = 1;
+	path->locks[level] = BTRFS_WRITE_LOCK;
 
 	wc->refs[parent_level] = 1;
 	wc->flags[parent_level] = BTRFS_BLOCK_FLAG_FULL_BACKREF;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20f24f1..20070cd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3017,8 +3017,10 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 		return NULL;
 	eb->start = start;
 	eb->len = len;
-	spin_lock_init(&eb->lock);
+	mutex_init(&eb->lock);
+	atomic_set(&eb->lock_readers, 0);
 	init_waitqueue_head(&eb->lock_wq);
+	init_waitqueue_head(&eb->read_lock_wq);
 
 #if LEAK_DEBUG
 	spin_lock_irqsave(&leak_lock, flags);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b5f120c..3b8ec90 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -128,14 +128,21 @@ struct extent_buffer {
 	struct rcu_head rcu_head;
 	atomic_t refs;
 
-	/* the spinlock is used to protect most operations */
-	spinlock_t lock;
+	/* count of read lock holders on the extent buffer */
+	atomic_t lock_readers;;
+
+	/* protects write locks */
+	struct mutex lock;
 
-	/*
-	 * when we keep the lock held while blocking, waiters go onto
-	 * the wq
+	/* readers use lock_wq while they wait for the write
+	 * lock holders to unlock
 	 */
 	wait_queue_head_t lock_wq;
+
+	/* writers use read_lock_wq while they wait for readers
+	 * to unlock
+	 */
+	wait_queue_head_t read_lock_wq;
 };
 
 static inline void extent_set_compress_type(unsigned long *bio_flags,
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 66fa43d..d59f873 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -24,185 +24,87 @@
 #include "extent_io.h"
 #include "locking.h"
 
-static inline void spin_nested(struct extent_buffer *eb)
-{
-	spin_lock(&eb->lock);
-}
-
 /*
- * Setting a lock to blocking will drop the spinlock and set the
- * flag that forces other procs who want the lock to wait.  After
- * this you can safely schedule with the lock held.
+ * This is a noop today, but it might come back
  */
 void btrfs_set_lock_blocking(struct extent_buffer *eb)
 {
-	if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags)) {
-		set_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags);
-		spin_unlock(&eb->lock);
-	}
-	/* exit with the spin lock released and the bit set */
+	return;
 }
 
 /*
- * clearing the blocking flag will take the spinlock again.
- * After this you can't safely schedule
+ * This is a noop today, but it might come back
  */
 void btrfs_clear_lock_blocking(struct extent_buffer *eb)
 {
-	if (test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags)) {
-		spin_nested(eb);
-		clear_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags);
-		smp_mb__after_clear_bit();
-	}
-	/* exit with the spin lock held */
+	return;
 }
 
-/*
- * unfortunately, many of the places that currently set a lock to blocking
- * don't end up blocking for very long, and often they don't block
- * at all.  For a dbench 50 run, if we don't spin on the blocking bit
- * at all, the context switch rate can jump up to 400,000/sec or more.
- *
- * So, we're still stuck with this crummy spin on the blocking bit,
- * at least until the most common causes of the short blocks
- * can be dealt with.
- */
-static int btrfs_spin_on_block(struct extent_buffer *eb)
+void btrfs_tree_read_lock(struct extent_buffer *eb)
 {
 	int i;
 
-	for (i = 0; i < 512; i++) {
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 1;
-		if (need_resched())
-			break;
+	atomic_inc(&eb->lock_readers);
+	smp_mb();
+	for (i = 0; i < 256; i++) {
+		if (!mutex_is_locked(&eb->lock))
+			return;
 		cpu_relax();
 	}
-	return 0;
+	wait_event(eb->read_lock_wq, mutex_is_locked(&eb->lock) == 0);
 }
 
-/*
- * This is somewhat different from trylock.  It will take the
- * spinlock but if it finds the lock is set to blocking, it will
- * return without the lock held.
- *
- * returns 1 if it was able to take the lock and zero otherwise
- *
- * After this call, scheduling is not safe without first calling
- * btrfs_set_lock_blocking()
- */
-int btrfs_try_spin_lock(struct extent_buffer *eb)
+void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
-	int i;
-
-	if (btrfs_spin_on_block(eb)) {
-		spin_nested(eb);
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 1;
-		spin_unlock(&eb->lock);
-	}
-	/* spin for a bit on the BLOCKING flag */
-	for (i = 0; i < 2; i++) {
-		cpu_relax();
-		if (!btrfs_spin_on_block(eb))
-			break;
+	WARN_ON(atomic_read(&eb->lock_readers) == 0);
 
-		spin_nested(eb);
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 1;
-		spin_unlock(&eb->lock);
+	if (atomic_dec_and_test(&eb->lock_readers)) {
+		if (waitqueue_active(&eb->lock_wq))
+			wake_up(&eb->lock_wq);
 	}
-	return 0;
 }
 
-/*
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
- */
-static int btrfs_wake_function(wait_queue_t *wait, unsigned mode,
-			       int sync, void *key)
-{
-	autoremove_wake_function(wait, mode, sync, key);
-	return 1;
-}
-
-/*
- * returns with the extent buffer spinlocked.
- *
- * This will spin and/or wait as required to take the lock, and then
- * return with the spinlock held.
- *
- * After this call, scheduling is not safe without first calling
- * btrfs_set_lock_blocking()
- */
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
+	int i;
 
-		finish_wait(&eb->lock_wq, &wait);
+again:
+	/* use try lock to avoid might_sleep() */
+	if (!mutex_trylock(&eb->lock))
+		mutex_lock(&eb->lock);
+	else
+		smp_mb();
+	if (atomic_read(&eb->lock_readers)) {
+		mutex_unlock(&eb->lock);
+		for (i = 0; i < 256; i++) {
+			if (!atomic_read(&eb->lock_readers))
+				goto again;;
+			cpu_relax();
+		}
+		smp_mb();
+		if (waitqueue_active(&eb->read_lock_wq))
+			wake_up(&eb->read_lock_wq);
+
+		wait_event(eb->lock_wq, atomic_read(&eb->lock_readers) == 0);
+		goto again;
 	}
 	return 0;
 }
 
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
+	mutex_unlock(&eb->lock);
+	if (waitqueue_active(&eb->read_lock_wq))
+		wake_up(&eb->read_lock_wq);
 	return 0;
 }
 
 void btrfs_assert_tree_locked(struct extent_buffer *eb)
 {
-	if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-		assert_spin_locked(&eb->lock);
+	BUG_ON(!mutex_is_locked(&eb->lock));
+}
+
+void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
+{
+	BUG_ON(!atomic_read(&eb->lock_readers));
 }
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 5c33a56..65b14f2 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -19,11 +19,25 @@
 #ifndef __BTRFS_LOCKING_
 #define __BTRFS_LOCKING_
 
+#define BTRFS_WRITE_LOCK 1
+#define BTRFS_READ_LOCK 2
+
 int btrfs_tree_lock(struct extent_buffer *eb);
 int btrfs_tree_unlock(struct extent_buffer *eb);
 int btrfs_try_spin_lock(struct extent_buffer *eb);
 
+void btrfs_tree_read_lock(struct extent_buffer *eb);
+void btrfs_tree_read_unlock(struct extent_buffer *eb);
 void btrfs_set_lock_blocking(struct extent_buffer *eb);
 void btrfs_clear_lock_blocking(struct extent_buffer *eb);
 void btrfs_assert_tree_locked(struct extent_buffer *eb);
+
+static inline void btrfs_tree_unlock_rw(struct extent_buffer *eb, int rw)
+{
+	if (rw == BTRFS_WRITE_LOCK)
+		btrfs_tree_unlock(eb);
+	else
+		btrfs_tree_read_unlock(eb);
+}
+
 #endif
