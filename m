Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab3EOHss (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:48 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 13/17] Btrfs: don't wait for all the writers circularly during the transaction commit
Date: Wed, 15 May 2013 15:48:27 +0800
Message-Id: <1368604111-25073-14-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_commit_transaction has the following loop before we commit the
transaction.

do {
    // attempt to do some useful stuff and/or sleep
} while (atomic_read(&cur_trans->num_writers) > 1 ||
	 (should_grow && cur_trans->num_joined != joined));

This is used to prevent from the TRANS_START to get in the way of a
committing transaction. But it does not prevent from TRANS_JOIN, that
is we would do this loop for a long time if some writers JOIN the
current transaction endlessly.

Because we need join the current transaction to do some useful stuff,
we can not block TRANS_JOIN here. So we introduce a external writer
counter, which is used to count the TRANS_USERSPACE/TRANS_START writers.
If the external writer counter is zero, we can break the above loop.

In order to make the code more clear, we don't use enum variant
to define the type of the transaction handle, use bitmask instead.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 55 ++++++++++++++++++++++++++++++++++++++------------
 fs/btrfs/transaction.h | 31 ++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cf8706c..fd319b2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -51,17 +51,41 @@ static noinline void switch_commit_root(struct btrfs_root *root)
 }
 
 static inline int can_join_transaction(struct btrfs_transaction *trans,
-				       int type)
+				       unsigned int type)
 {
 	return !(trans->in_commit &&
-		 type != TRANS_JOIN &&
-		 type != TRANS_JOIN_NOLOCK);
+		 (type & TRANS_EXTWRITERS));
+}
+
+static inline void extwriter_counter_inc(struct btrfs_transaction *trans,
+					 unsigned int type)
+{
+	if (type & TRANS_EXTWRITERS)
+		atomic_inc(&trans->num_extwriters);
+}
+
+static inline void extwriter_counter_dec(struct btrfs_transaction *trans,
+					 unsigned int type)
+{
+	if (type & TRANS_EXTWRITERS)
+		atomic_dec(&trans->num_extwriters);
+}
+
+static inline void extwriter_counter_init(struct btrfs_transaction *trans,
+					  unsigned int type)
+{
+	atomic_set(&trans->num_extwriters, ((type & TRANS_EXTWRITERS) ? 1 : 0));
+}
+
+static inline int extwriter_counter_read(struct btrfs_transaction *trans)
+{
+	return atomic_read(&trans->num_extwriters);
 }
 
 /*
  * either allocate a new transaction or hop into the existing one
  */
-static noinline int join_transaction(struct btrfs_root *root, int type)
+static noinline int join_transaction(struct btrfs_root *root, unsigned int type)
 {
 	struct btrfs_transaction *cur_trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -99,6 +123,7 @@ loop:
 		}
 		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
+		extwriter_counter_inc(cur_trans, type);
 		cur_trans->num_joined++;
 		spin_unlock(&fs_info->trans_lock);
 		return 0;
@@ -131,6 +156,7 @@ loop:
 	}
 
 	atomic_set(&cur_trans->num_writers, 1);
+	extwriter_counter_init(cur_trans, type);
 	cur_trans->num_joined = 0;
 	init_waitqueue_head(&cur_trans->writer_wait);
 	init_waitqueue_head(&cur_trans->commit_wait);
@@ -307,7 +333,7 @@ static int may_wait_transaction(struct btrfs_root *root, int type)
 }
 
 static struct btrfs_trans_handle *
-start_transaction(struct btrfs_root *root, u64 num_items, int type,
+start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 		  enum btrfs_reserve_flush_enum flush)
 {
 	struct btrfs_trans_handle *h;
@@ -320,7 +346,7 @@ start_transaction(struct btrfs_root *root, u64 num_items, int type,
 		return ERR_PTR(-EROFS);
 
 	if (current->journal_info) {
-		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK);
+		WARN_ON(type & TRANS_EXTWRITERS);
 		h = current->journal_info;
 		h->use_count++;
 		WARN_ON(h->use_count > 2);
@@ -366,7 +392,7 @@ again:
 	 * If we are ATTACH, it means we just want to catch the current
 	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
 	 */
-	if (type < TRANS_JOIN_NOLOCK)
+	if (type & __TRANS_FREEZABLE)
 		sb_start_intwrite(root->fs_info->sb);
 
 	if (may_wait_transaction(root, type))
@@ -429,7 +455,7 @@ got_it:
 	return h;
 
 join_fail:
-	if (type < TRANS_JOIN_NOLOCK)
+	if (type & __TRANS_FREEZABLE)
 		sb_end_intwrite(root->fs_info->sb);
 	kmem_cache_free(btrfs_trans_handle_cachep, h);
 alloc_fail:
@@ -677,12 +703,13 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	if (trans->type < TRANS_JOIN_NOLOCK)
+	if (trans->type & __TRANS_FREEZABLE)
 		sb_end_intwrite(root->fs_info->sb);
 
 	WARN_ON(cur_trans != info->running_transaction);
 	WARN_ON(atomic_read(&cur_trans->num_writers) < 1);
 	atomic_dec(&cur_trans->num_writers);
+	extwriter_counter_dec(cur_trans, trans->type);
 
 	smp_mb();
 	if (waitqueue_active(&cur_trans->writer_wait))
@@ -1625,6 +1652,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		spin_unlock(&root->fs_info->trans_lock);
 	}
 
+	extwriter_counter_dec(cur_trans, trans->type);
+
 	if (!btrfs_test_opt(root, SSD) &&
 	    (now < cur_trans->start_time || now - cur_trans->start_time < 1))
 		should_grow = 1;
@@ -1641,13 +1670,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		prepare_to_wait(&cur_trans->writer_wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 
-		if (atomic_read(&cur_trans->num_writers) > 1)
-			schedule_timeout(MAX_SCHEDULE_TIMEOUT);
+		if (extwriter_counter_read(cur_trans) > 0)
+			schedule();
 		else if (should_grow)
 			schedule_timeout(1);
 
 		finish_wait(&cur_trans->writer_wait, &wait);
-	} while (atomic_read(&cur_trans->num_writers) > 1 ||
+	} while (extwriter_counter_read(cur_trans) > 0 ||
 		 (should_grow && cur_trans->num_joined != joined));
 
 	ret = btrfs_flush_all_pending_stuffs(trans, root);
@@ -1831,7 +1860,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
-	if (trans->type < TRANS_JOIN_NOLOCK)
+	if (trans->type & __TRANS_FREEZABLE)
 		sb_end_intwrite(root->fs_info->sb);
 
 	trace_btrfs_transaction_commit(root);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 24c9733..5cc77b0 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -25,6 +25,12 @@
 struct btrfs_transaction {
 	u64 transid;
 	/*
+	 * total external writers(USERSPACE/START/ATTACH) in this
+	 * transaction, it must be zero before the transaction is
+	 * being committed
+	 */
+	atomic_t num_extwriters;
+	/*
 	 * total writers in this transaction, it must be zero before the
 	 * transaction can end
 	 */
@@ -48,13 +54,22 @@ struct btrfs_transaction {
 	int aborted;
 };
 
-enum btrfs_trans_type {
-	TRANS_START,
-	TRANS_JOIN,
-	TRANS_USERSPACE,
-	TRANS_JOIN_NOLOCK,
-	TRANS_ATTACH,
-};
+#define __TRANS_FREEZABLE	(1U << 0)
+
+#define __TRANS_USERSPACE	(1U << 8)
+#define __TRANS_START		(1U << 9)
+#define __TRANS_ATTACH		(1U << 10)
+#define __TRANS_JOIN		(1U << 11)
+#define __TRANS_JOIN_NOLOCK	(1U << 12)
+
+#define TRANS_USERSPACE		(__TRANS_USERSPACE | __TRANS_FREEZABLE)
+#define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
+#define TRANS_ATTACH		(__TRANS_ATTACH)
+#define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
+#define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
+
+#define TRANS_EXTWRITERS	(__TRANS_USERSPACE | __TRANS_START |	\
+				 __TRANS_ATTACH)
 
 struct btrfs_trans_handle {
 	u64 transid;
@@ -70,7 +85,7 @@ struct btrfs_trans_handle {
 	short aborted;
 	short adding_csums;
 	bool allocating_chunk;
-	enum btrfs_trans_type type;
+	unsigned int type;
 	/*
 	 * this root is only needed to validate that the root passed to
 	 * start_transaction is the same as the one passed to end_transaction.
-- 
1.8.1.4

