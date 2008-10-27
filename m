From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Add root tree pointer transaction ids
Date: Mon, 27 Oct 2008 14:30:41 +0800
Message-ID: <49056011.7090405@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch adds transaction IDs to root tree pointers.
Transaction IDs in tree pointers are compared with the
generation numbers in block headers when reading root
blocks of trees. This can detect some types of IO errors.

Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2008-10-27 10:37:40.000000000 +0800
+++ 2/fs/btrfs/ctree.h	2008-10-27 10:41:45.000000000 +0800
@@ -297,6 +297,7 @@ struct btrfs_super_block {
 	__le32 leafsize;
 	__le32 stripesize;
 	__le32 sys_chunk_array_size;
+	__le64 chunk_root_generation;
 	u8 root_level;
 	u8 chunk_root_level;
 	u8 log_root_level;
@@ -439,6 +440,7 @@ struct btrfs_dir_item {
 
 struct btrfs_root_item {
 	struct btrfs_inode_item inode;
+	__le64 generation;
 	__le64 root_dirid;
 	__le64 bytenr;
 	__le64 byte_limit;
@@ -1358,10 +1360,14 @@ static inline int btrfs_is_leaf(struct e
 }
 
 /* struct btrfs_root_item */
+BTRFS_SETGET_FUNCS(disk_root_generation, struct btrfs_root_item,
+		   generation, 64);
 BTRFS_SETGET_FUNCS(disk_root_refs, struct btrfs_root_item, refs, 32);
 BTRFS_SETGET_FUNCS(disk_root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_FUNCS(disk_root_level, struct btrfs_root_item, level, 8);
 
+BTRFS_SETGET_STACK_FUNCS(root_generation, struct btrfs_root_item,
+			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_STACK_FUNCS(root_level, struct btrfs_root_item, level, 8);
 BTRFS_SETGET_STACK_FUNCS(root_dirid, struct btrfs_root_item, root_dirid, 64);
@@ -1378,6 +1384,8 @@ BTRFS_SETGET_STACK_FUNCS(super_generatio
 BTRFS_SETGET_STACK_FUNCS(super_root, struct btrfs_super_block, root, 64);
 BTRFS_SETGET_STACK_FUNCS(super_sys_array_size,
 			 struct btrfs_super_block, sys_chunk_array_size, 32);
+BTRFS_SETGET_STACK_FUNCS(super_chunk_root_generation,
+			 struct btrfs_super_block, chunk_root_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_root_level, struct btrfs_super_block,
 			 root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(super_chunk_root, struct btrfs_super_block,
diff -urp 1/fs/btrfs/disk-io.c 2/fs/btrfs/disk-io.c
--- 1/fs/btrfs/disk-io.c	2008-10-27 10:37:40.000000000 +0800
+++ 2/fs/btrfs/disk-io.c	2008-10-27 13:29:06.000000000 +0800
@@ -828,6 +828,7 @@ static int find_and_setup_root(struct bt
 {
 	int ret;
 	u32 blocksize;
+	u64 generation;
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
 		     tree_root->sectorsize, tree_root->stripesize,
@@ -836,9 +837,10 @@ static int find_and_setup_root(struct bt
 				   &root->root_item, &root->root_key);
 	BUG_ON(ret);
 
+	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, 0);
+				     blocksize, generation);
 	BUG_ON(!root->node);
 	return 0;
 }
@@ -925,6 +927,7 @@ struct btrfs_root *btrfs_read_fs_root_no
 	struct btrfs_path *path;
 	struct extent_buffer *l;
 	u64 highest_inode;
+	u64 generation;
 	u32 blocksize;
 	int ret = 0;
 
@@ -966,9 +969,10 @@ out:
 		kfree(root);
 		return ERR_PTR(ret);
 	}
+	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, 0);
+				     blocksize, generation);
 	BUG_ON(!root->node);
 insert:
 	if (location->objectid != BTRFS_TREE_LOG_OBJECTID) {
@@ -1353,6 +1357,7 @@ struct btrfs_root *open_ctree(struct sup
 	u32 leafsize;
 	u32 blocksize;
 	u32 stripesize;
+	u64 generation;
 	struct buffer_head *bh;
 	struct btrfs_root *extent_root = kzalloc(sizeof(struct btrfs_root),
 						 GFP_NOFS);
@@ -1588,13 +1593,14 @@ struct btrfs_root *open_ctree(struct sup
 
 	blocksize = btrfs_level_size(tree_root,
 				     btrfs_super_chunk_root_level(disk_super));
+	generation = btrfs_super_chunk_root_generation(disk_super);
 
 	__setup_root(nodesize, leafsize, sectorsize, stripesize,
 		     chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
 
 	chunk_root->node = read_tree_block(chunk_root,
 					   btrfs_super_chunk_root(disk_super),
-					   blocksize, 0);
+					   blocksize, generation);
 	BUG_ON(!chunk_root->node);
 
 	read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
@@ -1610,11 +1616,11 @@ struct btrfs_root *open_ctree(struct sup
 
 	blocksize = btrfs_level_size(tree_root,
 				     btrfs_super_root_level(disk_super));
-
+	generation = btrfs_super_generation(disk_super);
 
 	tree_root->node = read_tree_block(tree_root,
 					  btrfs_super_root(disk_super),
-					  blocksize, 0);
+					  blocksize, generation);
 	if (!tree_root->node)
 		goto fail_sb_buffer;
 
@@ -1664,15 +1670,16 @@ struct btrfs_root *open_ctree(struct sup
 			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
 
 		log_tree_root->node = read_tree_block(tree_root, bytenr,
-						      blocksize, 0);
+						      blocksize,
+						      generation + 1);
 		ret = btrfs_recover_log_trees(log_tree_root);
 		BUG_ON(ret);
 	}
+	fs_info->last_trans_committed = btrfs_super_generation(disk_super);
 
 	ret = btrfs_cleanup_reloc_trees(tree_root);
 	BUG_ON(ret);
 
-	fs_info->last_trans_committed = btrfs_super_generation(disk_super);
 	return tree_root;
 
 fail_cleaner:
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2008-10-27 10:47:00.000000000 +0800
+++ 2/fs/btrfs/extent-tree.c	2008-10-27 10:47:51.000000000 +0800
@@ -4404,6 +4404,7 @@ static int noinline init_reloc_tree(stru
 	btrfs_set_root_refs(root_item, 0);
 	btrfs_set_root_bytenr(root_item, eb->start);
 	btrfs_set_root_level(root_item, btrfs_header_level(eb));
+	btrfs_set_root_generation(root_item, trans->transid);
 
 	btrfs_tree_unlock(eb);
 	free_extent_buffer(eb);
diff -urp 1/fs/btrfs/ioctl.c 2/fs/btrfs/ioctl.c
--- 1/fs/btrfs/ioctl.c	2008-10-24 09:18:54.000000000 +0800
+++ 2/fs/btrfs/ioctl.c	2008-10-27 10:41:57.000000000 +0800
@@ -108,6 +108,7 @@ static noinline int create_subvol(struct
 	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
 
 	btrfs_set_root_bytenr(&root_item, leaf->start);
+	btrfs_set_root_generation(&root_item, trans->transid);
 	btrfs_set_root_level(&root_item, 0);
 	btrfs_set_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, 0);
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2008-10-27 10:37:40.000000000 +0800
+++ 2/fs/btrfs/transaction.c	2008-10-27 10:41:57.000000000 +0800
@@ -439,6 +439,7 @@ static int update_cowonly_root(struct bt
 				       root->node->start);
 		btrfs_set_root_level(&root->root_item,
 				     btrfs_header_level(root->node));
+		btrfs_set_root_generation(&root->root_item, trans->transid);
 		ret = btrfs_update_root(trans, tree_root,
 					&root->root_key,
 					&root->root_item);
@@ -456,6 +457,12 @@ int btrfs_commit_tree_roots(struct btrfs
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct list_head *next;
+	struct extent_buffer *eb;
+
+	eb = btrfs_lock_root_node(fs_info->tree_root);
+	btrfs_cow_block(trans, fs_info->tree_root, eb, NULL, 0, &eb, 0);
+	btrfs_tree_unlock(eb);
+	free_extent_buffer(eb);
 
 	while(!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
@@ -559,6 +566,9 @@ static noinline int add_dirty_roots(stru
 					      root->node->start);
 			btrfs_set_root_level(&root->root_item,
 					     btrfs_header_level(root->node));
+			btrfs_set_root_generation(&root->root_item,
+						  root->root_key.offset);
+
 			err = btrfs_insert_root(trans, root->fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
@@ -756,6 +766,7 @@ static noinline int create_pending_snaps
 
 	btrfs_set_root_bytenr(new_root_item, tmp->start);
 	btrfs_set_root_level(new_root_item, btrfs_header_level(tmp));
+	btrfs_set_root_generation(new_root_item, trans->transid);
 	ret = btrfs_insert_root(trans, root->fs_info->tree_root, &key,
 				new_root_item);
 	btrfs_tree_unlock(tmp);
@@ -946,6 +957,8 @@ int btrfs_commit_transaction(struct btrf
 				   chunk_root->node->start);
 	btrfs_set_super_chunk_root_level(&root->fs_info->super_copy,
 					 btrfs_header_level(chunk_root->node));
+	btrfs_set_super_chunk_root_generation(&root->fs_info->super_copy,
+				btrfs_header_generation(chunk_root->node));
 
 	if (!root->fs_info->log_root_recovering) {
 		btrfs_set_super_log_root(&root->fs_info->super_copy, 0);
diff -urp 1/fs/btrfs/tree-log.c 2/fs/btrfs/tree-log.c
--- 1/fs/btrfs/tree-log.c	2008-10-27 10:37:40.000000000 +0800
+++ 2/fs/btrfs/tree-log.c	2008-10-27 10:41:57.000000000 +0800
@@ -117,6 +117,7 @@ int btrfs_add_log_tree(struct btrfs_tran
 	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
 
 	btrfs_set_root_bytenr(&root_item, leaf->start);
+	btrfs_set_root_generation(&root_item, trans->transid);
 	btrfs_set_root_level(&root_item, 0);
 	btrfs_set_root_refs(&root_item, 0);
 	btrfs_set_root_used(&root_item, 0);
@@ -2066,6 +2067,7 @@ static int update_log_root(struct btrfs_
 		return 0;
 
 	btrfs_set_root_bytenr(&log->root_item, log->node->start);
+	btrfs_set_root_generation(&log->root_item, trans->transid);
 	btrfs_set_root_level(&log->root_item, btrfs_header_level(log->node));
 	ret = btrfs_update_root(trans, log->fs_info->log_root_tree,
 				&log->root_key, &log->root_item);
