Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13848 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752162AbeBHDXG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:06 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id BB92348AE765
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:00 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 04/18] btrfs-progs: lowmem check: exclude extents of metadata blocks
Date: Thu, 8 Feb 2018 11:27:23 +0800
Message-ID: <20180208032737.31561-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit d17d6663c99c ("btrfs-progs: lowmem check: Fix regression which
screws up extent allocator") removes pin_metadata_blocks() from
lowmem repair.
So we have to find another way to exclude extents which should be
occupied by tree blocks.

Introduce exclude_metadata_blocks() to mark extents of all tree
blocks dirty in fs_info->excluded_extents.
Export it since it will be used in lowmem too.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-common.c | 73 +++++++++++++++++++++++++++++++++++++++++++++--------
 check/mode-common.h |  2 ++
 2 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index e6d8ebe8b9b7..acceb24b9597 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -377,40 +377,54 @@ int zero_log_tree(struct btrfs_root *root)
 	return ret;
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
 
@@ -425,7 +439,7 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				fprintf(stderr, "Error reading root block\n");
 				return -EIO;
 			}
-			ret = pin_down_tree_blocks(fs_info, tmp, 0);
+			ret = traverse_tree_blocks(fs_info, tmp, 0, pin);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -444,7 +458,8 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				fprintf(stderr, "Error reading tree block\n");
 				return -EIO;
 			}
-			ret = pin_down_tree_blocks(fs_info, tmp, tree_root);
+			ret = traverse_tree_blocks(fs_info, tmp, tree_root,
+						   pin);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -454,6 +469,12 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
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
@@ -465,6 +486,38 @@ static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
 	return pin_down_tree_blocks(fs_info, fs_info->tree_root->node, 1);
 }
 
+static int exclude_tree_blocks(struct btrfs_fs_info *fs_info,
+				struct extent_buffer *eb, int tree_root)
+{
+	return traverse_tree_blocks(fs_info, eb, tree_root, 0);
+}
+
+int exclude_metadata_blocks(struct btrfs_fs_info *fs_info)
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
+void cleanup_excluded_extents(struct btrfs_fs_info *fs_info)
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
diff --git a/check/mode-common.h b/check/mode-common.h
index e1835d94ab11..e2a824a318c1 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -134,4 +134,6 @@ bool is_super_size_valid(struct btrfs_fs_info *fs_info);
 int check_space_cache(struct btrfs_root *root);
 int check_csums(struct btrfs_root *root);
 int recow_extent_buffer(struct btrfs_root *root, struct extent_buffer *eb);
+int exclude_metadata_blocks(struct btrfs_fs_info *fs_info);
+void cleanup_excluded_extents(struct btrfs_fs_info *fs_info);
 #endif
-- 
2.16.1



