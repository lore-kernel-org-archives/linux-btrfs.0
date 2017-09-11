Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33010 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdIKVMm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 17:12:42 -0400
Received: by mail-qt0-f195.google.com with SMTP id b1so3962069qtc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:12:41 -0700 (PDT)
From: josef@toxicpanda.com
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 01/10] btrfs: add a helper to return a head ref
Date: Mon, 11 Sep 2017 17:12:27 -0400
Message-Id: <1505164356-13474-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1505164356-13474-1-git-send-email-jbacik@fb.com>
References: <1505164356-13474-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Simplify the error handling in __btrfs_run_delayed_refs by breaking out
the code used to return a head back to the delayed_refs tree for
processing into a helper function.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b68fb8c..636aac0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2508,6 +2508,17 @@ select_delayed_ref(struct btrfs_delayed_ref_head *head)
 	return ref;
 }
 
+static void
+unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
+			  struct btrfs_delayed_ref_head *head)
+{
+	spin_lock(&delayed_refs->lock);
+	head->processing = 0;
+	delayed_refs->num_heads_ready++;
+	spin_unlock(&delayed_refs->lock);
+	btrfs_delayed_ref_unlock(head);
+}
+
 /*
  * Returns 0 on success or if called with an already aborted transaction.
  * Returns -ENOMEM or -EIO on failure and will abort the transaction.
@@ -2581,11 +2592,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		if (ref && ref->seq &&
 		    btrfs_check_delayed_seq(fs_info, delayed_refs, ref->seq)) {
 			spin_unlock(&locked_ref->lock);
-			spin_lock(&delayed_refs->lock);
-			locked_ref->processing = 0;
-			delayed_refs->num_heads_ready++;
-			spin_unlock(&delayed_refs->lock);
-			btrfs_delayed_ref_unlock(locked_ref);
+			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			locked_ref = NULL;
 			cond_resched();
 			count++;
@@ -2631,14 +2638,11 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 					 */
 					if (must_insert_reserved)
 						locked_ref->must_insert_reserved = 1;
-					spin_lock(&delayed_refs->lock);
-					locked_ref->processing = 0;
-					delayed_refs->num_heads_ready++;
-					spin_unlock(&delayed_refs->lock);
+					unselect_delayed_ref_head(delayed_refs,
+								  locked_ref);
 					btrfs_debug(fs_info,
 						    "run_delayed_extent_op returned %d",
 						    ret);
-					btrfs_delayed_ref_unlock(locked_ref);
 					return ret;
 				}
 				continue;
@@ -2696,11 +2700,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 
 		btrfs_free_delayed_extent_op(extent_op);
 		if (ret) {
-			spin_lock(&delayed_refs->lock);
-			locked_ref->processing = 0;
-			delayed_refs->num_heads_ready++;
-			spin_unlock(&delayed_refs->lock);
-			btrfs_delayed_ref_unlock(locked_ref);
+			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			btrfs_put_delayed_ref(ref);
 			btrfs_debug(fs_info, "run_one_delayed_ref returned %d",
 				    ret);
-- 
2.7.4

