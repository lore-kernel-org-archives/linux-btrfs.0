Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41779 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965553Ab3E2S5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 14:57:44 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E1EB67C0432
	for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 12:57:43 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id EKmCjlMCh4jrJCi3 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 12:57:42 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: simplify unlink reservations
Date: Wed, 29 May 2013 14:57:40 -0400
Message-ID: <1369853860-13888-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave pointed out a problem where if you filled up a file system as much as
possible you couldn't remove any files.  The whole unlink reservation thing is
convoluted because it tries to guess if it's going to add space to unlink
something or not, and has all these odd uncommented cases where it simply does
not try.  So to fix this I've added a way to conditionally steal from the global
reserve if we can't make our normal reservation.  If we have more than half the
space in the global reserve free we will go ahead and steal from the global
reserve.  With this patch Dave's reproducer now works and I can rm all the files
on the file system.  Thanks,

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h       |    4 +-
 fs/btrfs/extent-tree.c |   25 ++++++
 fs/btrfs/inode.c       |  212 +++++-------------------------------------------
 3 files changed, 50 insertions(+), 191 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fd62aa8..a07b8c0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1495,7 +1495,6 @@ struct btrfs_fs_info {
 	int do_barriers;
 	int closing;
 	int log_root_recovering;
-	int enospc_unlink;
 
 	u64 total_pinned;
 
@@ -3183,6 +3182,9 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 			    struct btrfs_block_rsv *dst_rsv,
 			    u64 num_bytes);
+int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
+			     struct btrfs_block_rsv *dest, u64 num_bytes,
+			     int min_factor);
 void btrfs_block_rsv_release(struct btrfs_root *root,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4ec8305..e14f8bd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4297,6 +4297,31 @@ static void block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
 	spin_unlock(&block_rsv->lock);
 }
 
+int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
+			     struct btrfs_block_rsv *dest, u64 num_bytes,
+			     int min_factor)
+{
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	u64 min_bytes;
+
+	if (global_rsv->space_info != dest->space_info)
+		return -ENOSPC;
+
+	spin_lock(&global_rsv->lock);
+	min_bytes = div_factor(global_rsv->size, min_factor);
+	if (global_rsv->reserved < min_bytes + num_bytes) {
+		spin_unlock(&global_rsv->lock);
+		return -ENOSPC;
+	}
+	global_rsv->reserved -= num_bytes;
+	if (global_rsv->reserved < global_rsv->size)
+		global_rsv->full = 0;
+	spin_unlock(&global_rsv->lock);
+
+	block_rsv_add_bytes(dest, num_bytes, 1);
+	return 0;
+}
+
 static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 				    struct btrfs_block_rsv *block_rsv,
 				    struct btrfs_block_rsv *dest, u64 num_bytes)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 80b82b1..b11a95e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3679,53 +3679,20 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 	return ret;
 }
-		
-
-/* helper to check if there is any shared block in the path */
-static int check_path_shared(struct btrfs_root *root,
-			     struct btrfs_path *path)
-{
-	struct extent_buffer *eb;
-	int level;
-	u64 refs = 1;
-
-	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
-		int ret;
-
-		if (!path->nodes[level])
-			break;
-		eb = path->nodes[level];
-		if (!btrfs_block_can_be_shared(root, eb))
-			continue;
-		ret = btrfs_lookup_extent_info(NULL, root, eb->start, level, 1,
-					       &refs, NULL);
-		if (refs > 1)
-			return 1;
-	}
-	return 0;
-}
 
 /*
  * helper to start transaction for unlink and rmdir.
  *
- * unlink and rmdir are special in btrfs, they do not always free space.
- * so in enospc case, we should make sure they will free space before
- * allowing them to use the global metadata reservation.
+ * unlink and rmdir are special in btrfs, they do not always free space, so
+ * if we cannot make our reservations the normal way try and see if there is
+ * plenty of slack room in the global reserve to migrate, otherwise we cannot
+ * allow the unlink to occur.
  */
-static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
-						       struct dentry *dentry)
+static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
-	struct btrfs_path *path;
-	struct btrfs_dir_item *di;
-	struct inode *inode = dentry->d_inode;
-	u64 index;
-	int check_link = 1;
-	int err = -ENOSPC;
 	int ret;
-	u64 ino = btrfs_ino(inode);
-	u64 dir_ino = btrfs_ino(dir);
 
 	/*
 	 * 1 for the possible orphan item
@@ -3738,158 +3705,23 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
-	if (ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
-		return ERR_PTR(-ENOSPC);
-
-	/* check if there is someone else holds reference */
-	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
-		return ERR_PTR(-ENOSPC);
-
-	if (atomic_read(&inode->i_count) > 2)
-		return ERR_PTR(-ENOSPC);
-
-	if (xchg(&root->fs_info->enospc_unlink, 1))
-		return ERR_PTR(-ENOSPC);
-
-	path = btrfs_alloc_path();
-	if (!path) {
-		root->fs_info->enospc_unlink = 0;
-		return ERR_PTR(-ENOMEM);
-	}
+	if (PTR_ERR(trans) == -ENOSPC) {
+		u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
 
-	/* 1 for the orphan item */
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		btrfs_free_path(path);
-		root->fs_info->enospc_unlink = 0;
-		return trans;
-	}
-
-	path->skip_locking = 1;
-	path->search_commit_root = 1;
-
-	ret = btrfs_lookup_inode(trans, root, path,
-				&BTRFS_I(dir)->location, 0);
-	if (ret < 0) {
-		err = ret;
-		goto out;
-	}
-	if (ret == 0) {
-		if (check_path_shared(root, path))
-			goto out;
-	} else {
-		check_link = 0;
-	}
-	btrfs_release_path(path);
-
-	ret = btrfs_lookup_inode(trans, root, path,
-				&BTRFS_I(inode)->location, 0);
-	if (ret < 0) {
-		err = ret;
-		goto out;
-	}
-	if (ret == 0) {
-		if (check_path_shared(root, path))
-			goto out;
-	} else {
-		check_link = 0;
-	}
-	btrfs_release_path(path);
-
-	if (ret == 0 && S_ISREG(inode->i_mode)) {
-		ret = btrfs_lookup_file_extent(trans, root, path,
-					       ino, (u64)-1, 0);
-		if (ret < 0) {
-			err = ret;
-			goto out;
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans))
+			return trans;
+		ret = btrfs_cond_migrate_bytes(root->fs_info,
+					       &root->fs_info->trans_block_rsv,
+					       num_bytes, 5);
+		if (ret) {
+			btrfs_end_transaction(trans, root);
+			return ERR_PTR(ret);
 		}
-		BUG_ON(ret == 0); /* Corruption */
-		if (check_path_shared(root, path))
-			goto out;
-		btrfs_release_path(path);
-	}
-
-	if (!check_link) {
-		err = 0;
-		goto out;
-	}
-
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				dentry->d_name.name, dentry->d_name.len, 0);
-	if (IS_ERR(di)) {
-		err = PTR_ERR(di);
-		goto out;
-	}
-	if (di) {
-		if (check_path_shared(root, path))
-			goto out;
-	} else {
-		err = 0;
-		goto out;
-	}
-	btrfs_release_path(path);
-
-	ret = btrfs_get_inode_ref_index(trans, root, path, dentry->d_name.name,
-					dentry->d_name.len, ino, dir_ino, 0,
-					&index);
-	if (ret) {
-		err = ret;
-		goto out;
-	}
-
-	if (check_path_shared(root, path))
-		goto out;
-
-	btrfs_release_path(path);
-
-	/*
-	 * This is a commit root search, if we can lookup inode item and other
-	 * relative items in the commit root, it means the transaction of
-	 * dir/file creation has been committed, and the dir index item that we
-	 * delay to insert has also been inserted into the commit root. So
-	 * we needn't worry about the delayed insertion of the dir index item
-	 * here.
-	 */
-	di = btrfs_lookup_dir_index_item(trans, root, path, dir_ino, index,
-				dentry->d_name.name, dentry->d_name.len, 0);
-	if (IS_ERR(di)) {
-		err = PTR_ERR(di);
-		goto out;
-	}
-	BUG_ON(ret == -ENOENT);
-	if (check_path_shared(root, path))
-		goto out;
-
-	err = 0;
-out:
-	btrfs_free_path(path);
-	/* Migrate the orphan reservation over */
-	if (!err)
-		err = btrfs_block_rsv_migrate(trans->block_rsv,
-				&root->fs_info->global_block_rsv,
-				trans->bytes_reserved);
-
-	if (err) {
-		btrfs_end_transaction(trans, root);
-		root->fs_info->enospc_unlink = 0;
-		return ERR_PTR(err);
-	}
-
-	trans->block_rsv = &root->fs_info->global_block_rsv;
-	return trans;
-}
-
-static void __unlink_end_trans(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root)
-{
-	if (trans->block_rsv->type == BTRFS_BLOCK_RSV_GLOBAL) {
-		btrfs_block_rsv_release(root, trans->block_rsv,
-					trans->bytes_reserved);
 		trans->block_rsv = &root->fs_info->trans_block_rsv;
-		BUG_ON(!root->fs_info->enospc_unlink);
-		root->fs_info->enospc_unlink = 0;
+		trans->bytes_reserved = num_bytes;
 	}
-	btrfs_end_transaction(trans, root);
+	return trans;
 }
 
 static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
@@ -3899,7 +3731,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	int ret;
 
-	trans = __unlink_start_trans(dir, dentry);
+	trans = __unlink_start_trans(dir);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
@@ -3917,7 +3749,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 
 out:
-	__unlink_end_trans(trans, root);
+	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root);
 	return ret;
 }
@@ -4014,7 +3846,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID)
 		return -EPERM;
 
-	trans = __unlink_start_trans(dir, dentry);
+	trans = __unlink_start_trans(dir);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
@@ -4036,7 +3868,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!err)
 		btrfs_i_size_write(inode, 0);
 out:
-	__unlink_end_trans(trans, root);
+	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root);
 
 	return err;
-- 
1.7.7.6

