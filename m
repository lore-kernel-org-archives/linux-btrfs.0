Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34653 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbbBXKr3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 05:47:29 -0500
Received: by pabrd3 with SMTP id rd3so35204406pab.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 02:47:28 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 1/3] btrfs: handle ENOMEM in btrfs_alloc_tree_block
Date: Tue, 24 Feb 2015 02:47:04 -0800
Message-Id: <b0a70e4ad3c51e6da22cc01fed1ced4f383c5f4c.1424773781.git.osandov@osandov.com>
In-Reply-To: <cover.1424773781.git.osandov@osandov.com>
References: <cover.1424773781.git.osandov@osandov.com>
In-Reply-To: <cover.1424773781.git.osandov@osandov.com>
References: <cover.1424773781.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is one of the first places to give out when memory is tight. Handle
it properly rather than with a BUG_ON.

Also fix the comment about the return value, which is an ERR_PTR, not
NULL, on error.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/extent-tree.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 571f402..7443d67 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7262,7 +7262,7 @@ static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
  * returns the key for the extent through ins, and a tree buffer for
  * the first block of the extent through buf.
  *
- * returns the tree buffer or NULL.
+ * returns the tree buffer or an ERR_PTR on error.
  */
 struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
@@ -7273,6 +7273,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_key ins;
 	struct btrfs_block_rsv *block_rsv;
 	struct extent_buffer *buf;
+	struct btrfs_delayed_extent_op *extent_op;
 	u64 flags = 0;
 	int ret;
 	u32 blocksize = root->nodesize;
@@ -7293,13 +7294,14 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_reserve_extent(root, blocksize, blocksize,
 				   empty_size, hint, &ins, 0, 0);
-	if (ret) {
-		unuse_block_rsv(root->fs_info, block_rsv, blocksize);
-		return ERR_PTR(ret);
-	}
+	if (ret)
+		goto out_unuse;
 
 	buf = btrfs_init_new_buffer(trans, root, ins.objectid, level);
-	BUG_ON(IS_ERR(buf)); /* -ENOMEM */
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto out_free_reserved;
+	}
 
 	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
 		if (parent == 0)
@@ -7309,9 +7311,11 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		BUG_ON(parent > 0);
 
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
-		struct btrfs_delayed_extent_op *extent_op;
 		extent_op = btrfs_alloc_delayed_extent_op();
-		BUG_ON(!extent_op); /* -ENOMEM */
+		if (!extent_op) {
+			ret = -ENOMEM;
+			goto out_free_buf;
+		}
 		if (key)
 			memcpy(&extent_op->key, key, sizeof(extent_op->key));
 		else
@@ -7326,13 +7330,24 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		extent_op->level = level;
 
 		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
-					ins.objectid,
-					ins.offset, parent, root_objectid,
-					level, BTRFS_ADD_DELAYED_EXTENT,
-					extent_op, 0);
-		BUG_ON(ret); /* -ENOMEM */
+						 ins.objectid, ins.offset,
+						 parent, root_objectid, level,
+						 BTRFS_ADD_DELAYED_EXTENT,
+						 extent_op, 0);
+		if (ret)
+			goto out_free_delayed;
 	}
 	return buf;
+
+out_free_delayed:
+	btrfs_free_delayed_extent_op(extent_op);
+out_free_buf:
+	free_extent_buffer(buf);
+out_free_reserved:
+	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 0);
+out_unuse:
+	unuse_block_rsv(root->fs_info, block_rsv, blocksize);
+	return ERR_PTR(ret);
 }
 
 struct walk_control {
-- 
2.3.0

