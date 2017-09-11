Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35769 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdIKVMp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 17:12:45 -0400
Received: by mail-qt0-f195.google.com with SMTP id l25so3398456qtf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:12:44 -0700 (PDT)
From: josef@toxicpanda.com
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 03/10] btrfs: breakout empty head cleanup to a helper
Date: Mon, 11 Sep 2017 17:12:29 -0400
Message-Id: <1505164356-13474-4-git-send-email-jbacik@fb.com>
In-Reply-To: <1505164356-13474-1-git-send-email-jbacik@fb.com>
References: <1505164356-13474-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Move this code out to a helper function to further simplivy
__btrfs_run_delayed_refs.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 80 ++++++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 47780b7..ad02f49 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2539,6 +2539,43 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
 	return ret ? ret : 1;
 }
 
+static int cleanup_ref_head(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info,
+			    struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_delayed_ref_root *delayed_refs;
+	int ret;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	ret = cleanup_extent_op(trans, fs_info, head);
+	if (ret < 0) {
+		unselect_delayed_ref_head(delayed_refs, head);
+		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
+		return ret;
+	} else if (ret) {
+		return ret;
+	}
+
+	/*
+	 * Need to drop our head ref lock and re-acquire the delayed ref lock
+	 * and then re-check to make sure nobody got added.
+	 */
+	spin_unlock(&head->lock);
+	spin_lock(&delayed_refs->lock);
+	spin_lock(&head->lock);
+	if (!list_empty(&head->ref_list) || head->extent_op) {
+		spin_unlock(&head->lock);
+		spin_unlock(&delayed_refs->lock);
+		return 1;
+	}
+	head->node.in_tree = 0;
+	delayed_refs->num_heads--;
+	rb_erase(&head->href_node, &delayed_refs->href_root);
+	spin_unlock(&delayed_refs->lock);
+	return 0;
+}
+
 /*
  * Returns 0 on success or if called with an already aborted transaction.
  * Returns -ENOMEM or -EIO on failure and will abort the transaction.
@@ -2620,47 +2657,20 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		}
 
 		if (!ref) {
-
-
-			/* All delayed refs have been processed, Go ahead
-			 * and send the head node to run_one_delayed_ref,
-			 * so that any accounting fixes can happen
-			 */
-			ref = &locked_ref->node;
-
-			ret = cleanup_extent_op(trans, fs_info, locked_ref);
-			if (ret < 0) {
-				unselect_delayed_ref_head(delayed_refs,
-							  locked_ref);
-				btrfs_debug(fs_info,
-					    "run_delayed_extent_op returned %d",
-					    ret);
-				return ret;
-			} else if (ret > 0) {
+			ret = cleanup_ref_head(trans, fs_info, locked_ref);
+			if (ret > 0 ) {
 				/* We dropped our lock, we need to loop. */
 				ret = 0;
 				continue;
+			} else if (ret) {
+				return ret;
 			}
 
-			/*
-			 * Need to drop our head ref lock and re-acquire the
-			 * delayed ref lock and then re-check to make sure
-			 * nobody got added.
+			/* All delayed refs have been processed, Go ahead
+			 * and send the head node to run_one_delayed_ref,
+			 * so that any accounting fixes can happen
 			 */
-			spin_unlock(&locked_ref->lock);
-			spin_lock(&delayed_refs->lock);
-			spin_lock(&locked_ref->lock);
-			if (!list_empty(&locked_ref->ref_list) ||
-			    locked_ref->extent_op) {
-				spin_unlock(&locked_ref->lock);
-				spin_unlock(&delayed_refs->lock);
-				continue;
-			}
-			ref->in_tree = 0;
-			delayed_refs->num_heads--;
-			rb_erase(&locked_ref->href_node,
-				 &delayed_refs->href_root);
-			spin_unlock(&delayed_refs->lock);
+			ref = &locked_ref->node;
 		} else {
 			actual_count++;
 			ref->in_tree = 0;
-- 
2.7.4

