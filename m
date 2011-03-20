From: Tejun Heo <tj@kernel.org>
Subject: [PATCH RFC] btrfs: Simplify locking
Date: Sun, 20 Mar 2011 18:44:33 +0100
Message-ID: <20110320174433.GA12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, guys.

I've been looking through btrfs code and found out that the locking
was quite interesting.  The distinction between blocking and
non-blocking locking is valid but is essentially attacing the same
problem that CONFIG_MUTEX_SPIN_ON_OWNER addresses in generic manner.

It seemed that CONFIG_MUTEX_SPIN_ON_OWNER should be able to do it
better as it actually knows whether the lock owner is running or not,
so I did a few "dbench 50" runs with the complex locking removed.

The test machine is a dual core machine with 1 gig of memory.  The
filesystem is on OCZ vertex 64 gig SSD.  I'm attaching the kernel
config.  Please note that CONFIG_MUTEX_SPIN_ON_OWNER is enabled only
when lock debugging is disabled, but it will be enabled on virtually
any production configuration.

The machine was idle during the dbench runs and CPU usages and context
switches are calculated from /proc/stat over the dbench runs.  The
throughput is as reported by dbench.

         user  system  sirq    cxtsw throughput
before  14426  129332   345  1674004    171.7
after   14274  129036   308  1183346    172.119

So, the extra code isn't really helping anything.  It's worse in every
way.  Are there some obscure reasons the custom locking should be kept
around?

One thing to note is that the patch makes try_tree_lock and
try_spin_lock identical.  It might be benefical to apply owner spin
logic to try_spin_lock.  I'll test that one too and see whether it
makes any difference.

Thanks.

NOT-Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/btrfs/Makefile    |    2 
 fs/btrfs/ctree.c     |   16 +--
 fs/btrfs/extent_io.c |    3 
 fs/btrfs/extent_io.h |   12 --
 fs/btrfs/locking.c   |  233 ---------------------------------------------------
 fs/btrfs/locking.h   |   43 +++++++--
 6 files changed, 48 insertions(+), 261 deletions(-)

Index: work/fs/btrfs/ctree.c
===================================================================
--- work.orig/fs/btrfs/ctree.c
+++ work/fs/btrfs/ctree.c
@@ -1074,7 +1074,7 @@ static noinline int balance_level(struct
 
 	left = read_node_slot(root, parent, pslot - 1);
 	if (left) {
-		btrfs_tree_lock(left);
+		btrfs_tree_lock_nested(left, 1);
 		btrfs_set_lock_blocking(left);
 		wret = btrfs_cow_block(trans, root, left,
 				       parent, pslot - 1, &left);
@@ -1085,7 +1085,7 @@ static noinline int balance_level(struct
 	}
 	right = read_node_slot(root, parent, pslot + 1);
 	if (right) {
-		btrfs_tree_lock(right);
+		btrfs_tree_lock_nested(right, 2);
 		btrfs_set_lock_blocking(right);
 		wret = btrfs_cow_block(trans, root, right,
 				       parent, pslot + 1, &right);
@@ -1241,7 +1241,7 @@ static noinline int push_nodes_for_inser
 	if (left) {
 		u32 left_nr;
 
-		btrfs_tree_lock(left);
+		btrfs_tree_lock_nested(left, 1);
 		btrfs_set_lock_blocking(left);
 
 		left_nr = btrfs_header_nritems(left);
@@ -1291,7 +1291,7 @@ static noinline int push_nodes_for_inser
 	if (right) {
 		u32 right_nr;
 
-		btrfs_tree_lock(right);
+		btrfs_tree_lock_nested(right, 1);
 		btrfs_set_lock_blocking(right);
 
 		right_nr = btrfs_header_nritems(right);
@@ -2519,7 +2519,7 @@ static int push_leaf_right(struct btrfs_
 	if (right == NULL)
 		return 1;
 
-	btrfs_tree_lock(right);
+	btrfs_tree_lock_nested(right, 1);
 	btrfs_set_lock_blocking(right);
 
 	free_space = btrfs_leaf_free_space(root, right);
@@ -2772,7 +2772,7 @@ static int push_leaf_left(struct btrfs_t
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
Index: work/fs/btrfs/extent_io.c
===================================================================
--- work.orig/fs/btrfs/extent_io.c
+++ work/fs/btrfs/extent_io.c
@@ -3171,8 +3171,7 @@ static struct extent_buffer *__alloc_ext
 		return NULL;
 	eb->start = start;
 	eb->len = len;
-	spin_lock_init(&eb->lock);
-	init_waitqueue_head(&eb->lock_wq);
+	mutex_init(&eb->lock);
 	INIT_RCU_HEAD(&eb->rcu_head);
 
 #if LEAK_DEBUG
Index: work/fs/btrfs/extent_io.h
===================================================================
--- work.orig/fs/btrfs/extent_io.h
+++ work/fs/btrfs/extent_io.h
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
Index: work/fs/btrfs/locking.c
===================================================================
--- work.orig/fs/btrfs/locking.c
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
Index: work/fs/btrfs/locking.h
===================================================================
--- work.orig/fs/btrfs/locking.h
+++ work/fs/btrfs/locking.h
@@ -19,13 +19,40 @@
 #ifndef __BTRFS_LOCKING_
 #define __BTRFS_LOCKING_
 
-int btrfs_tree_lock(struct extent_buffer *eb);
-int btrfs_tree_unlock(struct extent_buffer *eb);
+#include <linux/bug.h>
 
-int btrfs_try_tree_lock(struct extent_buffer *eb);
-int btrfs_try_spin_lock(struct extent_buffer *eb);
+static inline bool btrfs_try_spin_lock(struct extent_buffer *eb)
+{
+	return mutex_trylock(&eb->lock);
+}
 
-void btrfs_set_lock_blocking(struct extent_buffer *eb);
-void btrfs_clear_lock_blocking(struct extent_buffer *eb);
-void btrfs_assert_tree_locked(struct extent_buffer *eb);
-#endif
+static inline void btrfs_tree_lock(struct extent_buffer *eb)
+{
+	mutex_lock(&eb->lock);
+}
+
+static inline void btrfs_tree_lock_nested(struct extent_buffer *eb,
+					  unsigned int subclass)
+{
+	mutex_lock_nested(&eb->lock, subclass);
+}
+
+static inline void btrfs_tree_unlock(struct extent_buffer *eb)
+{
+	mutex_unlock(&eb->lock);
+}
+
+static inline int btrfs_try_tree_lock(struct extent_buffer *eb)
+{
+	return mutex_trylock(&eb->lock);
+}
+
+static inline void btrfs_set_lock_blocking(struct extent_buffer *eb)	{ }
+static inline void btrfs_clear_lock_blocking(struct extent_buffer *eb)	{ }
+
+static inline void btrfs_assert_tree_locked(struct extent_buffer *eb)
+{
+	BUG_ON(!mutex_is_locked(&eb->lock));
+}
+
+#endif	/* __BTRFS_LOCKING_ */
Index: work/fs/btrfs/Makefile
===================================================================
--- work.orig/fs/btrfs/Makefile
+++ work/fs/btrfs/Makefile
@@ -5,6 +5,6 @@ btrfs-y += super.o ctree.o extent-tree.o
 	   file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
-	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
+	   extent_io.o volumes.o async-thread.o ioctl.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o
