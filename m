From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix wrong information of the directory in the snapshot
Date: Thu, 23 Feb 2012 15:46:35 +0800
Message-ID: <4F45EEDB.6070708@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The snapshot should be the image of the fs tree before it was created,
so the metadata of the snapshot should not exist in the its tree. But now, we
found the directory item and directory name index is in both the snapshot tree
and the fs tree.

Besides that, it also makes the users feel strange. For example:
 # mkfs.btrfs /dev/sda1
 # mount /dev/sda1 /mnt
 # mkdir /mnt/1
 # cd /mnt/1
 # btrfs subvolume snapshot /mnt snap0
 # ll /mnt/1
 total 0
 drwxr-xr-x 1 root root 10 Jun 30 15:01 1
			^^^
 # ll /mnt/1/snap0/
 total 0
 drwxr-xr-x 1 root root 10 Jun 30 15:01 1
			^^^
			It is also 10, but...
 # ll /mnt/1/snap0/1
 total 0
 [None]
 # cd /mnt/1/snap0/1/snap0
 [Enter a unexisted directory successfully]

There is nothing in the directory 1 in snap0, but btrfs told the length of
this directory is 10. Beside that, we can enter an unexisted directory, it is
very strange.

So I think we should insert directory item and directory name index and update
the parent inode as the last step of snapshot creation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c       |    8 +++++++-
 fs/btrfs/transaction.c |   30 +++++++++++++++---------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ac77fef..9334a57 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4171,7 +4171,13 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			}
 no_dentry:
 			/* is this a reference to our own snapshot? If so
-			 * skip it
+			 * skip it.
+			 *
+			 * In contrast to old kernels, we insert the snapshot's
+			 * dir item and dir index after it has been created, so
+			 * we won't find a reference to our own snapshot. We
+			 * still keep the following code for backward
+			 * compatibility.
 			 */
 			if (location.type == BTRFS_ROOT_ITEM_KEY &&
 			    location.objectid == root->root_key.objectid) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 287a672..b7528d1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -906,21 +906,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	parent_root = BTRFS_I(parent_inode)->root;
 	record_root_in_trans(trans, parent_root);
 
-	/*
-	 * insert the directory item
-	 */
 	ret = btrfs_set_inode_index(parent_inode, &index);
 	BUG_ON(ret);
-	ret = btrfs_insert_dir_item(trans, parent_root,
-				dentry->d_name.name, dentry->d_name.len,
-				parent_inode, &key,
-				BTRFS_FT_DIR, index);
-	BUG_ON(ret);
-
-	btrfs_i_size_write(parent_inode, parent_inode->i_size +
-					 dentry->d_name.len * 2);
-	ret = btrfs_update_inode(trans, parent_root, parent_inode);
-	BUG_ON(ret);
 
 	/*
 	 * pull in the delayed directory update
@@ -978,6 +965,19 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	BUG_ON(IS_ERR(pending->snap));
 
 	btrfs_reloc_post_snapshot(trans, pending);
+	/*
+	 * insert the directory item
+	 */
+	ret = btrfs_insert_dir_item(trans, parent_root,
+				dentry->d_name.name, dentry->d_name.len,
+				parent_inode, &key,
+				BTRFS_FT_DIR, index);
+	BUG_ON(ret);
+
+	btrfs_i_size_write(parent_inode, parent_inode->i_size +
+					 dentry->d_name.len * 2);
+	ret = btrfs_update_inode(trans, parent_root, parent_inode);
+	BUG_ON(ret);
 fail:
 	kfree(new_root_item);
 	trans->block_rsv = rsv;
@@ -1258,10 +1258,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	mutex_lock(&root->fs_info->reloc_mutex);
 
-	ret = btrfs_run_delayed_items(trans, root);
+	ret = create_pending_snapshots(trans, root->fs_info);
 	BUG_ON(ret);
 
-	ret = create_pending_snapshots(trans, root->fs_info);
+	ret = btrfs_run_delayed_items(trans, root);
 	BUG_ON(ret);
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-- 
1.7.6.5
