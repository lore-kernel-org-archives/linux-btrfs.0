Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753660AbeAKFKE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:04 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A67DE48AEA11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:51 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/67] btrfs-progs: add the stack prefix for disk_key_offset set/get function
Date: Thu, 11 Jan 2018 13:08:37 +0800
Message-ID: <20180111050939.21251-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The disk_key_offset set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 chunk-recover.c  |  2 +-
 cmds-check.c     |  4 ++--
 convert/common.c | 16 ++++++++--------
 ctree.c          |  4 ++--
 ctree.h          |  3 ++-
 image/main.c     |  2 +-
 mkfs/common.c    | 15 ++++++++-------
 print-tree.c     |  4 ++--
 qgroup-verify.c  |  2 +-
 9 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 0448e5e9..89c0eea6 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1162,7 +1162,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 	}
 	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
-	btrfs_set_disk_key_offset(&disk_key, min_devid);
+	btrfs_set_stack_disk_key_offset(&disk_key, min_devid);
 
 	cow = btrfs_alloc_free_block(trans, root, root->fs_info->nodesize,
 				     BTRFS_CHUNK_TREE_OBJECTID,
diff --git a/cmds-check.c b/cmds-check.c
index a39e651a..68ba3448 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2625,7 +2625,7 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 			btrfs_set_stack_disk_key_objectid(&copy_key,
 							  root->objectid);
 			btrfs_set_disk_key_type(&copy_key, 0);
-			btrfs_set_disk_key_offset(&copy_key, 0);
+			btrfs_set_stack_disk_key_offset(&copy_key, 0);
 
 			btrfs_set_tree_block_level(eb, bi, level);
 			btrfs_set_tree_block_key(eb, bi, &copy_key);
@@ -9731,7 +9731,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 			btrfs_set_stack_disk_key_objectid(&copy_key,
 						    rec->info_objectid);
 			btrfs_set_disk_key_type(&copy_key, 0);
-			btrfs_set_disk_key_offset(&copy_key, 0);
+			btrfs_set_stack_disk_key_offset(&copy_key, 0);
 
 			btrfs_set_tree_block_level(leaf, bi, rec->info_level);
 			btrfs_set_tree_block_key(leaf, bi, &copy_key);
diff --git a/convert/common.c b/convert/common.c
index d18a5179..6b5f98dd 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -200,7 +200,7 @@ static void insert_temp_root_item(struct extent_buffer *buf,
 	memset(&disk_key, 0, sizeof(disk_key));
 	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key, objectid);
-	btrfs_set_disk_key_offset(&disk_key, 0);
+	btrfs_set_stack_disk_key_offset(&disk_key, 0);
 
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
@@ -307,7 +307,7 @@ static int insert_temp_dev_item(int fd, struct extent_buffer *buf,
 	/* setup device item 1, 0 is for replace case */
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
-	btrfs_set_disk_key_offset(&disk_key, 1);
+	btrfs_set_stack_disk_key_offset(&disk_key, 1);
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
 	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(*dev_item));
@@ -368,7 +368,7 @@ static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
 	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key,
 					  BTRFS_FIRST_CHUNK_TREE_OBJECTID);
-	btrfs_set_disk_key_offset(&disk_key, start);
+	btrfs_set_stack_disk_key_offset(&disk_key, start);
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
 	btrfs_set_item_size(buf, btrfs_item_nr(*slot),
@@ -471,7 +471,7 @@ static void insert_temp_dev_extent(struct extent_buffer *buf,
 	(*itemoff) -= sizeof(*dev_extent);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key, 1);
-	btrfs_set_disk_key_offset(&disk_key, start);
+	btrfs_set_stack_disk_key_offset(&disk_key, start);
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
 	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(*dev_extent));
@@ -597,10 +597,10 @@ static int insert_temp_extent_item(int fd, struct extent_buffer *buf,
 
 	if (skinny_metadata) {
 		btrfs_set_disk_key_type(&disk_key, BTRFS_METADATA_ITEM_KEY);
-		btrfs_set_disk_key_offset(&disk_key, 0);
+		btrfs_set_stack_disk_key_offset(&disk_key, 0);
 	} else {
 		btrfs_set_disk_key_type(&disk_key, BTRFS_EXTENT_ITEM_KEY);
-		btrfs_set_disk_key_offset(&disk_key, cfg->nodesize);
+		btrfs_set_stack_disk_key_offset(&disk_key, cfg->nodesize);
 	}
 	btrfs_set_stack_disk_key_objectid(&disk_key, bytenr);
 
@@ -646,7 +646,7 @@ static int insert_temp_extent_item(int fd, struct extent_buffer *buf,
 	if (btrfs_header_nritems(tmp) == 0) {
 		btrfs_set_disk_key_type(&tree_info_key, 0);
 		btrfs_set_stack_disk_key_objectid(&tree_info_key, 0);
-		btrfs_set_disk_key_offset(&tree_info_key, 0);
+		btrfs_set_stack_disk_key_offset(&tree_info_key, 0);
 	} else {
 		btrfs_item_key(tmp, &tree_info_key, 0);
 	}
@@ -669,7 +669,7 @@ static void insert_temp_block_group(struct extent_buffer *buf,
 	(*itemoff) -= sizeof(bgi);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_BLOCK_GROUP_ITEM_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key, bytenr);
-	btrfs_set_disk_key_offset(&disk_key, len);
+	btrfs_set_stack_disk_key_offset(&disk_key, len);
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
 	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(bgi));
diff --git a/ctree.c b/ctree.c
index 4d8b0e05..818bdfda 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2372,8 +2372,8 @@ int btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 			      data_end + size_diff, btrfs_leaf_data(leaf) +
 			      data_end, old_data_start - data_end);
 
-		offset = btrfs_disk_key_offset(&disk_key);
-		btrfs_set_disk_key_offset(&disk_key, offset + size_diff);
+		offset = btrfs_stack_disk_key_offset(&disk_key);
+		btrfs_set_stack_disk_key_offset(&disk_key, offset + size_diff);
 		btrfs_set_item_key(leaf, &disk_key, slot);
 		if (slot == 0)
 			btrfs_fixup_low_keys(root, path, &disk_key, 1);
diff --git a/ctree.h b/ctree.h
index 59f56599..3a1ddd59 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1929,7 +1929,8 @@ static inline void btrfs_set_free_space_key(struct extent_buffer *eb,
 /* struct btrfs_disk_key */
 BTRFS_SETGET_STACK_FUNCS(stack_disk_key_objectid, struct btrfs_disk_key,
 			 objectid, 64);
-BTRFS_SETGET_STACK_FUNCS(disk_key_offset, struct btrfs_disk_key, offset, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_disk_key_offset, struct btrfs_disk_key, offset,
+			 64);
 BTRFS_SETGET_STACK_FUNCS(disk_key_type, struct btrfs_disk_key, type, 8);
 
 static inline void btrfs_disk_key_to_cpu(struct btrfs_key *cpu,
diff --git a/image/main.c b/image/main.c
index 69897b91..7060ebda 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1102,7 +1102,7 @@ static void update_super_old(u8 *buffer)
 
 	btrfs_set_stack_disk_key_objectid(key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_disk_key_type(key, BTRFS_CHUNK_ITEM_KEY);
-	btrfs_set_disk_key_offset(key, 0);
+	btrfs_set_stack_disk_key_offset(key, 0);
 
 	btrfs_set_stack_chunk_length(chunk, (u64)-1);
 	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
diff --git a/mkfs/common.c b/mkfs/common.c
index 2697437a..f4655b63 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -62,7 +62,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_root_generation(&root_item, 1);
 
 	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
-	btrfs_set_disk_key_offset(&disk_key, 0);
+	btrfs_set_stack_disk_key_offset(&disk_key, 0);
 	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize) - sizeof(root_item);
 
 	for (blk = 0; blk < MKFS_BLOCK_COUNT; blk++) {
@@ -228,11 +228,12 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 		if (skinny_metadata) {
 			btrfs_set_disk_key_type(&disk_key,
 						BTRFS_METADATA_ITEM_KEY);
-			btrfs_set_disk_key_offset(&disk_key, 0);
+			btrfs_set_stack_disk_key_offset(&disk_key, 0);
 		} else {
 			btrfs_set_disk_key_type(&disk_key,
 						BTRFS_EXTENT_ITEM_KEY);
-			btrfs_set_disk_key_offset(&disk_key, cfg->nodesize);
+			btrfs_set_stack_disk_key_offset(&disk_key,
+							cfg->nodesize);
 		}
 		btrfs_set_item_key(buf, &disk_key, nritems);
 		btrfs_set_item_offset(buf, btrfs_item_nr(nritems),
@@ -250,7 +251,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 		/* create extent ref */
 		ref_root = reference_root_table[i];
 		btrfs_set_stack_disk_key_objectid(&disk_key, cfg->blocks[i]);
-		btrfs_set_disk_key_offset(&disk_key, ref_root);
+		btrfs_set_stack_disk_key_offset(&disk_key, ref_root);
 		btrfs_set_disk_key_type(&disk_key, BTRFS_TREE_BLOCK_REF_KEY);
 		btrfs_set_item_key(buf, &disk_key, nritems);
 		btrfs_set_item_offset(buf, btrfs_item_nr(nritems),
@@ -277,7 +278,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 
 	/* first device 1 (there is no device 0) */
 	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
-	btrfs_set_disk_key_offset(&disk_key, 1);
+	btrfs_set_stack_disk_key_offset(&disk_key, 1);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
 	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
@@ -310,7 +311,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	/* then we have chunk 0 */
 	btrfs_set_stack_disk_key_objectid(&disk_key,
 					  BTRFS_FIRST_CHUNK_TREE_OBJECTID);
-	btrfs_set_disk_key_offset(&disk_key, 0);
+	btrfs_set_stack_disk_key_offset(&disk_key, 0);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
 	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
@@ -364,7 +365,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 		sizeof(struct btrfs_dev_extent);
 
 	btrfs_set_stack_disk_key_objectid(&disk_key, 1);
-	btrfs_set_disk_key_offset(&disk_key, 0);
+	btrfs_set_stack_disk_key_offset(&disk_key, 0);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
 	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
diff --git a/print-tree.c b/print-tree.c
index 254982bc..6e7ccfeb 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -809,7 +809,7 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 {
 	u64 objectid = btrfs_stack_disk_key_objectid(disk_key);
 	u8 type = btrfs_disk_key_type(disk_key);
-	u64 offset = btrfs_disk_key_offset(disk_key);
+	u64 offset = btrfs_stack_disk_key_offset(disk_key);
 
 	printf("key (");
 	print_objectid(stdout, objectid, type);
@@ -1204,7 +1204,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 		btrfs_item_key(eb, &disk_key, i);
 		objectid = btrfs_stack_disk_key_objectid(&disk_key);
 		type = btrfs_disk_key_type(&disk_key);
-		offset = btrfs_disk_key_offset(&disk_key);
+		offset = btrfs_stack_disk_key_offset(&disk_key);
 
 		printf("\titem %d ", i);
 		btrfs_print_key(&disk_key);
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 571b4d4f..5b21bdc7 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -851,7 +851,7 @@ static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
 	struct qgroup_info *item;
 
 	if (c) {
-		c->qgroupid = btrfs_disk_key_offset(key);
+		c->qgroupid = btrfs_stack_disk_key_offset(key);
 		c->key = *key;
 
 		item = &c->diskinfo;
-- 
2.15.1



