From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 2/4] add snapshot/subvol support for rename and rmdir
Date: Tue, 25 Aug 2009 22:38:30 +0800
Message-ID: <4A93F766.7060607@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Links to snapshots/subvols are similar to normal directories.
The main difference is snapshots/subvols use root back & forward
references instead of inode back references. This patch adds code
that handles back & forward references for rename and rmdir.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/ctree.h 3/fs/btrfs/ctree.h
--- 2/fs/btrfs/ctree.h	2009-08-24 10:36:46.212099000 +0800
+++ 3/fs/btrfs/ctree.h	2009-08-24 10:38:34.280386024 +0800
@@ -2102,12 +2102,15 @@ int btrfs_drop_subtree(struct btrfs_tran
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
@@ -2140,6 +2143,10 @@ btrfs_lookup_dir_index_item(struct btrfs
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
@@ -2234,6 +2241,10 @@ int btrfs_unlink_inode(struct btrfs_tran
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct inode *parent_inode, struct inode *inode,
 		   const char *name, int name_len, int add_backref, u64 index);
+int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct inode *dir, struct inode *inode,
+			const char *name, int name_len);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct inode *inode, u64 new_size,
diff -urp 2/fs/btrfs/dir-item.c 3/fs/btrfs/dir-item.c
--- 2/fs/btrfs/dir-item.c	2009-08-24 10:36:46.213099000 +0800
+++ 3/fs/btrfs/dir-item.c	2009-08-24 10:38:34.281099463 +0800
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
diff -urp 2/fs/btrfs/inode.c 3/fs/btrfs/inode.c
--- 2/fs/btrfs/inode.c	2009-08-24 10:36:46.217098000 +0800
+++ 3/fs/btrfs/inode.c	2009-08-24 10:38:34.284098975 +0800
@@ -2356,6 +2356,72 @@ static int btrfs_unlink(struct inode *di
 	return ret;
 }
 
+int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct inode *dir, struct inode *inode,
+			const char *name, int name_len)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_dir_item *di;
+	struct btrfs_key key;
+	u64 index;
+	int ret;
+
+	WARN_ON(root == BTRFS_I(inode)->root);
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
+	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY ||
+		key.objectid != BTRFS_I(inode)->root->root_key.objectid);
+	ret = btrfs_delete_one_dir_name(trans, root, path, di);
+	BUG_ON(ret);
+	btrfs_release_path(root, path);
+
+	ret = btrfs_del_root_ref(trans, root->fs_info->tree_root,
+				 BTRFS_I(inode)->root->root_key.objectid,
+				 root->root_key.objectid, dir->i_ino,
+				 &index, name, name_len);
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
+	btrfs_dir_item_key_to_cpu(leaf, di, &key);
+	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY ||
+		key.objectid != BTRFS_I(inode)->root->root_key.objectid);
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
@@ -2369,25 +2435,30 @@ static int btrfs_rmdir(struct inode *dir
 	 * the FIRST_FREE_OBJECTID check makes sure we don't try to rmdir
 	 * the root of a subvolume or snapshot
 	 */
-	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
-	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
-	}
 
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, dir);
 
+	if (unlikely(inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+		root->fs_info->last_trans_log_full_commit = trans->transid;
+		err = btrfs_unlink_subvol(trans, root, dir, dentry->d_inode,
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
@@ -3674,26 +3745,36 @@ int btrfs_add_link(struct btrfs_trans_ha
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
+		key.offset = (u64)-1;
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
@@ -4782,20 +4863,12 @@ static int btrfs_rename(struct inode *ol
 	int ret;
 
 	/* we're not allowed to rename between subvolumes */
-	if (BTRFS_I(old_inode)->root->root_key.objectid !=
-	    BTRFS_I(new_dir)->root->root_key.objectid)
+	if (BTRFS_I(old_dir)->root != BTRFS_I(new_dir)->root)
 		return -EXDEV;
 
 	if (S_ISDIR(old_inode->i_mode) && new_inode &&
-	    new_inode->i_size > BTRFS_EMPTY_DIR_SIZE) {
+	    new_inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
-	}
-
-	/* to rename a snapshot or subvolume, we need to juggle the
-	 * backrefs.  This isn't coded yet
-	 */
-	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
-		return -EXDEV;
 
 	ret = btrfs_check_metadata_free_space(root);
 	if (ret)
@@ -4812,6 +4885,11 @@ static int btrfs_rename(struct inode *ol
 
 	trans = btrfs_start_transaction(root, 1);
 
+	/* force full log commit if snapshot or subvolume gets involved. */
+	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    (new_inode && new_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID))
+		root->fs_info->last_trans_log_full_commit = trans->transid;
+
 	/*
 	 * make sure the inode gets flushed if it is replacing
 	 * something.
@@ -4840,18 +4918,35 @@ static int btrfs_rename(struct inode *ol
 	if (old_dentry->d_parent != new_dentry->d_parent)
 		btrfs_record_unlink_dir(trans, old_dir, old_inode, 1);
 
-	ret = btrfs_unlink_inode(trans, root, old_dir, old_dentry->d_inode,
-				 old_dentry->d_name.name,
-				 old_dentry->d_name.len);
+	if (unlikely(old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+		ret = btrfs_unlink_subvol(trans, root, old_dir,
+					  old_dentry->d_inode,
+					  old_dentry->d_name.name,
+					  old_dentry->d_name.len);
+	} else {
+		btrfs_inc_nlink(old_dentry->d_inode);
+		ret = btrfs_unlink_inode(trans, root, old_dir,
+					 old_dentry->d_inode,
+					 old_dentry->d_name.name,
+					 old_dentry->d_name.len);
+	}
 	if (ret)
 		goto out_fail;
 
 	if (new_inode) {
 		new_inode->i_ctime = CURRENT_TIME;
-		ret = btrfs_unlink_inode(trans, root, new_dir,
-					 new_dentry->d_inode,
-					 new_dentry->d_name.name,
-					 new_dentry->d_name.len);
+		if (unlikely(new_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+			ret = btrfs_unlink_subvol(trans, root, new_dir,
+						  new_dentry->d_inode,
+						  new_dentry->d_name.name,
+						  new_dentry->d_name.len);
+			WARN_ON(new_inode->i_nlink == 0);
+		} else {
+			ret = btrfs_unlink_inode(trans, root, new_dir,
+						 new_dentry->d_inode,
+						 new_dentry->d_name.name,
+						 new_dentry->d_name.len);
+		}
 		if (ret)
 			goto out_fail;
 		if (new_inode->i_nlink == 0) {
@@ -4859,7 +4954,6 @@ static int btrfs_rename(struct inode *ol
 			if (ret)
 				goto out_fail;
 		}
-
 	}
 	ret = btrfs_set_inode_index(new_dir, &index);
 	if (ret)
diff -urp 2/fs/btrfs/ioctl.c 3/fs/btrfs/ioctl.c
--- 2/fs/btrfs/ioctl.c	2009-08-24 10:36:46.219099000 +0800
+++ 3/fs/btrfs/ioctl.c	2009-08-24 10:38:34.286099535 +0800
@@ -323,18 +323,8 @@ static noinline int create_subvol(struct
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
 
-	/* add the backref first */
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
-				 objectid, BTRFS_ROOT_BACKREF_KEY,
-				 root->root_key.objectid,
-				 dir->i_ino, index, name, namelen);
-
-	BUG_ON(ret);
-
-	/* now add the forward ref */
-	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
-				 root->root_key.objectid, BTRFS_ROOT_REF_KEY,
-				 objectid,
+				 objectid, root->root_key.objectid,
 				 dir->i_ino, index, name, namelen);
 
 	BUG_ON(ret);
diff -urp 2/fs/btrfs/root-tree.c 3/fs/btrfs/root-tree.c
--- 2/fs/btrfs/root-tree.c	2009-08-24 10:36:46.220099000 +0800
+++ 3/fs/btrfs/root-tree.c	2009-08-24 10:38:34.287099466 +0800
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
diff -urp 2/fs/btrfs/transaction.c 3/fs/btrfs/transaction.c
--- 2/fs/btrfs/transaction.c	2009-08-24 10:36:46.248107000 +0800
+++ 3/fs/btrfs/transaction.c	2009-08-24 10:38:34.288098978 +0800
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
diff -urp 2/fs/btrfs/tree-log.c 3/fs/btrfs/tree-log.c
--- 2/fs/btrfs/tree-log.c	2009-08-24 10:36:46.248107000 +0800
+++ 3/fs/btrfs/tree-log.c	2009-08-24 10:38:34.290099887 +0800
@@ -2885,6 +2885,11 @@ int btrfs_log_inode_parent(struct btrfs_
 	if (ret)
 		goto end_no_trans;
 
+	if (root != BTRFS_I(inode)->root) {
+		ret = 0;
+		goto end_no_trans;
+	}
+
 	start_log_trans(trans, root);
 
 	ret = btrfs_log_inode(trans, root, inode, inode_only);
@@ -2907,6 +2912,9 @@ int btrfs_log_inode_parent(struct btrfs_
 			break;
 
 		inode = parent->d_inode;
+		if (root != BTRFS_I(inode)->root)
+			break;
+
 		if (BTRFS_I(inode)->generation >
 		    root->fs_info->last_trans_committed) {
 			ret = btrfs_log_inode(trans, root, inode, inode_only);
