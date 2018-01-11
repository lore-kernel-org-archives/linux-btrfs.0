Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753668AbeAKFKD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:03 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 249FE48AEA13
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:52 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/67] btrfs-progs: add the stack prefix for disk_key_type set/get function
Date: Thu, 11 Jan 2018 13:08:38 +0800
Message-ID: <20180111050939.21251-7-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The disk_key_type set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 chunk-recover.c  |  2 +-
 cmds-check.c     |  4 ++--
 convert/common.c | 17 +++++++++--------
 ctree.c          |  3 ++-
 ctree.h          |  2 +-
 image/main.c     |  2 +-
 mkfs/common.c    | 15 ++++++++-------
 print-tree.c     |  4 ++--
 8 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 89c0eea6..123cd097 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1161,7 +1161,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 			min_devid = dev->devid;
 	}
 	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
-	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_stack_disk_key_offset(&disk_key, min_devid);
 
 	cow = btrfs_alloc_free_block(trans, root, root->fs_info->nodesize,
diff --git a/cmds-check.c b/cmds-check.c
index 68ba3448..8c66cff1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2624,7 +2624,7 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 					     sizeof(*bi));
 			btrfs_set_stack_disk_key_objectid(&copy_key,
 							  root->objectid);
-			btrfs_set_disk_key_type(&copy_key, 0);
+			btrfs_set_stack_disk_key_type(&copy_key, 0);
 			btrfs_set_stack_disk_key_offset(&copy_key, 0);
 
 			btrfs_set_tree_block_level(eb, bi, level);
@@ -9730,7 +9730,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 
 			btrfs_set_stack_disk_key_objectid(&copy_key,
 						    rec->info_objectid);
-			btrfs_set_disk_key_type(&copy_key, 0);
+			btrfs_set_stack_disk_key_type(&copy_key, 0);
 			btrfs_set_stack_disk_key_offset(&copy_key, 0);
 
 			btrfs_set_tree_block_level(leaf, bi, rec->info_level);
diff --git a/convert/common.c b/convert/common.c
index 6b5f98dd..b1e1dd13 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -198,7 +198,7 @@ static void insert_temp_root_item(struct extent_buffer *buf,
 	btrfs_set_root_bytenr(&root_item, bytenr);
 
 	memset(&disk_key, 0, sizeof(disk_key));
-	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key, objectid);
 	btrfs_set_stack_disk_key_offset(&disk_key, 0);
 
@@ -305,7 +305,7 @@ static int insert_temp_dev_item(int fd, struct extent_buffer *buf,
 	btrfs_set_header_nritems(buf, *slot + 1);
 	(*itemoff) -= sizeof(*dev_item);
 	/* setup device item 1, 0 is for replace case */
-	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
 	btrfs_set_stack_disk_key_offset(&disk_key, 1);
 	btrfs_set_item_key(buf, &disk_key, *slot);
@@ -365,7 +365,7 @@ static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
 
 	btrfs_set_header_nritems(buf, *slot + 1);
 	(*itemoff) -= btrfs_chunk_item_size(1);
-	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key,
 					  BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_stack_disk_key_offset(&disk_key, start);
@@ -469,7 +469,7 @@ static void insert_temp_dev_extent(struct extent_buffer *buf,
 
 	btrfs_set_header_nritems(buf, *slot + 1);
 	(*itemoff) -= sizeof(*dev_extent);
-	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key, 1);
 	btrfs_set_stack_disk_key_offset(&disk_key, start);
 	btrfs_set_item_key(buf, &disk_key, *slot);
@@ -596,10 +596,11 @@ static int insert_temp_extent_item(int fd, struct extent_buffer *buf,
 	*(itemoff) -= itemsize;
 
 	if (skinny_metadata) {
-		btrfs_set_disk_key_type(&disk_key, BTRFS_METADATA_ITEM_KEY);
+		btrfs_set_stack_disk_key_type(&disk_key,
+					      BTRFS_METADATA_ITEM_KEY);
 		btrfs_set_stack_disk_key_offset(&disk_key, 0);
 	} else {
-		btrfs_set_disk_key_type(&disk_key, BTRFS_EXTENT_ITEM_KEY);
+		btrfs_set_stack_disk_key_type(&disk_key, BTRFS_EXTENT_ITEM_KEY);
 		btrfs_set_stack_disk_key_offset(&disk_key, cfg->nodesize);
 	}
 	btrfs_set_stack_disk_key_objectid(&disk_key, bytenr);
@@ -644,7 +645,7 @@ static int insert_temp_extent_item(int fd, struct extent_buffer *buf,
 		goto out;
 	}
 	if (btrfs_header_nritems(tmp) == 0) {
-		btrfs_set_disk_key_type(&tree_info_key, 0);
+		btrfs_set_stack_disk_key_type(&tree_info_key, 0);
 		btrfs_set_stack_disk_key_objectid(&tree_info_key, 0);
 		btrfs_set_stack_disk_key_offset(&tree_info_key, 0);
 	} else {
@@ -667,7 +668,7 @@ static void insert_temp_block_group(struct extent_buffer *buf,
 
 	btrfs_set_header_nritems(buf, *slot + 1);
 	(*itemoff) -= sizeof(bgi);
-	btrfs_set_disk_key_type(&disk_key, BTRFS_BLOCK_GROUP_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_BLOCK_GROUP_ITEM_KEY);
 	btrfs_set_stack_disk_key_objectid(&disk_key, bytenr);
 	btrfs_set_stack_disk_key_offset(&disk_key, len);
 	btrfs_set_item_key(buf, &disk_key, *slot);
diff --git a/ctree.c b/ctree.c
index 818bdfda..86df6bd9 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2349,7 +2349,8 @@ int btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 
 		btrfs_item_key(leaf, &disk_key, slot);
 
-		if (btrfs_disk_key_type(&disk_key) == BTRFS_EXTENT_DATA_KEY) {
+		if (btrfs_stack_disk_key_type(&disk_key)
+				== BTRFS_EXTENT_DATA_KEY) {
 			unsigned long ptr;
 			struct btrfs_file_extent_item *fi;
 
diff --git a/ctree.h b/ctree.h
index 3a1ddd59..92b294c9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1931,7 +1931,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_disk_key_objectid, struct btrfs_disk_key,
 			 objectid, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_disk_key_offset, struct btrfs_disk_key, offset,
 			 64);
-BTRFS_SETGET_STACK_FUNCS(disk_key_type, struct btrfs_disk_key, type, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_disk_key_type, struct btrfs_disk_key, type, 8);
 
 static inline void btrfs_disk_key_to_cpu(struct btrfs_key *cpu,
 					 struct btrfs_disk_key *disk)
diff --git a/image/main.c b/image/main.c
index 7060ebda..56244586 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1101,7 +1101,7 @@ static void update_super_old(u8 *buffer)
 				       sizeof(struct btrfs_disk_key));
 
 	btrfs_set_stack_disk_key_objectid(key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
-	btrfs_set_disk_key_type(key, BTRFS_CHUNK_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(key, BTRFS_CHUNK_ITEM_KEY);
 	btrfs_set_stack_disk_key_offset(key, 0);
 
 	btrfs_set_stack_chunk_length(chunk, (u64)-1);
diff --git a/mkfs/common.c b/mkfs/common.c
index f4655b63..0fec2bdd 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -61,7 +61,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_root_used(&root_item, cfg->nodesize);
 	btrfs_set_root_generation(&root_item, 1);
 
-	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
 	btrfs_set_stack_disk_key_offset(&disk_key, 0);
 	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize) - sizeof(root_item);
 
@@ -226,11 +226,11 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 		itemoff -= item_size;
 		btrfs_set_stack_disk_key_objectid(&disk_key, cfg->blocks[i]);
 		if (skinny_metadata) {
-			btrfs_set_disk_key_type(&disk_key,
+			btrfs_set_stack_disk_key_type(&disk_key,
 						BTRFS_METADATA_ITEM_KEY);
 			btrfs_set_stack_disk_key_offset(&disk_key, 0);
 		} else {
-			btrfs_set_disk_key_type(&disk_key,
+			btrfs_set_stack_disk_key_type(&disk_key,
 						BTRFS_EXTENT_ITEM_KEY);
 			btrfs_set_stack_disk_key_offset(&disk_key,
 							cfg->nodesize);
@@ -252,7 +252,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 		ref_root = reference_root_table[i];
 		btrfs_set_stack_disk_key_objectid(&disk_key, cfg->blocks[i]);
 		btrfs_set_stack_disk_key_offset(&disk_key, ref_root);
-		btrfs_set_disk_key_type(&disk_key, BTRFS_TREE_BLOCK_REF_KEY);
+		btrfs_set_stack_disk_key_type(&disk_key,
+					      BTRFS_TREE_BLOCK_REF_KEY);
 		btrfs_set_item_key(buf, &disk_key, nritems);
 		btrfs_set_item_offset(buf, btrfs_item_nr(nritems),
 				      itemoff);
@@ -279,7 +280,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	/* first device 1 (there is no device 0) */
 	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
 	btrfs_set_stack_disk_key_offset(&disk_key, 1);
-	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
 	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
 	btrfs_set_item_size(buf, btrfs_item_nr(nritems), item_size);
@@ -312,7 +313,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_stack_disk_key_objectid(&disk_key,
 					  BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_stack_disk_key_offset(&disk_key, 0);
-	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
 	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
 	btrfs_set_item_size(buf, btrfs_item_nr(nritems), item_size);
@@ -366,7 +367,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 
 	btrfs_set_stack_disk_key_objectid(&disk_key, 1);
 	btrfs_set_stack_disk_key_offset(&disk_key, 0);
-	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
+	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
 	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
 	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
diff --git a/print-tree.c b/print-tree.c
index 6e7ccfeb..ff4e1199 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -808,7 +808,7 @@ void print_objectid(FILE *stream, u64 objectid, u8 type)
 void btrfs_print_key(struct btrfs_disk_key *disk_key)
 {
 	u64 objectid = btrfs_stack_disk_key_objectid(disk_key);
-	u8 type = btrfs_disk_key_type(disk_key);
+	u8 type = btrfs_stack_disk_key_type(disk_key);
 	u64 offset = btrfs_stack_disk_key_offset(disk_key);
 
 	printf("key (");
@@ -1203,7 +1203,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 
 		btrfs_item_key(eb, &disk_key, i);
 		objectid = btrfs_stack_disk_key_objectid(&disk_key);
-		type = btrfs_disk_key_type(&disk_key);
+		type = btrfs_stack_disk_key_type(&disk_key);
 		offset = btrfs_stack_disk_key_offset(&disk_key);
 
 		printf("\titem %d ", i);
-- 
2.15.1



