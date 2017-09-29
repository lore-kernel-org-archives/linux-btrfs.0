Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:50889 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbdI2ToW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:22 -0400
Received: by mail-qt0-f195.google.com with SMTP id f15so923181qtf.7
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:22 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 09/21] btrfs: move extent_op cleanup to a helper
Date: Fri, 29 Sep 2017 15:43:53 -0400
Message-Id: <1506714245-23072-10-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move the extent_op cleanup for an empty head ref to a helper function to
help simplify __btrfs_run_delayed_refs.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 77 ++++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f356b4a66186..f4048b23c7be 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2587,6 +2587,26 @@ unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
 	btrfs_delayed_ref_unlock(head);
 }
 
+static int cleanup_extent_op(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info,
+			     struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
+	int ret;
+
+	if (!extent_op)
+		return 0;
+	head->extent_op = NULL;
+	if (head->must_insert_reserved) {
+		btrfs_free_delayed_extent_op(extent_op);
+		return 0;
+	}
+	spin_unlock(&head->lock);
+	ret = run_delayed_extent_op(trans, fs_info, &head->node, extent_op);
+	btrfs_free_delayed_extent_op(extent_op);
+	return ret ? ret : 1;
+}
+
 /*
  * Returns 0 on success or if called with an already aborted transaction.
  * Returns -ENOMEM or -EIO on failure and will abort the transaction.
@@ -2667,16 +2687,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		/*
-		 * record the must insert reserved flag before we
-		 * drop the spin lock.
-		 */
-		must_insert_reserved = locked_ref->must_insert_reserved;
-		locked_ref->must_insert_reserved = 0;
-
-		extent_op = locked_ref->extent_op;
-		locked_ref->extent_op = NULL;
-
 		if (!ref) {
 
 
@@ -2686,33 +2696,17 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			 */
 			ref = &locked_ref->node;
 
-			if (extent_op && must_insert_reserved) {
-				btrfs_free_delayed_extent_op(extent_op);
-				extent_op = NULL;
-			}
-
-			if (extent_op) {
-				spin_unlock(&locked_ref->lock);
-				ret = run_delayed_extent_op(trans, fs_info,
-							    ref, extent_op);
-				btrfs_free_delayed_extent_op(extent_op);
-
-				if (ret) {
-					/*
-					 * Need to reset must_insert_reserved if
-					 * there was an error so the abort stuff
-					 * can cleanup the reserved space
-					 * properly.
-					 */
-					if (must_insert_reserved)
-						locked_ref->must_insert_reserved = 1;
-					unselect_delayed_ref_head(delayed_refs,
-								  locked_ref);
-					btrfs_debug(fs_info,
-						    "run_delayed_extent_op returned %d",
-						    ret);
-					return ret;
-				}
+			ret = cleanup_extent_op(trans, fs_info, locked_ref);
+			if (ret < 0) {
+				unselect_delayed_ref_head(delayed_refs,
+							  locked_ref);
+				btrfs_debug(fs_info,
+					    "run_delayed_extent_op returned %d",
+					    ret);
+				return ret;
+			} else if (ret > 0) {
+				/* We dropped our lock, we need to loop. */
+				ret = 0;
 				continue;
 			}
 
@@ -2761,6 +2755,15 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				WARN_ON(1);
 			}
 		}
+		/*
+		 * record the must insert reserved flag before we
+		 * drop the spin lock.
+		 */
+		must_insert_reserved = locked_ref->must_insert_reserved;
+		locked_ref->must_insert_reserved = 0;
+
+		extent_op = locked_ref->extent_op;
+		locked_ref->extent_op = NULL;
 		spin_unlock(&locked_ref->lock);
 
 		ret = run_one_delayed_ref(trans, fs_info, ref, extent_op,
-- 
2.7.4

