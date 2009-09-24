From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] check size of inode backref before adding hardlink
Date: Thu, 24 Sep 2009 17:08:29 +0800
Message-ID: <4ABB370D.3090203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

For every hardlink in btrfs, there is a corresponding inode back
reference. All inode back references for hardlinks in a given
directory are stored in single b-tree item. The size of b-tree item
is limited by the size of b-tree leaf, so we can only create limited
number of hardlinks to a given file in a directory.

The original code lacks of the check, it oops if the number of
hardlinks goes over the limit. This patch fixes the issue by adding
check to btrfs_link and btrfs_rename.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2009-07-29 10:03:04.150859426 +0800
+++ 2/fs/btrfs/ctree.c	2009-09-23 09:55:39.366357021 +0800
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
--- 1/fs/btrfs/inode.c	2009-09-23 05:49:42.007477065 +0800
+++ 2/fs/btrfs/inode.c	2009-09-23 10:20:17.006357143 +0800
@@ -4133,18 +4133,16 @@ static int btrfs_link(struct dentry *old
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
-	if (err)
-		drop_inode = 1;
-
-	btrfs_update_inode_block_group(trans, dir);
-	err = btrfs_update_inode(trans, root, inode);
-
-	if (err)
+	if (err) {
 		drop_inode = 1;
+	} else {
+		btrfs_update_inode_block_group(trans, dir);
+		err = btrfs_update_inode(trans, root, inode);
+		BUG_ON(err);
+		btrfs_log_new_name(trans, inode, NULL, dentry->d_parent);
+	}
 
 	nr = trans->blocks_used;
-
-	btrfs_log_new_name(trans, inode, NULL, dentry->d_parent);
 	btrfs_end_transaction_throttle(trans, root);
 fail:
 	if (drop_inode) {
@@ -5087,23 +5085,26 @@ static int btrfs_rename(struct inode *ol
 		down_read(&root->fs_info->subvol_sem);
 
 	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_trans_block_group(trans, new_dir);
 
 	if (dest != root)
 		btrfs_record_root_in_trans(trans, dest);
 
-	/*
-	 * make sure the inode gets flushed if it is replacing
-	 * something.
-	 */
-	if (new_inode && new_inode->i_size &&
-	    old_inode && S_ISREG(old_inode->i_mode)) {
-		btrfs_add_ordered_operation(trans, root, old_inode);
-	}
+	ret = btrfs_set_inode_index(new_dir, &index);
+	if (ret)
+		goto out_fail;
 
-	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+	if (unlikely(old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		/* force full log commit if subvolume involved. */
 		root->fs_info->last_trans_log_full_commit = trans->transid;
 	} else {
+		ret = btrfs_insert_inode_ref(trans, dest,
+					     new_dentry->d_name.name,
+					     new_dentry->d_name.len,
+					     old_inode->i_ino,
+					     new_dir->i_ino, index);
+		if (ret)
+			goto out_fail;
 		/*
 		 * this is an ugly little race, but the rename is required
 		 * to make sure that if we crash, the inode is either at the
@@ -5113,8 +5114,14 @@ static int btrfs_rename(struct inode *ol
 		 */
 		btrfs_pin_log_trans(root);
 	}
-
-	btrfs_set_trans_block_group(trans, new_dir);
+	/*
+	 * make sure the inode gets flushed if it is replacing
+	 * something.
+	 */
+	if (new_inode && new_inode->i_size &&
+	    old_inode && S_ISREG(old_inode->i_mode)) {
+		btrfs_add_ordered_operation(trans, root, old_inode);
+	}
 
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
@@ -5159,12 +5166,10 @@ static int btrfs_rename(struct inode *ol
 			BUG_ON(ret);
 		}
 	}
-	ret = btrfs_set_inode_index(new_dir, &index);
-	BUG_ON(ret);
 
 	ret = btrfs_add_link(trans, new_dir, old_inode,
 			     new_dentry->d_name.name,
-			     new_dentry->d_name.len, 1, index);
+			     new_dentry->d_name.len, 0, index);
 	BUG_ON(ret);
 
 	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
@@ -5172,7 +5177,7 @@ static int btrfs_rename(struct inode *ol
 				   new_dentry->d_parent);
 		btrfs_end_log_trans(root);
 	}
-
+out_fail:
 	btrfs_end_transaction_throttle(trans, root);
 
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
diff -urp 1/fs/btrfs/inode-item.c 2/fs/btrfs/inode-item.c
--- 1/fs/btrfs/inode-item.c	2009-09-23 05:49:41.980477037 +0800
+++ 2/fs/btrfs/inode-item.c	2009-09-23 09:55:56.309353757 +0800
@@ -149,6 +149,8 @@ int btrfs_insert_inode_ref(struct btrfs_
 		ptr = (unsigned long)(ref + 1);
 		ret = 0;
 	} else if (ret < 0) {
+		if (ret == -EOVERFLOW)
+			ret = -EMLINK;
 		goto out;
 	} else {
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
