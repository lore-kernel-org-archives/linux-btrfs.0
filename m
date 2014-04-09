Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29227 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbaDIHKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 03:10:05 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v9 16/16] Btrfs: fix dedup enospc problem
Date: Wed,  9 Apr 2014 15:08:44 +0800
Message-Id: <1397027325-27151-17-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
References: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the case of dedupe, btrfs will produce large number of delayed refs, and
processing them can very likely eat all of the space reserved in
global_block_rsv, and we'll end up with transaction abortion due to ENOSPC.

I tried several different ways to reserve more space for global_block_rsv to
hope it's enough for flushing delayed refs, but I failed and code could
become very messy.

I found that with high delayed refs pressure, the throttle work in the
end_transaction had little use since it didn't block new delayed refs'
insertion, so I put throttle stuff into the very start stage,
i.e. start_transaction.

We take the worst case into account in the throttle code, that is,
every delayed_refs would update btree, so when we reach the limit that
it may use up all the reserved space of global_block_rsv, we kick
transaction_kthread to commit transaction to process these delayed refs,
refresh global_block_rsv's space, and get pinned space back as well.
That way we get rid of annoy ENOSPC problem.

However, this leads to a new problem that it cannot use along with option
"flushoncommit", otherwise it can cause ABBA deadlock between
commit_transaction between ordered extents flush.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c  | 50 ++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/ordered-data.c |  6 ++++++
 fs/btrfs/transaction.c  | 41 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.h  |  1 +
 4 files changed, 87 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6f8b012..ec6f42d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2695,24 +2695,52 @@ static inline u64 heads_to_leaves(struct btrfs_root *root, u64 heads)
 int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 				       struct btrfs_root *root)
 {
+	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_block_rsv *global_rsv;
-	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
+	u64 num_heads;
+	u64 num_entries;
 	u64 num_bytes;
 	int ret = 0;
 
-	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
-	num_heads = heads_to_leaves(root, num_heads);
-	if (num_heads > 1)
-		num_bytes += (num_heads - 1) * root->leafsize;
-	num_bytes <<= 1;
 	global_rsv = &root->fs_info->global_block_rsv;
 
-	/*
-	 * If we can't allocate any more chunks lets make sure we have _lots_ of
-	 * wiggle room since running delayed refs can create more delayed refs.
-	 */
-	if (global_rsv->space_info->full)
+	if (trans) {
+		num_heads = trans->transaction->delayed_refs.num_heads_ready;
+		num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+		num_heads = heads_to_leaves(root, num_heads);
+		if (num_heads > 1)
+			num_bytes += (num_heads - 1) * root->leafsize;
 		num_bytes <<= 1;
+		/*
+		 * If we can't allocate any more chunks lets make sure we have
+		 * _lots_ of wiggle room since running delayed refs can create
+		 * more delayed refs.
+		 */
+		if (global_rsv->space_info->full)
+			num_bytes <<= 1;
+	} else {
+		if (root->fs_info->dedup_bs == 0)
+			return 0;
+
+		/* dedup enabled */
+		spin_lock(&root->fs_info->trans_lock);
+		if (!root->fs_info->running_transaction) {
+			spin_unlock(&root->fs_info->trans_lock);
+			return 0;
+		}
+
+		delayed_refs =
+			 &root->fs_info->running_transaction->delayed_refs;
+
+		num_entries = atomic_read(&delayed_refs->num_entries);
+		num_heads = delayed_refs->num_heads;
+
+		spin_unlock(&root->fs_info->trans_lock);
+
+		/* The worst case */
+		num_bytes = (num_entries - num_heads) *
+					btrfs_calc_trans_metadata_size(root, 1);
+	}
 
 	spin_lock(&global_rsv->lock);
 	if (global_rsv->reserved <= num_bytes)
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index c520e13..72c0caa 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -747,6 +747,12 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 				      &cur_trans->ordered_operations);
 		spin_unlock(&root->fs_info->ordered_root_lock);
 
+		if (cur_trans->blocked) {
+			cur_trans->blocked = 0;
+			if (waitqueue_active(&cur_trans->commit_wait))
+				wake_up(&cur_trans->commit_wait);
+		}
+
 		work = btrfs_alloc_delalloc_work(inode, wait, 1);
 		if (!work) {
 			spin_lock(&root->fs_info->ordered_root_lock);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a04707f..9937eb2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -215,6 +215,7 @@ loop:
 	cur_trans->transid = fs_info->generation;
 	fs_info->running_transaction = cur_trans;
 	cur_trans->aborted = 0;
+	cur_trans->blocked = 1;
 	spin_unlock(&fs_info->trans_lock);
 
 	return 0;
@@ -329,6 +330,27 @@ static void wait_current_trans(struct btrfs_root *root)
 		wait_event(root->fs_info->transaction_wait,
 			   cur_trans->state >= TRANS_STATE_UNBLOCKED ||
 			   cur_trans->aborted);
+
+		btrfs_put_transaction(cur_trans);
+	} else {
+		spin_unlock(&root->fs_info->trans_lock);
+	}
+}
+
+static noinline void wait_current_trans_for_commit(struct btrfs_root *root)
+{
+	struct btrfs_transaction *cur_trans;
+
+	spin_lock(&root->fs_info->trans_lock);
+	cur_trans = root->fs_info->running_transaction;
+	if (cur_trans && is_transaction_blocked(cur_trans)) {
+		atomic_inc(&cur_trans->use_count);
+		spin_unlock(&root->fs_info->trans_lock);
+
+		wait_event(cur_trans->commit_wait,
+			   cur_trans->state >= TRANS_STATE_COMPLETED ||
+			   cur_trans->aborted || cur_trans->blocked == 0);
+
 		btrfs_put_transaction(cur_trans);
 	} else {
 		spin_unlock(&root->fs_info->trans_lock);
@@ -436,6 +458,25 @@ again:
 	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
 
+	/*
+	 * In the case of dedupe, we need to throttle delayed refs at the
+	 * very start stage, otherwise we'd run into ENOSPC because more
+	 * delayed refs are added while processing delayed refs.
+	 */
+	if (root->fs_info->dedup_bs > 0 && type == TRANS_JOIN &&
+	    btrfs_check_space_for_delayed_refs(NULL, root)) {
+		struct btrfs_transaction *cur_trans;
+
+		spin_lock(&root->fs_info->trans_lock);
+		cur_trans = root->fs_info->running_transaction;
+		if (cur_trans && cur_trans->state == TRANS_STATE_RUNNING)
+			cur_trans->state = TRANS_STATE_BLOCKED;
+		spin_unlock(&root->fs_info->trans_lock);
+
+		wake_up_process(root->fs_info->transaction_kthread);
+		wait_current_trans_for_commit(root);
+	}
+
 	do {
 		ret = join_transaction(root, type);
 		if (ret == -EBUSY) {
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 6ac037e..ac58d43 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -59,6 +59,7 @@ struct btrfs_transaction {
 	struct list_head pending_chunks;
 	struct btrfs_delayed_ref_root delayed_refs;
 	int aborted;
+	int blocked;
 };
 
 #define __TRANS_FREEZABLE	(1U << 0)
-- 
1.8.2.1

