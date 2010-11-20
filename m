From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use dget_parent where we can UPDATED
Date: Sat, 20 Nov 2010 04:48:00 -0500
Message-ID: <1290246480-26141-1-git-send-email-josef@redhat.com>
References: <1290198971-21663-2-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290198971-21663-2-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

There are lots of places where we do dentry->d_parent->d_inode without holding
the dentry->d_lock.  This could cause problems with rename.  So instead we need
to use dget_parent() and hold the reference to the parent as long as we are
going to use it's inode and then dput it at the end.

Signed-off-by: Josef Bacik <josef@redhat.com>
Cc: raven@themaw.net
---
-screwed up and used dget() instead of dget_parent() in one place

 fs/btrfs/inode.c       |    9 ++++++---
 fs/btrfs/ioctl.c       |   20 ++++++++++++++++----
 fs/btrfs/transaction.c |    5 ++++-
 fs/btrfs/tree-log.c    |   21 +++++++++++++++++----
 4 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 558cac2..821ec73 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4810,10 +4810,12 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
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
@@ -6607,8 +6609,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	BUG_ON(ret);
 
 	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
-		btrfs_log_new_name(trans, old_inode, old_dir,
-				   new_dentry->d_parent);
+		struct dentry *parent = dget_parent(new_dentry);
+		btrfs_log_new_name(trans, old_inode, old_dir, parent);
+		dput(parent);
 		btrfs_end_log_trans(root);
 	}
 out_fail:
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 463d91b..5dba458 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -233,7 +233,8 @@ static noinline int create_subvol(struct btrfs_root *root,
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
 	struct btrfs_root *new_root;
-	struct inode *dir = dentry->d_parent->d_inode;
+	struct dentry *parent = dget_parent(dentry);
+	struct inode *dir;
 	int ret;
 	int err;
 	u64 objectid;
@@ -242,8 +243,13 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	ret = btrfs_find_free_objectid(NULL, root->fs_info->tree_root,
 				       0, &objectid);
-	if (ret)
+	if (ret) {
+		dput(parent);
 		return ret;
+	}
+
+	dir = parent->d_inode;
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
index 1fffbc0..f50e931 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -902,6 +902,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = pending->root;
 	struct btrfs_root *parent_root;
 	struct inode *parent_inode;
+	struct dentry *parent;
 	struct dentry *dentry;
 	struct extent_buffer *tmp;
 	struct extent_buffer *old;
@@ -941,7 +942,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	trans->block_rsv = &pending->block_rsv;
 
 	dentry = pending->dentry;
-	parent_inode = dentry->d_parent->d_inode;
+	parent = dget_parent(dentry);
+	parent_inode = parent->d_inode;
 	parent_root = BTRFS_I(parent_inode)->root;
 	record_root_in_trans(trans, parent_root);
 
@@ -989,6 +991,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				 parent_inode->i_ino, index,
 				 dentry->d_name.name, dentry->d_name.len);
 	BUG_ON(ret);
+	dput(parent);
 
 	key.offset = (u64)-1;
 	pending->snap = btrfs_read_fs_root_no_name(root->fs_info, &key);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a29f193..054744a 100644
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
@@ -3039,8 +3047,13 @@ end_no_trans:
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct dentry *dentry)
 {
-	return btrfs_log_inode_parent(trans, root, dentry->d_inode,
-				      dentry->d_parent, 0);
+	struct dentry *parent = dget_parent(dentry);
+	int ret;
+
+	ret = btrfs_log_inode_parent(trans, root, dentry->d_inode, parent, 0);
+	dput(parent);
+
+	return ret;
 }
 
 /*
-- 
1.6.6.1

