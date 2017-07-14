Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751105AbdGNSb0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 14:31:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBDE7AAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 18:31:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: get fs_info from eb in btrfs_print_leaf, remove argument
Date: Fri, 14 Jul 2017 20:30:11 +0200
Message-Id: <e7678b9aaa327601f2b96e3c9e6f6fb8f726b2c1.1500056930.git.dsterba@suse.com>
In-Reply-To: <cover.1500056930.git.dsterba@suse.com>
References: <cover.1500056930.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c       | 14 +++++++-------
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent-tree.c |  6 +++---
 fs/btrfs/print-tree.c  |  5 +++--
 fs/btrfs/print-tree.h  |  2 +-
 fs/btrfs/root-tree.c   |  2 +-
 6 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3f4daa9d6e2c..6d49db7d86be 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4650,7 +4650,7 @@ void btrfs_truncate_item(struct btrfs_fs_info *fs_info,
 	btrfs_mark_buffer_dirty(leaf);
 
 	if (btrfs_leaf_free_space(fs_info, leaf) < 0) {
-		btrfs_print_leaf(fs_info, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 }
@@ -4679,7 +4679,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	data_end = leaf_data_end(fs_info, leaf);
 
 	if (btrfs_leaf_free_space(fs_info, leaf) < data_size) {
-		btrfs_print_leaf(fs_info, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 	slot = path->slots[0];
@@ -4687,7 +4687,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 
 	BUG_ON(slot < 0);
 	if (slot >= nritems) {
-		btrfs_print_leaf(fs_info, leaf);
+		btrfs_print_leaf(leaf);
 		btrfs_crit(fs_info, "slot %d too large, nritems %d",
 			   slot, nritems);
 		BUG_ON(1);
@@ -4718,7 +4718,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	btrfs_mark_buffer_dirty(leaf);
 
 	if (btrfs_leaf_free_space(fs_info, leaf) < 0) {
-		btrfs_print_leaf(fs_info, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 }
@@ -4757,7 +4757,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 	data_end = leaf_data_end(fs_info, leaf);
 
 	if (btrfs_leaf_free_space(fs_info, leaf) < total_size) {
-		btrfs_print_leaf(fs_info, leaf);
+		btrfs_print_leaf(leaf);
 		btrfs_crit(fs_info, "not enough freespace need %u have %d",
 			   total_size, btrfs_leaf_free_space(fs_info, leaf));
 		BUG();
@@ -4767,7 +4767,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 		unsigned int old_data = btrfs_item_end_nr(leaf, slot);
 
 		if (old_data < data_end) {
-			btrfs_print_leaf(fs_info, leaf);
+			btrfs_print_leaf(leaf);
 			btrfs_crit(fs_info, "slot %d old_data %d data_end %d",
 				   slot, old_data, data_end);
 			BUG_ON(1);
@@ -4811,7 +4811,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_mark_buffer_dirty(leaf);
 
 	if (btrfs_leaf_free_space(fs_info, leaf) < 0) {
-		btrfs_print_leaf(fs_info, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 }
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b6758892874f..1d1ea6f7080d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4052,7 +4052,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 				     fs_info->dirty_metadata_batch);
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_header_level(buf) == 0 && check_leaf(root, buf)) {
-		btrfs_print_leaf(fs_info, buf);
+		btrfs_print_leaf(buf);
 		ASSERT(0);
 	}
 #endif
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 375f8c728d91..ffa1c538abfa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6973,7 +6973,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 					  "umm, got %d back from search, was looking for %llu",
 					  ret, bytenr);
 				if (ret > 0)
-					btrfs_print_leaf(info, path->nodes[0]);
+					btrfs_print_leaf(path->nodes[0]);
 			}
 			if (ret < 0) {
 				btrfs_abort_transaction(trans, ret);
@@ -6982,7 +6982,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			extent_slot = path->slots[0];
 		}
 	} else if (WARN_ON(ret == -ENOENT)) {
-		btrfs_print_leaf(info, path->nodes[0]);
+		btrfs_print_leaf(path->nodes[0]);
 		btrfs_err(info,
 			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
 			bytenr, parent, root_objectid, owner_objectid,
@@ -7019,7 +7019,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			btrfs_err(info,
 				  "umm, got %d back from search, was looking for %llu",
 				ret, bytenr);
-			btrfs_print_leaf(info, path->nodes[0]);
+			btrfs_print_leaf(path->nodes[0]);
 		}
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fcae61e175f3..569393ffd0fd 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -161,8 +161,9 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 	}
 }
 
-void btrfs_print_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *l)
+void btrfs_print_leaf(struct extent_buffer *l)
 {
+	struct btrfs_fs_info *fs_info = l->fs_info;
 	int i;
 	u32 type, nr;
 	struct btrfs_item *item;
@@ -329,7 +330,7 @@ void btrfs_print_tree(struct btrfs_fs_info *fs_info, struct extent_buffer *c)
 	nr = btrfs_header_nritems(c);
 	level = btrfs_header_level(c);
 	if (level == 0) {
-		btrfs_print_leaf(fs_info, c);
+		btrfs_print_leaf(c);
 		return;
 	}
 	btrfs_info(fs_info,
diff --git a/fs/btrfs/print-tree.h b/fs/btrfs/print-tree.h
index 4f2e0ea0e95a..689a52ee0cd1 100644
--- a/fs/btrfs/print-tree.h
+++ b/fs/btrfs/print-tree.h
@@ -18,6 +18,6 @@
 
 #ifndef __PRINT_TREE_
 #define __PRINT_TREE_
-void btrfs_print_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *l);
+void btrfs_print_leaf(struct extent_buffer *l);
 void btrfs_print_tree(struct btrfs_fs_info *fs_info, struct extent_buffer *c);
 #endif
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 460db0cb2d07..5b488af6f25e 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -151,7 +151,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	}
 
 	if (ret != 0) {
-		btrfs_print_leaf(fs_info, path->nodes[0]);
+		btrfs_print_leaf(path->nodes[0]);
 		btrfs_crit(fs_info, "unable to update root key %llu %u %llu",
 			   key->objectid, key->type, key->offset);
 		BUG_ON(1);
-- 
2.13.0

