Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21202 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755955AbcIOCNp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 22:13:45 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: kill BUG_ON in run_delayed_tree_ref
Date: Wed, 14 Sep 2016 19:19:05 -0700
Message-Id: <1473905945-3227-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In a corrupted btrfs image, we can come across this BUG_ON and
get an unreponsive system, but if we return errors instead,
its caller can handle everything gracefully by aborting the current
transaction.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 779fd72..290c673 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2360,7 +2360,13 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		ins.type = BTRFS_EXTENT_ITEM_KEY;
 	}
 
-	BUG_ON(node->ref_mod != 1);
+	if (node->ref_mod != 1) {
+		btrfs_err(root->fs_info,
+	"btree block(%llu) has %d references rather than 1: action %d ref_root %llu parent %llu",
+			  node->bytenr, node->ref_mod, node->action, ref_root,
+			  parent);
+		return -EIO;
+	}
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags);
 		ret = alloc_reserved_tree_block(trans, root,
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
