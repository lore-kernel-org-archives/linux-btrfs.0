From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 6/8] Avoid orphan inodes cleanup during replaying log
Date: Mon, 02 Nov 2009 17:20:22 +0800
Message-ID: <4AEEA456.6050705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We do log replay in a single transaction, so it's not good to
do unbound operations during replaying log. This patch makes
orphan inodes cleanup executed after replaying log. It also
avoid doing other unbound operations such as truncating a file
during replaying log. These unbound operations are postponed
to the orphan inode cleanup stage.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 5/fs/btrfs/disk-io.c 6/fs/btrfs/disk-io.c
--- 5/fs/btrfs/disk-io.c	2009-10-30 17:02:55.480797000 +0800
+++ 6/fs/btrfs/disk-io.c	2009-11-02 14:23:15.081890895 +0800
@@ -1971,6 +1971,9 @@ struct btrfs_root *open_ctree(struct sup
 		if (sb->s_flags & MS_RDONLY) {
 			ret =  btrfs_commit_super(tree_root);
 			BUG_ON(ret);
+		} else {
+			ret = btrfs_cleanup_fs_roots(fs_info);
+			BUG_ON(ret);
 		}
 	}
 
diff -urp 5/fs/btrfs/inode.c 6/fs/btrfs/inode.c
--- 5/fs/btrfs/inode.c	2009-10-30 17:06:04.403039000 +0800
+++ 6/fs/btrfs/inode.c	2009-11-02 14:23:15.086890964 +0800
@@ -2054,6 +2054,9 @@ void btrfs_orphan_cleanup(struct btrfs_r
 	struct inode *inode;
 	int ret = 0, nr_unlink = 0, nr_truncate = 0;
 
+	if (root->fs_info->log_root_recovering)
+		return;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return;
@@ -2063,7 +2066,6 @@ void btrfs_orphan_cleanup(struct btrfs_r
 	btrfs_set_key_type(&key, BTRFS_ORPHAN_ITEM_KEY);
 	key.offset = (u64)-1;
 
-
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0) {
@@ -3236,6 +3238,11 @@ void btrfs_delete_inode(struct inode *in
 	}
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
+	if (root->fs_info->log_root_recovering) {
+		BUG_ON(!list_empty(&BTRFS_I(inode)->i_orphan));
+		goto no_delete;
+	}
+
 	if (inode->i_nlink > 0) {
 		BUG_ON(btrfs_root_refs(&root->root_item) != 0);
 		goto no_delete;
diff -urp 5/fs/btrfs/tree-log.c 6/fs/btrfs/tree-log.c
--- 5/fs/btrfs/tree-log.c	2009-10-30 17:02:55.488797000 +0800
+++ 6/fs/btrfs/tree-log.c	2009-11-02 14:24:17.388140346 +0800
@@ -930,6 +930,17 @@ out_nowrite:
 	return 0;
 }
 
+static int insert_orphan_item(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root, u64 offset)
+{
+	int ret;
+	ret = btrfs_find_orphan_item(root, offset);
+	if (ret > 0)
+		ret = btrfs_insert_orphan_item(trans, root, offset);
+	return ret;
+}
+
+
 /*
  * There are a few corners where the link count of the file can't
  * be properly maintained during replay.  So, instead of adding
@@ -997,9 +1008,13 @@ static noinline int fixup_inode_link_cou
 	}
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 
-	if (inode->i_nlink == 0 && S_ISDIR(inode->i_mode)) {
-		ret = replay_dir_deletes(trans, root, NULL, path,
-					 inode->i_ino, 1);
+	if (inode->i_nlink == 0) {
+		if (S_ISDIR(inode->i_mode)) {
+			ret = replay_dir_deletes(trans, root, NULL, path,
+						 inode->i_ino, 1);
+			BUG_ON(ret);
+		}
+		ret = insert_orphan_item(trans, root, inode->i_ino);
 		BUG_ON(ret);
 	}
 	btrfs_free_path(path);
@@ -1587,7 +1602,6 @@ static int replay_one_buffer(struct btrf
 		/* inode keys are done during the first stage */
 		if (key.type == BTRFS_INODE_ITEM_KEY &&
 		    wc->stage == LOG_WALK_REPLAY_INODES) {
-			struct inode *inode;
 			struct btrfs_inode_item *inode_item;
 			u32 mode;
 
@@ -1603,31 +1617,16 @@ static int replay_one_buffer(struct btrf
 					     eb, i, &key);
 			BUG_ON(ret);
 
-			/* for regular files, truncate away
-			 * extents past the new EOF
+			/* for regular files, make sure corresponding
+			 * orhpan item exist. extents past the new EOF
+			 * will be truncated later by orphan cleanup.
 			 */
 			if (S_ISREG(mode)) {
-				inode = read_one_inode(root,
-						       key.objectid);
-				BUG_ON(!inode);
-
-				ret = btrfs_truncate_inode_items(wc->trans,
-					root, inode, inode->i_size,
-					BTRFS_EXTENT_DATA_KEY);
+				ret = insert_orphan_item(wc->trans, root,
+							 key.objectid);
 				BUG_ON(ret);
-
-				/* if the nlink count is zero here, the iput
-				 * will free the inode.  We bump it to make
-				 * sure it doesn't get freed until the link
-				 * count fixup is done
-				 */
-				if (inode->i_nlink == 0) {
-					btrfs_inc_nlink(inode);
-					btrfs_update_inode(wc->trans,
-							   root, inode);
-				}
-				iput(inode);
 			}
+
 			ret = link_to_fixup_dir(wc->trans, root,
 						path, key.objectid);
 			BUG_ON(ret);
