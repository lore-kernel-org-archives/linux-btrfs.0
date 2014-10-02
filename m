Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbaJBQwf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:52:35 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3F90EAAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:52:34 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/6] btrfs: return void from readahead_tree_block
Date: Thu,  2 Oct 2014 18:52:33 +0200
Message-Id: <6197d86eabb844c1a9c99956d4e6b0f8eb548ad3.1412265712.git.dsterba@suse.cz>
In-Reply-To: <cover.1412265712.git.dsterba@suse.cz>
References: <cover.1412265712.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Errors in readahead are not fatal and ignored elsewhere in the code.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c     | 6 ++----
 fs/btrfs/disk-io.h     | 2 +-
 fs/btrfs/extent-tree.c | 4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ff83748d39da..332f63518156 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1062,19 +1062,17 @@ static const struct address_space_operations btree_aops = {
 	.set_page_dirty = btree_set_page_dirty,
 };
 
-int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize)
+void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize)
 {
 	struct extent_buffer *buf = NULL;
 	struct inode *btree_inode = root->fs_info->btree_inode;
-	int ret = 0;
 
 	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
 	if (!buf)
-		return 0;
+		return;
 	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
 				 buf, 0, WAIT_NONE, btree_get_extent, 0);
 	free_extent_buffer(buf);
-	return ret;
 }
 
 int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 8cd6a53db621..0d9793f6b594 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -46,7 +46,7 @@ struct btrfs_fs_devices;
 
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
-int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize);
+void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize);
 int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 int mirror_num, struct extent_buffer **eb);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 058abd088f0f..e0468a9789a5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7486,9 +7486,7 @@ static noinline void reada_walk_down(struct btrfs_trans_handle *trans,
 				continue;
 		}
 reada:
-		ret = readahead_tree_block(root, bytenr, blocksize);
-		if (ret)
-			break;
+		readahead_tree_block(root, bytenr, blocksize);
 		nread++;
 	}
 	wc->reada_slot = slot;
-- 
1.8.4.5

