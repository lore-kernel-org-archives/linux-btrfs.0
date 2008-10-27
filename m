From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Progs: Add root tree pointer transaction ids
Date: Mon, 27 Oct 2008 14:37:16 +0800
Message-ID: <4905619C.8060906@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yanzheng@21cn.com
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
diff -urp btrfs-progs-base/ctree.h btrfs-progs-1/ctree.h
--- btrfs-progs-base/ctree.h	2008-10-21 09:46:14.000000000 +0800
+++ btrfs-progs-1/ctree.h	2008-10-27 13:15:47.000000000 +0800
@@ -279,6 +279,7 @@ struct btrfs_super_block {
 	__le32 leafsize;
 	__le32 stripesize;
 	__le32 sys_chunk_array_size;
+	__le64 chunk_root_generation;
 	u8 root_level;
 	u8 chunk_root_level;
 	u8 log_root_level;
@@ -412,6 +413,7 @@ struct btrfs_dir_item {
 
 struct btrfs_root_item {
 	struct btrfs_inode_item inode;
+	__le64 generation;
 	__le64 root_dirid;
 	__le64 bytenr;
 	__le64 byte_limit;
@@ -1199,10 +1201,14 @@ static inline int btrfs_is_leaf(struct e
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
@@ -1218,6 +1224,8 @@ BTRFS_SETGET_STACK_FUNCS(super_generatio
 BTRFS_SETGET_STACK_FUNCS(super_root, struct btrfs_super_block, root, 64);
 BTRFS_SETGET_STACK_FUNCS(super_sys_array_size,
 			 struct btrfs_super_block, sys_chunk_array_size, 32);
+BTRFS_SETGET_STACK_FUNCS(super_chunk_root_generation,
+			 struct btrfs_super_block, chunk_root_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_root_level, struct btrfs_super_block,
 			 root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(super_chunk_root, struct btrfs_super_block,
diff -urp btrfs-progs-base/disk-io.c btrfs-progs-1/disk-io.c
--- btrfs-progs-base/disk-io.c	2008-09-30 16:50:58.000000000 +0800
+++ btrfs-progs-1/disk-io.c	2008-10-27 13:15:47.000000000 +0800
@@ -274,6 +274,8 @@ static int update_cowonly_root(struct bt
 			break;
 		btrfs_set_root_bytenr(&root->root_item,
 				       root->node->start);
+		btrfs_set_root_generation(&root->root_item,
+					  trans->transid);
 		root->root_item.level = btrfs_header_level(root->node);
 		ret = btrfs_update_root(trans, tree_root,
 					&root->root_key,
@@ -289,6 +291,12 @@ static int commit_tree_roots(struct btrf
 {
 	struct btrfs_root *root;
 	struct list_head *next;
+	struct extent_buffer *eb;
+
+	eb = fs_info->tree_root->node;
+	extent_buffer_get(eb);
+	btrfs_cow_block(trans, fs_info->tree_root, eb, NULL, 0, &eb);
+	free_extent_buffer(eb);
 
 	while(!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
@@ -345,6 +353,7 @@ int btrfs_commit_transaction(struct btrf
 
 	root->root_key.offset = trans->transid;
 	btrfs_set_root_bytenr(&root->root_item, root->node->start);
+	btrfs_set_root_generation(&root->root_item, root->root_key.offset);
 	root->root_item.level = btrfs_header_level(root->node);
 	ret = btrfs_insert_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
@@ -395,6 +404,7 @@ static int find_and_setup_root(struct bt
 {
 	int ret;
 	u32 blocksize;
+	u64 generation;
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
 		     tree_root->sectorsize, tree_root->stripesize,
@@ -404,8 +414,9 @@ static int find_and_setup_root(struct bt
 	BUG_ON(ret);
 
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
+	generation = btrfs_root_generation(&root->root_item);
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, 0);
+				     blocksize, generation);
 	BUG_ON(!root->node);
 	return 0;
 }
@@ -428,6 +439,7 @@ struct btrfs_root *btrfs_read_fs_root(st
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_path *path;
 	struct extent_buffer *l;
+	u64 generation;
 	u32 blocksize;
 	int ret = 0;
 
@@ -470,9 +482,10 @@ out:
 		free(root);
 		return ERR_PTR(ret);
 	}
+	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, 0);
+				     blocksize, generation);
 	BUG_ON(!root->node);
 insert:
 	root->ref_cows = 1;
@@ -506,6 +519,7 @@ struct btrfs_root *open_ctree_fd(int fp,
 	u32 leafsize;
 	u32 blocksize;
 	u32 stripesize;
+	u64 generation;
 	struct btrfs_root *root = malloc(sizeof(struct btrfs_root));
 	struct btrfs_root *tree_root = malloc(sizeof(struct btrfs_root));
 	struct btrfs_root *extent_root = malloc(sizeof(struct btrfs_root));
@@ -604,13 +618,14 @@ struct btrfs_root *open_ctree_fd(int fp,
 	BUG_ON(ret);
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
 
@@ -623,10 +638,11 @@ struct btrfs_root *open_ctree_fd(int fp,
 
 	blocksize = btrfs_level_size(tree_root,
 				     btrfs_super_root_level(disk_super));
+	generation = btrfs_super_generation(disk_super);
 
 	tree_root->node = read_tree_block(tree_root,
 					  btrfs_super_root(disk_super),
-					  blocksize, 0);
+					  blocksize, generation);
 	BUG_ON(!tree_root->node);
 	ret = find_and_setup_root(tree_root, fs_info,
 				  BTRFS_EXTENT_TREE_OBJECTID, extent_root);
@@ -706,6 +722,8 @@ int write_ctree_super(struct btrfs_trans
 				   chunk_root->node->start);
 	btrfs_set_super_chunk_root_level(&root->fs_info->super_copy,
 					 btrfs_header_level(chunk_root->node));
+	btrfs_set_super_chunk_root_generation(&root->fs_info->super_copy,
+				btrfs_header_generation(chunk_root->node));
 	write_extent_buffer(root->fs_info->sb_buffer,
 			    &root->fs_info->super_copy, 0,
 			    sizeof(root->fs_info->super_copy));
diff -urp btrfs-progs-base/mkfs.c btrfs-progs-1/mkfs.c
--- btrfs-progs-base/mkfs.c	2008-10-21 09:46:14.000000000 +0800
+++ btrfs-progs-1/mkfs.c	2008-10-27 13:15:47.000000000 +0800
@@ -247,6 +247,7 @@ static int create_data_reloc_tree(struct
 	memcpy(&root_item, &root->root_item, sizeof(root_item));
 	btrfs_set_root_bytenr(&root_item, tmp->start);
 	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
+	btrfs_set_root_generation(&root_item, trans->transid);
 	free_extent_buffer(tmp);
 
 	location.objectid = objectid;
diff -urp btrfs-progs-base/utils.c btrfs-progs-1/utils.c
--- btrfs-progs-base/utils.c	2008-10-10 04:21:07.000000000 +0800
+++ btrfs-progs-1/utils.c	2008-10-27 13:15:47.000000000 +0800
@@ -101,6 +101,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_super_leafsize(&super, leafsize);
 	btrfs_set_super_nodesize(&super, nodesize);
 	btrfs_set_super_stripesize(&super, stripesize);
+	btrfs_set_super_chunk_root_generation(&super, 1);
 	if (label)
 		strcpy(super.label, label);
 
@@ -130,6 +131,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 	btrfs_set_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, leafsize);
+	btrfs_set_root_generation(&root_item, 1);
 
 	memset(&disk_key, 0, sizeof(disk_key));
 	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
