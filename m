From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 05/10] Btrfs: add nested locking mode for paths
Date: Wed,  4 Jan 2012 18:35:43 +0100
Message-ID: <5b25f70f4200766355cdabda604e131d2fb6010d.1325692561.git.list.btrfs@jan-o-sch.net>
References: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

This patch adds the possibilty to read-lock an extent even if it is already
write-locked from the same thread. btrfs_find_all_roots() needs this
capability.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/extent_io.c |    1 +
 fs/btrfs/extent_io.h |    2 +
 fs/btrfs/locking.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 54 insertions(+), 2 deletions(-)

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
index d77b67c..5e178d8 100644
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
@@ -81,12 +97,25 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 void btrfs_tree_read_lock(struct extent_buffer *eb)
 {
 again:
+	read_lock(&eb->lock);
+	if (atomic_read(&eb->blocking_writers) &&
+	    current->pid == eb->lock_owner) {
+		/*
+		 * This extent is already write-locked by our thread. We allow
+		 * an additional read lock to be added because it's for the same
+		 * thread. btrfs_find_all_roots() depends on this as it may be
+		 * called on a partly (write-)locked tree.
+		 */
+		BUG_ON(eb->lock_nested);
+		eb->lock_nested = 1;
+		read_unlock(&eb->lock);
+		return;
+	}
+	read_unlock(&eb->lock);
 	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
 	read_lock(&eb->lock);
 	if (atomic_read(&eb->blocking_writers)) {
 		read_unlock(&eb->lock);
-		wait_event(eb->write_lock_wq,
-			   atomic_read(&eb->blocking_writers) == 0);
 		goto again;
 	}
 	atomic_inc(&eb->read_locks);
@@ -129,6 +158,7 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 	}
 	atomic_inc(&eb->write_locks);
 	atomic_inc(&eb->spinning_writers);
+	eb->lock_owner = current->pid;
 	return 1;
 }
 
@@ -137,6 +167,15 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
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
@@ -149,6 +188,15 @@ void btrfs_tree_read_unlock(struct extent_buffer *eb)
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
@@ -181,6 +229,7 @@ again:
 	WARN_ON(atomic_read(&eb->spinning_writers));
 	atomic_inc(&eb->spinning_writers);
 	atomic_inc(&eb->write_locks);
+	eb->lock_owner = current->pid;
 	return 0;
 }
 
-- 
1.7.3.4

