Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbeHOKbG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 06:31:06 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D92CEAEE1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 07:40:00 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: refactor __btrfs_run_delayed_refs loop
Date: Wed, 15 Aug 2018 10:39:56 +0300
Message-Id: <1534318796-23111-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1534318796-23111-1-git-send-email-nborisov@suse.com>
References: <1534318796-23111-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Refactor the delayed refs loop by using the newly introduced
btrfs_run_delayed_refs_for_head function. This greatly simplifies
__btrfs_run_delayed_refs and makes it more obvious what is happening.
We now have 1 loop which iterates the existing delayed_heads and then
each selected ref head is processed by the new helper. All existing
semantics of the code are preserved so no functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 107 +++++++++++++------------------------------------
 1 file changed, 27 insertions(+), 80 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 165a29871814..6a66b7f56b28 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2550,6 +2550,9 @@ int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
+	lockdep_assert_held(&locked_ref->mutex);
+	lockdep_assert_held(&locked_ref->lock);
+
 	while ((ref = select_delayed_ref(locked_ref))) {
 
 		if (ref->seq &&
@@ -2624,31 +2627,24 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_ref_head *locked_ref = NULL;
-	struct btrfs_delayed_extent_op *extent_op;
 	ktime_t start = ktime_get();
 	int ret;
 	unsigned long count = 0;
 	unsigned long actual_count = 0;
-	int must_insert_reserved = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	while (1) {
+	do {
 		if (!locked_ref) {
-			if (count >= nr)
-				break;
-
 			locked_ref = btrfs_obtain_ref_head(trans);
-			if (!locked_ref)
-				break;
-			else if (PTR_ERR(locked_ref) == -EAGAIN) {
-				locked_ref = NULL;
-				count++;
-				continue;
+			if (IS_ERR_OR_NULL(locked_ref)) {
+				if (PTR_ERR(locked_ref) == -EAGAIN) {
+					continue;
+				} else
+					break;
 			}
+			count++;
 		}
-
 		/*
 		 * We need to try and merge add/drops of the same ref since we
 		 * can run into issues with relocate dropping the implicit ref
@@ -2664,23 +2660,19 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		spin_lock(&locked_ref->lock);
 		btrfs_merge_delayed_refs(trans, delayed_refs, locked_ref);
 
-		ref = select_delayed_ref(locked_ref);
-
-		if (ref && ref->seq &&
-		    btrfs_check_delayed_seq(fs_info, ref->seq)) {
-			spin_unlock(&locked_ref->lock);
-			unselect_delayed_ref_head(delayed_refs, locked_ref);
-			locked_ref = NULL;
-			cond_resched();
-			count++;
-			continue;
-		}
-
-		/*
-		 * We're done processing refs in this ref_head, clean everything
-		 * up and move on to the next ref_head.
-		 */
-		if (!ref) {
+		ret = btrfs_run_delayed_refs_for_head(trans, locked_ref,
+						      &actual_count);
+		if (ret < 0 && ret != -EAGAIN) {
+			/*
+			 * Error, btrfs_run_delayed_refs_for_head already
+			 * unlocked everything so just bail out
+			 */
+			return ret;
+		} else if (!ret) {
+			/*
+			 * Success, perform the usual cleanup of a processed
+			 * head
+			 */
 			ret = cleanup_ref_head(trans, locked_ref);
 			if (ret > 0 ) {
 				/* We dropped our lock, we need to loop. */
@@ -2689,61 +2681,16 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			} else if (ret) {
 				return ret;
 			}
-			locked_ref = NULL;
-			count++;
-			continue;
-		}
-
-		actual_count++;
-		ref->in_tree = 0;
-		rb_erase(&ref->ref_node, &locked_ref->ref_tree);
-		RB_CLEAR_NODE(&ref->ref_node);
-		if (!list_empty(&ref->add_list))
-			list_del(&ref->add_list);
-		/*
-		 * When we play the delayed ref, also correct the ref_mod on
-		 * head
-		 */
-		switch (ref->action) {
-		case BTRFS_ADD_DELAYED_REF:
-		case BTRFS_ADD_DELAYED_EXTENT:
-			locked_ref->ref_mod -= ref->ref_mod;
-			break;
-		case BTRFS_DROP_DELAYED_REF:
-			locked_ref->ref_mod += ref->ref_mod;
-			break;
-		default:
-			WARN_ON(1);
 		}
-		atomic_dec(&delayed_refs->num_entries);
 
 		/*
-		 * Record the must-insert_reserved flag before we drop the spin
-		 * lock.
+		 * Either success case or btrfs_run_delayed_refs_for_head
+		 * returned -EAGAIN, meaning we need to select another head
 		 */
-		must_insert_reserved = locked_ref->must_insert_reserved;
-		locked_ref->must_insert_reserved = 0;
 
-		extent_op = locked_ref->extent_op;
-		locked_ref->extent_op = NULL;
-		spin_unlock(&locked_ref->lock);
-
-		ret = run_one_delayed_ref(trans, ref, extent_op,
-					  must_insert_reserved);
-
-		btrfs_free_delayed_extent_op(extent_op);
-		if (ret) {
-			unselect_delayed_ref_head(delayed_refs, locked_ref);
-			btrfs_put_delayed_ref(ref);
-			btrfs_debug(fs_info, "run_one_delayed_ref returned %d",
-				    ret);
-			return ret;
-		}
-
-		btrfs_put_delayed_ref(ref);
-		count++;
+		locked_ref = NULL;
 		cond_resched();
-	}
+	} while ((nr != -1 && count < nr) || locked_ref);
 
 	/*
 	 * We don't want to include ref heads since we can have empty ref heads
-- 
2.7.4
