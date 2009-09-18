From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 3/4] change how subvolumes are organized
Date: Fri, 18 Sep 2009 20:18:55 +0800
Message-ID: <4AB37AAF.5040508@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs allows subvolumes and snapshots anywhere in the directory tree.
If we snapshot a subvolume that contains a link to other subvolume
called subvolA, subvolA can be accessed through both the original
subvolume and the snapshot. This is similar to creating hard link to
directory, and has the very similar problems.

The aim of this patch is enforcing there is only one access point to
each subvolume. Only the first directory entry (the one added when
the subvolume/snapshot was created) is treated as valid access point.
The first directory entry is distinguished by checking root forward
reference. If the corresponding root forward reference is missing,
we know the entry is not the first one.

This patch also adds snapshot/subvolume rename support, the code
allows rename subvolume link across subvolumes.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 3/fs/btrfs/btrfs_inode.h 4/fs/btrfs/btrfs_inode.h
--- 3/fs/btrfs/btrfs_inode.h	2009-09-16 15:24:37.247170000 +0800
+++ 4/fs/btrfs/btrfs_inode.h	2009-09-18 15:42:47.363127953 +0800
@@ -138,6 +138,7 @@ struct btrfs_inode {
 	 * of these.
 	 */
 	unsigned ordered_data_close:1;
+	unsigned dummy_inode:1;
 
 	struct inode vfs_inode;
 };
diff -urp 3/fs/btrfs/ctree.h 4/fs/btrfs/ctree.h
--- 3/fs/btrfs/ctree.h	2009-09-18 15:01:03.954130853 +0800
+++ 4/fs/btrfs/ctree.h	2009-09-18 15:48:21.807350311 +0800
@@ -114,6 +114,10 @@ struct btrfs_ordered_sum;
  */
 #define BTRFS_DEV_ITEMS_OBJECTID 1ULL
 
+#define BTRFS_BTREE_INODE_OBJECTID 1
+
+#define BTRFS_EMPTY_SUBVOL_DIR_OBJECTID 2
+
 /*
  * we can actually store much bigger names, but lets not confuse the rest
  * of linux
@@ -782,6 +786,8 @@ struct btrfs_fs_info {
 
 	/* the log root tree is a directory of all the other log roots */
 	struct btrfs_root *log_root_tree;
+
+	spinlock_t fs_roots_radix_lock;
 	struct radix_tree_root fs_roots_radix;
 
 	/* block group cache stuff */
@@ -1000,6 +1006,8 @@ struct btrfs_root {
 	u64 highest_objectid;
 	int ref_cows;
 	int track_dirty;
+	int in_radix;
+
 	u64 defrag_trans_start;
 	struct btrfs_key defrag_progress;
 	struct btrfs_key defrag_max;
@@ -2100,12 +2108,15 @@ int btrfs_drop_subtree(struct btrfs_tran
 			struct extent_buffer *parent);
 /* root-item.c */
 int btrfs_find_root_ref(struct btrfs_root *tree_root,
-		   struct btrfs_path *path,
-		   u64 root_id, u64 ref_id);
+			struct btrfs_path *path,
+			u64 root_id, u64 ref_id);
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *tree_root,
-		       u64 root_id, u8 type, u64 ref_id,
-		       u64 dirid, u64 sequence,
+		       u64 root_id, u64 ref_id, u64 dirid, u64 sequence,
+		       const char *name, int name_len);
+int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *tree_root,
+		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
 		       const char *name, int name_len);
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_key *key);
@@ -2138,6 +2149,10 @@ btrfs_lookup_dir_index_item(struct btrfs
 			    struct btrfs_path *path, u64 dir,
 			    u64 objectid, const char *name, int name_len,
 			    int mod);
+struct btrfs_dir_item *
+btrfs_search_dir_index_item(struct btrfs_root *root,
+			    struct btrfs_path *path, u64 dirid,
+			    const char *name, int name_len);
 struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
 			      struct btrfs_path *path,
 			      const char *name, int name_len);
@@ -2160,6 +2175,7 @@ int btrfs_insert_orphan_item(struct btrf
 			     struct btrfs_root *root, u64 offset);
 int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 offset);
+int btrfs_find_orphan_item(struct btrfs_root *root, u64 offset);
 
 /* inode-map.c */
 int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
@@ -2232,6 +2248,10 @@ int btrfs_unlink_inode(struct btrfs_tran
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct inode *parent_inode, struct inode *inode,
 		   const char *name, int name_len, int add_backref, u64 index);
+int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct inode *dir, u64 objectid,
+			const char *name, int name_len);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct inode *inode, u64 new_size,
diff -urp 3/fs/btrfs/dir-item.c 4/fs/btrfs/dir-item.c
--- 3/fs/btrfs/dir-item.c	2009-07-24 09:51:38.289051000 +0800
+++ 4/fs/btrfs/dir-item.c	2009-09-18 15:42:47.367127960 +0800
@@ -281,6 +281,53 @@ btrfs_lookup_dir_index_item(struct btrfs
 	return btrfs_match_dir_item_name(root, path, name, name_len);
 }
 
+struct btrfs_dir_item *
+btrfs_search_dir_index_item(struct btrfs_root *root,
+			    struct btrfs_path *path, u64 dirid,
+			    const char *name, int name_len)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_dir_item *di;
+	struct btrfs_key key;
+	u32 nritems;
+	int ret;
+
+	key.objectid = dirid;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	leaf = path->nodes[0];
+	nritems = btrfs_header_nritems(leaf);
+
+	while (1) {
+		if (path->slots[0] >= nritems) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				return ERR_PTR(ret);
+			if (ret > 0)
+				break;
+			leaf = path->nodes[0];
+			nritems = btrfs_header_nritems(leaf);
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid != dirid || key.type != BTRFS_DIR_INDEX_KEY)
+			break;
+
+		di = btrfs_match_dir_item_name(root, path, name, name_len);
+		if (di)
+			return di;
+
+		path->slots[0]++;
+	}
+	return NULL;
+}
+
 struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root,
 					  struct btrfs_path *path, u64 dir,
diff -urp 3/fs/btrfs/disk-io.c 4/fs/btrfs/disk-io.c
--- 3/fs/btrfs/disk-io.c	2009-09-18 15:01:03.956351209 +0800
+++ 4/fs/btrfs/disk-io.c	2009-09-18 15:47:37.111351060 +0800
@@ -41,6 +41,7 @@
 
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
+static void free_fs_root(struct btrfs_root *root);
 
 static atomic_t btrfs_bdi_num = ATOMIC_INIT(0);
 
@@ -951,14 +952,16 @@ static int find_and_setup_root(struct bt
 		     root, fs_info, objectid);
 	ret = btrfs_find_last_root(tree_root, objectid,
 				   &root->root_item, &root->root_key);
+	if (ret > 0)
+		return -ENOENT;
 	BUG_ON(ret);
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
-	root->commit_root = btrfs_root_node(root);
 	BUG_ON(!root->node);
+	root->commit_root = btrfs_root_node(root);
 	return 0;
 }
 
@@ -1176,39 +1179,66 @@ struct btrfs_root *btrfs_read_fs_root_no
 		return fs_info->dev_root;
 	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
 		return fs_info->csum_root;
-
+again:
+	spin_lock(&fs_info->fs_roots_radix_lock);
 	root = radix_tree_lookup(&fs_info->fs_roots_radix,
 				 (unsigned long)location->objectid);
+	spin_unlock(&fs_info->fs_roots_radix_lock);
 	if (root)
 		return root;
 
+	ret = btrfs_find_orphan_item(fs_info->tree_root, location->objectid);
+	if (ret == 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		return ERR_PTR(ret);
+
 	root = btrfs_read_fs_root_no_radix(fs_info->tree_root, location);
 	if (IS_ERR(root))
 		return root;
 
+	WARN_ON(btrfs_root_refs(&root->root_item) == 0);
 	set_anon_super(&root->anon_super, NULL);
 
+	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (ret)
+		goto fail;
+
+	spin_lock(&fs_info->fs_roots_radix_lock);
 	ret = radix_tree_insert(&fs_info->fs_roots_radix,
 				(unsigned long)root->root_key.objectid,
 				root);
+	if (ret == 0)
+		root->in_radix = 1;
+	spin_unlock(&fs_info->fs_roots_radix_lock);
+	radix_tree_preload_end();
 	if (ret) {
-		free_extent_buffer(root->node);
-		kfree(root);
-		return ERR_PTR(ret);
+		if (ret == -EEXIST) {
+			free_fs_root(root);
+			goto again;
+		}
+		goto fail;
 	}
-	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
-		ret = btrfs_find_dead_roots(fs_info->tree_root,
-					    root->root_key.objectid);
-		BUG_ON(ret);
+
+	ret = btrfs_find_dead_roots(fs_info->tree_root,
+				    root->root_key.objectid);
+	WARN_ON(ret);
+
+	if (!(fs_info->sb->s_flags & MS_RDONLY))
 		btrfs_orphan_cleanup(root);
-	}
+
 	return root;
+fail:
+	free_fs_root(root);
+	return ERR_PTR(ret);
 }
 
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 				      struct btrfs_key *location,
 				      const char *name, int namelen)
 {
+	return btrfs_read_fs_root_no_name(fs_info, location);
+#if 0
 	struct btrfs_root *root;
 	int ret;
 
@@ -1225,7 +1255,7 @@ struct btrfs_root *btrfs_read_fs_root(st
 		kfree(root);
 		return ERR_PTR(ret);
 	}
-#if 0
+
 	ret = btrfs_sysfs_add_root(root);
 	if (ret) {
 		free_extent_buffer(root->node);
@@ -1233,9 +1263,9 @@ struct btrfs_root *btrfs_read_fs_root(st
 		kfree(root);
 		return ERR_PTR(ret);
 	}
-#endif
 	root->in_sysfs = 1;
 	return root;
+#endif
 }
 
 static int btrfs_congested_fn(void *congested_data, int bdi_bits)
@@ -2225,20 +2255,25 @@ int write_ctree_super(struct btrfs_trans
 
 int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 {
-	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
+	spin_lock(&fs_info->fs_roots_radix_lock);
 	radix_tree_delete(&fs_info->fs_roots_radix,
 			  (unsigned long)root->root_key.objectid);
+	spin_unlock(&fs_info->fs_roots_radix_lock);
+	free_fs_root(root);
+	return 0;
+}
+
+static void free_fs_root(struct btrfs_root *root)
+{
+	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
 	if (root->anon_super.s_dev) {
 		down_write(&root->anon_super.s_umount);
 		kill_anon_super(&root->anon_super);
 	}
-	if (root->node)
-		free_extent_buffer(root->node);
-	if (root->commit_root)
-		free_extent_buffer(root->commit_root);
+	free_extent_buffer(root->node);
+	free_extent_buffer(root->commit_root);
 	kfree(root->name);
 	kfree(root);
-	return 0;
 }
 
 static int del_fs_roots(struct btrfs_fs_info *fs_info)
diff -urp 3/fs/btrfs/inode.c 4/fs/btrfs/inode.c
--- 3/fs/btrfs/inode.c	2009-09-18 15:01:03.960350728 +0800
+++ 4/fs/btrfs/inode.c	2009-09-18 16:58:27.740127798 +0800
@@ -2365,6 +2365,69 @@ static int btrfs_unlink(struct inode *di
 	return ret;
 }
 
+int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct inode *dir, u64 objectid,
+			const char *name, int name_len)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_dir_item *di;
+	struct btrfs_key key;
+	u64 index;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
+				   name, name_len, -1);
+	BUG_ON(!di || IS_ERR(di));
+
+	leaf = path->nodes[0];
+	btrfs_dir_item_key_to_cpu(leaf, di, &key);
+	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
+	ret = btrfs_delete_one_dir_name(trans, root, path, di);
+	BUG_ON(ret);
+	btrfs_release_path(root, path);
+
+	ret = btrfs_del_root_ref(trans, root->fs_info->tree_root,
+				 objectid, root->root_key.objectid,
+				 dir->i_ino, &index, name, name_len);
+	if (ret < 0) {
+		BUG_ON(ret != -ENOENT);
+		di = btrfs_search_dir_index_item(root, path, dir->i_ino,
+						 name, name_len);
+		BUG_ON(!di || IS_ERR(di));
+
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		btrfs_release_path(root, path);
+		index = key.offset;
+	}
+
+	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
+					 index, name, name_len, -1);
+	BUG_ON(!di || IS_ERR(di));
+
+	leaf = path->nodes[0];
+	btrfs_dir_item_key_to_cpu(leaf, di, &key);
+	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
+	ret = btrfs_delete_one_dir_name(trans, root, path, di);
+	BUG_ON(ret);
+	btrfs_release_path(root, path);
+
+	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	ret = btrfs_update_inode(trans, root, dir);
+	BUG_ON(ret);
+	dir->i_sb->s_dirt = 1;
+
+	btrfs_free_path(path);
+	return 0;
+}
+
 static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
@@ -2374,29 +2437,31 @@ static int btrfs_rmdir(struct inode *dir
 	struct btrfs_trans_handle *trans;
 	unsigned long nr = 0;
 
-	/*
-	 * the FIRST_FREE_OBJECTID check makes sure we don't try to rmdir
-	 * the root of a subvolume or snapshot
-	 */
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
-	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -ENOTEMPTY;
-	}
 
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, dir);
 
+	if (unlikely(inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
+		err = btrfs_unlink_subvol(trans, root, dir,
+					  BTRFS_I(inode)->location.objectid,
+					  dentry->d_name.name,
+					  dentry->d_name.len);
+		goto out;
+	}
+
 	err = btrfs_orphan_add(trans, inode);
 	if (err)
-		goto fail_trans;
+		goto out;
 
 	/* now the directory is empty */
 	err = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
 				 dentry->d_name.name, dentry->d_name.len);
 	if (!err)
 		btrfs_i_size_write(inode, 0);
-
-fail_trans:
+out:
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
@@ -3083,29 +3148,67 @@ out_err:
  * is kind of like crossing a mount point.
  */
 static int fixup_tree_root_location(struct btrfs_root *root,
-			     struct btrfs_key *location,
-			     struct btrfs_root **sub_root,
-			     struct dentry *dentry)
+				    struct inode *dir,
+				    struct dentry *dentry,
+				    struct btrfs_key *location,
+				    struct btrfs_root **sub_root)
 {
-	struct btrfs_root_item *ri;
+	struct btrfs_path *path;
+	struct btrfs_root *new_root;
+	struct btrfs_root_ref *ref;
+	struct extent_buffer *leaf;
+	int ret;
+	int err = 0;
 
-	if (btrfs_key_type(location) != BTRFS_ROOT_ITEM_KEY)
-		return 0;
-	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID)
-		return 0;
+	path = btrfs_alloc_path();
+	if (!path) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = -ENOENT;
+	ret = btrfs_find_root_ref(root->fs_info->tree_root, path,
+				  BTRFS_I(dir)->root->root_key.objectid,
+				  location->objectid);
+	if (ret) {
+		if (ret < 0)
+			err = ret;
+		goto out;
+	}
 
-	*sub_root = btrfs_read_fs_root(root->fs_info, location,
-					dentry->d_name.name,
-					dentry->d_name.len);
-	if (IS_ERR(*sub_root))
-		return PTR_ERR(*sub_root);
+	leaf = path->nodes[0];
+	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_ref);
+	if (btrfs_root_ref_dirid(leaf, ref) != dir->i_ino ||
+	    btrfs_root_ref_name_len(leaf, ref) != dentry->d_name.len)
+		goto out;
 
-	ri = &(*sub_root)->root_item;
-	location->objectid = btrfs_root_dirid(ri);
-	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
-	location->offset = 0;
+	ret = memcmp_extent_buffer(leaf, dentry->d_name.name,
+				   (unsigned long)(ref + 1),
+				   dentry->d_name.len);
+	if (ret)
+		goto out;
 
-	return 0;
+	btrfs_release_path(root->fs_info->tree_root, path);
+
+	new_root = btrfs_read_fs_root_no_name(root->fs_info, location);
+	if (IS_ERR(new_root)) {
+		err = PTR_ERR(new_root);
+		goto out;
+	}
+
+	if (btrfs_root_refs(&new_root->root_item) == 0) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	*sub_root = new_root;
+	location->objectid = btrfs_root_dirid(&new_root->root_item);
+	location->type = BTRFS_INODE_ITEM_KEY;
+	location->offset = 0;
+	err = 0;
+out:
+	btrfs_free_path(path);
+	return err;
 }
 
 static void inode_tree_add(struct inode *inode)
@@ -3238,11 +3341,34 @@ struct inode *btrfs_iget(struct super_bl
 	return inode;
 }
 
+static struct inode *new_simple_dir(struct super_block *s,
+				    struct btrfs_key *key,
+				    struct btrfs_root *root)
+{
+	struct inode *inode = new_inode(s);
+
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	init_btrfs_i(inode);
+
+	BTRFS_I(inode)->root = root;
+	memcpy(&BTRFS_I(inode)->location, key, sizeof(*key));
+	BTRFS_I(inode)->dummy_inode = 1;
+
+	inode->i_ino = BTRFS_EMPTY_SUBVOL_DIR_OBJECTID;
+	inode->i_op = &simple_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+
+	return inode;
+}
+
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode;
-	struct btrfs_inode *bi = BTRFS_I(dir);
-	struct btrfs_root *root = bi->root;
+	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
 	int ret;
@@ -3255,17 +3381,25 @@ struct inode *btrfs_lookup_dentry(struct
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	inode = NULL;
-	if (location.objectid) {
-		ret = fixup_tree_root_location(root, &location, &sub_root,
-						dentry);
-		if (ret < 0)
-			return ERR_PTR(ret);
-		if (ret > 0)
-			return ERR_PTR(-ENOENT);
+	if (location.objectid == 0)
+		return NULL;
+
+	if (location.type == BTRFS_INODE_ITEM_KEY) {
+		inode = btrfs_iget(dir->i_sb, &location, root);
+		return inode;
+	}
+
+	BUG_ON(location.type != BTRFS_ROOT_ITEM_KEY);
+
+	ret = fixup_tree_root_location(root, dir, dentry,
+				       &location, &sub_root);
+	if (ret < 0) {
+		if (ret != -ENOENT)
+			inode = ERR_PTR(ret);
+		else
+			inode = new_simple_dir(dir->i_sb, &location, sub_root);
+	} else {
 		inode = btrfs_iget(dir->i_sb, &location, sub_root);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
 	}
 	return inode;
 }
@@ -3275,9 +3409,6 @@ static struct dentry *btrfs_lookup(struc
 {
 	struct inode *inode;
 
-	if (dentry->d_name.len > BTRFS_NAME_LEN)
-		return ERR_PTR(-ENAMETOOLONG);
-
 	inode = btrfs_lookup_dentry(dir, dentry);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
@@ -3683,26 +3814,35 @@ int btrfs_add_link(struct btrfs_trans_ha
 		   struct inode *parent_inode, struct inode *inode,
 		   const char *name, int name_len, int add_backref, u64 index)
 {
-	int ret;
+	int ret = 0;
 	struct btrfs_key key;
 	struct btrfs_root *root = BTRFS_I(parent_inode)->root;
 
-	key.objectid = inode->i_ino;
-	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
-	key.offset = 0;
+	if (unlikely(inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+		memcpy(&key, &BTRFS_I(inode)->root->root_key, sizeof(key));
+	} else {
+		key.objectid = inode->i_ino;
+		btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
+		key.offset = 0;
+	}
+
+	if (unlikely(inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+		ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
+					 key.objectid, root->root_key.objectid,
+					 parent_inode->i_ino,
+					 index, name, name_len);
+	} else if (add_backref) {
+		ret = btrfs_insert_inode_ref(trans, root,
+					     name, name_len, inode->i_ino,
+					     parent_inode->i_ino, index);
+	}
 
-	ret = btrfs_insert_dir_item(trans, root, name, name_len,
-				    parent_inode->i_ino,
-				    &key, btrfs_inode_type(inode),
-				    index);
 	if (ret == 0) {
-		if (add_backref) {
-			ret = btrfs_insert_inode_ref(trans, root,
-						     name, name_len,
-						     inode->i_ino,
-						     parent_inode->i_ino,
-						     index);
-		}
+		ret = btrfs_insert_dir_item(trans, root, name, name_len,
+					    parent_inode->i_ino, &key,
+					    btrfs_inode_type(inode), index);
+		BUG_ON(ret);
+
 		btrfs_i_size_write(parent_inode, parent_inode->i_size +
 				   name_len * 2);
 		parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
@@ -4792,31 +4932,29 @@ static int btrfs_rename(struct inode *ol
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(old_dir)->root;
+	struct btrfs_root *dest = BTRFS_I(new_dir)->root;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct inode *old_inode = old_dentry->d_inode;
 	struct timespec ctime = CURRENT_TIME;
 	u64 index = 0;
+	u64 root_objectid;
 	int ret;
 
-	/* we're not allowed to rename between subvolumes */
-	if (BTRFS_I(old_inode)->root->root_key.objectid !=
-	    BTRFS_I(new_dir)->root->root_key.objectid)
+	/* we only allow rename subvolume link between subvolumes */
+	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
 		return -EXDEV;
 
-	if (S_ISDIR(old_inode->i_mode) && new_inode &&
-	    new_inode->i_size > BTRFS_EMPTY_DIR_SIZE) {
+	if (old_inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||
+	    (new_inode && new_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID))
 		return -ENOTEMPTY;
-	}
 
-	/* to rename a snapshot or subvolume, we need to juggle the
-	 * backrefs.  This isn't coded yet
-	 */
-	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
-		return -EXDEV;
+	if (S_ISDIR(old_inode->i_mode) && new_inode &&
+	    new_inode->i_size > BTRFS_EMPTY_DIR_SIZE)
+		return -ENOTEMPTY;
 
 	ret = btrfs_check_metadata_free_space(root);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	/*
 	 * we're using rename to replace one file with another.
@@ -4829,6 +4967,9 @@ static int btrfs_rename(struct inode *ol
 
 	trans = btrfs_start_transaction(root, 1);
 
+	if (dest != root)
+		btrfs_record_root_in_trans(trans, dest);
+
 	/*
 	 * make sure the inode gets flushed if it is replacing
 	 * something.
@@ -4838,18 +4979,22 @@ static int btrfs_rename(struct inode *ol
 		btrfs_add_ordered_operation(trans, root, old_inode);
 	}
 
-	/*
-	 * this is an ugly little race, but the rename is required to make
-	 * sure that if we crash, the inode is either at the old name
-	 * or the new one.  pinning the log transaction lets us make sure
-	 * we don't allow a log commit to come in after we unlink the
-	 * name but before we add the new name back in.
-	 */
-	btrfs_pin_log_trans(root);
+	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+		/* force full log commit if subvolume involved. */
+		root->fs_info->last_trans_log_full_commit = trans->transid;
+	} else {
+		/*
+		 * this is an ugly little race, but the rename is required
+		 * to make sure that if we crash, the inode is either at the
+		 * old name or the new one.  pinning the log transaction lets
+		 * us make sure we don't allow a log commit to come in after
+		 * we unlink the name but before we add the new name back in.
+		 */
+		btrfs_pin_log_trans(root);
+	}
 
 	btrfs_set_trans_block_group(trans, new_dir);
 
-	btrfs_inc_nlink(old_dentry->d_inode);
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
 	old_inode->i_ctime = ctime;
@@ -4857,47 +5002,58 @@ static int btrfs_rename(struct inode *ol
 	if (old_dentry->d_parent != new_dentry->d_parent)
 		btrfs_record_unlink_dir(trans, old_dir, old_inode, 1);
 
-	ret = btrfs_unlink_inode(trans, root, old_dir, old_dentry->d_inode,
-				 old_dentry->d_name.name,
-				 old_dentry->d_name.len);
-	if (ret)
-		goto out_fail;
+	if (unlikely(old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+		root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
+		ret = btrfs_unlink_subvol(trans, root, old_dir, root_objectid,
+					old_dentry->d_name.name,
+					old_dentry->d_name.len);
+	} else {
+		btrfs_inc_nlink(old_dentry->d_inode);
+		ret = btrfs_unlink_inode(trans, root, old_dir,
+					 old_dentry->d_inode,
+					 old_dentry->d_name.name,
+					 old_dentry->d_name.len);
+	}
+	BUG_ON(ret);
 
 	if (new_inode) {
 		new_inode->i_ctime = CURRENT_TIME;
-		ret = btrfs_unlink_inode(trans, root, new_dir,
-					 new_dentry->d_inode,
-					 new_dentry->d_name.name,
-					 new_dentry->d_name.len);
-		if (ret)
-			goto out_fail;
+		if (unlikely(new_inode->i_ino ==
+			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
+			root_objectid = BTRFS_I(new_inode)->location.objectid;
+			ret = btrfs_unlink_subvol(trans, dest, new_dir,
+						root_objectid,
+						new_dentry->d_name.name,
+						new_dentry->d_name.len);
+			BUG_ON(new_inode->i_nlink == 0);
+		} else {
+			ret = btrfs_unlink_inode(trans, dest, new_dir,
+						 new_dentry->d_inode,
+						 new_dentry->d_name.name,
+						 new_dentry->d_name.len);
+		}
+		BUG_ON(ret);
 		if (new_inode->i_nlink == 0) {
 			ret = btrfs_orphan_add(trans, new_dentry->d_inode);
-			if (ret)
-				goto out_fail;
+			BUG_ON(ret);
 		}
-
 	}
 	ret = btrfs_set_inode_index(new_dir, &index);
-	if (ret)
-		goto out_fail;
+	BUG_ON(ret);
 
-	ret = btrfs_add_link(trans, new_dentry->d_parent->d_inode,
-			     old_inode, new_dentry->d_name.name,
+	ret = btrfs_add_link(trans, new_dir, old_inode,
+			     new_dentry->d_name.name,
 			     new_dentry->d_name.len, 1, index);
-	if (ret)
-		goto out_fail;
+	BUG_ON(ret);
 
-	btrfs_log_new_name(trans, old_inode, old_dir,
-				       new_dentry->d_parent);
-out_fail:
+	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
+		btrfs_log_new_name(trans, old_inode, old_dir,
+				   new_dentry->d_parent);
+		btrfs_end_log_trans(root);
+	}
 
-	/* this btrfs_end_log_trans just allows the current
-	 * log-sub transaction to complete
-	 */
-	btrfs_end_log_trans(root);
 	btrfs_end_transaction_throttle(trans, root);
-out_unlock:
+
 	return ret;
 }
 
diff -urp 3/fs/btrfs/ioctl.c 4/fs/btrfs/ioctl.c
--- 3/fs/btrfs/ioctl.c	2009-09-16 15:24:37.331171000 +0800
+++ 4/fs/btrfs/ioctl.c	2009-09-18 15:42:47.377359227 +0800
@@ -322,20 +322,9 @@ static noinline int create_subvol(struct
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
 
-	/* add the backref first */
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
-				 objectid, BTRFS_ROOT_BACKREF_KEY,
-				 root->root_key.objectid,
+				 objectid, root->root_key.objectid,
 				 dir->i_ino, index, name, namelen);
-
-	BUG_ON(ret);
-
-	/* now add the forward ref */
-	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
-				 root->root_key.objectid, BTRFS_ROOT_REF_KEY,
-				 objectid,
-				 dir->i_ino, index, name, namelen);
-
 	BUG_ON(ret);
 
 	ret = btrfs_commit_transaction(trans, root);
diff -urp 3/fs/btrfs/orphan.c 4/fs/btrfs/orphan.c
--- 3/fs/btrfs/orphan.c	2009-07-24 09:51:38.432086000 +0800
+++ 4/fs/btrfs/orphan.c	2009-09-16 16:04:16.967166000 +0800
@@ -65,3 +65,23 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+int btrfs_find_orphan_item(struct btrfs_root *root, u64 offset)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = offset;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+
+	btrfs_free_path(path);
+	return ret;
+}
diff -urp 3/fs/btrfs/root-tree.c 4/fs/btrfs/root-tree.c
--- 3/fs/btrfs/root-tree.c	2009-07-27 08:40:03.556529000 +0800
+++ 4/fs/btrfs/root-tree.c	2009-09-18 15:42:47.377359227 +0800
@@ -278,31 +278,57 @@ out:
 	return ret;
 }
 
-#if 0 /* this will get used when snapshot deletion is implemented */
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *tree_root,
-		       u64 root_id, u8 type, u64 ref_id)
+		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
+		       const char *name, int name_len)
+
 {
+	struct btrfs_path *path;
+	struct btrfs_root_ref *ref;
+	struct extent_buffer *leaf;
 	struct btrfs_key key;
+	unsigned long ptr;
+	int err = 0;
 	int ret;
-	struct btrfs_path *path;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = root_id;
-	key.type = type;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
 	key.offset = ref_id;
-
+again:
 	ret = btrfs_search_slot(trans, tree_root, &key, path, -1, 1);
-	BUG_ON(ret);
-
-	ret = btrfs_del_item(trans, tree_root, path);
-	BUG_ON(ret);
+	BUG_ON(ret < 0);
+	if (ret == 0) {
+		leaf = path->nodes[0];
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_root_ref);
+
+		WARN_ON(btrfs_root_ref_dirid(leaf, ref) != dirid);
+		WARN_ON(btrfs_root_ref_name_len(leaf, ref) != name_len);
+		ptr = (unsigned long)(ref + 1);
+		WARN_ON(memcmp_extent_buffer(leaf, name, ptr, name_len));
+		*sequence = btrfs_root_ref_sequence(leaf, ref);
+
+		ret = btrfs_del_item(trans, tree_root, path);
+		BUG_ON(ret);
+	} else
+		err = -ENOENT;
+
+	if (key.type == BTRFS_ROOT_BACKREF_KEY) {
+		btrfs_release_path(tree_root, path);
+		key.objectid = ref_id;
+		key.type = BTRFS_ROOT_REF_KEY;
+		key.offset = root_id;
+		goto again;
+	}
 
 	btrfs_free_path(path);
-	return ret;
+	return err;
 }
-#endif
 
 int btrfs_find_root_ref(struct btrfs_root *tree_root,
 		   struct btrfs_path *path,
@@ -319,7 +345,6 @@ int btrfs_find_root_ref(struct btrfs_roo
 	return ret;
 }
 
-
 /*
  * add a btrfs_root_ref item.  type is either BTRFS_ROOT_REF_KEY
  * or BTRFS_ROOT_BACKREF_KEY.
@@ -335,8 +360,7 @@ int btrfs_find_root_ref(struct btrfs_roo
  */
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *tree_root,
-		       u64 root_id, u8 type, u64 ref_id,
-		       u64 dirid, u64 sequence,
+		       u64 root_id, u64 ref_id, u64 dirid, u64 sequence,
 		       const char *name, int name_len)
 {
 	struct btrfs_key key;
@@ -346,13 +370,14 @@ int btrfs_add_root_ref(struct btrfs_tran
 	struct extent_buffer *leaf;
 	unsigned long ptr;
 
-
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = root_id;
-	key.type = type;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
 	key.offset = ref_id;
-
+again:
 	ret = btrfs_insert_empty_item(trans, tree_root, path, &key,
 				      sizeof(*ref) + name_len);
 	BUG_ON(ret);
@@ -366,6 +391,14 @@ int btrfs_add_root_ref(struct btrfs_tran
 	write_extent_buffer(leaf, name, ptr, name_len);
 	btrfs_mark_buffer_dirty(leaf);
 
+	if (key.type == BTRFS_ROOT_BACKREF_KEY) {
+		btrfs_release_path(tree_root, path);
+		key.objectid = ref_id;
+		key.type = BTRFS_ROOT_REF_KEY;
+		key.offset = root_id;
+		goto again;
+	}
+
 	btrfs_free_path(path);
-	return ret;
+	return 0;
 }
diff -urp 3/fs/btrfs/transaction.c 4/fs/btrfs/transaction.c
--- 3/fs/btrfs/transaction.c	2009-09-18 15:00:46.435351000 +0800
+++ 4/fs/btrfs/transaction.c	2009-09-18 15:42:47.378358670 +0800
@@ -779,24 +779,14 @@ static noinline int finish_pending_snaps
 	ret = btrfs_update_inode(trans, parent_root, parent_inode);
 	BUG_ON(ret);
 
-	/* add the backref first */
 	ret = btrfs_add_root_ref(trans, parent_root->fs_info->tree_root,
 				 pending->root_key.objectid,
-				 BTRFS_ROOT_BACKREF_KEY,
 				 parent_root->root_key.objectid,
 				 parent_inode->i_ino, index, pending->name,
 				 namelen);
 
 	BUG_ON(ret);
 
-	/* now add the forward ref */
-	ret = btrfs_add_root_ref(trans, parent_root->fs_info->tree_root,
-				 parent_root->root_key.objectid,
-				 BTRFS_ROOT_REF_KEY,
-				 pending->root_key.objectid,
-				 parent_inode->i_ino, index, pending->name,
-				 namelen);
-
 	inode = btrfs_lookup_dentry(parent_inode, pending->dentry);
 	d_instantiate(pending->dentry, inode);
 fail:
