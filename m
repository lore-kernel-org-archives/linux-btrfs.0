Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40542 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754782AbcHWWTN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 18:19:13 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: detect corruption when non-root leaf has zero item
Date: Tue, 23 Aug 2016 15:22:58 -0700
Message-Id: <1471990978-27124-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1470286628-4123-1-git-send-email-bo.li.liu@oracle.com>
References: <1470286628-4123-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Right now we treat leaf which has zero item as a valid one
because we could have an empty tree, that is, a root that is
also a leaf without any item, however, in the same case but
when the leaf is not a root, we can end up with hitting the
BUG_ON(1) in btrfs_extend_item() called by
setup_inline_extent_backref().

This makes us check the situation as a corruption if leaf is
not its own root.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: fix code style.

 fs/btrfs/disk-io.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a5a22be..8df7e73 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -559,8 +559,29 @@ static noinline int check_leaf(struct btrfs_root *root,
 	u32 nritems = btrfs_header_nritems(leaf);
 	int slot;
 
-	if (nritems == 0)
+	if (nritems == 0) {
+		struct btrfs_root *check_root;
+
+		key.objectid = btrfs_header_owner(leaf);
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+
+		check_root = btrfs_get_fs_root(root->fs_info, &key, false);
+		/*
+		 * The only reason we also check NULL here is that during
+		 * open_ctree() some roots has not yet been set up.
+		 */
+		if (!IS_ERR_OR_NULL(check_root)) {
+			/* if leaf is the root, then it's fine */
+			if (leaf->start !=
+			    btrfs_root_bytenr(&check_root->root_item)) {
+				CORRUPT("non-root leaf's nritems is 0",
+					leaf, root, 0);
+				return -EIO;
+			}
+		}
 		return 0;
+	}
 
 	/* Check the 0 item */
 	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=
-- 
2.5.5

