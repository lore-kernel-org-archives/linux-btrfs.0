Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:21049 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753959AbeAKHbK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:10 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 2E892486A76D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:01 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 04/17] btrfs-progs: lowmem check: exclude extents of metadata blocks
Date: Thu, 11 Jan 2018 15:34:58 +0800
Message-ID: <20180111073511.25288-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit d17d6663c99c ("btrfs-progs: lowmem check: Fix regression which
screws up extent allocator") removes pin_metadata_blocks() from
lowmem repair.
So we have to find another way to exclude extents which should be
occupied by tree blocks.

Modify pin_down_tree_blocks() only for code reuse.
So behavior of pin_metadata_blocks() which works with option
'init-extent-tree' is not influenced.

Introduce exclude_blocks_and_extent_items() to mark extents of all tree
blocks dirty in fs_info->excluded_extents.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 63 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 24fb4bc50b95..ba60285cf80d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13543,40 +13543,54 @@ init:
 	return 0;
 }
 
-static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
-				struct extent_buffer *eb, int tree_root)
+static int traverse_tree_blocks(struct btrfs_fs_info *fs_info,
+				struct extent_buffer *eb, int tree_root,
+				int pin)
 {
 	struct extent_buffer *tmp;
 	struct btrfs_root_item *ri;
 	struct btrfs_key key;
+	struct extent_io_tree *tree;
 	u64 bytenr;
 	int level = btrfs_header_level(eb);
 	int nritems;
 	int ret;
 	int i;
+	u64 end = eb->start + eb->len;
 
+	if (pin)
+		tree = &fs_info->pinned_extents;
+	else
+		tree = fs_info->excluded_extents;
 	/*
-	 * If we have pinned this block before, don't pin it again.
+	 * If we have pinned/excluded this block before, don't do it again.
 	 * This can not only avoid forever loop with broken filesystem
 	 * but also give us some speedups.
 	 */
-	if (test_range_bit(&fs_info->pinned_extents, eb->start,
-			   eb->start + eb->len - 1, EXTENT_DIRTY, 0))
+	if (test_range_bit(tree, eb->start, end - 1, EXTENT_DIRTY, 0))
 		return 0;
 
-	btrfs_pin_extent(fs_info, eb->start, eb->len);
+	if (pin)
+		btrfs_pin_extent(fs_info, eb->start, eb->len);
+	else
+		set_extent_dirty(tree, eb->start, end - 1);
 
 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
 		if (level == 0) {
+			bool is_extent_root;
 			btrfs_item_key_to_cpu(eb, &key, i);
 			if (key.type != BTRFS_ROOT_ITEM_KEY)
 				continue;
 			/* Skip the extent root and reloc roots */
-			if (key.objectid == BTRFS_EXTENT_TREE_OBJECTID ||
-			    key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
+			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
 			    key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
 				continue;
+			is_extent_root =
+				key.objectid == BTRFS_EXTENT_TREE_OBJECTID;
+			/* If pin, skip the extent root */
+			if (pin && is_extent_root)
+				continue;
 			ri = btrfs_item_ptr(eb, i, struct btrfs_root_item);
 			bytenr = btrfs_disk_root_bytenr(eb, ri);
 
@@ -13591,7 +13605,7 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				fprintf(stderr, "Error reading root block\n");
 				return -EIO;
 			}
-			ret = pin_down_tree_blocks(fs_info, tmp, 0);
+			ret = traverse_tree_blocks(fs_info, tmp, 0, pin);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -13610,7 +13624,8 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				fprintf(stderr, "Error reading tree block\n");
 				return -EIO;
 			}
-			ret = pin_down_tree_blocks(fs_info, tmp, tree_root);
+			ret = traverse_tree_blocks(fs_info, tmp, tree_root,
+						   pin);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -13620,6 +13635,12 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
+				struct extent_buffer *eb, int tree_root)
+{
+	return traverse_tree_blocks(fs_info, eb, tree_root, 1);
+}
+
 static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
 {
 	int ret;
@@ -13631,6 +13652,38 @@ static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
 	return pin_down_tree_blocks(fs_info, fs_info->tree_root->node, 1);
 }
 
+static int exclude_tree_blocks(struct btrfs_fs_info *fs_info,
+				struct extent_buffer *eb, int tree_root)
+{
+	return traverse_tree_blocks(fs_info, eb, tree_root, 0);
+}
+
+static int exclude_metadata_blocks(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+	struct extent_io_tree *excluded_extents;
+
+	excluded_extents = malloc(sizeof(*excluded_extents));
+	if (!excluded_extents)
+		return -ENOMEM;
+	extent_io_tree_init(excluded_extents);
+	fs_info->excluded_extents = excluded_extents;
+
+	ret = exclude_tree_blocks(fs_info, fs_info->chunk_root->node, 0);
+	if (ret)
+		return ret;
+	return exclude_tree_blocks(fs_info, fs_info->tree_root->node, 1);
+}
+
+static void cleanup_excluded_extents(struct btrfs_fs_info *fs_info)
+{
+	if (fs_info->excluded_extents) {
+		extent_io_tree_cleanup(fs_info->excluded_extents);
+		free(fs_info->excluded_extents);
+	}
+	fs_info->excluded_extents = NULL;
+}
+
 static int reset_block_groups(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_group_cache *cache;
-- 
2.15.1



