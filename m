From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 5/8] Avoid orphan inodes cleanup during committing transaction
Date: Mon, 02 Nov 2009 17:20:16 +0800
Message-ID: <4AEEA450.2070503@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_lookup_dentry may trigger orphan cleanup, so it's not good
to call it during committing transaction.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 4/fs/btrfs/ioctl.c 5/fs/btrfs/ioctl.c
--- 4/fs/btrfs/ioctl.c	2009-10-30 17:02:55.484797548 +0800
+++ 5/fs/btrfs/ioctl.c	2009-10-30 12:54:45.537040000 +0800
@@ -355,10 +355,10 @@ fail:
 static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 			   char *name, int namelen)
 {
+	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
-	int ret = 0;
-	int err;
+	int ret;
 	unsigned long nr = 0;
 
 	if (!root->ref_cows)
@@ -372,20 +372,20 @@ static int create_snapshot(struct btrfs_
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
@@ -395,9 +395,18 @@ static int create_snapshot(struct btrfs_
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
-	err = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
 
-fail_unlock:
+	inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto fail;
+	}
+	BUG_ON(!inode);
+	d_instantiate(dentry, inode);
+	ret = 0;
+fail:
 	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
diff -urp 4/fs/btrfs/transaction.c 5/fs/btrfs/transaction.c
--- 4/fs/btrfs/transaction.c	2009-10-30 17:02:55.486797545 +0800
+++ 5/fs/btrfs/transaction.c	2009-10-30 17:07:43.758039649 +0800
@@ -800,7 +800,6 @@ static noinline int finish_pending_snaps
 	u64 index = 0;
 	struct btrfs_trans_handle *trans;
 	struct inode *parent_inode;
-	struct inode *inode;
 	struct btrfs_root *parent_root;
 
 	parent_inode = pending->dentry->d_parent->d_inode;
@@ -832,8 +831,6 @@ static noinline int finish_pending_snaps
 
 	BUG_ON(ret);
 
-	inode = btrfs_lookup_dentry(parent_inode, pending->dentry);
-	d_instantiate(pending->dentry, inode);
 fail:
 	btrfs_end_transaction(trans, fs_info->fs_root);
 	return ret;
