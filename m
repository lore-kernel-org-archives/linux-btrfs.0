Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48885 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751545AbeCUIpS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 04:45:18 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3FB0AC69
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 08:45:17 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/8] btrfs: Use init_delayed_ref_head in add_delayed_ref_head
Date: Wed, 21 Mar 2018 10:45:11 +0200
Message-Id: <1521621912-25065-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1521621912-25065-1-git-send-email-nborisov@suse.com>
References: <1521621912-25065-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the newly introduced function when initialising the head_ref in
add_delayed_ref_head. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 62 ++++----------------------------------------------
 1 file changed, 4 insertions(+), 58 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 47b1a534f95f..0198d2e3ec05 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -625,68 +625,14 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_delayed_ref_head *existing;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int count_mod = 1;
-	int must_insert_reserved = 0;
 	int qrecord_inserted = 0;
 
-	/* If reserved is provided, it must be a data extent. */
-	BUG_ON(!is_data && reserved);
-
-	/*
-	 * the head node stores the sum of all the mods, so dropping a ref
-	 * should drop the sum in the head node by one.
-	 */
-	if (action == BTRFS_UPDATE_DELAYED_HEAD)
-		count_mod = 0;
-	else if (action == BTRFS_DROP_DELAYED_REF)
-		count_mod = -1;
-
-	/*
-	 * BTRFS_ADD_DELAYED_EXTENT means that we need to update
-	 * the reserved accounting when the extent is finally added, or
-	 * if a later modification deletes the delayed ref without ever
-	 * inserting the extent into the extent allocation tree.
-	 * ref->must_insert_reserved is the flag used to record
-	 * that accounting mods are required.
-	 *
-	 * Once we record must_insert_reserved, switch the action to
-	 * BTRFS_ADD_DELAYED_REF because other special casing is not required.
-	 */
-	if (action == BTRFS_ADD_DELAYED_EXTENT)
-		must_insert_reserved = 1;
-	else
-		must_insert_reserved = 0;
-
 	delayed_refs = &trans->transaction->delayed_refs;
-
-	refcount_set(&head_ref->refs, 1);
-	head_ref->bytenr = bytenr;
-	head_ref->num_bytes = num_bytes;
-	head_ref->ref_mod = count_mod;
-	head_ref->must_insert_reserved = must_insert_reserved;
-	head_ref->is_data = is_data;
-	head_ref->ref_tree = RB_ROOT;
-	INIT_LIST_HEAD(&head_ref->ref_add_list);
-	RB_CLEAR_NODE(&head_ref->href_node);
-	head_ref->processing = 0;
-	head_ref->total_ref_mod = count_mod;
-	head_ref->qgroup_reserved = 0;
-	head_ref->qgroup_ref_root = 0;
-	spin_lock_init(&head_ref->lock);
-	mutex_init(&head_ref->mutex);
-
+	init_delayed_ref_head(head_ref, qrecord, bytenr, num_bytes, ref_root,
+			      reserved, action, is_data);
 	/* Record qgroup extent info if provided */
 	if (qrecord) {
-		if (ref_root && reserved) {
-			head_ref->qgroup_ref_root = ref_root;
-			head_ref->qgroup_reserved = reserved;
-		}
-
-		qrecord->bytenr = bytenr;
-		qrecord->num_bytes = num_bytes;
-		qrecord->old_roots = NULL;
-
-		if(btrfs_qgroup_trace_extent_nolock(trans->fs_info,
+		if (btrfs_qgroup_trace_extent_nolock(trans->fs_info,
 					delayed_refs, qrecord))
 			kfree(qrecord);
 		else
@@ -711,7 +657,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	} else {
 		if (old_ref_mod)
 			*old_ref_mod = 0;
-		if (is_data && count_mod < 0)
+		if (is_data && head_ref->ref_mod < 0)
 			delayed_refs->pending_csums += num_bytes;
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
-- 
2.7.4

