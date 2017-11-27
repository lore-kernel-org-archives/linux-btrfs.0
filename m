Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:1322 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751126AbdK0DKR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Nov 2017 22:10:17 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH 3/3] btrfs-progs: check: exclude extents of tree blocks and extent items
Date: Mon, 27 Nov 2017 11:13:53 +0800
Message-ID: <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
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
blocks dirty in fs_info->excluded_extents. It also calls
exclude_extent_items() to exclude extent_items in extent tree.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 112 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c7b570bef9c3..f39285c5a3c2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13351,6 +13351,7 @@ out:
 	return err;
 }
 
+static int exclude_blocks_and_extent_items(struct btrfs_fs_info *fs_info);
 /*
  * Low memory usage version check_chunks_and_extents.
  */
@@ -13363,12 +13364,22 @@ static int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
 	struct btrfs_root *root1;
 	struct btrfs_root *root;
 	struct btrfs_root *cur_root;
+	struct extent_io_tree excluded_extents;
 	int err = 0;
 	int ret;
 
 	root = fs_info->fs_root;
 
 	if (repair) {
+		extent_io_tree_init(&excluded_extents);
+		fs_info->excluded_extents = &excluded_extents;
+		ret = exclude_blocks_and_extent_items(fs_info);
+		if (ret) {
+			error("failed to exclude tree blocks and extent items");
+			return ret;
+		}
+		reset_cached_block_groups(fs_info);
+
 		trans = btrfs_start_transaction(fs_info->extent_root, 1);
 		if (IS_ERR(trans)) {
 			error("failed to start transaction before check");
@@ -13437,6 +13448,8 @@ out:
 			err |= ret;
 		else
 			err &= ~BG_ACCOUNTING_ERROR;
+		extent_io_tree_cleanup(&excluded_extents);
+		fs_info->excluded_extents = NULL;
 	}
 
 	if (trans)
@@ -13534,40 +13547,106 @@ init:
 	return 0;
 }
 
-static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
-				struct extent_buffer *eb, int tree_root)
+static int exclude_extent_items(struct btrfs_fs_info *fs_info,
+				struct extent_io_tree *tree)
+{
+	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_buffer *eb;
+	int slot;
+	int ret;
+	u64 start;
+	u64 end;
+
+	ASSERT(tree);
+	btrfs_init_path(&path);
+	key.objectid = 0;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		eb = path.nodes[0];
+		slot = path.slots[0];
+		btrfs_item_key_to_cpu(eb, &key, slot);
+		if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+		    key.type != BTRFS_METADATA_ITEM_KEY)
+			goto next;
+		start = key.objectid;
+		if (key.type == BTRFS_EXTENT_ITEM_KEY)
+			end = start + key.offset;
+		else
+			end = start + fs_info->nodesize;
+
+		set_extent_dirty(tree, start, end - 1);
+next:
+		ret = btrfs_next_item(root, &path);
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+		if (ret < 0)
+			goto out;
+	}
+out:
+	if (ret)
+		error("failed to exclude extent items");
+	btrfs_release_path(&path);
+	return ret;
+}
+
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
 
@@ -13582,7 +13661,7 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				fprintf(stderr, "Error reading root block\n");
 				return -EIO;
 			}
-			ret = pin_down_tree_blocks(fs_info, tmp, 0);
+			ret = traverse_tree_blocks(fs_info, tmp, 0, pin);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -13601,7 +13680,8 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				fprintf(stderr, "Error reading tree block\n");
 				return -EIO;
 			}
-			ret = pin_down_tree_blocks(fs_info, tmp, tree_root);
+			ret = traverse_tree_blocks(fs_info, tmp, tree_root,
+						   pin);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -13611,6 +13691,12 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
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
@@ -13622,6 +13708,22 @@ static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
 	return pin_down_tree_blocks(fs_info, fs_info->tree_root->node, 1);
 }
 
+static int exclude_tree_blocks(struct btrfs_fs_info *fs_info,
+				struct extent_buffer *eb, int tree_root)
+{
+	return traverse_tree_blocks(fs_info, fs_info->tree_root->node, 1, 0);
+}
+
+static int exclude_blocks_and_extent_items(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	ret = exclude_extent_items(fs_info, fs_info->excluded_extents);
+	if (ret)
+		return ret;
+	return exclude_tree_blocks(fs_info, fs_info->tree_root->node, 1);
+}
+
 static int reset_block_groups(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_group_cache *cache;
-- 
2.15.0



