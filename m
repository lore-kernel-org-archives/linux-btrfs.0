From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 06/12] Btrfs: Avoid orphan inodes cleanup during committing
 transaction
Date: Thu, 12 Nov 2009 17:37:02 +0800
Message-ID: <4AFBD73E.2070204@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_lookup_dentry may trigger orphan cleanup, so it's not good
to call it during committing transaction.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
---
 fs/btrfs/ioctl.c       |   29 +++++++++++++++++------------
 fs/btrfs/transaction.c |    4 ----
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a1a8db8..3d6b338 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -237,7 +237,6 @@ static noinline int create_subvol(struct btrfs_root *root,
 	u64 objectid;
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
-	unsigned long nr = 1;
 
 	/*
 	 * 1 - inode item
@@ -342,24 +341,21 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
 fail:
-	nr = trans->blocks_used;
 	err = btrfs_commit_transaction(trans, root);
 	if (err && !ret)
 		ret = err;
 
 	btrfs_unreserve_metadata_space(root, 6);
-	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
 
 static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 			   char *name, int namelen)
 {
+	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
-	int ret = 0;
-	int err;
-	unsigned long nr = 0;
+	int ret;
 
 	if (!root->ref_cows)
 		return -EINVAL;
@@ -372,20 +368,20 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	 */
 	ret = btrfs_reserve_metadata_space(root, 6);
 	if (ret)
-		goto fail_unlock;
+		goto fail;
 
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
 	if (!pending_snapshot) {
 		ret = -ENOMEM;
 		btrfs_unreserve_metadata_space(root, 6);
-		goto fail_unlock;
+		goto fail;
 	}
 	pending_snapshot->name = kmalloc(namelen + 1, GFP_NOFS);
 	if (!pending_snapshot->name) {
 		ret = -ENOMEM;
 		kfree(pending_snapshot);
 		btrfs_unreserve_metadata_space(root, 6);
-		goto fail_unlock;
+		goto fail;
 	}
 	memcpy(pending_snapshot->name, name, namelen);
 	pending_snapshot->name[namelen] = '\0';
@@ -395,10 +391,19 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
-	err = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
+	btrfs_unreserve_metadata_space(root, 6);
 
-fail_unlock:
-	btrfs_btree_balance_dirty(root, nr);
+	inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto fail;
+	}
+	BUG_ON(!inode);
+	d_instantiate(dentry, inode);
+	ret = 0;
+fail:
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b7b22c3..728e8fe 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -796,7 +796,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	memcpy(&pending->root_key, &key, sizeof(key));
 fail:
 	kfree(new_root_item);
-	btrfs_unreserve_metadata_space(root, 6);
 	return ret;
 }
 
@@ -808,7 +807,6 @@ static noinline int finish_pending_snapshot(struct btrfs_fs_info *fs_info,
 	u64 index = 0;
 	struct btrfs_trans_handle *trans;
 	struct inode *parent_inode;
-	struct inode *inode;
 	struct btrfs_root *parent_root;
 
 	parent_inode = pending->dentry->d_parent->d_inode;
@@ -840,8 +838,6 @@ static noinline int finish_pending_snapshot(struct btrfs_fs_info *fs_info,
 
 	BUG_ON(ret);
 
-	inode = btrfs_lookup_dentry(parent_inode, pending->dentry);
-	d_instantiate(pending->dentry, inode);
 fail:
 	btrfs_end_transaction(trans, fs_info->fs_root);
 	return ret;
-- 
1.6.2.5

