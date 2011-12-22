From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 05/10] Btrfs: add nested locking mode for paths
Date: Thu, 22 Dec 2011 17:03:19 +0100
Message-ID: <108c7352f9047f90144360a5609816464b33afff.1324568416.git.list.btrfs@jan-o-sch.net>
References: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
Cc: lizf@cn.fujitsu.com, sensille@gmx.net
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

This patch adds the possibilty to read-lock an extent even if it is already
write-locked from the same thread. btrfs_find_all_roots() needs this
capability.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c     |   22 ++++++++++++--------
 fs/btrfs/ctree.h     |    1 +
 fs/btrfs/extent_io.c |    1 +
 fs/btrfs/extent_io.h |    2 +
 fs/btrfs/locking.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/locking.h   |    2 +-
 6 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0639a55..d0cd67e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -186,13 +186,14 @@ struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
  * tree until you end up with a lock on the root.  A locked buffer
  * is returned, with a reference held.
  */
-struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
+struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root,
+						int nested)
 {
 	struct extent_buffer *eb;
 
 	while (1) {
 		eb = btrfs_root_node(root);
-		btrfs_tree_read_lock(eb);
+		btrfs_tree_read_lock(eb, nested);
 		if (eb == root->node)
 			break;
 		btrfs_tree_read_unlock(eb);
@@ -1637,6 +1638,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	/* everything at write_lock_level or lower must be write locked */
 	int write_lock_level = 0;
 	u8 lowest_level = 0;
+	int nested = p->nested;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
@@ -1678,8 +1680,9 @@ again:
 		b = root->commit_root;
 		extent_buffer_get(b);
 		level = btrfs_header_level(b);
+		BUG_ON(p->skip_locking && nested);
 		if (!p->skip_locking)
-			btrfs_tree_read_lock(b);
+			btrfs_tree_read_lock(b, 0);
 	} else {
 		if (p->skip_locking) {
 			b = btrfs_root_node(root);
@@ -1688,7 +1691,7 @@ again:
 			/* we don't know the level of the root node
 			 * until we actually have it read locked
 			 */
-			b = btrfs_read_lock_root_node(root);
+			b = btrfs_read_lock_root_node(root, nested);
 			level = btrfs_header_level(b);
 			if (level <= write_lock_level) {
 				/* whoops, must trade for write lock */
@@ -1827,7 +1830,8 @@ cow_done:
 					err = btrfs_try_tree_read_lock(b);
 					if (!err) {
 						btrfs_set_path_blocking(p);
-						btrfs_tree_read_lock(b);
+						btrfs_tree_read_lock(b,
+								     nested);
 						btrfs_clear_path_blocking(p, b,
 								  BTRFS_READ_LOCK);
 					}
@@ -3972,7 +3976,7 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 
 	WARN_ON(!path->keep_locks);
 again:
-	cur = btrfs_read_lock_root_node(root);
+	cur = btrfs_read_lock_root_node(root, 0);
 	level = btrfs_header_level(cur);
 	WARN_ON(path->nodes[level]);
 	path->nodes[level] = cur;
@@ -4066,7 +4070,7 @@ find_next_key:
 		cur = read_node_slot(root, cur, slot);
 		BUG_ON(!cur);
 
-		btrfs_tree_read_lock(cur);
+		btrfs_tree_read_lock(cur, 0);
 
 		path->locks[level - 1] = BTRFS_READ_LOCK;
 		path->nodes[level - 1] = cur;
@@ -4260,7 +4264,7 @@ again:
 			ret = btrfs_try_tree_read_lock(next);
 			if (!ret) {
 				btrfs_set_path_blocking(path);
-				btrfs_tree_read_lock(next);
+				btrfs_tree_read_lock(next, 0);
 				btrfs_clear_path_blocking(path, next,
 							  BTRFS_READ_LOCK);
 			}
@@ -4297,7 +4301,7 @@ again:
 			ret = btrfs_try_tree_read_lock(next);
 			if (!ret) {
 				btrfs_set_path_blocking(path);
-				btrfs_tree_read_lock(next);
+				btrfs_tree_read_lock(next, 0);
 				btrfs_clear_path_blocking(path, next,
 							  BTRFS_READ_LOCK);
 			}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 543f60b..34a6941 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -530,6 +530,7 @@ struct btrfs_path {
 	unsigned int skip_locking:1;
 	unsigned int leave_spinning:1;
 	unsigned int search_commit_root:1;
+	unsigned int nested:1;
 };
 
 /*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index be1bf62..dd8d140 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3571,6 +3571,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	atomic_set(&eb->blocking_writers, 0);
 	atomic_set(&eb->spinning_readers, 0);
 	atomic_set(&eb->spinning_writers, 0);
+	eb->lock_nested = 0;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7604c30..bc6a042cb 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -129,6 +129,7 @@ struct extent_buffer {
 	struct list_head leak_list;
 	struct rcu_head rcu_head;
 	atomic_t refs;
+	pid_t lock_owner;
 
 	/* count of read lock holders on the extent buffer */
 	atomic_t write_locks;
@@ -137,6 +138,7 @@ struct extent_buffer {
 	atomic_t blocking_readers;
 	atomic_t spinning_readers;
 	atomic_t spinning_writers;
+	int lock_nested;
 
 	/* protects write locks */
 	rwlock_t lock;
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index d77b67c..3cd604f 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -33,6 +33,14 @@ void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
  */
 void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
 {
+	if (eb->lock_nested) {
+		read_lock(&eb->lock);
+		if (eb->lock_nested && current->pid == eb->lock_owner) {
+			read_unlock(&eb->lock);
+			return;
+		}
+		read_unlock(&eb->lock);
+	}
 	if (rw == BTRFS_WRITE_LOCK) {
 		if (atomic_read(&eb->blocking_writers) == 0) {
 			WARN_ON(atomic_read(&eb->spinning_writers) != 1);
@@ -57,6 +65,14 @@ void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
  */
 void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 {
+	if (eb->lock_nested) {
+		read_lock(&eb->lock);
+		if (&eb->lock_nested && current->pid == eb->lock_owner) {
+			read_unlock(&eb->lock);
+			return;
+		}
+		read_unlock(&eb->lock);
+	}
 	if (rw == BTRFS_WRITE_LOCK_BLOCKING) {
 		BUG_ON(atomic_read(&eb->blocking_writers) != 1);
 		write_lock(&eb->lock);
@@ -78,15 +94,24 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
  * take a spinning read lock.  This will wait for any blocking
  * writers
  */
-void btrfs_tree_read_lock(struct extent_buffer *eb)
+void btrfs_tree_read_lock(struct extent_buffer *eb, int nested)
 {
 again:
+	if (nested) {
+		read_lock(&eb->lock);
+		if (atomic_read(&eb->blocking_writers) &&
+		    current->pid == eb->lock_owner) {
+			BUG_ON(eb->lock_nested);
+			eb->lock_nested = 1;
+			read_unlock(&eb->lock);
+			return;
+		}
+		read_unlock(&eb->lock);
+	}
 	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
 	read_lock(&eb->lock);
 	if (atomic_read(&eb->blocking_writers)) {
 		read_unlock(&eb->lock);
-		wait_event(eb->write_lock_wq,
-			   atomic_read(&eb->blocking_writers) == 0);
 		goto again;
 	}
 	atomic_inc(&eb->read_locks);
@@ -129,6 +154,7 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 	}
 	atomic_inc(&eb->write_locks);
 	atomic_inc(&eb->spinning_writers);
+	eb->lock_owner = current->pid;
 	return 1;
 }
 
@@ -137,6 +163,15 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
  */
 void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
+	if (eb->lock_nested) {
+		read_lock(&eb->lock);
+		if (eb->lock_nested && current->pid == eb->lock_owner) {
+			eb->lock_nested = 0;
+			read_unlock(&eb->lock);
+			return;
+		}
+		read_unlock(&eb->lock);
+	}
 	btrfs_assert_tree_read_locked(eb);
 	WARN_ON(atomic_read(&eb->spinning_readers) == 0);
 	atomic_dec(&eb->spinning_readers);
@@ -149,6 +184,15 @@ void btrfs_tree_read_unlock(struct extent_buffer *eb)
  */
 void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
 {
+	if (eb->lock_nested) {
+		read_lock(&eb->lock);
+		if (eb->lock_nested && current->pid == eb->lock_owner) {
+			eb->lock_nested = 0;
+			read_unlock(&eb->lock);
+			return;
+		}
+		read_unlock(&eb->lock);
+	}
 	btrfs_assert_tree_read_locked(eb);
 	WARN_ON(atomic_read(&eb->blocking_readers) == 0);
 	if (atomic_dec_and_test(&eb->blocking_readers))
@@ -181,6 +225,7 @@ again:
 	WARN_ON(atomic_read(&eb->spinning_writers));
 	atomic_inc(&eb->spinning_writers);
 	atomic_inc(&eb->write_locks);
+	eb->lock_owner = current->pid;
 	return 0;
 }
 
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 17247dd..c6d69e5 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -28,7 +28,7 @@ int btrfs_tree_lock(struct extent_buffer *eb);
 int btrfs_tree_unlock(struct extent_buffer *eb);
 int btrfs_try_spin_lock(struct extent_buffer *eb);
 
-void btrfs_tree_read_lock(struct extent_buffer *eb);
+void btrfs_tree_read_lock(struct extent_buffer *eb, int nested);
 void btrfs_tree_read_unlock(struct extent_buffer *eb);
 void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb);
 void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw);
-- 
1.7.3.4

