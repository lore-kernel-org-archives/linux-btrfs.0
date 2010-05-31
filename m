From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfs: Fix BUG_ON for fs converted from extN
Date: Mon, 31 May 2010 17:04:46 +0800
Message-ID: <4C037BAE.9010300@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tree blocks can live in data block groups in FS converted from extN.
So it's easy to trigger the BUG_ON.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2010-05-26 23:55:46.610378078 +0800
+++ 3/fs/btrfs/extent-tree.c	2010-05-31 16:36:51.907580723 +0800
@@ -4360,7 +4360,8 @@ void btrfs_free_tree_block(struct btrfs_
 
 	block_rsv = get_block_rsv(trans, root);
 	cache = btrfs_lookup_block_group(root->fs_info, buf->start);
-	BUG_ON(block_rsv->space_info != cache->space_info);
+	if (block_rsv->space_info != cache->space_info)
+		goto out;
 
 	if (btrfs_header_generation(buf) == trans->transid) {
 		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
