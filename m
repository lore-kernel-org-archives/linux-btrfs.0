From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] updated new dir format patch
Date: Tue, 22 Jul 2008 13:55:16 -0400
Message-ID: <20080722175516.GA8960@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Updated new dir format which should help performance a little bit.  Everytime we
create a new inode go ahead and set index_cnt to 2 in case its a dir, so if we
make a dir and then touch a file in that dir we don't have to search for a dir
index that doesn't exist yet in order to get the index_cnt set properly.
Thanks,

Josef


diff -r 82fa3b59a9fa btrfs_inode.h
--- a/btrfs_inode.h	Tue Jul 22 20:13:52 2008 -0400
+++ b/btrfs_inode.h	Tue Jul 22 20:59:34 2008 -0400
@@ -49,6 +49,21 @@ struct btrfs_inode {
 	u64 delalloc_bytes;
 	u64 disk_i_size;
 	u32 flags;
+
+	/*
+	 * if this is a directory then index_cnt is the counter for the index
+	 * number for new files that are created
+	 */
+	u64 index_cnt;
+
+	/*
+	 * index holds the directory index for this inode on creation, so
+	 * add_link can do what its supposed to.  This isn't populated when the
+	 * inode is read because there isn't really a reason to know this unless
+	 * we are creating the directory index or deleting it, and deletion
+	 * reads the index off of the inode reference at unlink time.
+	 */
+	u64 index;
 };
 
 static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
diff -r 82fa3b59a9fa ctree.h
--- a/ctree.h	Tue Jul 22 20:13:52 2008 -0400
+++ b/ctree.h	Tue Jul 22 20:59:34 2008 -0400
@@ -373,6 +373,7 @@ struct btrfs_dev_extent {
 } __attribute__ ((__packed__));
 
 struct btrfs_inode_ref {
+	__le64 index;
 	__le16 name_len;
 	/* name goes here */
 } __attribute__ ((__packed__));
@@ -899,6 +900,7 @@ BTRFS_SETGET_STACK_FUNCS(block_group_fla
 
 /* struct btrfs_inode_ref */
 BTRFS_SETGET_FUNCS(inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
+BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
 
 /* struct btrfs_inode_item */
 BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
@@ -1525,7 +1527,7 @@ int btrfs_find_dead_roots(struct btrfs_r
 /* dir-item.c */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, const char *name, int name_len, u64 dir,
-			  struct btrfs_key *location, u8 type);
+			  struct btrfs_key *location, u8 type, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
@@ -1570,11 +1572,11 @@ int btrfs_insert_inode_ref(struct btrfs_
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid);
+			   u64 inode_objectid, u64 ref_objectid, u64 index);
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid);
+			   u64 inode_objectid, u64 ref_objectid, u64 *index);
 int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid);
diff -r 82fa3b59a9fa dir-item.c
--- a/dir-item.c	Tue Jul 22 20:13:52 2008 -0400
+++ b/dir-item.c	Tue Jul 22 20:59:34 2008 -0400
@@ -110,7 +110,7 @@ int btrfs_insert_xattr_item(struct btrfs
 
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, const char *name, int name_len, u64 dir,
-			  struct btrfs_key *location, u8 type)
+			  struct btrfs_key *location, u8 type, u64 index)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -156,7 +156,7 @@ second_insert:
 	btrfs_release_path(root, path);
 
 	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
-	key.offset = location->objectid;
+	key.offset = index;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name, name_len);
 	if (IS_ERR(dir_item)) {
diff -r 82fa3b59a9fa inode-item.c
--- a/inode-item.c	Tue Jul 22 20:13:52 2008 -0400
+++ b/inode-item.c	Tue Jul 22 20:59:34 2008 -0400
@@ -52,7 +52,7 @@ int btrfs_del_inode_ref(struct btrfs_tra
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid)
+			   u64 inode_objectid, u64 ref_objectid, u64 *index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -86,6 +86,10 @@ int btrfs_del_inode_ref(struct btrfs_tra
 	}
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+
+	if (index)
+		*index = btrfs_inode_ref_index(leaf, ref);
+
 	if (del_len == item_size) {
 		ret = btrfs_del_item(trans, root, path);
 		goto out;
@@ -106,7 +110,7 @@ int btrfs_insert_inode_ref(struct btrfs_
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid)
+			   u64 inode_objectid, u64 ref_objectid, u64 index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -138,6 +142,7 @@ int btrfs_insert_inode_ref(struct btrfs_
 				     struct btrfs_inode_ref);
 		ref = (struct btrfs_inode_ref *)((unsigned long)ref + old_size);
 		btrfs_set_inode_ref_name_len(path->nodes[0], ref, name_len);
+		btrfs_set_inode_ref_index(path->nodes[0], ref, index);
 		ptr = (unsigned long)(ref + 1);
 		ret = 0;
 	} else if (ret < 0) {
@@ -146,6 +151,7 @@ int btrfs_insert_inode_ref(struct btrfs_
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_inode_ref);
 		btrfs_set_inode_ref_name_len(path->nodes[0], ref, name_len);
+		btrfs_set_inode_ref_index(path->nodes[0], ref, index);
 		ptr = (unsigned long)(ref + 1);
 	}
 	write_extent_buffer(path->nodes[0], name, ptr, name_len);
diff -r 82fa3b59a9fa inode.c
--- a/inode.c	Tue Jul 22 20:13:52 2008 -0400
+++ b/inode.c	Tue Jul 22 20:59:34 2008 -0400
@@ -1041,6 +1041,8 @@ void btrfs_read_locked_inode(struct inod
 	inode->i_rdev = 0;
 	rdev = btrfs_inode_rdev(leaf, inode_item);
 
+	BTRFS_I(inode)->index_cnt = (u64)-1;
+
 	alloc_group_block = btrfs_inode_block_group(leaf, inode_item);
 	BTRFS_I(inode)->block_group = btrfs_lookup_block_group(root->fs_info,
 						       alloc_group_block);
@@ -1162,6 +1164,7 @@ static int btrfs_unlink_trans(struct btr
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
+	u64 index;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -1186,8 +1189,19 @@ static int btrfs_unlink_trans(struct btr
 		goto err;
 	btrfs_release_path(root, path);
 
+	ret = btrfs_del_inode_ref(trans, root, name, name_len,
+				  dentry->d_inode->i_ino,
+				  dentry->d_parent->d_inode->i_ino, &index);
+	if (ret) {
+		printk("failed to delete reference to %.*s, "
+		       "inode %lu parent %lu\n", name_len, name,
+		       dentry->d_inode->i_ino,
+		       dentry->d_parent->d_inode->i_ino);
+		goto err;
+	}
+
 	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
-					 key.objectid, name, name_len, -1);
+					 index, name, name_len, -1);
 	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
 		goto err;
@@ -1200,15 +1214,6 @@ static int btrfs_unlink_trans(struct btr
 	btrfs_release_path(root, path);
 
 	dentry->d_inode->i_ctime = dir->i_ctime;
-	ret = btrfs_del_inode_ref(trans, root, name, name_len,
-				  dentry->d_inode->i_ino,
-				  dentry->d_parent->d_inode->i_ino);
-	if (ret) {
-		printk("failed to delete reference to %.*s, "
-		       "inode %lu parent %lu\n", name_len, name,
-		       dentry->d_inode->i_ino,
-		       dentry->d_parent->d_inode->i_ino);
-	}
 err:
 	btrfs_free_path(path);
 	if (!ret) {
@@ -1814,6 +1819,7 @@ static int btrfs_init_locked_inode(struc
 	BTRFS_I(inode)->root = args->root;
 	BTRFS_I(inode)->delalloc_bytes = 0;
 	BTRFS_I(inode)->disk_i_size = 0;
+	BTRFS_I(inode)->index_cnt = (u64)-1;
 	extent_map_tree_init(&BTRFS_I(inode)->extent_tree, GFP_NOFS);
 	extent_io_tree_init(&BTRFS_I(inode)->io_tree,
 			     inode->i_mapping, GFP_NOFS);
@@ -2096,8 +2102,61 @@ void btrfs_dirty_inode(struct inode *ino
 	btrfs_end_transaction(trans, root);
 }
 
+static void btrfs_get_index_count(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_key key, found_key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+
+	int ret;
+
+	key.objectid = inode->i_ino;
+	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
+	key.offset = (u64)-1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret  < 0)
+		goto out;
+
+	/* FIXME: we should be able to handle this */
+	if (ret == 0)
+		goto out;
+
+	/*
+	 * MAGIC NUMBER EXPLANATION:
+	 * since we search a directory based on f_pos we have to start at 2
+	 * since '.' and '..' have f_pos of 0 and 1 respectively, so everybody
+	 * else has to start at 2
+	 */
+	if (path->slots[0] == 0) {
+		BTRFS_I(inode)->index_cnt = 2;
+		goto out;
+	}
+
+	path->slots[0]--;
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+
+	if (found_key.objectid != inode->i_ino ||
+	    btrfs_key_type(&found_key) != BTRFS_DIR_INDEX_KEY) {
+		BTRFS_I(inode)->index_cnt = 2;
+		goto out;
+	}
+
+	BTRFS_I(inode)->index_cnt = found_key.offset + 1;
+out:
+	btrfs_free_path(path);
+}
+
 static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
+				     struct inode *dir,
 				     const char *name, int name_len,
 				     u64 ref_objectid,
 				     u64 objectid,
@@ -2112,6 +2171,7 @@ static struct inode *btrfs_new_inode(str
 	struct btrfs_inode_ref *ref;
 	struct btrfs_key key[2];
 	u32 sizes[2];
+	u64 index = 0;
 	unsigned long ptr;
 	int ret;
 	int owner;
@@ -2122,6 +2182,13 @@ static struct inode *btrfs_new_inode(str
 	inode = new_inode(root->fs_info->sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
+
+	if (dir) {
+		if (BTRFS_I(dir)->index_cnt == (u64)-1)
+			btrfs_get_index_count(dir);
+		index = BTRFS_I(dir)->index_cnt;
+		BTRFS_I(dir)->index_cnt++;
+	}
 
 	extent_map_tree_init(&BTRFS_I(inode)->extent_tree, GFP_NOFS);
 	extent_io_tree_init(&BTRFS_I(inode)->io_tree,
@@ -2179,8 +2246,17 @@ static struct inode *btrfs_new_inode(str
 	ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
 			     struct btrfs_inode_ref);
 	btrfs_set_inode_ref_name_len(path->nodes[0], ref, name_len);
+	btrfs_set_inode_ref_index(path->nodes[0], ref, index);
 	ptr = (unsigned long)(ref + 1);
 	write_extent_buffer(path->nodes[0], name, ptr, name_len);
+
+	BTRFS_I(inode)->index = index;
+
+	/*
+	 * index_cnt is ignored for everything but a dir,
+	 * btrfs_get_index_count has an explanation for the magic number
+	 */
+	BTRFS_I(inode)->index_cnt = 2;
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
@@ -2193,6 +2269,8 @@ static struct inode *btrfs_new_inode(str
 	insert_inode_hash(inode);
 	return inode;
 fail:
+	if (dir)
+		BTRFS_I(dir)->index_cnt--;
 	btrfs_free_path(path);
 	return ERR_PTR(ret);
 }
@@ -2209,7 +2287,7 @@ static int btrfs_add_link(struct btrfs_t
 	int ret;
 	struct btrfs_key key;
 	struct btrfs_root *root = BTRFS_I(dentry->d_parent->d_inode)->root;
-	struct inode *parent_inode;
+	struct inode *parent_inode = dentry->d_parent->d_inode;
 
 	key.objectid = inode->i_ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
@@ -2218,16 +2296,17 @@ static int btrfs_add_link(struct btrfs_t
 	ret = btrfs_insert_dir_item(trans, root,
 				    dentry->d_name.name, dentry->d_name.len,
 				    dentry->d_parent->d_inode->i_ino,
-				    &key, btrfs_inode_type(inode));
+				    &key, btrfs_inode_type(inode),
+				    BTRFS_I(inode)->index);
 	if (ret == 0) {
 		if (add_backref) {
 			ret = btrfs_insert_inode_ref(trans, root,
 					     dentry->d_name.name,
 					     dentry->d_name.len,
 					     inode->i_ino,
-					     dentry->d_parent->d_inode->i_ino);
+					     parent_inode->i_ino,
+					     BTRFS_I(inode)->index);
 		}
-		parent_inode = dentry->d_parent->d_inode;
 		btrfs_i_size_write(parent_inode, parent_inode->i_size +
 				   dentry->d_name.len * 2);
 		parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
@@ -2278,7 +2357,7 @@ static int btrfs_mknod(struct inode *dir
 		goto out_unlock;
 	}
 
-	inode = btrfs_new_inode(trans, root, dentry->d_name.name,
+	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
 				dentry->d_parent->d_inode->i_ino, objectid,
 				BTRFS_I(dir)->block_group, mode);
@@ -2339,7 +2418,7 @@ static int btrfs_create(struct inode *di
 		goto out_unlock;
 	}
 
-	inode = btrfs_new_inode(trans, root, dentry->d_name.name,
+	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
 				dentry->d_parent->d_inode->i_ino,
 				objectid, BTRFS_I(dir)->block_group, mode);
@@ -2465,7 +2544,7 @@ static int btrfs_mkdir(struct inode *dir
 		goto out_unlock;
 	}
 
-	inode = btrfs_new_inode(trans, root, dentry->d_name.name,
+	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
 				dentry->d_parent->d_inode->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFDIR | mode);
@@ -3103,9 +3182,8 @@ int btrfs_create_subvol_root(struct btrf
 		struct btrfs_block_group_cache *block_group)
 {
 	struct inode *inode;
-	int ret;
 
-	inode = btrfs_new_inode(trans, new_root, "..", 2, new_dirid,
+	inode = btrfs_new_inode(trans, new_root, NULL, "..", 2, new_dirid,
 				new_dirid, block_group, S_IFDIR | 0700);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
@@ -3113,8 +3191,6 @@ int btrfs_create_subvol_root(struct btrf
 	inode->i_fop = &btrfs_dir_file_operations;
 	new_root->inode = inode;
 
-	ret = btrfs_insert_inode_ref(trans, new_root, "..", 2, new_dirid,
-				     new_dirid);
 	inode->i_nlink = 1;
 	btrfs_i_size_write(inode, 0);
 
@@ -3363,7 +3439,7 @@ static int btrfs_symlink(struct inode *d
 		goto out_unlock;
 	}
 
-	inode = btrfs_new_inode(trans, root, dentry->d_name.name,
+	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
 				dentry->d_parent->d_inode->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFLNK|S_IRWXUGO);
diff -r 82fa3b59a9fa ioctl.c
--- a/ioctl.c	Tue Jul 22 20:13:52 2008 -0400
+++ b/ioctl.c	Tue Jul 22 20:59:34 2008 -0400
@@ -131,13 +131,13 @@ static noinline int create_subvol(struct
 	dir = root->fs_info->sb->s_root->d_inode;
 	ret = btrfs_insert_dir_item(trans, root->fs_info->tree_root,
 				    name, namelen, dir->i_ino, &key,
-				    BTRFS_FT_DIR);
+				    BTRFS_FT_DIR, 0);
 	if (ret)
 		goto fail;
 
 	ret = btrfs_insert_inode_ref(trans, root->fs_info->tree_root,
 			     name, namelen, objectid,
-			     root->fs_info->sb->s_root->d_inode->i_ino);
+			     root->fs_info->sb->s_root->d_inode->i_ino, 0);
 	if (ret)
 		goto fail;
 
diff -r 82fa3b59a9fa transaction.c
--- a/transaction.c	Tue Jul 22 20:13:52 2008 -0400
+++ b/transaction.c	Tue Jul 22 20:59:34 2008 -0400
@@ -574,14 +574,14 @@ static noinline int create_pending_snaps
 	ret = btrfs_insert_dir_item(trans, root->fs_info->tree_root,
 				    pending->name, namelen,
 				    root->fs_info->sb->s_root->d_inode->i_ino,
-				    &key, BTRFS_FT_DIR);
+				    &key, BTRFS_FT_DIR, 0);
 
 	if (ret)
 		goto fail;
 
 	ret = btrfs_insert_inode_ref(trans, root->fs_info->tree_root,
 			     pending->name, strlen(pending->name), objectid,
-			     root->fs_info->sb->s_root->d_inode->i_ino);
+			     root->fs_info->sb->s_root->d_inode->i_ino, 0);
 
 	/* Invalidate existing dcache entry for new snapshot. */
 	btrfs_invalidate_dcache_root(root, pending->name, namelen);
