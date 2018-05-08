Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2328 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932878AbeEHIYY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:24 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 02/16] btrfs-progs: lowmem: exclude extents of metadata blocks
Date: Tue, 8 May 2018 16:29:58 +0800
Message-ID: <20180508083012.12090-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit d17d6663c99c ("btrfs-progs: lowmem check: Fix regression which
screws up extent allocator") removes pin_metadata_blocks() from
lowmem repair.
So we have to find another way to exclude extents which should be
occupied by existed tree blocks.

Modify pin_down_tree_blocks() and rename it to traverse_tree_blocks
for sharing codes between new function exclude_metadata_blocks().

exclude_metadata_blocks() traverses and mark extents of all tree
blocks dirty in fs_info->excluded_extents.
cleanup_excluded_extents() is responsible for cleanup.
Export them to mode-common.h since they will be used both in original
and lowmem modes.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-common.c | 73 ++++++++++++++++++++++++++++++++++++++-------
 check/mode-common.h |  2 ++
 2 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index 0b57412b0edf..db9e429937fd 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -606,40 +606,54 @@ void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
 	}
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
 
@@ -654,7 +668,7 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				fprintf(stderr, "Error reading root block\n");
 				return -EIO;
 			}
-			ret = pin_down_tree_blocks(fs_info, tmp, 0);
+			ret = traverse_tree_blocks(fs_info, tmp, 0, pin);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -673,7 +687,8 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				fprintf(stderr, "Error reading tree block\n");
 				return -EIO;
 			}
-			ret = pin_down_tree_blocks(fs_info, tmp, tree_root);
+			ret = traverse_tree_blocks(fs_info, tmp, tree_root,
+						   pin);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -683,6 +698,12 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
+				struct extent_buffer *eb, int tree_root)
+{
+	return traverse_tree_blocks(fs_info, eb, tree_root, 1);
+}
+
 int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
 {
 	int ret;
@@ -693,3 +714,35 @@ int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
 
 	return pin_down_tree_blocks(fs_info, fs_info->tree_root->node, 1);
 }
+
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
diff --git a/check/mode-common.h b/check/mode-common.h
index 65d2ae4188f1..a47485783409 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -99,5 +99,7 @@ int check_child_node(struct extent_buffer *parent, int slot,
 		     struct extent_buffer *child);
 void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
 int pin_metadata_blocks(struct btrfs_fs_info *fs_info);
+int exclude_metadata_blocks(struct btrfs_fs_info *fs_info);
+void cleanup_excluded_extents(struct btrfs_fs_info *fs_info);
 
 #endif
-- 
2.17.0



