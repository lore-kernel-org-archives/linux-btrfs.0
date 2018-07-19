Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34237 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbeGSPdn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:33:43 -0400
Received: by mail-qk0-f195.google.com with SMTP id b66-v6so4410456qkj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:12 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 03/22] btrfs: use cleanup_extent_op in check_ref_cleanup
Date: Thu, 19 Jul 2018 10:49:47 -0400
Message-Id: <20180719145006.17532-3-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Unify the extent_op handling as well, just add a flag so we don't
actually run the extent op from check_ref_cleanup and instead return a
value so that we can skip cleaning up the ref head.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cf1152d01309..33cd43dd73ee 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2528,19 +2528,24 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
 }
 
 static int cleanup_extent_op(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info,
-			     struct btrfs_delayed_ref_head *head)
+			     struct btrfs_delayed_ref_head *head,
+			     bool run_extent_op)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	int ret;
 
 	if (!extent_op)
 		return 0;
+
 	head->extent_op = NULL;
 	if (head->must_insert_reserved) {
 		btrfs_free_delayed_extent_op(extent_op);
 		return 0;
+	} else if (!run_extent_op) {
+		return 1;
 	}
+
 	spin_unlock(&head->lock);
 	ret = run_delayed_extent_op(trans, fs_info, head, extent_op);
 	btrfs_free_delayed_extent_op(extent_op);
@@ -2590,7 +2595,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
-	ret = cleanup_extent_op(trans, fs_info, head);
+	ret = cleanup_extent_op(trans, head, true);
 	if (ret < 0) {
 		unselect_delayed_ref_head(delayed_refs, head);
 		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
@@ -7115,12 +7120,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (!RB_EMPTY_ROOT(&head->ref_tree))
 		goto out;
 
-	if (head->extent_op) {
-		if (!head->must_insert_reserved)
-			goto out;
-		btrfs_free_delayed_extent_op(head->extent_op);
-		head->extent_op = NULL;
-	}
+	if (cleanup_extent_op(trans, head, false))
+		goto out;
 
 	/*
 	 * waiting for the lock here would deadlock.  If someone else has it
-- 
2.14.3

