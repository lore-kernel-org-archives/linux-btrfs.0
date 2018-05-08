Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2328 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933091AbeEHIY0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:26 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 01/16] btrfs-progs: check: move pin_down_tree_blocks to mode-common.c
Date: Tue, 8 May 2018 16:29:57 +0800
Message-ID: <20180508083012.12090-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move pin_down_tree_blocks from main.c to mode-common.c for
further patches.
And export pin_metadata_blocks to mode-common.h.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/main.c        | 88 ---------------------------------------------
 check/mode-common.c | 88 +++++++++++++++++++++++++++++++++++++++++++++
 check/mode-common.h |  1 +
 3 files changed, 89 insertions(+), 88 deletions(-)

diff --git a/check/main.c b/check/main.c
index 11a6561a5eac..4944e72e6eb9 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8367,94 +8367,6 @@ init:
 	return 0;
 }
 
-static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
-				struct extent_buffer *eb, int tree_root)
-{
-	struct extent_buffer *tmp;
-	struct btrfs_root_item *ri;
-	struct btrfs_key key;
-	u64 bytenr;
-	int level = btrfs_header_level(eb);
-	int nritems;
-	int ret;
-	int i;
-
-	/*
-	 * If we have pinned this block before, don't pin it again.
-	 * This can not only avoid forever loop with broken filesystem
-	 * but also give us some speedups.
-	 */
-	if (test_range_bit(&fs_info->pinned_extents, eb->start,
-			   eb->start + eb->len - 1, EXTENT_DIRTY, 0))
-		return 0;
-
-	btrfs_pin_extent(fs_info, eb->start, eb->len);
-
-	nritems = btrfs_header_nritems(eb);
-	for (i = 0; i < nritems; i++) {
-		if (level == 0) {
-			btrfs_item_key_to_cpu(eb, &key, i);
-			if (key.type != BTRFS_ROOT_ITEM_KEY)
-				continue;
-			/* Skip the extent root and reloc roots */
-			if (key.objectid == BTRFS_EXTENT_TREE_OBJECTID ||
-			    key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
-			    key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
-				continue;
-			ri = btrfs_item_ptr(eb, i, struct btrfs_root_item);
-			bytenr = btrfs_disk_root_bytenr(eb, ri);
-
-			/*
-			 * If at any point we start needing the real root we
-			 * will have to build a stump root for the root we are
-			 * in, but for now this doesn't actually use the root so
-			 * just pass in extent_root.
-			 */
-			tmp = read_tree_block(fs_info, bytenr, 0);
-			if (!extent_buffer_uptodate(tmp)) {
-				fprintf(stderr, "Error reading root block\n");
-				return -EIO;
-			}
-			ret = pin_down_tree_blocks(fs_info, tmp, 0);
-			free_extent_buffer(tmp);
-			if (ret)
-				return ret;
-		} else {
-			bytenr = btrfs_node_blockptr(eb, i);
-
-			/* If we aren't the tree root don't read the block */
-			if (level == 1 && !tree_root) {
-				btrfs_pin_extent(fs_info, bytenr,
-						fs_info->nodesize);
-				continue;
-			}
-
-			tmp = read_tree_block(fs_info, bytenr, 0);
-			if (!extent_buffer_uptodate(tmp)) {
-				fprintf(stderr, "Error reading tree block\n");
-				return -EIO;
-			}
-			ret = pin_down_tree_blocks(fs_info, tmp, tree_root);
-			free_extent_buffer(tmp);
-			if (ret)
-				return ret;
-		}
-	}
-
-	return 0;
-}
-
-static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
-{
-	int ret;
-
-	ret = pin_down_tree_blocks(fs_info, fs_info->chunk_root->node, 0);
-	if (ret)
-		return ret;
-
-	return pin_down_tree_blocks(fs_info, fs_info->tree_root->node, 1);
-}
-
 static int reset_block_groups(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_group_cache *cache;
diff --git a/check/mode-common.c b/check/mode-common.c
index e857d44defa4..0b57412b0edf 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -605,3 +605,91 @@ void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
 		start = cache->key.objectid + cache->key.offset;
 	}
 }
+
+static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
+				struct extent_buffer *eb, int tree_root)
+{
+	struct extent_buffer *tmp;
+	struct btrfs_root_item *ri;
+	struct btrfs_key key;
+	u64 bytenr;
+	int level = btrfs_header_level(eb);
+	int nritems;
+	int ret;
+	int i;
+
+	/*
+	 * If we have pinned this block before, don't pin it again.
+	 * This can not only avoid forever loop with broken filesystem
+	 * but also give us some speedups.
+	 */
+	if (test_range_bit(&fs_info->pinned_extents, eb->start,
+			   eb->start + eb->len - 1, EXTENT_DIRTY, 0))
+		return 0;
+
+	btrfs_pin_extent(fs_info, eb->start, eb->len);
+
+	nritems = btrfs_header_nritems(eb);
+	for (i = 0; i < nritems; i++) {
+		if (level == 0) {
+			btrfs_item_key_to_cpu(eb, &key, i);
+			if (key.type != BTRFS_ROOT_ITEM_KEY)
+				continue;
+			/* Skip the extent root and reloc roots */
+			if (key.objectid == BTRFS_EXTENT_TREE_OBJECTID ||
+			    key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
+			    key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+				continue;
+			ri = btrfs_item_ptr(eb, i, struct btrfs_root_item);
+			bytenr = btrfs_disk_root_bytenr(eb, ri);
+
+			/*
+			 * If at any point we start needing the real root we
+			 * will have to build a stump root for the root we are
+			 * in, but for now this doesn't actually use the root so
+			 * just pass in extent_root.
+			 */
+			tmp = read_tree_block(fs_info, bytenr, 0);
+			if (!extent_buffer_uptodate(tmp)) {
+				fprintf(stderr, "Error reading root block\n");
+				return -EIO;
+			}
+			ret = pin_down_tree_blocks(fs_info, tmp, 0);
+			free_extent_buffer(tmp);
+			if (ret)
+				return ret;
+		} else {
+			bytenr = btrfs_node_blockptr(eb, i);
+
+			/* If we aren't the tree root don't read the block */
+			if (level == 1 && !tree_root) {
+				btrfs_pin_extent(fs_info, bytenr,
+						fs_info->nodesize);
+				continue;
+			}
+
+			tmp = read_tree_block(fs_info, bytenr, 0);
+			if (!extent_buffer_uptodate(tmp)) {
+				fprintf(stderr, "Error reading tree block\n");
+				return -EIO;
+			}
+			ret = pin_down_tree_blocks(fs_info, tmp, tree_root);
+			free_extent_buffer(tmp);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	ret = pin_down_tree_blocks(fs_info, fs_info->chunk_root->node, 0);
+	if (ret)
+		return ret;
+
+	return pin_down_tree_blocks(fs_info, fs_info->tree_root->node, 1);
+}
diff --git a/check/mode-common.h b/check/mode-common.h
index 877c1aa9d68e..65d2ae4188f1 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -98,5 +98,6 @@ void reada_walk_down(struct btrfs_root *root, struct extent_buffer *node,
 int check_child_node(struct extent_buffer *parent, int slot,
 		     struct extent_buffer *child);
 void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
+int pin_metadata_blocks(struct btrfs_fs_info *fs_info);
 
 #endif
-- 
2.17.0



