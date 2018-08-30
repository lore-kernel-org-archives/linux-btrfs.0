Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:41187 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbeH3Vpt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:45:49 -0400
Received: by mail-qt0-f196.google.com with SMTP id t39-v6so11275486qtc.8
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:34 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 03/35] btrfs: use cleanup_extent_op in check_ref_cleanup
Date: Thu, 30 Aug 2018 13:41:53 -0400
Message-Id: <20180830174225.2200-4-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Unify the extent_op handling as well, just add a flag so we don't
actually run the extent op from check_ref_cleanup and instead return a
value so that we can skip cleaning up the ref head.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4c9fd35bca07..87c42a2c45b1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2443,18 +2443,23 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
 }
 
 static int cleanup_extent_op(struct btrfs_trans_handle *trans,
-			     struct btrfs_delayed_ref_head *head)
+			     struct btrfs_delayed_ref_head *head,
+			     bool run_extent_op)
 {
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
 	ret = run_delayed_extent_op(trans, head, extent_op);
 	btrfs_free_delayed_extent_op(extent_op);
@@ -2506,7 +2511,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
-	ret = cleanup_extent_op(trans, head);
+	ret = cleanup_extent_op(trans, head, true);
 	if (ret < 0) {
 		unselect_delayed_ref_head(delayed_refs, head);
 		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
@@ -6977,12 +6982,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
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
