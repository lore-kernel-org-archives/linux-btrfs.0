Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:52731 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbeDKJI2 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 11 Apr 2018 05:08:28 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: print-tree: output enhancement
Date: Wed, 11 Apr 2018 17:08:12 +0800
Message-Id: <20180411090813.19495-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch enhance the following things:

- tree block header
  * add generation and owner output for node and leaf
- node pointer generation output
- allow btrfs_print_tree() to not follow nodes
  * just like btrfs-progs

Please note that, although function btrfs_print_tree() is not called by
anyone right now, it's still a pretty useful function to debug kernel.
So that function is still kept for later use.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Fix title from "btrfs-progs" to "btrfs"
---
 fs/btrfs/print-tree.c | 25 +++++++++++++++----------
 fs/btrfs/print-tree.h |  2 +-
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 4a8770485f77..9904cf741e1c 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -202,9 +202,10 @@ void btrfs_print_leaf(struct extent_buffer *l)
 	fs_info = l->fs_info;
 	nr = btrfs_header_nritems(l);
 
-	btrfs_info(fs_info, "leaf %llu total ptrs %d free space %d",
-		   btrfs_header_bytenr(l), nr,
-		   btrfs_leaf_free_space(fs_info, l));
+	btrfs_info(fs_info,
+		   "leaf %llu gen %llu total ptrs %d free space %d owner %llu",
+		   btrfs_header_bytenr(l), btrfs_header_generation(l), nr,
+		   btrfs_leaf_free_space(fs_info, l), btrfs_header_owner(l));
 	for (i = 0 ; i < nr ; i++) {
 		item = btrfs_item_nr(i);
 		btrfs_item_key_to_cpu(l, &key, i);
@@ -338,7 +339,7 @@ void btrfs_print_leaf(struct extent_buffer *l)
 	}
 }
 
-void btrfs_print_tree(struct extent_buffer *c)
+void btrfs_print_tree(struct extent_buffer *c, bool follow)
 {
 	struct btrfs_fs_info *fs_info;
 	int i; u32 nr;
@@ -355,15 +356,19 @@ void btrfs_print_tree(struct extent_buffer *c)
 		return;
 	}
 	btrfs_info(fs_info,
-		   "node %llu level %d total ptrs %d free spc %u",
-		   btrfs_header_bytenr(c), level, nr,
-		   (u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr);
+		   "node %llu level %d gen %llu total ptrs %d free spc %u owner %llu",
+		   btrfs_header_bytenr(c), level, btrfs_header_generation(c),
+		   nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
+		   btrfs_header_owner(c));
 	for (i = 0; i < nr; i++) {
 		btrfs_node_key_to_cpu(c, &key, i);
-		pr_info("\tkey %d (%llu %u %llu) block %llu\n",
+		pr_info("\tkey %d (%llu %u %llu) block %llu gen %llu\n",
 		       i, key.objectid, key.type, key.offset,
-		       btrfs_node_blockptr(c, i));
+		       btrfs_node_blockptr(c, i),
+		       btrfs_node_ptr_generation(c, i));
 	}
+	if (!follow)
+		return;
 	for (i = 0; i < nr; i++) {
 		struct btrfs_key first_key;
 		struct extent_buffer *next;
@@ -385,7 +390,7 @@ void btrfs_print_tree(struct extent_buffer *c)
 		if (btrfs_header_level(next) !=
 		       level - 1)
 			BUG();
-		btrfs_print_tree(next);
+		btrfs_print_tree(next, follow);
 		free_extent_buffer(next);
 	}
 }
diff --git a/fs/btrfs/print-tree.h b/fs/btrfs/print-tree.h
index 3afd508ed8c5..834f3c187f0d 100644
--- a/fs/btrfs/print-tree.h
+++ b/fs/btrfs/print-tree.h
@@ -19,5 +19,5 @@
 #ifndef __PRINT_TREE_
 #define __PRINT_TREE_
 void btrfs_print_leaf(struct extent_buffer *l);
-void btrfs_print_tree(struct extent_buffer *c);
+void btrfs_print_tree(struct extent_buffer *c, bool follow);
 #endif
-- 
2.17.0

