From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] btrfs-progs: fix various bugs in btrfs-convert
Date: Mon, 12 Jan 2009 22:29:58 +0800
Message-ID: <496B53E6.20309@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch fixes various bugs in btrfs-convert. These bugs
are mainly related to updating inode's isize and nbytes.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp btrfs-progs-orig/convert.c btrfs-progs/convert.c
--- btrfs-progs-orig/convert.c	2008-12-18 08:09:27.000000000 +0800
+++ btrfs-progs/convert.c	2009-01-12 12:29:50.000000000 +0800
@@ -579,6 +579,7 @@ static int create_file_extents(struct bt
 	    inode_size <= BTRFS_MAX_INLINE_DATA_SIZE(root)) {
 		u64 num_bytes = data.num_blocks * sectorsize;
 		u64 disk_bytenr = data.disk_block * sectorsize;
+		u64 nbytes;
 
 		buffer = malloc(num_bytes);
 		if (!buffer)
@@ -592,6 +593,8 @@ static int create_file_extents(struct bt
 						 0, buffer, num_bytes);
 		if (ret)
 			goto fail;
+		nbytes = btrfs_stack_inode_nbytes(btrfs_inode) + num_bytes;
+		btrfs_set_stack_inode_nbytes(btrfs_inode, nbytes);
 	} else if (data.num_blocks > 0) {
 		ret = record_file_blocks(trans, root, objectid, btrfs_inode,
 					 data.first_block, data.disk_block,
@@ -636,6 +639,7 @@ static int create_symbol_link(struct btr
 	BUG_ON(pathname[inode_size] != 0);
 	ret = btrfs_insert_inline_extent(trans, root, objectid, 0,
 					 pathname, inode_size + 1);
+	btrfs_set_stack_inode_nbytes(btrfs_inode, inode_size + 1);
 	return ret;
 }
 
@@ -977,7 +981,7 @@ static int copy_inode_item(struct btrfs_
 {
 	btrfs_set_stack_inode_generation(dst, 1);
 	btrfs_set_stack_inode_size(dst, src->i_size);
-	btrfs_set_stack_inode_nbytes(dst, (u64)src->i_blocks * blocksize);
+	btrfs_set_stack_inode_nbytes(dst, 0);
 	btrfs_set_stack_inode_block_group(dst, 0);
 	btrfs_set_stack_inode_nlink(dst, src->i_links_count);
 	btrfs_set_stack_inode_uid(dst, src->i_uid | (src->i_uid_high << 16));
@@ -1411,8 +1415,10 @@ struct btrfs_root *link_subvol(struct bt
 	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	struct btrfs_root *new_root;
+	struct btrfs_root *new_root = NULL;
 	struct btrfs_path *path;
+	struct btrfs_inode_item *inode_item;
+	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	u64 dirid = btrfs_root_dirid(&root->root_item);
 	u64 index = 2;
@@ -1436,11 +1442,21 @@ struct btrfs_root *link_subvol(struct bt
 		if (key.objectid == dirid && key.type == BTRFS_DIR_INDEX_KEY)
 			index = key.offset + 1;
 	}
-	btrfs_free_path(path);
+	btrfs_release_path(root, path);
 
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
 
+	key.objectid = dirid;
+	key.offset = 0;
+	key.type =  BTRFS_INODE_ITEM_KEY;
+
+	ret = btrfs_lookup_inode(trans, root, path, &key, 1);
+	BUG_ON(ret);
+	leaf = path->nodes[0];
+	inode_item = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_inode_item);
+
 	key.objectid = root_objectid;
 	key.offset = (u64)-1;
 	key.type = BTRFS_ROOT_ITEM_KEY;
@@ -1456,6 +1472,11 @@ struct btrfs_root *link_subvol(struct bt
 	if (ret)
 		goto fail;
 
+	btrfs_set_inode_size(leaf, inode_item, strlen(buf) * 2 +
+			     btrfs_inode_size(leaf, inode_item));
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+
 	/* add the backref first */
 	ret = btrfs_add_root_ref(trans, tree_root, root_objectid,
 				 BTRFS_ROOT_BACKREF_KEY,
@@ -1472,12 +1493,11 @@ struct btrfs_root *link_subvol(struct bt
 	BUG_ON(ret);
 
 	new_root = btrfs_read_fs_root(fs_info, &key);
-	if (!new_root || IS_ERR(new_root))
-		goto fail;
-
-	return new_root;
+	if (IS_ERR(new_root))
+		new_root = NULL;
 fail:
-	return NULL;
+	btrfs_free_path(path);
+	return new_root;
 }
 
 /*
diff -urp btrfs-progs-orig/file-item.c btrfs-progs/file-item.c
--- btrfs-progs-orig/file-item.c	2008-12-18 08:09:27.000000000 +0800
+++ btrfs-progs/file-item.c	2009-01-12 12:39:05.000000000 +0800
@@ -64,8 +64,12 @@ int btrfs_insert_file_extent(struct btrf
 	btrfs_set_file_extent_disk_num_bytes(leaf, item, disk_num_bytes);
 	btrfs_set_file_extent_offset(leaf, item, 0);
 	btrfs_set_file_extent_num_bytes(leaf, item, num_bytes);
+	btrfs_set_file_extent_ram_bytes(leaf, item, num_bytes);
 	btrfs_set_file_extent_generation(leaf, item, trans->transid);
 	btrfs_set_file_extent_type(leaf, item, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_file_extent_compression(leaf, item, 0);
+	btrfs_set_file_extent_encryption(leaf, item, 0);
+	btrfs_set_file_extent_other_encoding(leaf, item, 0);
 	btrfs_mark_buffer_dirty(leaf);
 out:
 	btrfs_free_path(path);
