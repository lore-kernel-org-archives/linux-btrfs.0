Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:12581 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbeCWI2s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 04:28:48 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id B3912AC0203
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 17:28:42 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 008B346E7C7
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 17:28:42 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: Allow rmdir(2) to delete a subvolume
Message-ID: <ae04d89d-c0c0-8e88-acdd-168cbd74adf3@jp.fujitsu.com>
Date: Fri, 23 Mar 2018 17:28:38 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch changes the behavior of rmdir(2) to allow it to delete
an empty subvolume.

In order to do that the core logic of subvolume deletion is moved from
ioctl.c to inode.c and named as btrfs_delete_subvolume(), which is
also called in the btrfs_rmdir() if a directory is an empty subvolume.

Note that call of d_delete() is not included in the
btrfs_delete_subvolume(); they are not needed for rmdir(2) because
d_delete() will be called in vfs layer later.

btrfs_delete_subvolume() requires inode_lock for both @dir and @dentry.
For rmdir(2) it is already acquired in vfs layer before calling
btrfs_rmdir().

Also, btrfs_unlink_subvol() is no longer called outside of inode.c
and is changed to a static function.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h |   5 +-
 fs/btrfs/inode.c | 199 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c | 185 +--------------------------------------------------
 3 files changed, 200 insertions(+), 189 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index da308774b8a4..6f23f0694ac3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3162,10 +3162,7 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
 		   const char *name, int name_len, int add_backref, u64 index);
-int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct inode *dir, u64 objectid,
-			const char *name, int name_len);
+int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry);
 int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f53470112670..c23e41e6cdfe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4252,7 +4252,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	return ret;
 }
 
-int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
+static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct inode *dir, u64 objectid,
 			const char *name, int name_len)
@@ -4333,6 +4333,201 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * helper to check if the subvolume references other subvolumes
+ */
+static noinline int may_destroy_subvol(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *di;
+	struct btrfs_key key;
+	u64 dir_id;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/* Make sure this root isn't set as the default subvol */
+	dir_id = btrfs_super_root_dir(fs_info->super_copy);
+	di = btrfs_lookup_dir_item(NULL, fs_info->tree_root, path,
+				   dir_id, "default", 7, 0);
+	if (di && !IS_ERR(di)) {
+		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
+		if (key.objectid == root->root_key.objectid) {
+			ret = -EPERM;
+			btrfs_err(fs_info,
+				  "deleting default subvolume %llu is not allowed",
+				  key.objectid);
+			goto out;
+		}
+		btrfs_release_path(path);
+	}
+
+	key.objectid = root->root_key.objectid;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+
+	ret = 0;
+	if (path->slots[0] > 0) {
+		path->slots[0]--;
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.objectid == root->root_key.objectid &&
+		    key.type == BTRFS_ROOT_REF_KEY)
+			ret = -ENOTEMPTY;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
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
+	}
+
+	if (!err) {
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
@@ -4344,7 +4539,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
 	if (btrfs_ino(BTRFS_I(inode)) == BTRFS_FIRST_FREE_OBJECTID)
-		return -EPERM;
+		return btrfs_delete_subvolume(dir, dentry);
 
 	trans = __unlink_start_trans(dir);
 	if (IS_ERR(trans))
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 111ee282b777..7559a1a82e6d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1843,60 +1843,6 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	return ret;
 }
 
-/*
- * helper to check if the subvolume references other subvolumes
- */
-static noinline int may_destroy_subvol(struct btrfs_root *root)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_path *path;
-	struct btrfs_dir_item *di;
-	struct btrfs_key key;
-	u64 dir_id;
-	int ret;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	/* Make sure this root isn't set as the default subvol */
-	dir_id = btrfs_super_root_dir(fs_info->super_copy);
-	di = btrfs_lookup_dir_item(NULL, fs_info->tree_root, path,
-				   dir_id, "default", 7, 0);
-	if (di && !IS_ERR(di)) {
-		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
-		if (key.objectid == root->root_key.objectid) {
-			ret = -EPERM;
-			btrfs_err(fs_info,
-				  "deleting default subvolume %llu is not allowed",
-				  key.objectid);
-			goto out;
-		}
-		btrfs_release_path(path);
-	}
-
-	key.objectid = root->root_key.objectid;
-	key.type = BTRFS_ROOT_REF_KEY;
-	key.offset = (u64)-1;
-
-	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
-	if (ret < 0)
-		goto out;
-	BUG_ON(ret == 0);
-
-	ret = 0;
-	if (path->slots[0] > 0) {
-		path->slots[0]--;
-		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-		if (key.objectid == root->root_key.objectid &&
-		    key.type == BTRFS_ROOT_REF_KEY)
-			ret = -ENOTEMPTY;
-	}
-out:
-	btrfs_free_path(path);
-	return ret;
-}
-
 static noinline int key_in_sk(struct btrfs_key *key,
 			      struct btrfs_ioctl_search_key *sk)
 {
@@ -2320,12 +2266,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
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
@@ -2409,133 +2350,11 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
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

