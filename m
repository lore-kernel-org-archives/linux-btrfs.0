Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:40991 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751916AbdHUH6Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 03:58:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 5BFF947243AB
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 15:58:20 +0800 (CST)
From: <zhangyu-fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: Check root before printing item
Date: Mon, 21 Aug 2017 15:57:13 +0800
Message-ID: <20170821075713.32051-1-zhangyu-fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>

[TEST/fuzz] case: 004-simple-dump-tree

Since the wrong key(DATA_RELOC_TREE CHUNK_ITEM 0) in root tree,
error calling print_chunk(), resulting in num_stripes == 0.

ERROR:
     [TEST/fuzz]   004-simple-dump-tree
ctree.h:317: btrfs_chunk_item_size: BUG_ON `num_stripes == 0`
        triggered, value 1

failed (ignored, ret=134): /myproject/btrfs-progs/btrfs
inspect-internal dump-tree
/myproject/btrfs-progs/tests/fuzz-tests/images/
bko-155201-wrong-chunk-item-in-root-tree.raw.restored

test failed for case 004-simple-dump-tree
Makefile:288: recipe for target 'test-fuzz' failed
make: *** [test-fuzz] Error 1

So, before printing item, determine the root is valid or not.

Signed-off-by: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
---
 print-tree.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index a0d3395..79bb9f4 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1028,9 +1028,15 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
+			if (root != root->fs_info->tree_root ||
+				!is_fstree(objectid))
+				break;
 			print_inode_item(eb, ptr);
 			break;
 		case BTRFS_INODE_REF_KEY:
+			if (root != root->fs_info->tree_root ||
+				!is_fstree(objectid))
+				break;
 			print_inode_ref_item(eb, item_size, ptr);
 			break;
 		case BTRFS_INODE_EXTREF_KEY:
@@ -1039,10 +1045,14 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 		case BTRFS_DIR_ITEM_KEY:
 		case BTRFS_DIR_INDEX_KEY:
 		case BTRFS_XATTR_ITEM_KEY:
+			if (!is_fstree(objectid))
+				break;
 			print_dir_item(eb, item_size, ptr);
 			break;
 		case BTRFS_DIR_LOG_INDEX_KEY:
 		case BTRFS_DIR_LOG_ITEM_KEY: {
+			if (root != root->fs_info->log_root_tree)
+				break;
 			struct btrfs_dir_log_item *dlog;
 
 			dlog = btrfs_item_ptr(eb, i, struct btrfs_dir_log_item);
@@ -1051,30 +1061,48 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 			break;
 			}
 		case BTRFS_ORPHAN_ITEM_KEY:
+			if (root != root->fs_info->tree_root)
+				break;
 			printf("\t\torphan item\n");
 			break;
 		case BTRFS_ROOT_ITEM_KEY:
+			if (root != root->fs_info->tree_root)
+				break;
 			print_root(eb, i);
 			break;
 		case BTRFS_ROOT_REF_KEY:
+			if (root != root->fs_info->tree_root)
+				break;
 			print_root_ref(eb, i, "ref");
 			break;
 		case BTRFS_ROOT_BACKREF_KEY:
+			if (root != root->fs_info->tree_root)
+				break;
 			print_root_ref(eb, i, "backref");
 			break;
 		case BTRFS_EXTENT_ITEM_KEY:
+			if (root != root->fs_info->extent_root)
+				break;
 			print_extent_item(eb, i, 0);
 			break;
 		case BTRFS_METADATA_ITEM_KEY:
+			if (root != root->fs_info->extent_root)
+				break;
 			print_extent_item(eb, i, 1);
 			break;
 		case BTRFS_TREE_BLOCK_REF_KEY:
+			if (root != root->fs_info->extent_root)
+				break;
 			printf("\t\ttree block backref\n");
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
+			if (root != root->fs_info->extent_root)
+				break;
 			printf("\t\tshared block backref\n");
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
+			if (root != root->fs_info->extent_root)
+				break;
 			struct btrfs_extent_data_ref *dref;
 
 			dref = btrfs_item_ptr(eb, i, struct btrfs_extent_data_ref);
@@ -1087,7 +1115,10 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 			break;
 			}
 		case BTRFS_SHARED_DATA_REF_KEY: {
+			if (root != root->fs_info->extent_root)
+				break;
 			struct btrfs_shared_data_ref *sref;
+
 			sref = btrfs_item_ptr(eb, i, struct btrfs_shared_data_ref);
 			printf("\t\tshared data backref count %u\n",
 			       btrfs_shared_data_ref_count(eb, sref));
@@ -1101,15 +1132,23 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 #endif
 			break;
 		case BTRFS_CSUM_ITEM_KEY:
+			if (root != root->fs_info->csum_root)
+				break;
 			printf("\t\tcsum item\n");
 			break;
 		case BTRFS_EXTENT_CSUM_KEY:
+			if (root != root->fs_info->csum_root)
+				break;
 			printf("\t\textent csum item\n");
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
+			if (!is_fstree(objectid))
+				break;
 			print_file_extent_item(eb, item, i, ptr);
 			break;
 		case BTRFS_BLOCK_GROUP_ITEM_KEY: {
+			if (root != root->fs_info->extent_root)
+				break;
 			struct btrfs_block_group_item bg_item;
 
 			read_extent_buffer(eb, &bg_item, (unsigned long)ptr,
@@ -1124,6 +1163,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 			break;
 			}
 		case BTRFS_FREE_SPACE_INFO_KEY: {
+			if (root != root->fs_info->free_space_root)
+				break;
 			struct btrfs_free_space_info *free_info;
 
 			free_info = btrfs_item_ptr(eb, i, struct btrfs_free_space_info);
@@ -1133,18 +1174,28 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 			break;
 			}
 		case BTRFS_FREE_SPACE_EXTENT_KEY:
+			if (root != root->fs_info->free_space_root)
+				break;
 			printf("\t\tfree space extent\n");
 			break;
 		case BTRFS_FREE_SPACE_BITMAP_KEY:
+			if (root != root->fs_info->free_space_root)
+				break;
 			printf("\t\tfree space bitmap\n");
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
+			if (root != root->fs_info->chunk_root)
+				break;
 			print_chunk(eb, ptr);
 			break;
 		case BTRFS_DEV_ITEM_KEY:
+			if (root != root->fs_info->chunk_root)
+				break;
 			print_dev_item(eb, ptr);
 			break;
 		case BTRFS_DEV_EXTENT_KEY: {
+			if (root != root->fs_info->dev_root)
+				break;
 			struct btrfs_dev_extent *dev_extent;
 
 			dev_extent = btrfs_item_ptr(eb, i,
@@ -1169,6 +1220,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 			break;
 			}
 		case BTRFS_QGROUP_STATUS_KEY: {
+			if (root != root->fs_info->quota_root)
+				break;
 			struct btrfs_qgroup_status_item *qg_status;
 
 			qg_status = btrfs_item_ptr(eb, i,
@@ -1190,6 +1243,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 		case BTRFS_QGROUP_RELATION_KEY:
 			break;
 		case BTRFS_QGROUP_INFO_KEY: {
+			if (root != root->fs_info->quota_root)
+				break;
 			struct btrfs_qgroup_info_item *qg_info;
 
 			qg_info = btrfs_item_ptr(eb, i,
@@ -1212,6 +1267,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 			break;
 			}
 		case BTRFS_QGROUP_LIMIT_KEY: {
+			if (root != root->fs_info->quota_root)
+				break;
 			struct btrfs_qgroup_limit_item *qg_limit;
 
 			qg_limit = btrfs_item_ptr(eb, i,
-- 
2.9.4



