From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] btrfs: Simplify extent_buffer locking
Date: Thu, 24 Mar 2011 18:43:08 +0100
Message-ID: <1300988588-13986-4-git-send-email-tj@kernel.org>
References: <1300988588-13986-1-git-send-email-tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
To: chris.mason@oracle.com, peterz@infradead.org, mingo@redhat.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300988588-13986-1-git-send-email-tj@kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

extent_buffer implemented custom locking which required explicit
distinction between non-sleepable and sleepable lockings.  This was to
prevent excessive context switches.

For short non-blocking acquisitions, lock was left non-blocking and
other threads which wanted to lock the same eb would spin on it
instead of scheduling out.  If the lock owner wanted to perform
blocking operations, it had to upgrade the locking to blocking mode by
calling btrfs_set_lock_blocking().

The distinction is useful and leads to performance gains compared to
naive sleeping sleeping lock implementation; however, the standard
mutex implementation already has adaptive owner spinning -
CONFIG_MUTEX_SPIN_ON_OWNER - which addresses the same problem in
transparent manner.

Compared to CONFIG_MUTEX_SPIN_ON_OWNER, the custom implementation has
several disadvantages.

* It requires explicit blocking state management by the lock owner,
  which can be tedious, error-prone and has its own overhead.

* Although the default mutex lacks access to explicit information from
  the lock owner, it has direct visibility into scheduling which is
  often better information for deciding whether optimistic spinning
  would be useful.

* Lockdep annoation comes for free.  This can be added to the custom
  implementation but hasn't been.

This patch removes the custom extent_buffer locking by replacing
eb->lock with a mutex and making the locking API simple wrappers
around mutex operations.

The following is from "dbench 50" runs on 8-way opteron w/ 4GiB of
memory and SSD.  CONFIG_PREEMPT_VOLUNTARY is set.

       USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
BEFORE 59898  504517    377  6814245     782.295
AFTER  61090  493441    457  1631688     827.751

Other tests also show generally favorable results for the standard
mutex based implementation.  For more info, please read the following
threads.

 http://thread.gmane.org/gmane.comp.file-systems.btrfs/9658
 http://thread.gmane.org/gmane.linux.kernel/1116910

This patch makes all eb locking visible to lockdep and triggers
various locking ordering warnings along the allocation path.  At least
some of them seem to indicate genuine locking bugs while it is
possible that some are spuriously triggered and simply require better
lockdep annoations.  Note that this patch doesn't change locking
ordering itself.  Lockdep now just has more visibility into btrfs
locking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 fs/btrfs/Makefile    |    2 +-
 fs/btrfs/ctree.c     |   16 ++--
 fs/btrfs/extent_io.c |    3 +-
 fs/btrfs/extent_io.h |   12 +--
 fs/btrfs/locking.c   |  233 --------------------------------------------------
 fs/btrfs/locking.h   |   65 ++++++++++++--
 6 files changed, 70 insertions(+), 261 deletions(-)
 delete mode 100644 fs/btrfs/locking.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 31610ea..8688f47 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -5,6 +5,6 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
-	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
+	   extent_io.o volumes.o async-thread.o ioctl.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b5baff0..bc1627d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1074,7 +1074,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 	left = read_node_slot(root, parent, pslot - 1);
 	if (left) {
-		btrfs_tree_lock(left);
+		btrfs_tree_lock_nested(left, 1);
 		btrfs_set_lock_blocking(left);
 		wret = btrfs_cow_block(trans, root, left,
 				       parent, pslot - 1, &left);
@@ -1085,7 +1085,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	}
 	right = read_node_slot(root, parent, pslot + 1);
 	if (right) {
-		btrfs_tree_lock(right);
+		btrfs_tree_lock_nested(right, 2);
 		btrfs_set_lock_blocking(right);
 		wret = btrfs_cow_block(trans, root, right,
 				       parent, pslot + 1, &right);
@@ -1241,7 +1241,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	if (left) {
 		u32 left_nr;
 
-		btrfs_tree_lock(left);
+		btrfs_tree_lock_nested(left, 1);
 		btrfs_set_lock_blocking(left);
 
 		left_nr = btrfs_header_nritems(left);
@@ -1291,7 +1291,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	if (right) {
 		u32 right_nr;
 
-		btrfs_tree_lock(right);
+		btrfs_tree_lock_nested(right, 1);
 		btrfs_set_lock_blocking(right);
 
 		right_nr = btrfs_header_nritems(right);
@@ -2519,7 +2519,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (right == NULL)
 		return 1;
 
-	btrfs_tree_lock(right);
+	btrfs_tree_lock_nested(right, 1);
 	btrfs_set_lock_blocking(right);
 
 	free_space = btrfs_leaf_free_space(root, right);
@@ -2772,7 +2772,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (left == NULL)
 		return 1;
 
-	btrfs_tree_lock(left);
+	btrfs_tree_lock_nested(left, 1);
 	btrfs_set_lock_blocking(left);
 
 	free_space = btrfs_leaf_free_space(root, left);
@@ -4420,7 +4420,7 @@ again:
 			ret = btrfs_try_spin_lock(next);
 			if (!ret) {
 				btrfs_set_path_blocking(path);
-				btrfs_tree_lock(next);
+				btrfs_tree_lock_nested(next, 1);
 				if (!force_blocking)
 					btrfs_clear_path_blocking(path, next);
 			}
@@ -4460,7 +4460,7 @@ again:
 			ret = btrfs_try_spin_lock(next);
 			if (!ret) {
 				btrfs_set_path_blocking(path);
-				btrfs_tree_lock(next);
+				btrfs_tree_lock_nested(next, 1);
 				if (!force_blocking)
 					btrfs_clear_path_blocking(path, next);
 			}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9fcb5ed..0b96a0a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3171,8 +3171,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 		return NULL;
 	eb->start = start;
 	eb->len = len;
-	spin_lock_init(&eb->lock);
-	init_waitqueue_head(&eb->lock_wq);
+	mutex_init(&eb->lock);
 	INIT_RCU_HEAD(&eb->rcu_head);
 
 #if LEAK_DEBUG
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9318dfe..c70c8c9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -2,6 +2,7 @@
 #define __EXTENTIO__
 
 #include <linux/rbtree.h>
+#include <linux/mutex.h>
 
 /* bits for the extent state */
 #define EXTENT_DIRTY 1
@@ -29,7 +30,6 @@
 
 /* these are bit numbers for test/set bit */
 #define EXTENT_BUFFER_UPTODATE 0
-#define EXTENT_BUFFER_BLOCKING 1
 #define EXTENT_BUFFER_DIRTY 2
 
 /* these are flags for extent_clear_unlock_delalloc */
@@ -129,14 +129,8 @@ struct extent_buffer {
 	struct list_head leak_list;
 	struct rcu_head rcu_head;
 
-	/* the spinlock is used to protect most operations */
-	spinlock_t lock;
-
-	/*
-	 * when we keep the lock held while blocking, waiters go onto
-	 * the wq
-	 */
-	wait_queue_head_t lock_wq;
+	/* used to protect most operations */
+	struct mutex lock;
 };
 
 static inline void extent_set_compress_type(unsigned long *bio_flags,
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
deleted file mode 100644
index 6151f2e..0000000
--- a/fs/btrfs/locking.c
+++ /dev/null
@@ -1,233 +0,0 @@
-/*
- * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-#include <linux/sched.h>
-#include <linux/pagemap.h>
-#include <linux/spinlock.h>
-#include <linux/page-flags.h>
-#include <asm/bug.h>
-#include "ctree.h"
-#include "extent_io.h"
-#include "locking.h"
-
-static inline void spin_nested(struct extent_buffer *eb)
-{
-	spin_lock(&eb->lock);
-}
-
-/*
- * Setting a lock to blocking will drop the spinlock and set the
- * flag that forces other procs who want the lock to wait.  After
- * this you can safely schedule with the lock held.
- */
-void btrfs_set_lock_blocking(struct extent_buffer *eb)
-{
-	if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags)) {
-		set_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags);
-		spin_unlock(&eb->lock);
-	}
-	/* exit with the spin lock released and the bit set */
-}
-
-/*
- * clearing the blocking flag will take the spinlock again.
- * After this you can't safely schedule
- */
-void btrfs_clear_lock_blocking(struct extent_buffer *eb)
-{
-	if (test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags)) {
-		spin_nested(eb);
-		clear_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags);
-		smp_mb__after_clear_bit();
-	}
-	/* exit with the spin lock held */
-}
-
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
-{
-	int i;
-
-	for (i = 0; i < 512; i++) {
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 1;
-		if (need_resched())
-			break;
-		cpu_relax();
-	}
-	return 0;
-}
-
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
-{
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
-
-		spin_nested(eb);
-		if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-			return 1;
-		spin_unlock(&eb->lock);
-	}
-	return 0;
-}
-
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
-int btrfs_tree_lock(struct extent_buffer *eb)
-{
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
-	}
-	return 0;
-}
-
-/*
- * Very quick trylock, this does not spin or schedule.  It returns
- * 1 with the spinlock held if it was able to take the lock, or it
- * returns zero if it was unable to take the lock.
- *
- * After this call, scheduling is not safe without first calling
- * btrfs_set_lock_blocking()
- */
-int btrfs_try_tree_lock(struct extent_buffer *eb)
-{
-	if (spin_trylock(&eb->lock)) {
-		if (test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags)) {
-			/*
-			 * we've got the spinlock, but the real owner is
-			 * blocking.  Drop the spinlock and return failure
-			 */
-			spin_unlock(&eb->lock);
-			return 0;
-		}
-		return 1;
-	}
-	/* someone else has the spinlock giveup */
-	return 0;
-}
-
-int btrfs_tree_unlock(struct extent_buffer *eb)
-{
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
-	return 0;
-}
-
-void btrfs_assert_tree_locked(struct extent_buffer *eb)
-{
-	if (!test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags))
-		assert_spin_locked(&eb->lock);
-}
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 6c4ce45..1bb1fee 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -19,13 +19,62 @@
 #ifndef __BTRFS_LOCKING_
 #define __BTRFS_LOCKING_
 
-int btrfs_tree_lock(struct extent_buffer *eb);
-int btrfs_tree_unlock(struct extent_buffer *eb);
+#include <linux/bug.h>
 
-int btrfs_try_tree_lock(struct extent_buffer *eb);
-int btrfs_try_spin_lock(struct extent_buffer *eb);
+/*
+ * Lock/unlock wrappers for eb->lock.
+ *
+ * Lock-neseting eb's at the same level should always be done with the
+ * immediate parent locked to avoid deadlocks and use subclass 1 and 2.
+ */
+static inline void btrfs_tree_lock_nested(struct extent_buffer *eb,
+					  unsigned int subclass)
+{
+	mutex_lock_nested(&eb->lock, subclass);
+}
+
+static inline void btrfs_tree_lock(struct extent_buffer *eb)
+{
+	mutex_lock(&eb->lock);
+}
+
+static inline void btrfs_tree_unlock(struct extent_buffer *eb)
+{
+	mutex_unlock(&eb->lock);
+}
+
+/*
+ * Trylock wrappers for eb->lock.
+ *
+ * In the previous custom locking, btrfs_try_tree_lock() tried to acquire
+ * only once while btrfs_try_spin_lock() performed optimistic spinning
+ * before giving up.  With standard mutex, the distinction doesn't exist.
+ */
+static inline int btrfs_try_tree_lock(struct extent_buffer *eb)
+{
+	return mutex_trylock(&eb->lock);
+}
+
+static inline bool btrfs_try_spin_lock(struct extent_buffer *eb)
+{
+	return mutex_trylock(&eb->lock);
+}
+
+/*
+ * In the previous custom locking, lock owner needed to explicitly manage
+ * blocking state of the locked eb's.  Unless blocking was explicitly set,
+ * the lock owner wasn't allowed to sleep.  With standard mutex, the
+ * distinction doesn't exist.
+ *
+ * The blocking management functions are scheduled to be removed.  Don't
+ * use in new code.
+ */
+static inline void btrfs_set_lock_blocking(struct extent_buffer *eb)	{ }
+static inline void btrfs_clear_lock_blocking(struct extent_buffer *eb)	{ }
+
+static inline void btrfs_assert_tree_locked(struct extent_buffer *eb)
+{
+	BUG_ON(!mutex_is_locked(&eb->lock));
+}
 
-void btrfs_set_lock_blocking(struct extent_buffer *eb);
-void btrfs_clear_lock_blocking(struct extent_buffer *eb);
-void btrfs_assert_tree_locked(struct extent_buffer *eb);
-#endif
+#endif	/* __BTRFS_LOCKING_ */
-- 
1.7.1
