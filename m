Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27432 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756232AbcIOAST (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 20:18:19 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: add error handling for extent buffer in print tree
Date: Wed, 14 Sep 2016 17:23:39 -0700
Message-Id: <1473899019-29882-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Somehow we missed btrfs_print_tree when last time we
updated error handling for read_extent_block().

This keeps us from getting a NULL pointer panic when
btrfs_print_tree's read_extent_block() fails.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/print-tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 147dc6c..aaeee45 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -356,6 +356,13 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c)
 		struct extent_buffer *next = read_tree_block(root,
 					btrfs_node_blockptr(c, i),
 					btrfs_node_ptr_generation(c, i));
+		if (IS_ERR(next)) {
+			continue;
+		} else if (!extent_buffer_uptodate(next)) {
+			free_extent_buffer(next);
+			continue;
+		}
+
 		if (btrfs_is_leaf(next) &&
 		   level != 1)
 			BUG();
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
