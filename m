From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: pass the correct root to lookup_free_space_inode()
Date: Sun,  2 Oct 2011 13:56:53 +0300
Message-ID: <1317553013-17074-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Free space items are located in tree of tree roots, not in the extent
tree.  It didn't pop up because lookup_free_space_inode() grabs the
inode all the time instead of actually searching the tree.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 25b69d0..b66a0ce 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7283,7 +7283,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	inode = lookup_free_space_inode(root, block_group, path);
+	inode = lookup_free_space_inode(tree_root, block_group, path);
 	if (!IS_ERR(inode)) {
 		ret = btrfs_orphan_add(trans, inode);
 		BUG_ON(ret);
-- 
1.7.5.4

