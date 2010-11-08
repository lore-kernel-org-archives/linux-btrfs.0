From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix dentry->d_parent abuses V2
Date: Mon,  8 Nov 2010 10:01:48 -0500
Message-ID: <1289228508-20741-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are lots of places where we do dentry->d_parent->d_inode without holding
the dentry->d_lock.  This could cause problems with rename.  So instead use
dget_parent where we can, or in some cases we don't even need to use
dentry->d_parent->d_inode since we get the inode of the dir passed to us from
VFS.  I tested this with xfstests and my no space tests and everything turned
out fine.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
Cc: raven@themaw.net
---
V1->V2: return an error if btrfs_start_transaction fails in aio_write
-hold the dentry->d_parent ref while using its inode in create_subvol and
create_pending_snapshots

 fs/btrfs/file.c        |    7 +++++++
 fs/btrfs/inode.c       |   48 ++++++++++++++++++++++++------------------------
 fs/btrfs/ioctl.c       |   20 ++++++++++++++++----
 fs/btrfs/transaction.c |    5 ++++-
 fs/btrfs/tree-log.c    |   22 ++++++++++++++++++----
 5 files changed, 69 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e354c33..c1faded 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1047,8 +1047,14 @@ out:
 
 		if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 			trans = btrfs_start_transaction(root, 0);
+			if (IS_ERR(trans)) {
+				num_written = PTR_ERR(trans);
+				goto done;
+			}
+			mutex_lock(&inode->i_mutex);
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
+			mutex_unlock(&inode->i_mutex);
 			if (ret == 0) {
 				ret = btrfs_sync_log(trans, root);
 				if (ret == 0)
@@ -1067,6 +1073,7 @@ out:
 			     (start_pos + num_written - 1) >> PAGE_CACHE_SHIFT);
 		}
 	}
+done:
 	current->backing_dev_info = NULL;
 	return num_written ? num_written : err;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 558cac2..78877d7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4139,6 +4139,7 @@ static int btrfs_dentry_delete(struct dentry *dentry)
 		if (btrfs_root_refs(&root->root_item) == 0)
 			return 1;
 	}
+
 	return 0;
 }
 
@@ -4622,12 +4623,12 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 }
 
 static int btrfs_add_nondir(struct btrfs_trans_handle *trans,
-			    struct dentry *dentry, struct inode *inode,
-			    int backref, u64 index)
+			    struct inode *dir, struct dentry *dentry,
+			    struct inode *inode, int backref, u64 index)
 {
-	int err = btrfs_add_link(trans, dentry->d_parent->d_inode,
-				 inode, dentry->d_name.name,
-				 dentry->d_name.len, backref, index);
+	int err = btrfs_add_link(trans, dir, inode,
+				 dentry->d_name.name, dentry->d_name.len,
+				 backref, index);
 	if (!err) {
 		d_instantiate(dentry, inode);
 		return 0;
@@ -4668,8 +4669,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len,
-				dentry->d_parent->d_inode->i_ino, objectid,
+				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, mode, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
@@ -4682,7 +4682,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	}
 
 	btrfs_set_trans_block_group(trans, inode);
-	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
+	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
 	else {
@@ -4730,10 +4730,8 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len,
-				dentry->d_parent->d_inode->i_ino,
-				objectid, BTRFS_I(dir)->block_group, mode,
-				&index);
+				dentry->d_name.len, dir->i_ino, objectid,
+				BTRFS_I(dir)->block_group, mode, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_unlock;
@@ -4745,7 +4743,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	}
 
 	btrfs_set_trans_block_group(trans, inode);
-	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
+	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
 	else {
@@ -4805,15 +4803,17 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	btrfs_set_trans_block_group(trans, dir);
 	ihold(inode);
 
-	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
+	err = btrfs_add_nondir(trans, dir, dentry, inode, 1, index);
 
 	if (err) {
 		drop_inode = 1;
 	} else {
+		struct dentry *parent = dget_parent(dentry);
 		btrfs_update_inode_block_group(trans, dir);
 		err = btrfs_update_inode(trans, root, inode);
 		BUG_ON(err);
-		btrfs_log_new_name(trans, inode, NULL, dentry->d_parent);
+		btrfs_log_new_name(trans, inode, NULL, parent);
+		dput(parent);
 	}
 
 	nr = trans->blocks_used;
@@ -4853,8 +4853,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len,
-				dentry->d_parent->d_inode->i_ino, objectid,
+				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFDIR | mode,
 				&index);
 	if (IS_ERR(inode)) {
@@ -4877,9 +4876,8 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (err)
 		goto out_fail;
 
-	err = btrfs_add_link(trans, dentry->d_parent->d_inode,
-				 inode, dentry->d_name.name,
-				 dentry->d_name.len, 0, index);
+	err = btrfs_add_link(trans, dir, inode, dentry->d_name.name,
+			     dentry->d_name.len, 0, index);
 	if (err)
 		goto out_fail;
 
@@ -6607,8 +6605,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	BUG_ON(ret);
 
 	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
+		struct dentry *parent = dget_parent(new_dentry);
+
 		btrfs_log_new_name(trans, old_inode, old_dir,
-				   new_dentry->d_parent);
+				   parent);
+		dput(parent);
 		btrfs_end_log_trans(root);
 	}
 out_fail:
@@ -6758,8 +6759,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len,
-				dentry->d_parent->d_inode->i_ino, objectid,
+				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFLNK|S_IRWXUGO,
 				&index);
 	err = PTR_ERR(inode);
@@ -6773,7 +6773,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	}
 
 	btrfs_set_trans_block_group(trans, inode);
-	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
+	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
 	else {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 463d91b..e82925b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -233,17 +233,23 @@ static noinline int create_subvol(struct btrfs_root *root,
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
 	struct btrfs_root *new_root;
-	struct inode *dir = dentry->d_parent->d_inode;
+	struct dentry *parent = dget_parent(dentry);
+	struct inode *dir;
 	int ret;
 	int err;
 	u64 objectid;
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
 
+	dir = parent->d_inode;
+
 	ret = btrfs_find_free_objectid(NULL, root->fs_info->tree_root,
 				       0, &objectid);
-	if (ret)
+	if (ret) {
+		dput(parent);
 		return ret;
+	}
+
 	/*
 	 * 1 - inode item
 	 * 2 - refs
@@ -251,8 +257,10 @@ static noinline int create_subvol(struct btrfs_root *root,
 	 * 2 - dir items
 	 */
 	trans = btrfs_start_transaction(root, 6);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		dput(parent);
 		return PTR_ERR(trans);
+	}
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
 				      0, objectid, NULL, 0, 0, 0);
@@ -339,6 +347,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
 fail:
+	dput(parent);
 	if (async_transid) {
 		*async_transid = trans->transid;
 		err = btrfs_commit_transaction_async(trans, root, 1);
@@ -354,6 +363,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 			   char *name, int namelen, u64 *async_transid)
 {
 	struct inode *inode;
+	struct dentry *parent;
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
 	int ret;
@@ -396,7 +406,9 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 
 	btrfs_orphan_cleanup(pending_snapshot->snap);
 
-	inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
+	parent = dget_parent(dentry);
+	inode = btrfs_lookup_dentry(parent->d_inode, dentry);
+	dput(parent);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
 		goto fail;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1fffbc0..f37ab80 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -902,6 +902,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = pending->root;
 	struct btrfs_root *parent_root;
 	struct inode *parent_inode;
+	struct dentry *parent_dentry;
 	struct dentry *dentry;
 	struct extent_buffer *tmp;
 	struct extent_buffer *old;
@@ -941,7 +942,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	trans->block_rsv = &pending->block_rsv;
 
 	dentry = pending->dentry;
-	parent_inode = dentry->d_parent->d_inode;
+	parent_dentry = dget_parent(dentry);
+	parent_inode = parent_dentry->d_inode;
 	parent_root = BTRFS_I(parent_inode)->root;
 	record_root_in_trans(trans, parent_root);
 
@@ -989,6 +991,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				 parent_inode->i_ino, index,
 				 dentry->d_name.name, dentry->d_name.len);
 	BUG_ON(ret);
+	dput(parent_dentry);
 
 	key.offset = (u64)-1;
 	pending->snap = btrfs_read_fs_root_no_name(root->fs_info, &key);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a29f193..0d74c0a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2869,6 +2869,7 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct btrfs_root *root;
+	struct dentry *old_parent = NULL;
 
 	/*
 	 * for regular files, if its inode is already on disk, we don't
@@ -2910,10 +2911,13 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 		if (IS_ROOT(parent))
 			break;
 
-		parent = parent->d_parent;
+		parent = dget_parent(parent);
+		dput(old_parent);
+		old_parent = parent;
 		inode = parent->d_inode;
 
 	}
+	dput(old_parent);
 out:
 	return ret;
 }
@@ -2945,6 +2949,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 {
 	int inode_only = exists_only ? LOG_INODE_EXISTS : LOG_INODE_ALL;
 	struct super_block *sb;
+	struct dentry *old_parent = NULL;
 	int ret = 0;
 	u64 last_committed = root->fs_info->last_trans_committed;
 
@@ -3016,10 +3021,13 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		if (IS_ROOT(parent))
 			break;
 
-		parent = parent->d_parent;
+		parent = dget_parent(parent);
+		dput(old_parent);
+		old_parent = parent;
 	}
 	ret = 0;
 end_trans:
+	dput(old_parent);
 	if (ret < 0) {
 		BUG_ON(ret != -ENOSPC);
 		root->fs_info->last_trans_log_full_commit = trans->transid;
@@ -3039,8 +3047,14 @@ end_no_trans:
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct dentry *dentry)
 {
-	return btrfs_log_inode_parent(trans, root, dentry->d_inode,
-				      dentry->d_parent, 0);
+	struct dentry *parent = dget_parent(dentry);
+	int ret;
+
+	ret = btrfs_log_inode_parent(trans, root, dentry->d_inode, parent, 0);
+
+	dput(parent);
+
+	return ret;
 }
 
 /*
-- 
1.6.6.1

