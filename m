Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031039AbaLLRgA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 12:36:00 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 78AECABC6
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 17:35:59 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/9] btrfs: sink blocksize parameter to btrfs_init_new_buffer
Date: Fri, 12 Dec 2014 18:35:58 +0100
Message-Id: <fe864576de7fb940b5bd1f8ab8908a08a3416ca0.1418404754.git.dsterba@suse.cz>
In-Reply-To: <cover.1418404754.git.dsterba@suse.cz>
References: <cover.1418404754.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c025751c20d7..50ebc74db508 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7215,11 +7215,11 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 
 static struct extent_buffer *
 btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		      u64 bytenr, u32 blocksize, int level)
+		      u64 bytenr, int level)
 {
 	struct extent_buffer *buf;
 
-	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 	btrfs_set_header_generation(buf, trans->transid);
@@ -7338,7 +7338,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 
 	if (btrfs_test_is_dummy_root(root)) {
 		buf = btrfs_init_new_buffer(trans, root, root->alloc_bytenr,
-					    blocksize, level);
+					    level);
 		if (!IS_ERR(buf))
 			root->alloc_bytenr += blocksize;
 		return buf;
@@ -7355,8 +7355,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		return ERR_PTR(ret);
 	}
 
-	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
-				    blocksize, level);
+	buf = btrfs_init_new_buffer(trans, root, ins.objectid, level);
 	BUG_ON(IS_ERR(buf)); /* -ENOMEM */
 
 	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
-- 
2.1.3

