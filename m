Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47086 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdCCJCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:24 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 02/17] fs, btrfs: convert btrfs_transaction.use_count from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:11 +0200
Message-Id: <1488531326-21271-3-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/disk-io.c      |  2 +-
 fs/btrfs/extent-tree.c  |  2 +-
 fs/btrfs/ordered-data.c |  2 +-
 fs/btrfs/transaction.c  | 20 ++++++++++----------
 fs/btrfs/transaction.h  |  3 ++-
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5f1b08c..dca6432 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4615,7 +4615,7 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
 		t = list_first_entry(&fs_info->trans_list,
 				     struct btrfs_transaction, list);
 		if (t->state >= TRANS_STATE_COMMIT_START) {
-			atomic_inc(&t->use_count);
+			refcount_inc(&t->use_count);
 			spin_unlock(&fs_info->trans_lock);
 			btrfs_wait_for_commit(fs_info, t->transid);
 			btrfs_put_transaction(t);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6079465..63ba295 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10849,7 +10849,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		spin_lock(&fs_info->trans_lock);
 		trans = fs_info->running_transaction;
 		if (trans)
-			atomic_inc(&trans->use_count);
+			refcount_inc(&trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
 		ret = find_free_dev_extent_start(trans, device, minlen, start,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 9a46878..da5399f 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -623,7 +623,7 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 		spin_lock(&fs_info->trans_lock);
 		trans = fs_info->running_transaction;
 		if (trans)
-			atomic_inc(&trans->use_count);
+			refcount_inc(&trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
 		ASSERT(trans);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 61b807d..a7d7a7d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -60,8 +60,8 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 
 void btrfs_put_transaction(struct btrfs_transaction *transaction)
 {
-	WARN_ON(atomic_read(&transaction->use_count) == 0);
-	if (atomic_dec_and_test(&transaction->use_count)) {
+	WARN_ON(refcount_read(&transaction->use_count) == 0);
+	if (refcount_dec_and_test(&transaction->use_count)) {
 		BUG_ON(!list_empty(&transaction->list));
 		WARN_ON(!RB_EMPTY_ROOT(&transaction->delayed_refs.href_root));
 		if (transaction->delayed_refs.pending_csums)
@@ -207,7 +207,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 			spin_unlock(&fs_info->trans_lock);
 			return -EBUSY;
 		}
-		atomic_inc(&cur_trans->use_count);
+		refcount_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		extwriter_counter_inc(cur_trans, type);
 		spin_unlock(&fs_info->trans_lock);
@@ -257,7 +257,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	 * One for this trans handle, one so it will live on until we
 	 * commit the transaction.
 	 */
-	atomic_set(&cur_trans->use_count, 2);
+	refcount_set(&cur_trans->use_count, 2);
 	atomic_set(&cur_trans->pending_ordered, 0);
 	cur_trans->flags = 0;
 	cur_trans->start_time = get_seconds();
@@ -432,7 +432,7 @@ static void wait_current_trans(struct btrfs_fs_info *fs_info)
 	spin_lock(&fs_info->trans_lock);
 	cur_trans = fs_info->running_transaction;
 	if (cur_trans && is_transaction_blocked(cur_trans)) {
-		atomic_inc(&cur_trans->use_count);
+		refcount_inc(&cur_trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
 		wait_event(fs_info->transaction_wait,
@@ -744,7 +744,7 @@ int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid)
 		list_for_each_entry(t, &fs_info->trans_list, list) {
 			if (t->transid == transid) {
 				cur_trans = t;
-				atomic_inc(&cur_trans->use_count);
+				refcount_inc(&cur_trans->use_count);
 				ret = 0;
 				break;
 			}
@@ -773,7 +773,7 @@ int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid)
 				if (t->state == TRANS_STATE_COMPLETED)
 					break;
 				cur_trans = t;
-				atomic_inc(&cur_trans->use_count);
+				refcount_inc(&cur_trans->use_count);
 				break;
 			}
 		}
@@ -1839,7 +1839,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 
 	/* take transaction reference */
 	cur_trans = trans->transaction;
-	atomic_inc(&cur_trans->use_count);
+	refcount_inc(&cur_trans->use_count);
 
 	btrfs_end_transaction(trans);
 
@@ -2015,7 +2015,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	spin_lock(&fs_info->trans_lock);
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START) {
 		spin_unlock(&fs_info->trans_lock);
-		atomic_inc(&cur_trans->use_count);
+		refcount_inc(&cur_trans->use_count);
 		ret = btrfs_end_transaction(trans);
 
 		wait_for_commit(cur_trans);
@@ -2035,7 +2035,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		prev_trans = list_entry(cur_trans->list.prev,
 					struct btrfs_transaction, list);
 		if (prev_trans->state != TRANS_STATE_COMPLETED) {
-			atomic_inc(&prev_trans->use_count);
+			refcount_inc(&prev_trans->use_count);
 			spin_unlock(&fs_info->trans_lock);
 
 			wait_for_commit(prev_trans);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5dfb559..2d9ad36 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -18,6 +18,7 @@
 
 #ifndef __BTRFS_TRANSACTION__
 #define __BTRFS_TRANSACTION__
+#include <linux/refcount.h>
 #include "btrfs_inode.h"
 #include "delayed-ref.h"
 #include "ctree.h"
@@ -49,7 +50,7 @@ struct btrfs_transaction {
 	 * transaction can end
 	 */
 	atomic_t num_writers;
-	atomic_t use_count;
+	refcount_t use_count;
 	atomic_t pending_ordered;
 
 	unsigned long flags;
-- 
2.7.4

