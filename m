From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] check size of inode backref before adding hardlink
Date: Wed, 05 Aug 2009 17:13:42 +0800
Message-ID: <4A794D46.1050500@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

For every hardlink in btrfs, there is a corresponding inode back
reference. All inode back references for hardlinks in a given
directory are stored in single b-tree item. The size of b-tree item
is limited by the size of b-tree leaf, so we can only create limited
number of hardlinks to a given file in a directory.

The original code lacks of the check, it oops if the number of
hardlinks goes over the limit. This patch fixes the issue by adding
the check to btrfs_link and btrfs_rename.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2009-07-29 10:03:04.150859426 +0800
+++ 2/fs/btrfs/ctree.c	2009-08-05 14:55:01.850810000 +0800
@@ -2853,6 +2853,12 @@ static noinline int split_leaf(struct bt
 	int split;
 	int num_doubles = 0;
 
+	l = path->nodes[0];
+	slot = path->slots[0];
+	if (extend && data_size + btrfs_item_size_nr(l, slot) +
+	    sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(root))
+		return -EOVERFLOW;
+
 	/* first try to make some room by pushing left and right */
 	if (data_size && ins_key->type != BTRFS_DIR_ITEM_KEY) {
 		wret = push_leaf_right(trans, root, path, data_size, 0);
diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
--- 1/fs/btrfs/inode.c	2009-07-29 10:03:04.365858071 +0800
+++ 2/fs/btrfs/inode.c	2009-08-05 16:06:24.220810000 +0800
@@ -3674,7 +3674,7 @@ int btrfs_add_link(struct btrfs_trans_ha
 		   struct inode *parent_inode, struct inode *inode,
 		   const char *name, int name_len, int add_backref, u64 index)
 {
-	int ret;
+	int ret = 0;
 	struct btrfs_key key;
 	struct btrfs_root *root = BTRFS_I(parent_inode)->root;
 
@@ -3682,18 +3682,18 @@ int btrfs_add_link(struct btrfs_trans_ha
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 
-	ret = btrfs_insert_dir_item(trans, root, name, name_len,
-				    parent_inode->i_ino,
-				    &key, btrfs_inode_type(inode),
-				    index);
+	if (add_backref) {
+		ret = btrfs_insert_inode_ref(trans, root,
+					     name, name_len, inode->i_ino,
+					     parent_inode->i_ino, index);
+	}
+
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
@@ -3877,20 +3877,16 @@ static int btrfs_link(struct dentry *old
 	atomic_inc(&inode->i_count);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
-
-	if (err)
-		drop_inode = 1;
-
-	dir->i_sb->s_dirt = 1;
-	btrfs_update_inode_block_group(trans, dir);
-	err = btrfs_update_inode(trans, root, inode);
-
 	if (err)
 		drop_inode = 1;
+	else {
+		dir->i_sb->s_dirt = 1;
+		btrfs_update_inode_block_group(trans, dir);
+		btrfs_update_inode(trans, root, inode);
+		btrfs_log_new_name(trans, inode, NULL, dentry->d_parent);
+	}
 
 	nr = trans->blocks_used;
-
-	btrfs_log_new_name(trans, inode, NULL, dentry->d_parent);
 	btrfs_end_transaction_throttle(trans, root);
 fail:
 	if (drop_inode) {
@@ -4833,6 +4829,16 @@ static int btrfs_rename(struct inode *ol
 
 	btrfs_set_trans_block_group(trans, new_dir);
 
+	ret = btrfs_set_inode_index(new_dir, &index);
+	if (ret)
+		goto out_fail;
+
+	ret = btrfs_insert_inode_ref(trans, root, new_dentry->d_name.name,
+				     new_dentry->d_name.len, old_inode->i_ino,
+				     new_dir->i_ino, index);
+	if (ret)
+		goto out_fail;
+
 	btrfs_inc_nlink(old_dentry->d_inode);
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
@@ -4844,8 +4850,7 @@ static int btrfs_rename(struct inode *ol
 	ret = btrfs_unlink_inode(trans, root, old_dir, old_dentry->d_inode,
 				 old_dentry->d_name.name,
 				 old_dentry->d_name.len);
-	if (ret)
-		goto out_fail;
+	BUG_ON(ret);
 
 	if (new_inode) {
 		new_inode->i_ctime = CURRENT_TIME;
@@ -4853,24 +4858,17 @@ static int btrfs_rename(struct inode *ol
 					 new_dentry->d_inode,
 					 new_dentry->d_name.name,
 					 new_dentry->d_name.len);
-		if (ret)
-			goto out_fail;
+		BUG_ON(ret);
 		if (new_inode->i_nlink == 0) {
 			ret = btrfs_orphan_add(trans, new_dentry->d_inode);
-			if (ret)
-				goto out_fail;
+			BUG_ON(ret);
 		}
-
 	}
-	ret = btrfs_set_inode_index(new_dir, &index);
-	if (ret)
-		goto out_fail;
 
 	ret = btrfs_add_link(trans, new_dentry->d_parent->d_inode,
 			     old_inode, new_dentry->d_name.name,
-			     new_dentry->d_name.len, 1, index);
-	if (ret)
-		goto out_fail;
+			     new_dentry->d_name.len, 0, index);
+	BUG_ON(ret);
 
 	btrfs_log_new_name(trans, old_inode, old_dir,
 				       new_dentry->d_parent);
diff -urp 1/fs/btrfs/inode-item.c 2/fs/btrfs/inode-item.c
--- 1/fs/btrfs/inode-item.c	2009-07-24 09:51:38.372057017 +0800
+++ 2/fs/btrfs/inode-item.c	2009-08-05 15:11:37.141061000 +0800
@@ -149,6 +149,8 @@ int btrfs_insert_inode_ref(struct btrfs_
 		ptr = (unsigned long)(ref + 1);
 		ret = 0;
 	} else if (ret < 0) {
+		if (ret == -EOVERFLOW)
+			ret = -EMLINK;
 		goto out;
 	} else {
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
