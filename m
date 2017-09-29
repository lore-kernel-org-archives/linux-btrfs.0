Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36022 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbdI2ToV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:21 -0400
Received: by mail-qk0-f193.google.com with SMTP id z14so406481qkg.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:20 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 08/21] btrfs: add a helper to return a head ref
Date: Fri, 29 Sep 2017 15:43:52 -0400
Message-Id: <1506714245-23072-9-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simplify the error handling in __btrfs_run_delayed_refs by breaking out
the code used to return a head back to the delayed_refs tree for
processing into a helper function.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 00d86c8afaef..f356b4a66186 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2576,6 +2576,17 @@ select_delayed_ref(struct btrfs_delayed_ref_head *head)
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
@@ -2649,11 +2660,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
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
@@ -2699,14 +2706,11 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
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
@@ -2764,11 +2768,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 
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

