Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753632AbeAKFKF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:05 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1C02748AEA0D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:51 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/67] btrfs-progs: add the stack prefix for disk_key_objectid set/get function
Date: Thu, 11 Jan 2018 13:08:36 +0800
Message-ID: <20180111050939.21251-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The disk_key_objectid set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-list.c       |  2 +-
 chunk-recover.c    |  2 +-
 cmds-check.c       | 14 ++++++++------
 convert/common.c   | 15 ++++++++-------
 ctree.c            |  3 ++-
 ctree.h            |  2 +-
 dir-test.c         |  4 ++--
 free-space-cache.c |  2 +-
 image/main.c       |  2 +-
 mkfs/common.c      | 13 +++++++------
 print-tree.c       |  4 ++--
 random-test.c      |  4 ++--
 12 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index b6d76585..ffd143c0 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -951,7 +951,7 @@ int btrfs_list_get_default_subvolume(int fd, u64 *default_id)
 		name = (char *)(di + 1);
 
 		if (!strncmp("default", name, name_len))
-			found = btrfs_disk_key_objectid(&di->location);
+			found = btrfs_stack_disk_key_objectid(&di->location);
 	}
 
 out:
diff --git a/chunk-recover.c b/chunk-recover.c
index cfcf97d4..0448e5e9 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1160,7 +1160,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 		if (min_devid > dev->devid)
 			min_devid = dev->devid;
 	}
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
+	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_disk_key_offset(&disk_key, min_devid);
 
diff --git a/cmds-check.c b/cmds-check.c
index 207a927d..a39e651a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2622,7 +2622,8 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 			bi = (struct btrfs_tree_block_info *)(ei + 1);
 			memset_extent_buffer(eb, 0, (unsigned long)bi,
 					     sizeof(*bi));
-			btrfs_set_disk_key_objectid(&copy_key, root->objectid);
+			btrfs_set_stack_disk_key_objectid(&copy_key,
+							  root->objectid);
 			btrfs_set_disk_key_type(&copy_key, 0);
 			btrfs_set_disk_key_offset(&copy_key, 0);
 
@@ -4489,7 +4490,7 @@ static int check_fs_root(struct btrfs_root *root,
 		return -EIO;
 
 	if (btrfs_root_refs(root_item) > 0 ||
-	    btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
+	    btrfs_stack_disk_key_objectid(&root_item->drop_progress) == 0) {
 		path.nodes[level] = root->node;
 		extent_buffer_get(root->node);
 		path.slots[level] = 0;
@@ -6442,7 +6443,7 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 
 	/* For root being dropped, we don't need to check first inode */
 	if (btrfs_root_refs(&root->root_item) == 0 &&
-	    btrfs_disk_key_objectid(&root->root_item.drop_progress) >=
+	    btrfs_stack_disk_key_objectid(&root->root_item.drop_progress) >=
 	    BTRFS_FIRST_FREE_OBJECTID)
 		return 0;
 
@@ -6588,7 +6589,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 	btrfs_init_path(&path);
 
 	if (btrfs_root_refs(root_item) > 0 ||
-	    btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
+	    btrfs_stack_disk_key_objectid(&root_item->drop_progress) == 0) {
 		path.nodes[level] = root->node;
 		path.slots[level] = 0;
 		extent_buffer_get(root->node);
@@ -9727,7 +9728,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 			memset_extent_buffer(leaf, 0, (unsigned long)bi,
 					     sizeof(*bi));
 
-			btrfs_set_disk_key_objectid(&copy_key,
+			btrfs_set_stack_disk_key_objectid(&copy_key,
 						    rec->info_objectid);
 			btrfs_set_disk_key_type(&copy_key, 0);
 			btrfs_set_disk_key_offset(&copy_key, 0);
@@ -11538,7 +11539,8 @@ again:
 			offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
 			last_snapshot = btrfs_root_last_snapshot(&ri);
-			if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
+			if (btrfs_stack_disk_key_objectid(&ri.drop_progress)
+					== 0) {
 				level = btrfs_root_level(&ri);
 				ret = add_root_item_to_list(&normal_trees,
 						found_key.objectid,
diff --git a/convert/common.c b/convert/common.c
index e288d129..d18a5179 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -199,7 +199,7 @@ static void insert_temp_root_item(struct extent_buffer *buf,
 
 	memset(&disk_key, 0, sizeof(disk_key));
 	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
-	btrfs_set_disk_key_objectid(&disk_key, objectid);
+	btrfs_set_stack_disk_key_objectid(&disk_key, objectid);
 	btrfs_set_disk_key_offset(&disk_key, 0);
 
 	btrfs_set_item_key(buf, &disk_key, *slot);
@@ -306,7 +306,7 @@ static int insert_temp_dev_item(int fd, struct extent_buffer *buf,
 	(*itemoff) -= sizeof(*dev_item);
 	/* setup device item 1, 0 is for replace case */
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
+	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
 	btrfs_set_disk_key_offset(&disk_key, 1);
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
@@ -366,7 +366,8 @@ static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
 	btrfs_set_header_nritems(buf, *slot + 1);
 	(*itemoff) -= btrfs_chunk_item_size(1);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_stack_disk_key_objectid(&disk_key,
+					  BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_disk_key_offset(&disk_key, start);
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
@@ -469,7 +470,7 @@ static void insert_temp_dev_extent(struct extent_buffer *buf,
 	btrfs_set_header_nritems(buf, *slot + 1);
 	(*itemoff) -= sizeof(*dev_extent);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
-	btrfs_set_disk_key_objectid(&disk_key, 1);
+	btrfs_set_stack_disk_key_objectid(&disk_key, 1);
 	btrfs_set_disk_key_offset(&disk_key, start);
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
@@ -601,7 +602,7 @@ static int insert_temp_extent_item(int fd, struct extent_buffer *buf,
 		btrfs_set_disk_key_type(&disk_key, BTRFS_EXTENT_ITEM_KEY);
 		btrfs_set_disk_key_offset(&disk_key, cfg->nodesize);
 	}
-	btrfs_set_disk_key_objectid(&disk_key, bytenr);
+	btrfs_set_stack_disk_key_objectid(&disk_key, bytenr);
 
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
@@ -644,7 +645,7 @@ static int insert_temp_extent_item(int fd, struct extent_buffer *buf,
 	}
 	if (btrfs_header_nritems(tmp) == 0) {
 		btrfs_set_disk_key_type(&tree_info_key, 0);
-		btrfs_set_disk_key_objectid(&tree_info_key, 0);
+		btrfs_set_stack_disk_key_objectid(&tree_info_key, 0);
 		btrfs_set_disk_key_offset(&tree_info_key, 0);
 	} else {
 		btrfs_item_key(tmp, &tree_info_key, 0);
@@ -667,7 +668,7 @@ static void insert_temp_block_group(struct extent_buffer *buf,
 	btrfs_set_header_nritems(buf, *slot + 1);
 	(*itemoff) -= sizeof(bgi);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_BLOCK_GROUP_ITEM_KEY);
-	btrfs_set_disk_key_objectid(&disk_key, bytenr);
+	btrfs_set_stack_disk_key_objectid(&disk_key, bytenr);
 	btrfs_set_disk_key_offset(&disk_key, len);
 	btrfs_set_item_key(buf, &disk_key, *slot);
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
diff --git a/ctree.c b/ctree.c
index 4fc33b14..4d8b0e05 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1011,7 +1011,8 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 		}
 		if (path->reada < 0 && objectid) {
 			btrfs_node_key(node, &disk_key, nr);
-			if (btrfs_disk_key_objectid(&disk_key) != objectid)
+			if (btrfs_stack_disk_key_objectid(&disk_key)
+					!= objectid)
 				break;
 		}
 		search = btrfs_node_blockptr(node, nr);
diff --git a/ctree.h b/ctree.h
index d4254b67..59f56599 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1927,7 +1927,7 @@ static inline void btrfs_set_free_space_key(struct extent_buffer *eb,
 }
 
 /* struct btrfs_disk_key */
-BTRFS_SETGET_STACK_FUNCS(disk_key_objectid, struct btrfs_disk_key,
+BTRFS_SETGET_STACK_FUNCS(stack_disk_key_objectid, struct btrfs_disk_key,
 			 objectid, 64);
 BTRFS_SETGET_STACK_FUNCS(disk_key_offset, struct btrfs_disk_key, offset, 64);
 BTRFS_SETGET_STACK_FUNCS(disk_key_type, struct btrfs_disk_key, type, 8);
diff --git a/dir-test.c b/dir-test.c
index cfb77f2a..8fb23b82 100644
--- a/dir-test.c
+++ b/dir-test.c
@@ -183,7 +183,7 @@ static int del_dir_item(struct btrfs_trans_handle *trans,
 	/* find the inode number of the file */
 	di = btrfs_item_ptr(&path->nodes[0]->leaf, path->slots[0],
 			    struct btrfs_dir_item);
-	file_objectid = btrfs_disk_key_objectid(&di->location);
+	file_objectid = btrfs_stack_disk_key_objectid(&di->location);
 
 	/* delete the directory item */
 	ret = btrfs_del_item(trans, root, path);
@@ -264,7 +264,7 @@ static int lookup_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (!ret) {
 		di = btrfs_item_ptr(&path.nodes[0]->leaf, path.slots[0],
 				    struct btrfs_dir_item);
-		objectid = btrfs_disk_key_objectid(&di->location);
+		objectid = btrfs_stack_disk_key_objectid(&di->location);
 	}
 	btrfs_release_path(&path);
 	if (ret) {
diff --git a/free-space-cache.c b/free-space-cache.c
index 3d961b2b..c432435f 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -918,7 +918,7 @@ int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 	slot = path.slots[0];
 	sc_header = btrfs_item_ptr(node, slot, struct btrfs_free_space_header);
 	btrfs_free_space_key(node, sc_header, &location);
-	ino = btrfs_disk_key_objectid(&location);
+	ino = btrfs_stack_disk_key_objectid(&location);
 
 	/* Delete the free space header, as we have the ino to continue */
 	ret = btrfs_del_item(trans, tree_root, &path);
diff --git a/image/main.c b/image/main.c
index 54a2d7d5..69897b91 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1100,7 +1100,7 @@ static void update_super_old(u8 *buffer)
 	chunk = (struct btrfs_chunk *)(super->sys_chunk_array +
 				       sizeof(struct btrfs_disk_key));
 
-	btrfs_set_disk_key_objectid(key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_stack_disk_key_objectid(key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_disk_key_type(key, BTRFS_CHUNK_ITEM_KEY);
 	btrfs_set_disk_key_offset(key, 0);
 
diff --git a/mkfs/common.c b/mkfs/common.c
index dd5e7ecf..2697437a 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -71,7 +71,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 			continue;
 
 		btrfs_set_root_bytenr(&root_item, cfg->blocks[blk]);
-		btrfs_set_disk_key_objectid(&disk_key,
+		btrfs_set_stack_disk_key_objectid(&disk_key,
 			reference_root_table[blk]);
 		btrfs_set_item_key(buf, &disk_key, nritems);
 		btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
@@ -224,7 +224,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 
 		/* create extent item */
 		itemoff -= item_size;
-		btrfs_set_disk_key_objectid(&disk_key, cfg->blocks[i]);
+		btrfs_set_stack_disk_key_objectid(&disk_key, cfg->blocks[i]);
 		if (skinny_metadata) {
 			btrfs_set_disk_key_type(&disk_key,
 						BTRFS_METADATA_ITEM_KEY);
@@ -249,7 +249,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 
 		/* create extent ref */
 		ref_root = reference_root_table[i];
-		btrfs_set_disk_key_objectid(&disk_key, cfg->blocks[i]);
+		btrfs_set_stack_disk_key_objectid(&disk_key, cfg->blocks[i]);
 		btrfs_set_disk_key_offset(&disk_key, ref_root);
 		btrfs_set_disk_key_type(&disk_key, BTRFS_TREE_BLOCK_REF_KEY);
 		btrfs_set_item_key(buf, &disk_key, nritems);
@@ -276,7 +276,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize) - item_size;
 
 	/* first device 1 (there is no device 0) */
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
+	btrfs_set_stack_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
 	btrfs_set_disk_key_offset(&disk_key, 1);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
@@ -308,7 +308,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	itemoff = itemoff - item_size;
 
 	/* then we have chunk 0 */
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_stack_disk_key_objectid(&disk_key,
+					  BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_disk_key_offset(&disk_key, 0);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
@@ -362,7 +363,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize) -
 		sizeof(struct btrfs_dev_extent);
 
-	btrfs_set_disk_key_objectid(&disk_key, 1);
+	btrfs_set_stack_disk_key_objectid(&disk_key, 1);
 	btrfs_set_disk_key_offset(&disk_key, 0);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
diff --git a/print-tree.c b/print-tree.c
index 96cca9d5..254982bc 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -807,7 +807,7 @@ void print_objectid(FILE *stream, u64 objectid, u8 type)
 
 void btrfs_print_key(struct btrfs_disk_key *disk_key)
 {
-	u64 objectid = btrfs_disk_key_objectid(disk_key);
+	u64 objectid = btrfs_stack_disk_key_objectid(disk_key);
 	u8 type = btrfs_disk_key_type(disk_key);
 	u64 offset = btrfs_disk_key_offset(disk_key);
 
@@ -1202,7 +1202,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 		ptr = btrfs_item_ptr(eb, i, void*);
 
 		btrfs_item_key(eb, &disk_key, i);
-		objectid = btrfs_disk_key_objectid(&disk_key);
+		objectid = btrfs_stack_disk_key_objectid(&disk_key);
 		type = btrfs_disk_key_type(&disk_key);
 		offset = btrfs_disk_key_offset(&disk_key);
 
diff --git a/random-test.c b/random-test.c
index d5f830a9..1c3ec4c7 100644
--- a/random-test.c
+++ b/random-test.c
@@ -201,7 +201,7 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 			path.slots[0] -= 1;
 		}
 		slot = path.slots[0];
-		found = btrfs_disk_key_objectid(
+		found = btrfs_stack_disk_key_objectid(
 					&path.nodes[0]->leaf.items[slot].key);
 		ret = btrfs_del_item(trans, root, &path);
 		count++;
@@ -306,7 +306,7 @@ static int fill_radix(struct btrfs_root *root, struct radix_tree_root *radix)
 			slot -= 1;
 		}
 		for (i = slot; i >= 0; i--) {
-			found = btrfs_disk_key_objectid(&path.nodes[0]->
+			found = btrfs_stack_disk_key_objectid(&path.nodes[0]->
 							leaf.items[i].key);
 			radix_tree_preload(GFP_KERNEL);
 			ret = radix_tree_insert(radix, found, (void *)found);
-- 
2.15.1



