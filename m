Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38581 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbeGSPdm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:33:42 -0400
Received: by mail-qt0-f193.google.com with SMTP id y19-v6so7407237qto.5
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:10 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 02/22] btrfs: add cleanup_ref_head_accounting helper
Date: Thu, 19 Jul 2018 10:49:46 -0400
Message-Id: <20180719145006.17532-2-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We were missing some quota cleanups in check_ref_cleanup, so break the
ref head accounting cleanup into a helper and call that from both
check_ref_cleanup and cleanup_ref_head.  This will hopefully ensure that
we don't screw up accounting in the future for other things that we add.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 65 +++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ccaccd78534e..cf1152d01309 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2547,6 +2547,40 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
 	return ret ? ret : 1;
 }
 
+static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
+					struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_delayed_ref_root *delayed_refs =
+		&trans->transaction->delayed_refs;
+
+	if (head->total_ref_mod < 0) {
+		struct btrfs_space_info *space_info;
+		u64 flags;
+
+		if (head->is_data)
+			flags = BTRFS_BLOCK_GROUP_DATA;
+		else if (head->is_system)
+			flags = BTRFS_BLOCK_GROUP_SYSTEM;
+		else
+			flags = BTRFS_BLOCK_GROUP_METADATA;
+		space_info = __find_space_info(fs_info, flags);
+		ASSERT(space_info);
+		percpu_counter_add(&space_info->total_bytes_pinned,
+				   -head->num_bytes);
+
+		if (head->is_data) {
+			spin_lock(&delayed_refs->lock);
+			delayed_refs->pending_csums -= head->num_bytes;
+			spin_unlock(&delayed_refs->lock);
+		}
+	}
+
+	/* Also free its reserved qgroup space */
+	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
+				      head->qgroup_reserved);
+}
+
 static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info,
 			    struct btrfs_delayed_ref_head *head)
@@ -2581,30 +2615,6 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 	spin_unlock(&delayed_refs->lock);
 	spin_unlock(&head->lock);
 
-	trace_run_delayed_ref_head(fs_info, head, 0);
-
-	if (head->total_ref_mod < 0) {
-		struct btrfs_space_info *space_info;
-		u64 flags;
-
-		if (head->is_data)
-			flags = BTRFS_BLOCK_GROUP_DATA;
-		else if (head->is_system)
-			flags = BTRFS_BLOCK_GROUP_SYSTEM;
-		else
-			flags = BTRFS_BLOCK_GROUP_METADATA;
-		space_info = __find_space_info(fs_info, flags);
-		ASSERT(space_info);
-		percpu_counter_add(&space_info->total_bytes_pinned,
-				   -head->num_bytes);
-
-		if (head->is_data) {
-			spin_lock(&delayed_refs->lock);
-			delayed_refs->pending_csums -= head->num_bytes;
-			spin_unlock(&delayed_refs->lock);
-		}
-	}
-
 	if (head->must_insert_reserved) {
 		btrfs_pin_extent(fs_info, head->bytenr,
 				 head->num_bytes, 1);
@@ -2614,9 +2624,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	/* Also free its reserved qgroup space */
-	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
-				      head->qgroup_reserved);
+	cleanup_ref_head_accounting(trans, head);
+
+	trace_run_delayed_ref_head(fs_info, head, 0);
 	btrfs_delayed_ref_unlock(head);
 	btrfs_put_delayed_ref_head(head);
 	return 0;
@@ -7129,6 +7139,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (head->must_insert_reserved)
 		ret = 1;
 
+	cleanup_ref_head_accounting(trans, head);
 	mutex_unlock(&head->mutex);
 	btrfs_put_delayed_ref_head(head);
 	return ret;
-- 
2.14.3

