Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:52112 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753244AbeDRCfB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 22:35:01 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 6BD46AC00F2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 11:34:57 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 8EDF33284A8
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 11:34:56 +0900 (JST)
Subject: [PATCH v5 2/3] btrfs: Factor out the main deletion process from
 btrfs_ioctl_snap_destroy()
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <558a949c-ceb5-115d-744f-80fac2620f7d@jp.fujitsu.com>
Message-ID: <7bf89171-e71c-7320-f102-140ccefecad0@jp.fujitsu.com>
Date: Wed, 18 Apr 2018 11:34:52 +0900
MIME-Version: 1.0
In-Reply-To: <558a949c-ceb5-115d-744f-80fac2620f7d@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Factor out the secand half of btrfs_ioctl_snap_destroy() as
btrfs_delete_subvolume(), which performes some subvolume specific checks
before deletion (1. send is not in progress. 2. the subvolume
is not the default subvolume. 3. the subvolume does not contain other
subvolumes) and actual deletion process. btrfs_delete_subvolume() requires
inode_lock for both @dir and inode of @dentry. The remaining part of
btrfs_ioctl_snap_destroy() is mainly permission checks.

Note that call of d_delete() is not included in btrfs_delete_subvolume()
as this function will also be used by btrfs_rmdir() to delete an empty
subvolume and in that case d_delete() is called in vfs layer.

As a result, btrfs_unlink_subvol() and may_destroy_subvol()
become static functions. No functional change happens.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h |   6 +--
 fs/btrfs/inode.c | 143 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c | 131 +-------------------------------------------------
 3 files changed, 144 insertions(+), 136 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 64c119349f98..34c22026e905 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3166,11 +3166,7 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
 		   const char *name, int name_len, int add_backref, u64 index);
-int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct inode *dir, u64 objectid,
-			const char *name, int name_len);
-noinline int may_destroy_subvol(struct btrfs_root *root);
+int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry);
 int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 804a1913dabf..b421aa8dd1a4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4237,7 +4237,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	return ret;
 }
 
-int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
+static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct inode *dir, u64 objectid,
 			const char *name, int name_len)
@@ -4321,7 +4321,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 /*
  * helper to check if the subvolume references other subvolumes
  */
-noinline int may_destroy_subvol(struct btrfs_root *root)
+static noinline int may_destroy_subvol(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
@@ -4372,6 +4372,145 @@ noinline int may_destroy_subvol(struct btrfs_root *root)
 	return ret;
 }
 
+int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(dentry->d_sb);
+	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct inode *inode = d_inode(dentry);
+	struct btrfs_root *dest = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_block_rsv block_rsv;
+	u64 root_flags;
+	u64 qgroup_reserved;
+	int ret;
+	int err;
+
+	/*
+	 * Don't allow to delete a subvolume with send in progress. This is
+	 * inside the i_mutex so the error handling that has to drop the bit
+	 * again is not run concurrently.
+	 */
+	spin_lock(&dest->root_item_lock);
+	root_flags = btrfs_root_flags(&dest->root_item);
+	if (dest->send_in_progress == 0) {
+		btrfs_set_root_flags(&dest->root_item,
+				root_flags | BTRFS_ROOT_SUBVOL_DEAD);
+		spin_unlock(&dest->root_item_lock);
+	} else {
+		spin_unlock(&dest->root_item_lock);
+		btrfs_warn(fs_info,
+			   "Attempt to delete subvolume %llu during send",
+			   dest->root_key.objectid);
+		err = -EPERM;
+		return err;
+	}
+
+	down_write(&fs_info->subvol_sem);
+
+	err = may_destroy_subvol(dest);
+	if (err)
+		goto out_up_write;
+
+	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
+	/*
+	 * One for dir inode, two for dir entries, two for root
+	 * ref/backref.
+	 */
+	err = btrfs_subvolume_reserve_metadata(root, &block_rsv,
+					       5, &qgroup_reserved, true);
+	if (err)
+		goto out_up_write;
+
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out_release;
+	}
+	trans->block_rsv = &block_rsv;
+	trans->bytes_reserved = block_rsv.size;
+
+	btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
+
+	ret = btrfs_unlink_subvol(trans, root, dir,
+				dest->root_key.objectid,
+				dentry->d_name.name,
+				dentry->d_name.len);
+	if (ret) {
+		err = ret;
+		btrfs_abort_transaction(trans, ret);
+		goto out_end_trans;
+	}
+
+	btrfs_record_root_in_trans(trans, dest);
+
+	memset(&dest->root_item.drop_progress, 0,
+		sizeof(dest->root_item.drop_progress));
+	dest->root_item.drop_level = 0;
+	btrfs_set_root_refs(&dest->root_item, 0);
+
+	if (!test_and_set_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &dest->state)) {
+		ret = btrfs_insert_orphan_item(trans,
+					fs_info->tree_root,
+					dest->root_key.objectid);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			err = ret;
+			goto out_end_trans;
+		}
+	}
+
+	ret = btrfs_uuid_tree_rem(trans, fs_info, dest->root_item.uuid,
+				  BTRFS_UUID_KEY_SUBVOL,
+				  dest->root_key.objectid);
+	if (ret && ret != -ENOENT) {
+		btrfs_abort_transaction(trans, ret);
+		err = ret;
+		goto out_end_trans;
+	}
+	if (!btrfs_is_empty_uuid(dest->root_item.received_uuid)) {
+		ret = btrfs_uuid_tree_rem(trans, fs_info,
+					  dest->root_item.received_uuid,
+					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
+					  dest->root_key.objectid);
+		if (ret && ret != -ENOENT) {
+			btrfs_abort_transaction(trans, ret);
+			err = ret;
+			goto out_end_trans;
+		}
+	}
+
+out_end_trans:
+	trans->block_rsv = NULL;
+	trans->bytes_reserved = 0;
+	ret = btrfs_end_transaction(trans);
+	if (ret && !err)
+		err = ret;
+	inode->i_flags |= S_DEAD;
+out_release:
+	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+out_up_write:
+	up_write(&fs_info->subvol_sem);
+	if (err) {
+		spin_lock(&dest->root_item_lock);
+		root_flags = btrfs_root_flags(&dest->root_item);
+		btrfs_set_root_flags(&dest->root_item,
+				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
+		spin_unlock(&dest->root_item_lock);
+	} else {
+		d_invalidate(dentry);
+		btrfs_invalidate_inodes(dest);
+		ASSERT(dest->send_in_progress == 0);
+
+		/* the last ref */
+		if (dest->ino_cache_inode) {
+			iput(dest->ino_cache_inode);
+			dest->ino_cache_inode = NULL;
+		}
+	}
+
+	return err;
+}
+
 static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index abd998247d64..79e9d4c541b7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2255,12 +2255,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *dest = NULL;
 	struct btrfs_ioctl_vol_args *vol_args;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_block_rsv block_rsv;
-	u64 root_flags;
-	u64 qgroup_reserved;
 	int namelen;
-	int ret;
 	int err = 0;
 
 	if (!S_ISDIR(dir->i_mode))
@@ -2344,133 +2339,11 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	}
 
 	inode_lock(inode);
-
-	/*
-	 * Don't allow to delete a subvolume with send in progress. This is
-	 * inside the i_mutex so the error handling that has to drop the bit
-	 * again is not run concurrently.
-	 */
-	spin_lock(&dest->root_item_lock);
-	root_flags = btrfs_root_flags(&dest->root_item);
-	if (dest->send_in_progress == 0) {
-		btrfs_set_root_flags(&dest->root_item,
-				root_flags | BTRFS_ROOT_SUBVOL_DEAD);
-		spin_unlock(&dest->root_item_lock);
-	} else {
-		spin_unlock(&dest->root_item_lock);
-		btrfs_warn(fs_info,
-			   "Attempt to delete subvolume %llu during send",
-			   dest->root_key.objectid);
-		err = -EPERM;
-		goto out_unlock_inode;
-	}
-
-	down_write(&fs_info->subvol_sem);
-
-	err = may_destroy_subvol(dest);
-	if (err)
-		goto out_up_write;
-
-	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
-	/*
-	 * One for dir inode, two for dir entries, two for root
-	 * ref/backref.
-	 */
-	err = btrfs_subvolume_reserve_metadata(root, &block_rsv,
-					       5, &qgroup_reserved, true);
-	if (err)
-		goto out_up_write;
-
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
-		goto out_release;
-	}
-	trans->block_rsv = &block_rsv;
-	trans->bytes_reserved = block_rsv.size;
-
-	btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
-
-	ret = btrfs_unlink_subvol(trans, root, dir,
-				dest->root_key.objectid,
-				dentry->d_name.name,
-				dentry->d_name.len);
-	if (ret) {
-		err = ret;
-		btrfs_abort_transaction(trans, ret);
-		goto out_end_trans;
-	}
-
-	btrfs_record_root_in_trans(trans, dest);
-
-	memset(&dest->root_item.drop_progress, 0,
-		sizeof(dest->root_item.drop_progress));
-	dest->root_item.drop_level = 0;
-	btrfs_set_root_refs(&dest->root_item, 0);
-
-	if (!test_and_set_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &dest->state)) {
-		ret = btrfs_insert_orphan_item(trans,
-					fs_info->tree_root,
-					dest->root_key.objectid);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			err = ret;
-			goto out_end_trans;
-		}
-	}
-
-	ret = btrfs_uuid_tree_rem(trans, fs_info, dest->root_item.uuid,
-				  BTRFS_UUID_KEY_SUBVOL,
-				  dest->root_key.objectid);
-	if (ret && ret != -ENOENT) {
-		btrfs_abort_transaction(trans, ret);
-		err = ret;
-		goto out_end_trans;
-	}
-	if (!btrfs_is_empty_uuid(dest->root_item.received_uuid)) {
-		ret = btrfs_uuid_tree_rem(trans, fs_info,
-					  dest->root_item.received_uuid,
-					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
-					  dest->root_key.objectid);
-		if (ret && ret != -ENOENT) {
-			btrfs_abort_transaction(trans, ret);
-			err = ret;
-			goto out_end_trans;
-		}
-	}
-
-out_end_trans:
-	trans->block_rsv = NULL;
-	trans->bytes_reserved = 0;
-	ret = btrfs_end_transaction(trans);
-	if (ret && !err)
-		err = ret;
-	inode->i_flags |= S_DEAD;
-out_release:
-	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
-out_up_write:
-	up_write(&fs_info->subvol_sem);
-	if (err) {
-		spin_lock(&dest->root_item_lock);
-		root_flags = btrfs_root_flags(&dest->root_item);
-		btrfs_set_root_flags(&dest->root_item,
-				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
-		spin_unlock(&dest->root_item_lock);
-	}
-out_unlock_inode:
+	err = btrfs_delete_subvolume(dir, dentry);
 	inode_unlock(inode);
-	if (!err) {
-		d_invalidate(dentry);
-		btrfs_invalidate_inodes(dest);
+	if (!err)
 		d_delete(dentry);
-		ASSERT(dest->send_in_progress == 0);
 
-		/* the last ref */
-		if (dest->ino_cache_inode) {
-			iput(dest->ino_cache_inode);
-			dest->ino_cache_inode = NULL;
-		}
-	}
 out_dput:
 	dput(dentry);
 out_unlock_dir:
-- 
2.14.3

