Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab3EOHst (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:49 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 17/17] Btrfs: make the state of the transaction more readable
Date: Wed, 15 May 2013 15:48:31 +0800
Message-Id: <1368604111-25073-18-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We used 3 variants to track the state of the transaction, it was complex
and wasted the memory space. Besides that, it was hard to understand that
which types of the transaction handles should be blocked in each transaction
state, so the developers often made mistakes.

This patch improved the above problem. In this patch, we define 6 states
for the transaction,
  enum btrfs_trans_state {
	TRANS_STATE_RUNNING		= 0,
	TRANS_STATE_BLOCKED		= 1,
	TRANS_STATE_COMMIT_START	= 2,
	TRANS_STATE_COMMIT_DOING	= 3,
	TRANS_STATE_UNBLOCKED		= 4,
	TRANS_STATE_COMPLETED		= 5,
	TRANS_STATE_MAX			= 6,
  }
and just use 1 variant to track those state.

In order to make the blocked handle types for each state more clear,
we introduce a array:
  unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
	[TRANS_STATE_RUNNING]		= 0U,
	[TRANS_STATE_BLOCKED]		= (__TRANS_USERSPACE |
					   __TRANS_START),
	[TRANS_STATE_COMMIT_START]	= (__TRANS_USERSPACE |
					   __TRANS_START |
					   __TRANS_ATTACH),
	[TRANS_STATE_COMMIT_DOING]	= (__TRANS_USERSPACE |
					   __TRANS_START |
					   __TRANS_ATTACH |
					   __TRANS_JOIN),
	[TRANS_STATE_UNBLOCKED]		= (__TRANS_USERSPACE |
					   __TRANS_START |
					   __TRANS_ATTACH |
					   __TRANS_JOIN |
					   __TRANS_JOIN_NOLOCK),
	[TRANS_STATE_COMPLETED]		= (__TRANS_USERSPACE |
					   __TRANS_START |
					   __TRANS_ATTACH |
					   __TRANS_JOIN |
					   __TRANS_JOIN_NOLOCK),
  }
it is very intuitionistic.

Besides that, because we remove ->in_commit in transaction structure, so
the lock ->commit_lock which was used to protect it is unnecessary, remove
->commit_lock.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   1 -
 fs/btrfs/disk-io.c     |  36 ++++++------
 fs/btrfs/transaction.c | 156 ++++++++++++++++++++++++++-----------------------
 fs/btrfs/transaction.h |  16 +++--
 4 files changed, 114 insertions(+), 95 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a7e71ff..bf92302 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1496,7 +1496,6 @@ struct btrfs_fs_info {
 	int closing;
 	int log_root_recovering;
 	int enospc_unlink;
-	int trans_no_join;
 
 	u64 total_pinned;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6bb3f3d..530e3c0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1747,7 +1747,7 @@ static int transaction_kthread(void *arg)
 		}
 
 		now = get_seconds();
-		if (!cur->blocked &&
+		if (cur->state < TRANS_STATE_BLOCKED &&
 		    (now < cur->start_time || now - cur->start_time < 30)) {
 			spin_unlock(&root->fs_info->trans_lock);
 			delay = HZ * 5;
@@ -2183,7 +2183,6 @@ int open_ctree(struct super_block *sb,
 	fs_info->max_inline = 8192 * 1024;
 	fs_info->metadata_ratio = 0;
 	fs_info->defrag_inodes = RB_ROOT;
-	fs_info->trans_no_join = 0;
 	fs_info->free_chunk_space = 0;
 	fs_info->tree_mod_log = RB_ROOT;
 
@@ -3956,19 +3955,14 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv,
 				cur_trans->dirty_pages.dirty_bytes);
 
-	/* FIXME: cleanup wait for commit */
-	cur_trans->in_commit = 1;
-	cur_trans->blocked = 1;
+	cur_trans->state = TRANS_STATE_COMMIT_START;
 	wake_up(&root->fs_info->transaction_blocked_wait);
 
 	btrfs_evict_pending_snapshots(cur_trans);
 
-	cur_trans->blocked = 0;
+	cur_trans->state = TRANS_STATE_UNBLOCKED;
 	wake_up(&root->fs_info->transaction_wait);
 
-	cur_trans->commit_done = 1;
-	wake_up(&cur_trans->commit_wait);
-
 	btrfs_destroy_delayed_inodes(root);
 	btrfs_assert_delayed_root_empty(root);
 
@@ -3977,6 +3971,9 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	btrfs_destroy_pinned_extent(root,
 				    root->fs_info->pinned_extents);
 
+	cur_trans->state =TRANS_STATE_COMPLETED;
+	wake_up(&cur_trans->commit_wait);
+
 	/*
 	memset(cur_trans, 0, sizeof(*cur_trans));
 	kmem_cache_free(btrfs_transaction_cachep, cur_trans);
@@ -4004,25 +4001,23 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 		btrfs_destroy_delayed_refs(t, root);
 
-		/* FIXME: cleanup wait for commit */
-		t->in_commit = 1;
-		t->blocked = 1;
+		/*
+		 *  FIXME: cleanup wait for commit
+		 *  We needn't acquire the lock here, because we are during
+		 *  the umount, there is no other task which will change it.
+		 */
+		t->state = TRANS_STATE_COMMIT_START;
 		smp_mb();
 		if (waitqueue_active(&root->fs_info->transaction_blocked_wait))
 			wake_up(&root->fs_info->transaction_blocked_wait);
 
 		btrfs_evict_pending_snapshots(t);
 
-		t->blocked = 0;
+		t->state = TRANS_STATE_UNBLOCKED;
 		smp_mb();
 		if (waitqueue_active(&root->fs_info->transaction_wait))
 			wake_up(&root->fs_info->transaction_wait);
 
-		t->commit_done = 1;
-		smp_mb();
-		if (waitqueue_active(&t->commit_wait))
-			wake_up(&t->commit_wait);
-
 		btrfs_destroy_delayed_inodes(root);
 		btrfs_assert_delayed_root_empty(root);
 
@@ -4034,6 +4029,11 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 		btrfs_destroy_pinned_extent(root,
 					    root->fs_info->pinned_extents);
 
+		t->state = TRANS_STATE_COMPLETED;
+		smp_mb();
+		if (waitqueue_active(&t->commit_wait))
+			wake_up(&t->commit_wait);
+
 		atomic_set(&t->use_count, 0);
 		list_del_init(&t->list);
 		memset(t, 0, sizeof(*t));
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5e75ff4..e25d972 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -34,6 +34,29 @@
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
+static unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
+	[TRANS_STATE_RUNNING]		= 0U,
+	[TRANS_STATE_BLOCKED]		= (__TRANS_USERSPACE |
+					   __TRANS_START),
+	[TRANS_STATE_COMMIT_START]	= (__TRANS_USERSPACE |
+					   __TRANS_START |
+					   __TRANS_ATTACH),
+	[TRANS_STATE_COMMIT_DOING]	= (__TRANS_USERSPACE |
+					   __TRANS_START |
+					   __TRANS_ATTACH |
+					   __TRANS_JOIN),
+	[TRANS_STATE_UNBLOCKED]		= (__TRANS_USERSPACE |
+					   __TRANS_START |
+					   __TRANS_ATTACH |
+					   __TRANS_JOIN |
+					   __TRANS_JOIN_NOLOCK),
+	[TRANS_STATE_COMPLETED]		= (__TRANS_USERSPACE |
+					   __TRANS_START |
+					   __TRANS_ATTACH |
+					   __TRANS_JOIN |
+					   __TRANS_JOIN_NOLOCK),
+};
+
 static void put_transaction(struct btrfs_transaction *transaction)
 {
 	WARN_ON(atomic_read(&transaction->use_count) == 0);
@@ -50,13 +73,6 @@ static noinline void switch_commit_root(struct btrfs_root *root)
 	root->commit_root = btrfs_root_node(root);
 }
 
-static inline int can_join_transaction(struct btrfs_transaction *trans,
-				       unsigned int type)
-{
-	return !(trans->in_commit &&
-		 (type & TRANS_EXTWRITERS));
-}
-
 static inline void extwriter_counter_inc(struct btrfs_transaction *trans,
 					 unsigned int type)
 {
@@ -98,26 +114,13 @@ loop:
 		return -EROFS;
 	}
 
-	if (fs_info->trans_no_join) {
-		/* 
-		 * If we are JOIN_NOLOCK we're already committing a current
-		 * transaction, we just need a handle to deal with something
-		 * when committing the transaction, such as inode cache and
-		 * space cache. It is a special case.
-		 */
-		if (type != TRANS_JOIN_NOLOCK) {
-			spin_unlock(&fs_info->trans_lock);
-			return -EBUSY;
-		}
-	}
-
 	cur_trans = fs_info->running_transaction;
 	if (cur_trans) {
 		if (cur_trans->aborted) {
 			spin_unlock(&fs_info->trans_lock);
 			return cur_trans->aborted;
 		}
-		if (!can_join_transaction(cur_trans, type)) {
+		if (btrfs_blocked_trans_types[cur_trans->state] & type) {
 			spin_unlock(&fs_info->trans_lock);
 			return -EBUSY;
 		}
@@ -136,6 +139,12 @@ loop:
 	if (type == TRANS_ATTACH)
 		return -ENOENT;
 
+	/*
+	 * JOIN_NOLOCK only happens during the transaction commit, so
+	 * it is impossible that ->running_transaction is NULL
+	 */
+	BUG_ON(type == TRANS_JOIN_NOLOCK);
+
 	cur_trans = kmem_cache_alloc(btrfs_transaction_cachep, GFP_NOFS);
 	if (!cur_trans)
 		return -ENOMEM;
@@ -144,7 +153,7 @@ loop:
 	if (fs_info->running_transaction) {
 		/*
 		 * someone started a transaction after we unlocked.  Make sure
-		 * to redo the trans_no_join checks above
+		 * to redo the checks above
 		 */
 		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
 		goto loop;
@@ -158,14 +167,12 @@ loop:
 	extwriter_counter_init(cur_trans, type);
 	init_waitqueue_head(&cur_trans->writer_wait);
 	init_waitqueue_head(&cur_trans->commit_wait);
-	cur_trans->in_commit = 0;
-	cur_trans->blocked = 0;
+	cur_trans->state = TRANS_STATE_RUNNING;
 	/*
 	 * One for this trans handle, one so it will live on until we
 	 * commit the transaction.
 	 */
 	atomic_set(&cur_trans->use_count, 2);
-	cur_trans->commit_done = 0;
 	cur_trans->start_time = get_seconds();
 
 	cur_trans->delayed_refs.root = RB_ROOT;
@@ -188,7 +195,6 @@ loop:
 			"creating a fresh transaction\n");
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 
-	spin_lock_init(&cur_trans->commit_lock);
 	spin_lock_init(&cur_trans->delayed_refs.lock);
 	atomic_set(&cur_trans->delayed_refs.procs_running_refs, 0);
 	atomic_set(&cur_trans->delayed_refs.ref_seq, 0);
@@ -293,6 +299,12 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static inline int is_transaction_blocked(struct btrfs_transaction *trans)
+{
+	return (trans->state >= TRANS_STATE_BLOCKED &&
+		trans->state < TRANS_STATE_UNBLOCKED);
+}
+
 /* wait for commit against the current transaction to become unblocked
  * when this is done, it is safe to start a new transaction, but the current
  * transaction might not be fully on disk.
@@ -303,12 +315,12 @@ static void wait_current_trans(struct btrfs_root *root)
 
 	spin_lock(&root->fs_info->trans_lock);
 	cur_trans = root->fs_info->running_transaction;
-	if (cur_trans && cur_trans->blocked) {
+	if (cur_trans && is_transaction_blocked(cur_trans)) {
 		atomic_inc(&cur_trans->use_count);
 		spin_unlock(&root->fs_info->trans_lock);
 
 		wait_event(root->fs_info->transaction_wait,
-			   !cur_trans->blocked);
+			   cur_trans->state >= TRANS_STATE_UNBLOCKED);
 		put_transaction(cur_trans);
 	} else {
 		spin_unlock(&root->fs_info->trans_lock);
@@ -432,7 +444,8 @@ again:
 	INIT_LIST_HEAD(&h->new_bgs);
 
 	smp_mb();
-	if (cur_trans->blocked && may_wait_transaction(root, type)) {
+	if (cur_trans->state >= TRANS_STATE_BLOCKED &&
+	    may_wait_transaction(root, type)) {
 		btrfs_commit_transaction(h, root);
 		goto again;
 	}
@@ -536,7 +549,7 @@ btrfs_attach_transaction_barrier(struct btrfs_root *root)
 static noinline void wait_for_commit(struct btrfs_root *root,
 				    struct btrfs_transaction *commit)
 {
-	wait_event(commit->commit_wait, commit->commit_done);
+	wait_event(commit->commit_wait, commit->state == TRANS_STATE_COMPLETED);
 }
 
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
@@ -572,8 +585,8 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
 		spin_lock(&root->fs_info->trans_lock);
 		list_for_each_entry_reverse(t, &root->fs_info->trans_list,
 					    list) {
-			if (t->in_commit) {
-				if (t->commit_done)
+			if (t->state >= TRANS_STATE_COMMIT_START) {
+				if (t->state == TRANS_STATE_COMPLETED)
 					break;
 				cur_trans = t;
 				atomic_inc(&cur_trans->use_count);
@@ -614,7 +627,8 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 	int err;
 
 	smp_mb();
-	if (cur_trans->blocked || cur_trans->delayed_refs.flushing)
+	if (cur_trans->state >= TRANS_STATE_BLOCKED ||
+	    cur_trans->delayed_refs.flushing)
 		return 1;
 
 	updates = trans->delayed_ref_updates;
@@ -682,12 +696,12 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		btrfs_create_pending_block_groups(trans, root);
 
 	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
-	    should_end_transaction(trans, root)) {
-		trans->transaction->blocked = 1;
-		smp_wmb();
-	}
+	    should_end_transaction(trans, root) &&
+	    ACCESS_ONCE(cur_trans->state) == TRANS_STATE_RUNNING)
+		cmpxchg(&cur_trans->state, TRANS_STATE_RUNNING,
+			TRANS_STATE_BLOCKED);
 
-	if (lock && cur_trans->blocked && !cur_trans->in_commit) {
+	if (lock && ACCESS_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
 		if (throttle) {
 			/*
 			 * We may race with somebody else here so end up having
@@ -1343,20 +1357,26 @@ static void update_super_roots(struct btrfs_root *root)
 
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
 {
+	struct btrfs_transaction *trans;
 	int ret = 0;
+
 	spin_lock(&info->trans_lock);
-	if (info->running_transaction)
-		ret = info->running_transaction->in_commit;
+	trans = info->running_transaction;
+	if (trans)
+		ret = (trans->state >= TRANS_STATE_COMMIT_START);
 	spin_unlock(&info->trans_lock);
 	return ret;
 }
 
 int btrfs_transaction_blocked(struct btrfs_fs_info *info)
 {
+	struct btrfs_transaction *trans;
 	int ret = 0;
+
 	spin_lock(&info->trans_lock);
-	if (info->running_transaction)
-		ret = info->running_transaction->blocked;
+	trans = info->running_transaction;
+	if (trans)
+		ret = is_transaction_blocked(trans);
 	spin_unlock(&info->trans_lock);
 	return ret;
 }
@@ -1368,7 +1388,8 @@ int btrfs_transaction_blocked(struct btrfs_fs_info *info)
 static void wait_current_trans_commit_start(struct btrfs_root *root,
 					    struct btrfs_transaction *trans)
 {
-	wait_event(root->fs_info->transaction_blocked_wait, trans->in_commit);
+	wait_event(root->fs_info->transaction_blocked_wait,
+		   trans->state >= TRANS_STATE_COMMIT_START);
 }
 
 /*
@@ -1379,7 +1400,7 @@ static void wait_current_trans_commit_start_and_unblock(struct btrfs_root *root,
 					 struct btrfs_transaction *trans)
 {
 	wait_event(root->fs_info->transaction_wait,
-		   trans->commit_done || (trans->in_commit && !trans->blocked));
+		   trans->state >= TRANS_STATE_UNBLOCKED);
 }
 
 /*
@@ -1484,18 +1505,22 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 
 	list_del_init(&cur_trans->list);
 	if (cur_trans == root->fs_info->running_transaction) {
-		root->fs_info->trans_no_join = 1;
+		cur_trans->state = TRANS_STATE_COMMIT_DOING;
 		spin_unlock(&root->fs_info->trans_lock);
 		wait_event(cur_trans->writer_wait,
 			   atomic_read(&cur_trans->num_writers) == 1);
 
 		spin_lock(&root->fs_info->trans_lock);
-		root->fs_info->running_transaction = NULL;
 	}
 	spin_unlock(&root->fs_info->trans_lock);
 
 	btrfs_cleanup_one_transaction(trans->transaction, root);
 
+	spin_lock(&root->fs_info->trans_lock);
+	if (cur_trans == root->fs_info->running_transaction)
+		root->fs_info->running_transaction = NULL;
+	spin_unlock(&root->fs_info->trans_lock);
+
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
@@ -1507,10 +1532,6 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 		current->journal_info = NULL;
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
-
-	spin_lock(&root->fs_info->trans_lock);
-	root->fs_info->trans_no_join = 0;
-	spin_unlock(&root->fs_info->trans_lock);
 }
 
 static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
@@ -1554,13 +1575,6 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
 		btrfs_wait_all_ordered_extents(fs_info, 1);
 }
 
-/*
- * btrfs_transaction state sequence:
- *    in_commit = 0, blocked = 0  (initial)
- *    in_commit = 1, blocked = 1
- *    blocked = 0
- *    commit_done = 1
- */
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
@@ -1615,9 +1629,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	spin_lock(&cur_trans->commit_lock);
-	if (cur_trans->in_commit) {
-		spin_unlock(&cur_trans->commit_lock);
+	spin_lock(&root->fs_info->trans_lock);
+	if (cur_trans->state >= TRANS_STATE_COMMIT_START) {
+		spin_unlock(&root->fs_info->trans_lock);
 		atomic_inc(&cur_trans->use_count);
 		ret = btrfs_end_transaction(trans, root);
 
@@ -1628,16 +1642,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	trans->transaction->in_commit = 1;
-	trans->transaction->blocked = 1;
-	spin_unlock(&cur_trans->commit_lock);
+	cur_trans->state = TRANS_STATE_COMMIT_START;
 	wake_up(&root->fs_info->transaction_blocked_wait);
 
-	spin_lock(&root->fs_info->trans_lock);
 	if (cur_trans->list.prev != &root->fs_info->trans_list) {
 		prev_trans = list_entry(cur_trans->list.prev,
 					struct btrfs_transaction, list);
-		if (!prev_trans->commit_done) {
+		if (prev_trans->state != TRANS_STATE_COMPLETED) {
 			atomic_inc(&prev_trans->use_count);
 			spin_unlock(&root->fs_info->trans_lock);
 
@@ -1673,10 +1684,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	/*
 	 * Ok now we need to make sure to block out any other joins while we
 	 * commit the transaction.  We could have started a join before setting
-	 * no_join so make sure to wait for num_writers to == 1 again.
+	 * COMMIT_DOING so make sure to wait for num_writers to == 1 again.
 	 */
 	spin_lock(&root->fs_info->trans_lock);
-	root->fs_info->trans_no_join = 1;
+	cur_trans->state = TRANS_STATE_COMMIT_DOING;
 	spin_unlock(&root->fs_info->trans_lock);
 	wait_event(cur_trans->writer_wait,
 		   atomic_read(&cur_trans->num_writers) == 1);
@@ -1803,10 +1814,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	memcpy(root->fs_info->super_for_commit, root->fs_info->super_copy,
 	       sizeof(*root->fs_info->super_copy));
 
-	trans->transaction->blocked = 0;
 	spin_lock(&root->fs_info->trans_lock);
+	cur_trans->state = TRANS_STATE_UNBLOCKED;
 	root->fs_info->running_transaction = NULL;
-	root->fs_info->trans_no_join = 0;
 	spin_unlock(&root->fs_info->trans_lock);
 	mutex_unlock(&root->fs_info->reloc_mutex);
 
@@ -1834,10 +1844,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_finish_extent_commit(trans, root);
 
-	cur_trans->commit_done = 1;
-
 	root->fs_info->last_trans_committed = cur_trans->transid;
-
+	/*
+	 * We needn't acquire the lock here because there is no other task
+	 * which can change it.
+	 */
+	cur_trans->state = TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
 
 	spin_lock(&root->fs_info->trans_lock);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 0fc45e2..66d2a6c 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -22,6 +22,16 @@
 #include "delayed-ref.h"
 #include "ctree.h"
 
+enum btrfs_trans_state {
+	TRANS_STATE_RUNNING		= 0,
+	TRANS_STATE_BLOCKED		= 1,
+	TRANS_STATE_COMMIT_START	= 2,
+	TRANS_STATE_COMMIT_DOING	= 3,
+	TRANS_STATE_UNBLOCKED		= 4,
+	TRANS_STATE_COMPLETED		= 5,
+	TRANS_STATE_MAX			= 6,
+};
+
 struct btrfs_transaction {
 	u64 transid;
 	/*
@@ -37,10 +47,8 @@ struct btrfs_transaction {
 	atomic_t num_writers;
 	atomic_t use_count;
 
-	spinlock_t commit_lock;
-	int in_commit;
-	int commit_done;
-	int blocked;
+	/* Be protected by fs_info->trans_lock when we want to change it. */
+	enum btrfs_trans_state state;
 	struct list_head list;
 	struct extent_io_tree dirty_pages;
 	unsigned long start_time;
-- 
1.8.1.4

