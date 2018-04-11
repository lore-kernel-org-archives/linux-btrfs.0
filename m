Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:31814 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbeDKFUR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 01:20:17 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 347DDAC021A
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:20:11 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 55934BD6688
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:20:10 +0900 (JST)
Subject: [PATCH v4 2/4] btrfs: Add definition of btrfs_delete_subvolume()
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
Message-ID: <a5aa2c68-7ce8-2830-78f1-88d05a6c318b@jp.fujitsu.com>
Date: Wed, 11 Apr 2018 14:20:07 +0900
MIME-Version: 1.0
In-Reply-To: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new function btrfs_delete_subvolume() which is almost identical
to the secand half of btrfs_ioctl_snap_destroy(). This function requires
inode_lock for both @dir and inode of @dentry.

This performes additional check (1. send is not in progress. 2. the
subvolume is not a default subvolume. 3. the subvolume does not contain
other subvoume) and actual deletion process.

The code path is not changed yet and this function will be used to
refactor btrfs_ioctl_snap_destroy() and to allow rmdir(2) to delete an
empty subvolume.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h |   1 +
 fs/btrfs/inode.c | 139 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2dbead106aab..618365eb9d84 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3167,6 +3167,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 			struct inode *dir, u64 objectid,
 			const char *name, int name_len);
 noinline int may_destroy_subvol(struct btrfs_root *root);
+int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry);
 int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index db66fa4fede6..54c50a9fa2ee 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4387,6 +4387,145 @@ noinline int may_destroy_subvol(struct btrfs_root *root)
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
-- 
2.14.3

