From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not use btrfs_end_transaction_throttle everywhere
Date: Wed, 11 Jan 2012 13:26:27 -0500
Message-ID: <1326306387-13044-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a problem where things like open with O_CREAT would take up to
30 seconds when he had nfs activity on the same mount.  This is because all of
our quick metadata operations, like create, symlink etc all do
btrfs_end_transaction_throttle, which if the transaction is blocked will wait
for the commit to complete before it returns.  This adds a ridiculous amount of
latency and isn't really needed.  The normal btrfs_end_transaction will mark the
transaction as blocked and wake the transaction kthread up if it thinks the
transaction needs to end (this being in the running out of global reserve space
scenario), and this is all that is really needed since we've already done
everything we're going to do, we just need to return.  This should help people
with the latency they were seeing when using synchronous heavy workloads.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   18 +++++++++---------
 fs/btrfs/xattr.c |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 90a32f1..85b8b90 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2860,7 +2860,7 @@ static void __unlink_end_trans(struct btrfs_trans_handle *trans,
 		BUG_ON(!root->fs_info->enospc_unlink);
 		root->fs_info->enospc_unlink = 0;
 	}
-	btrfs_end_transaction_throttle(trans, root);
+	btrfs_end_transaction(trans, root);
 }
 
 static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
@@ -3449,7 +3449,7 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 		i_size_write(inode, newsize);
 		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
 		ret = btrfs_update_inode(trans, root, inode);
-		btrfs_end_transaction_throttle(trans, root);
+		btrfs_end_transaction(trans, root);
 	} else {
 
 		/*
@@ -4670,7 +4670,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	}
 out_unlock:
 	nr = trans->blocks_used;
-	btrfs_end_transaction_throttle(trans, root);
+	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
@@ -4738,7 +4738,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	}
 out_unlock:
 	nr = trans->blocks_used;
-	btrfs_end_transaction_throttle(trans, root);
+	btrfs_end_transaction(trans, root);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -4797,7 +4797,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	}
 
 	nr = trans->blocks_used;
-	btrfs_end_transaction_throttle(trans, root);
+	btrfs_end_transaction(trans, root);
 fail:
 	if (drop_inode) {
 		inode_dec_link_count(inode);
@@ -4863,7 +4863,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 out_fail:
 	nr = trans->blocks_used;
-	btrfs_end_transaction_throttle(trans, root);
+	btrfs_end_transaction(trans, root);
 	if (drop_on_err)
 		iput(inode);
 	btrfs_btree_balance_dirty(root, nr);
@@ -6683,7 +6683,7 @@ end_trans:
 			err = ret;
 
 		nr = trans->blocks_used;
-		ret = btrfs_end_transaction_throttle(trans, root);
+		ret = btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(root, nr);
 	}
 
@@ -7090,7 +7090,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		btrfs_end_log_trans(root);
 	}
 out_fail:
-	btrfs_end_transaction_throttle(trans, root);
+	btrfs_end_transaction(trans, root);
 out_notrans:
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
@@ -7262,7 +7262,7 @@ out_unlock:
 	if (!err)
 		d_instantiate(dentry, inode);
 	nr = trans->blocks_used;
-	btrfs_end_transaction_throttle(trans, root);
+	btrfs_end_transaction(trans, root);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 3848b04..e7a5659 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -200,7 +200,7 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
 out:
-	btrfs_end_transaction_throttle(trans, root);
+	btrfs_end_transaction(trans, root);
 	return ret;
 }
 
-- 
1.7.5.2

