Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29889 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753460AbcKWVve (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 16:51:34 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Filipe Manana <fdmanana@suse.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH v2] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
Date: Wed, 23 Nov 2016 13:58:14 -0800
Message-Id: <1479938294-3282-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This can only happen with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y.

Commit 1ba98d0 ("Btrfs: detect corruption when non-root leaf has zero item")
assumes that a leaf is its root when leaf->bytenr == btrfs_root_bytenr(root),
however, we should not use btrfs_root_bytenr(root) since it's mainly got
updated during committing transaction.  So the check can fail when doing
COW on this leaf while it is a root.

This changes to use "if (leaf == btrfs_root_node(root))" instead, just like
how we check whether leaf is a root in __btrfs_cow_block().

Fixes: 1ba98d086fe3 (Btrfs: detect corruption when non-root leaf has zero item)
Cc: stable@vger.kernel.org  # 4.8+
Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Tag itself for stable.

 fs/btrfs/disk-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9367c31..b401e6d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -572,13 +572,17 @@ static noinline int check_leaf(struct btrfs_root *root,
 		 * open_ctree() some roots has not yet been set up.
 		 */
 		if (!IS_ERR_OR_NULL(check_root)) {
+			struct extent_buffer *eb;
+
+			eb = btrfs_root_node(check_root);
 			/* if leaf is the root, then it's fine */
-			if (leaf->start !=
-			    btrfs_root_bytenr(&check_root->root_item)) {
+			if (leaf != eb) {
 				CORRUPT("non-root leaf's nritems is 0",
-					leaf, root, 0);
+					leaf, check_root, 0);
+				free_extent_buffer(eb);
 				return -EIO;
 			}
+			free_extent_buffer(eb);
 		}
 		return 0;
 	}
-- 
2.5.5

