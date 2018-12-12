Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAA8C6783B
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 00:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31C1320849
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 00:40:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31C1320849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbeLLAkJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 19:40:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:57838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726271AbeLLAkI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 19:40:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B6A95AE43
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 00:40:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/7] btrfs: qgroup: Don't trigger backref walk at delayed ref insert time
Date:   Wed, 12 Dec 2018 08:39:48 +0800
Message-Id: <20181212003953.5643-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212003953.5643-1-wqu@suse.com>
References: <20181212003953.5643-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
Since fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting
time out of commit trans"), kernel may lockup with quota enabled.

There is one backref trace triggered by snapshot dropping along with
write operation in the source subvolume.
The example can be stably reproduced.

  btrfs-cleaner   D    0  4062      2 0x80000000
  Call Trace:
   schedule+0x32/0x90
   btrfs_tree_read_lock+0x93/0x130 [btrfs]
   find_parent_nodes+0x29b/0x1170 [btrfs]
   btrfs_find_all_roots_safe+0xa8/0x120 [btrfs]
   btrfs_find_all_roots+0x57/0x70 [btrfs]
   btrfs_qgroup_trace_extent_post+0x37/0x70 [btrfs]
   btrfs_qgroup_trace_leaf_items+0x10b/0x140 [btrfs]
   btrfs_qgroup_trace_subtree+0xc8/0xe0 [btrfs]
   do_walk_down+0x541/0x5e3 [btrfs]
   walk_down_tree+0xab/0xe7 [btrfs]
   btrfs_drop_snapshot+0x356/0x71a [btrfs]
   btrfs_clean_one_deleted_snapshot+0xb8/0xf0 [btrfs]
   cleaner_kthread+0x12b/0x160 [btrfs]
   kthread+0x112/0x130
   ret_from_fork+0x27/0x50

[CAUSE]
When dropping snapshots with qgroup enabled, we will trigger backref
walk.

However such backref walk at that timing is pretty dangerous, as if one
of the parent nodes get WRITE locked by other thread, we could cause a
dead lock.

For example:

           FS 260     FS 261 (Dropped)
            node A        node B
           /      \      /      \
       node C      node D      node E
      /   \         /  \        /     \
  leaf F|leaf G|leaf H|leaf I|leaf J|leaf K

The lock sequence would be:

      Thread A (cleaner)             |       Thread B (other writer)
-----------------------------------------------------------------------
write_lock(B)                        |
write_lock(D)                        |
^^^ called by walk_down_tree()       |
                                     |       write_lock(A)
                                     |       write_lock(D) << Stall
read_lock(H) << for backref walk     |
read_lock(D) << lock owner is        |
                the same thread A    |
                so read lock is OK   |
read_lock(A) << Stall                |

So thread A hold write lock D, and needs read lock A to unlock.
While thread B holds write lock A, while needs lock D to unlock.

This will cause a dead lock.

This is not only limited to snapshot dropping case.
As the backref walk, even only happens on commit trees, is breaking the
normal top-down locking order, makes it deadlock prone.

[FIX]
The solution is not to trigger backref walk with any write lock hold.
This means we can't do backref walk at delayed ref insert time.

So this patch will mostly revert commit fb235dc06fac ("btrfs: qgroup:
Move half of the qgroup accounting time out of commit trans").

Reported-by: David Sterba <dsterba@suse.cz>
Reported-by: Filipe Manana <fdmanana@suse.com>
Fixes: fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting time out of commit trans")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-ref.c | 24 ++++--------------------
 fs/btrfs/qgroup.c      | 39 +++------------------------------------
 fs/btrfs/qgroup.h      | 30 ++----------------------------
 3 files changed, 9 insertions(+), 84 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 7e74bf42f2db..2fc7936a377f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -604,12 +604,10 @@ static noinline struct btrfs_delayed_ref_head *
 add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		     struct btrfs_delayed_ref_head *head_ref,
 		     struct btrfs_qgroup_extent_record *qrecord,
-		     int action, int *qrecord_inserted_ret,
-		     int *old_ref_mod, int *new_ref_mod)
+		     int action, int *old_ref_mod, int *new_ref_mod)
 {
 	struct btrfs_delayed_ref_head *existing;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int qrecord_inserted = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
@@ -618,8 +616,6 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		if (btrfs_qgroup_trace_extent_nolock(trans->fs_info,
 					delayed_refs, qrecord))
 			kfree(qrecord);
-		else
-			qrecord_inserted = 1;
 	}
 
 	trace_add_delayed_ref_head(trans->fs_info, head_ref, action);
@@ -645,8 +641,6 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		atomic_inc(&delayed_refs->num_entries);
 		trans->delayed_ref_updates++;
 	}
-	if (qrecord_inserted_ret)
-		*qrecord_inserted_ret = qrecord_inserted;
 	if (new_ref_mod)
 		*new_ref_mod = head_ref->total_ref_mod;
 
@@ -720,7 +714,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
-	int qrecord_inserted;
 	bool is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
 	int ret;
 	u8 ref_type;
@@ -769,8 +762,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	 * the spin lock
 	 */
 	head_ref = add_delayed_ref_head(trans, head_ref, record,
-					action, &qrecord_inserted,
-					old_ref_mod, new_ref_mod);
+					action, old_ref_mod, new_ref_mod);
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
 	spin_unlock(&delayed_refs->lock);
@@ -781,9 +773,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	if (ret > 0)
 		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
 
-	if (qrecord_inserted)
-		btrfs_qgroup_trace_extent_post(fs_info, record);
-
 	return 0;
 }
 
@@ -801,7 +790,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
-	int qrecord_inserted;
 	int ret;
 	u8 ref_type;
 
@@ -850,8 +838,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	 * the spin lock
 	 */
 	head_ref = add_delayed_ref_head(trans, head_ref, record,
-					action, &qrecord_inserted,
-					old_ref_mod, new_ref_mod);
+					action, old_ref_mod, new_ref_mod);
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
 	spin_unlock(&delayed_refs->lock);
@@ -862,9 +849,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	if (ret > 0)
 		kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
 
-
-	if (qrecord_inserted)
-		return btrfs_qgroup_trace_extent_post(fs_info, record);
 	return 0;
 }
 
@@ -889,7 +873,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	spin_lock(&delayed_refs->lock);
 
 	add_delayed_ref_head(trans, head_ref, NULL, BTRFS_UPDATE_DELAYED_HEAD,
-			     NULL, NULL, NULL);
+			     NULL, NULL);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0a66f619103d..8729492ac10f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1559,33 +1559,6 @@ int btrfs_qgroup_trace_extent_nolock(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
-				   struct btrfs_qgroup_extent_record *qrecord)
-{
-	struct ulist *old_root;
-	u64 bytenr = qrecord->bytenr;
-	int ret;
-
-	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, false);
-	if (ret < 0) {
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-		btrfs_warn(fs_info,
-"error accounting new delayed refs extent (err code: %d), quota inconsistent",
-			ret);
-		return 0;
-	}
-
-	/*
-	 * Here we don't need to get the lock of
-	 * trans->transaction->delayed_refs, since inserted qrecord won't
-	 * be deleted, only qrecord->node may be modified (new qrecord insert)
-	 *
-	 * So modifying qrecord->old_roots is safe here
-	 */
-	qrecord->old_roots = old_root;
-	return 0;
-}
-
 int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 			      u64 num_bytes, gfp_t gfp_flag)
 {
@@ -1609,11 +1582,9 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 	spin_lock(&delayed_refs->lock);
 	ret = btrfs_qgroup_trace_extent_nolock(fs_info, delayed_refs, record);
 	spin_unlock(&delayed_refs->lock);
-	if (ret > 0) {
+	if (ret > 0)
 		kfree(record);
-		return 0;
-	}
-	return btrfs_qgroup_trace_extent_post(fs_info, record);
+	return 0;
 }
 
 int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
@@ -2563,11 +2534,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 		trace_btrfs_qgroup_account_extents(fs_info, record);
 
 		if (!ret) {
-			/*
-			 * Old roots should be searched when inserting qgroup
-			 * extent record
-			 */
-			if (WARN_ON(!record->old_roots)) {
+			if (!record->old_roots) {
 				/* Search commit root to find old_roots */
 				ret = btrfs_find_all_roots(NULL, fs_info,
 						record->bytenr, 0,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index fd26fddacd90..a4de5065de4b 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -174,8 +174,7 @@ struct btrfs_delayed_extent_op;
  * Inform qgroup to trace one dirty extent, its info is recorded in @record.
  * So qgroup can account it at transaction committing time.
  *
- * No lock version, caller must acquire delayed ref lock and allocated memory,
- * then call btrfs_qgroup_trace_extent_post() after exiting lock context.
+ * No lock version, caller must acquire delayed ref lock and allocate memory,
  *
  * Return 0 for success insert
  * Return >0 for existing record, caller can free @record safely.
@@ -186,37 +185,12 @@ int btrfs_qgroup_trace_extent_nolock(
 		struct btrfs_delayed_ref_root *delayed_refs,
 		struct btrfs_qgroup_extent_record *record);
 
-/*
- * Post handler after qgroup_trace_extent_nolock().
- *
- * NOTE: Current qgroup does the expensive backref walk at transaction
- * committing time with TRANS_STATE_COMMIT_DOING, this blocks incoming
- * new transaction.
- * This is designed to allow btrfs_find_all_roots() to get correct new_roots
- * result.
- *
- * However for old_roots there is no need to do backref walk at that time,
- * since we search commit roots to walk backref and result will always be
- * correct.
- *
- * Due to the nature of no lock version, we can't do backref there.
- * So we must call btrfs_qgroup_trace_extent_post() after exiting
- * spinlock context.
- *
- * TODO: If we can fix and prove btrfs_find_all_roots() can get correct result
- * using current root, then we can move all expensive backref walk out of
- * transaction committing, but not now as qgroup accounting will be wrong again.
- */
-int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
-				   struct btrfs_qgroup_extent_record *qrecord);
-
 /*
  * Inform qgroup to trace one dirty extent, specified by @bytenr and
  * @num_bytes.
  * So qgroup can account it at commit trans time.
  *
- * Better encapsulated version, with memory allocation and backref walk for
- * commit roots.
+ * Better encapsulated version, with memory allocation
  * So this can sleep.
  *
  * Return 0 if the operation is done.
-- 
2.19.2

