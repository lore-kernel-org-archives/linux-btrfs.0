Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55425 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbeDSIGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 04:06:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2310AAE9F
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 08:06:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Drop add_delayed_ref_head fs_info parameter
Date: Thu, 19 Apr 2018 11:06:37 +0300
Message-Id: <1524125199-5435-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the transaction handle

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e9a624196295..c0608cbf1354 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -532,8 +532,7 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
  * overall modification count.
  */
 static noinline struct btrfs_delayed_ref_head *
-add_delayed_ref_head(struct btrfs_fs_info *fs_info,
-		     struct btrfs_trans_handle *trans,
+add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		     struct btrfs_delayed_ref_head *head_ref,
 		     struct btrfs_qgroup_extent_record *qrecord,
 		     u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
@@ -603,14 +602,14 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		qrecord->num_bytes = num_bytes;
 		qrecord->old_roots = NULL;
 
-		if(btrfs_qgroup_trace_extent_nolock(fs_info,
+		if(btrfs_qgroup_trace_extent_nolock(trans->fs_info,
 					delayed_refs, qrecord))
 			kfree(qrecord);
 		else
 			qrecord_inserted = 1;
 	}
 
-	trace_add_delayed_ref_head(fs_info, head_ref, action);
+	trace_add_delayed_ref_head(trans->fs_info, head_ref, action);
 
 	existing = htree_insert(&delayed_refs->href_root,
 				&head_ref->href_node);
@@ -795,8 +794,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(fs_info, trans, head_ref, record,
-					bytenr, num_bytes, 0, 0, action, 0,
+	head_ref = add_delayed_ref_head(trans, head_ref, record, bytenr,
+					num_bytes, 0, 0, action, 0,
 					&qrecord_inserted, old_ref_mod,
 					new_ref_mod);
 
@@ -863,8 +862,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(fs_info, trans, head_ref, record,
-					bytenr, num_bytes, ref_root, reserved,
+	head_ref = add_delayed_ref_head(trans, head_ref, record, bytenr,
+					num_bytes, ref_root, reserved,
 					action, 1, &qrecord_inserted,
 					old_ref_mod, new_ref_mod);
 
@@ -895,9 +894,8 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	add_delayed_ref_head(fs_info, trans, head_ref, NULL, bytenr,
-			     num_bytes, 0, 0, BTRFS_UPDATE_DELAYED_HEAD,
-			     extent_op->is_data, NULL, NULL, NULL);
+	add_delayed_ref_head(trans, head_ref, NULL, bytenr, num_bytes, 0, 0,
+			     BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data, NULL, NULL, NULL);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
-- 
2.7.4

