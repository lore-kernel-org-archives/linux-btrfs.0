Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaJBQwc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:52:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A69A9AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:52:30 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/6] btrfs: remove unused parameter from readahead_tree_block
Date: Thu,  2 Oct 2014 18:52:30 +0200
Message-Id: <58dc4ce4325108b35425ffd30e6acfad9644d49d.1412265712.git.dsterba@suse.cz>
In-Reply-To: <cover.1412265712.git.dsterba@suse.cz>
References: <cover.1412265712.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The parent_transid parameter has been unused since its introduction in
ca7a79ad8dbe2466 ("Pass down the expected generation number when reading
tree blocks").  In reada_tree_block, it was even wrongly set to leafsize.
Transid check is done in the proper read and readahead ignores errors.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c       | 6 +++---
 fs/btrfs/disk-io.c     | 3 +--
 fs/btrfs/disk-io.h     | 3 +--
 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/relocation.c  | 9 ++-------
 5 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 39021bf2df9a..1b7e3545a596 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2298,7 +2298,7 @@ static void reada_for_search(struct btrfs_root *root,
 		if ((search <= target && target - search <= 65536) ||
 		    (search > target && search - target <= 65536)) {
 			gen = btrfs_node_ptr_generation(node, nr);
-			readahead_tree_block(root, search, blocksize, gen);
+			readahead_tree_block(root, search, blocksize);
 			nread += blocksize;
 		}
 		nscan++;
@@ -2350,9 +2350,9 @@ static noinline void reada_for_balance(struct btrfs_root *root,
 	}
 
 	if (block1)
-		readahead_tree_block(root, block1, blocksize, 0);
+		readahead_tree_block(root, block1, blocksize);
 	if (block2)
-		readahead_tree_block(root, block2, blocksize, 0);
+		readahead_tree_block(root, block2, blocksize);
 }
 
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4780e6623c7b..ff83748d39da 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1062,8 +1062,7 @@ static const struct address_space_operations btree_aops = {
 	.set_page_dirty = btree_set_page_dirty,
 };
 
-int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
-			 u64 parent_transid)
+int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize)
 {
 	struct extent_buffer *buf = NULL;
 	struct inode *btree_inode = root->fs_info->btree_inode;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 14d06ee1e143..8cd6a53db621 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -46,8 +46,7 @@ struct btrfs_fs_devices;
 
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
-int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
-			 u64 parent_transid);
+int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize);
 int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 int mirror_num, struct extent_buffer **eb);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 44d04979f071..058abd088f0f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7486,8 +7486,7 @@ static noinline void reada_walk_down(struct btrfs_trans_handle *trans,
 				continue;
 		}
 reada:
-		ret = readahead_tree_block(root, bytenr, blocksize,
-					   generation);
+		ret = readahead_tree_block(root, bytenr, blocksize);
 		if (ret)
 			break;
 		nread++;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2d221c46180c..16cb2b4a9620 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2861,13 +2861,8 @@ static int reada_tree_block(struct reloc_control *rc,
 			    struct tree_block *block)
 {
 	BUG_ON(block->key_ready);
-	if (block->key.type == BTRFS_METADATA_ITEM_KEY)
-		readahead_tree_block(rc->extent_root, block->bytenr,
-				     block->key.objectid,
-				     rc->extent_root->nodesize);
-	else
-		readahead_tree_block(rc->extent_root, block->bytenr,
-				     block->key.objectid, block->key.offset);
+	readahead_tree_block(rc->extent_root, block->bytenr,
+			block->key.objectid);
 	return 0;
 }
 
-- 
1.8.4.5

