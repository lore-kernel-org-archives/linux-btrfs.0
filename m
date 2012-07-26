Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38836 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab2GZG5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jul 2012 02:57:55 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6Q6vp8k027942
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2012 14:57:52 +0800
Message-ID: <5010EA3E.4040009@cn.fujitsu.com>
Date: Thu, 26 Jul 2012 14:57:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: fix the snapshot that should not exist
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The snapshot should be the image of the fs tree before it was created,
so the metadata of the snapshot should not exist in the its tree. But now, we
found the directory item and directory name index is in both the snapshot tree
and the fs tree. It introduces some problem and makes the users feel strange:

 # mkfs.btrfs /dev/sda1
 # mount /dev/sda1 /mnt
 # mkdir /mnt/1
 # cd /mnt/1
 # btrfs subvolume snapshot /mnt snap0
 # ll /mnt/1
 total 0
 drwxr-xr-x 1 root root 10 Ju1 24 12:11 1
			^^^
 # ll /mnt/1/snap0/
 total 0
 drwxr-xr-x 1 root root 10 Ju1 24 12:11 1
                        ^^^
                        It is also 10, but...
 # ll /mnt/1/snap0/1
 total 0
 [None]
 # cd /mnt/1/snap0/1/snap0
 [Enter a unexisted directory successfully...]

There is nothing in the directory 1 in snap0, but btrfs told the length of
this directory is 10. Beside that, we can enter an unexisted directory, it is
very strange to the users.

 # btrfs subvolume snapshot /mnt/1/snap0 /mnt/snap1
 # ll /mnt/1/snap0/1/
 total 0
 [None]
 # ll /mnt/snap1/1/
 total 0
 drwxr-xr-x 1 root root 0 Ju1 24 12:14 snap0

And the source of snap1 did have any directory in Directory 1, but snap1 have
a snap0, it is different between the source and the snapshot.

So I think we should insert directory item and directory name index and update
the parent inode as the last step of snapshot creation, and do not leave the
useless metadata in the tree.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |   52 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6d89603..e9eceee 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -922,6 +922,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct btrfs_root *parent_root;
 	struct btrfs_block_rsv *rsv;
 	struct inode *parent_inode;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *dir_item;
 	struct dentry *parent;
 	struct dentry *dentry;
 	struct extent_buffer *tmp;
@@ -932,6 +934,12 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 objectid;
 	u64 root_flags;
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = pending->error = -ENOMEM;
+		goto path_alloc_fail;
+	}
+
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
 		ret = pending->error = -ENOMEM;
@@ -973,22 +981,20 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 */
 	ret = btrfs_set_inode_index(parent_inode, &index);
 	BUG_ON(ret); /* -ENOMEM */
-	ret = btrfs_insert_dir_item(trans, parent_root,
-				dentry->d_name.name, dentry->d_name.len,
-				parent_inode, &key,
-				BTRFS_FT_DIR, index);
-	if (ret == -EEXIST) {
+
+	/* check if there is a file/dir which has the same name. */
+	dir_item = btrfs_lookup_dir_item(NULL, parent_root, path,
+					 btrfs_ino(parent_inode),
+					 dentry->d_name.name,
+					 dentry->d_name.len, 0);
+	if (dir_item != NULL && !IS_ERR(dir_item)) {
 		pending->error = -EEXIST;
 		goto fail;
-	} else if (ret) {
+	} else if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
 		goto abort_trans;
 	}
-
-	btrfs_i_size_write(parent_inode, parent_inode->i_size +
-					 dentry->d_name.len * 2);
-	ret = btrfs_update_inode(trans, parent_root, parent_inode);
-	if (ret)
-		goto abort_trans;
+	btrfs_release_path(path);
 
 	/*
 	 * pull in the delayed directory update
@@ -1062,17 +1068,33 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_reloc_post_snapshot(trans, pending);
 	if (ret)
 		goto abort_trans;
+
+	ret = btrfs_insert_dir_item(trans, parent_root,
+				    dentry->d_name.name, dentry->d_name.len,
+				    parent_inode, &key,
+				    BTRFS_FT_DIR, index);
+	/* We have check the name at the beginning, so it is impossible. */
+	BUG_ON(ret == -EEXIST);
+	if (ret)
+		goto abort_trans;
+
+	btrfs_i_size_write(parent_inode, parent_inode->i_size +
+					 dentry->d_name.len * 2);
+	ret = btrfs_update_inode(trans, parent_root, parent_inode);
+	if (ret)
+		goto abort_trans;
 fail:
 	dput(parent);
 	trans->block_rsv = rsv;
 no_free_objectid:
 	kfree(new_root_item);
 root_item_alloc_fail:
+	btrfs_free_path(path);
+path_alloc_fail:
 	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
 	return ret;
 
 abort_trans:
-	dput(parent);
 	btrfs_abort_transaction(trans, root, ret);
 	goto fail;
 }
@@ -1386,13 +1408,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	mutex_lock(&root->fs_info->reloc_mutex);
 
-	ret = btrfs_run_delayed_items(trans, root);
+	ret = create_pending_snapshots(trans, root->fs_info);
 	if (ret) {
 		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
 	}
 
-	ret = create_pending_snapshots(trans, root->fs_info);
+	ret = btrfs_run_delayed_items(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
-- 
1.7.6.5
