Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751548AbeCUIpT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 04:45:19 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 03FEEAE39
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 08:45:18 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 8/8] btrfs: split delayed ref head initialization and addition
Date: Wed, 21 Mar 2018 10:45:12 +0200
Message-Id: <1521621912-25065-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1521621912-25065-1-git-send-email-nborisov@suse.com>
References: <1521621912-25065-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_delayed_ref_head really performed 2 independent operations -
initialisting the ref head and adding it to a list. Now that the init
part is in a separate function let's complete the separation between
both operations. This results in a lot simpler interface for
add_delayed_ref_head since the function now deals solely with either
adding the newly initialised delayed ref head or merging it into an
existing delayed ref head. This results in vastly simplified function
signature since 5 arguments are dropped. The only other thing worth
mentioning is that due to this split the WARN_ON catching reinit of
existing. In this patch the condition is extended such that:

  qrecord && head_ref->qgroup_ref_root && head_ref->qgroup_reserved

is added. This is done because the two qgroup_* prefixed member are
set only if both ref_root and reserved are passed. So functionally
it's equivalent to the old WARN_ON and allows to remove the two args
from add_delayed_ref_head.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 0198d2e3ec05..227c1336cc02 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -619,8 +619,7 @@ static noinline struct btrfs_delayed_ref_head *
 add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		     struct btrfs_delayed_ref_head *head_ref,
 		     struct btrfs_qgroup_extent_record *qrecord,
-		     u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
-		     int action, int is_data, int *qrecord_inserted_ret,
+		     int action, int *qrecord_inserted_ret,
 		     int *old_ref_mod, int *new_ref_mod)
 {
 	struct btrfs_delayed_ref_head *existing;
@@ -628,8 +627,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	int qrecord_inserted = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	init_delayed_ref_head(head_ref, qrecord, bytenr, num_bytes, ref_root,
-			      reserved, action, is_data);
+
 	/* Record qgroup extent info if provided */
 	if (qrecord) {
 		if (btrfs_qgroup_trace_extent_nolock(trans->fs_info,
@@ -644,7 +642,9 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	existing = htree_insert(&delayed_refs->href_root,
 				&head_ref->href_node);
 	if (existing) {
-		WARN_ON(ref_root && reserved && existing->qgroup_ref_root
+		WARN_ON(qrecord && head_ref->qgroup_ref_root
+			&& head_ref->qgroup_reserved
+			&& existing->qgroup_ref_root
 			&& existing->qgroup_reserved);
 		update_existing_head_ref(delayed_refs, existing, head_ref,
 					 old_ref_mod);
@@ -657,8 +657,8 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	} else {
 		if (old_ref_mod)
 			*old_ref_mod = 0;
-		if (is_data && head_ref->ref_mod < 0)
-			delayed_refs->pending_csums += num_bytes;
+		if (head_ref->is_data && head_ref->ref_mod < 0)
+			delayed_refs->pending_csums += head_ref->num_bytes;
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
 		atomic_inc(&delayed_refs->num_entries);
@@ -668,6 +668,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		*qrecord_inserted_ret = qrecord_inserted;
 	if (new_ref_mod)
 		*new_ref_mod = head_ref->total_ref_mod;
+
 	return head_ref;
 }
 
@@ -769,6 +770,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			goto free_head_ref;
 	}
 
+	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
+			      ref_root, 0, action, false);
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -778,11 +781,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(trans, head_ref, record, bytenr,
-					num_bytes, 0, 0, action, 0,
-					&qrecord_inserted, old_ref_mod,
-					new_ref_mod);
-
+	head_ref = add_delayed_ref_head(trans, head_ref, record,
+					action, &qrecord_inserted,
+					old_ref_mod, new_ref_mod);
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
 	spin_unlock(&delayed_refs->lock);
@@ -857,6 +858,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		}
 	}
 
+	init_delayed_ref_head(head_ref, record, bytenr, num_bytes, ref_root,
+			      reserved, action, true);
 	head_ref->extent_op = NULL;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -866,9 +869,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(trans, head_ref, record, bytenr,
-					num_bytes, ref_root, reserved,
-					action, 1, &qrecord_inserted,
+	head_ref = add_delayed_ref_head(trans, head_ref, record,
+					action, &qrecord_inserted,
 					old_ref_mod, new_ref_mod);
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
@@ -898,13 +900,15 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	if (!head_ref)
 		return -ENOMEM;
 
+	init_delayed_ref_head(head_ref, NULL, bytenr, num_bytes, 0, 0,
+			      BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data);
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	add_delayed_ref_head(trans, head_ref, NULL, bytenr, num_bytes, 0, 0,
-			     BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data, NULL, NULL, NULL);
+	add_delayed_ref_head(trans, head_ref, NULL, BTRFS_UPDATE_DELAYED_HEAD,
+			     NULL, NULL, NULL);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
-- 
2.7.4

