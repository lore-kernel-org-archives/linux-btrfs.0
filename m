Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:51677 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726798AbeIKQ2J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:28:09 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0F37A4B6ADFF
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 19:29:12 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH v2 3/4] btrfs: undelete: introduce btrfs_undelete_subvolume
Date: Tue, 11 Sep 2018 19:29:02 +0800
Message-ID: <20180911112903.25985-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function will do the following things which are almost the opposite
of what btrfs_delete_subvolume() does:

1. link the subvolume to the parent specified;
2. clear root flag and set root_refs to 1;
3. add the subvol to the uuid_tree;
4. delete the orphan_item.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f6173d4e7ced..f088dea53c16 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1880,6 +1880,119 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 	return ret;
 }
 
+static int btrfs_undelete_subvolume(struct btrfs_root *root,
+				    struct dentry *parent, const char *name,
+				    int namelen)
+{
+	struct inode *dir = d_inode(parent);
+	struct btrfs_fs_info *fs_info = btrfs_sb(dir->i_sb);
+	struct btrfs_root_item *root_item = &root->root_item;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_block_rsv block_rsv;
+	struct dentry *dentry;
+	struct inode *inode;
+	u64 root_flags;
+	int ret;
+
+	btrfs_debug(fs_info, "Undelete subvolume %llu",
+				root->root_key.objectid);
+
+	/* only care about the intact subvolume */
+	if (btrfs_disk_key_objectid(&root_item->drop_progress) != 0)
+		return 0;
+
+	ret = down_write_killable_nested(&dir->i_rwsem, I_MUTEX_PARENT);
+	if (ret == -EINTR)
+		return ret;
+
+	dentry = lookup_one_len(name, parent, namelen);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto out_unlock;
+	}
+
+	down_write(&fs_info->subvol_sem);
+
+	ret = btrfs_may_create(dir, dentry);
+	if (ret)
+		goto out_up_write;
+
+	ret = btrfs_check_dir_item_collision(BTRFS_I(dir)->root, dir->i_ino,
+					     name, namelen);
+	if (ret)
+		goto out_up_write;
+
+	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
+	/*
+	 * 1 - parent dir inode
+	 * 2 - dir entries
+	 * 2 - root ref/backref
+	 * 1 - UUID item
+	 */
+	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 6, false);
+	if (ret)
+		goto out_up_write;
+
+	trans = btrfs_start_transaction(BTRFS_I(dir)->root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+		goto out_up_write;
+	}
+
+	trans->block_rsv = &block_rsv;
+	trans->bytes_reserved = block_rsv.size;
+
+	ret = btrfs_link_subvol(trans, dir, root->root_key.objectid, name,
+				namelen);
+	if (ret)
+		goto fail;
+
+	/* clear BTRFS_ROOT_SUBVOL_DEAD root flag and set root_refs to 1*/
+	root_flags = btrfs_root_flags(root_item);
+	btrfs_set_root_flags(root_item,
+			     root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
+	btrfs_set_root_refs(root_item, 1);
+	ret = btrfs_update_root(trans, fs_info->tree_root,
+				&root->root_key, &root->root_item);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
+
+	ret = btrfs_uuid_tree_add(trans, root_item->uuid, BTRFS_UUID_KEY_SUBVOL,
+				  root->root_key.objectid);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
+
+	ret = btrfs_del_orphan_item(trans, fs_info->tree_root,
+				    root->root_key.objectid);
+	if (ret && ret != -ENOENT) {
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
+fail:
+	trans->block_rsv = NULL;
+	trans->bytes_reserved = 0;
+	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+	ret = btrfs_commit_transaction(trans);
+	if (!ret) {
+		inode = btrfs_lookup_dentry(dir, dentry);
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+		d_instantiate(dentry, inode);
+		fsnotify_mkdir(dir, dentry);
+	}
+out_up_write:
+	up_write(&fs_info->subvol_sem);
+	dput(dentry);
+out_unlock:
+	inode_unlock(dir);
+	return ret;
+}
+
 static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 						void __user *arg)
 {
-- 
2.18.0
