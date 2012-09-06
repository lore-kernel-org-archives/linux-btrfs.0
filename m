Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758152Ab2IFKox (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:53 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A3iMk017597
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:03:47 +0800
Message-ID: <504874F4.8000604@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:03:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 08/12] Btrfs: fix the snapshot that should not exist
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

The snapshot should be the image of the fs tree before it was created,
so the metadata of the snapshot should not exist in the its tree. But now, we
found the directory item and directory name index is in both the snapshot tree
and the fs tree. It introduces some problems and makes the users feel strange:

 # mkfs.btrfs /dev/sda1
 # mount /dev/sda1 /mnt
 # mkdir /mnt/1
 # cd /mnt/1
 # btrfs subvolume snapshot /mnt snap0
 # ls -a /mnt/1/snap0/1
 .	..	[no other file/dir]

 # ll /mnt/1/snap0/
 total 0
 drwxr-xr-x 1 root root 10 Ju1 24 12:11 1
			^^^
			There is no file/dir in it, but it's size is 10

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
useless metadata in the file tree.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v3 -> v4:
- No change.

Changelog v2 -> v3:
- rebase on the latest for-linus branch

Changelog v1 -> v2:
- add comment to explain why we need deal with the delayed items after
  snapshot creation and why this operation do not corrupt the metadata.
- move dput() to patch 01/13
---
 fs/btrfs/transaction.c |   68 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8bd2511..67d425b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -950,6 +950,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct btrfs_root *parent_root;
 	struct btrfs_block_rsv *rsv;
 	struct inode *parent_inode;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *dir_item;
 	struct dentry *parent;
 	struct dentry *dentry;
 	struct extent_buffer *tmp;
@@ -962,6 +964,12 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 root_flags;
 	uuid_le new_uuid;
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = pending->error = -ENOMEM;
+		goto path_alloc_fail;
+	}
+
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
 		ret = pending->error = -ENOMEM;
@@ -1010,23 +1018,20 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
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
-	parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
-	ret = btrfs_update_inode(trans, parent_root, parent_inode);
-	if (ret)
-		goto abort_trans;
+	btrfs_release_path(path);
 
 	/*
 	 * pull in the delayed directory update
@@ -1118,12 +1123,30 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 	if (ret)
 		goto abort_trans;
+
+	ret = btrfs_insert_dir_item(trans, parent_root,
+				    dentry->d_name.name, dentry->d_name.len,
+				    parent_inode, &key,
+				    BTRFS_FT_DIR, index);
+	/* We have check then name at the beginning, so it is impossible. */
+	BUG_ON(ret == -EEXIST);
+	if (ret)
+		goto abort_trans;
+
+	btrfs_i_size_write(parent_inode, parent_inode->i_size +
+					 dentry->d_name.len * 2);
+	parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
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
 
@@ -1449,13 +1472,28 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	mutex_lock(&root->fs_info->reloc_mutex);
 
-	ret = btrfs_run_delayed_items(trans, root);
+	/*
+	 * We needn't worry about the delayed items because we will
+	 * deal with them in create_pending_snapshot(), which is the
+	 * core function of the snapshot creation.
+	 */
+	ret = create_pending_snapshots(trans, root->fs_info);
 	if (ret) {
 		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
 	}
 
-	ret = create_pending_snapshots(trans, root->fs_info);
+	/*
+	 * We insert the dir indexes of the snapshots and update the inode
+	 * of the snapshots' parents after the snapshot creation, so there
+	 * are some delayed items which are not dealt with. Now deal with
+	 * them.
+	 *
+	 * We needn't worry that this operation will corrupt the snapshots,
+	 * because all the tree which are snapshoted will be forced to COW
+	 * the nodes and leaves.
+	 */
+	ret = btrfs_run_delayed_items(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
-- 
1.7.6.5
