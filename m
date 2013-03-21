Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:53657 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3CUKxS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 06:53:18 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so1570999dak.6
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 03:53:17 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, wangshilong1991@gmail.com
Subject: [PATCH] Btrfs: creating the subvolume qgroup automatically when enabling quota
Date: Thu, 21 Mar 2013 18:53:12 +0800
Message-Id: <1363863192-1533-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Creating the subvolume/snapshots(including root subvolume) qgroup
auotomatically when enabling quota.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c  |    2 +
 fs/btrfs/qgroup.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2c02310..222ce84 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3693,6 +3693,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	down_read(&root->fs_info->subvol_sem);
 	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
 		trans = btrfs_start_transaction(root, 2);
 		if (IS_ERR(trans)) {
@@ -3726,6 +3727,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	}
 out:
 	kfree(sa);
+	up_read(&root->fs_info->subvol_sem);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5471e47..1aff3a8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -783,11 +783,15 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *quota_root;
+	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_path *path = NULL;
 	struct btrfs_qgroup_status_item *ptr;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_qgroup *qgroup = NULL;
 	int ret = 0;
+	int slot;
 
 	spin_lock(&fs_info->qgroup_lock);
 	if (fs_info->quota_root) {
@@ -834,7 +838,58 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 
 	btrfs_mark_buffer_dirty(leaf);
 
+	key.objectid = 0;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = 0;
+
+	btrfs_release_path(path);
+	ret = btrfs_search_slot_for_read(tree_root, &key, path, 1, 0);
+	if (ret > 0)
+		goto out_add_root;
+	if (ret < 0)
+		goto out_free_path;
+
+
+	while (1) {
+		slot = path->slots[0];
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+
+		if (found_key.type == BTRFS_ROOT_REF_KEY) {
+			ret = add_qgroup_item(trans, quota_root,
+					      found_key.offset);
+			if (ret)
+				goto out_free_path;
+
+			spin_lock(&fs_info->qgroup_lock);
+			qgroup = add_qgroup_rb(fs_info, found_key.offset);
+			if (IS_ERR(qgroup)) {
+				spin_unlock(&fs_info->qgroup_lock);
+				ret = PTR_ERR(qgroup);
+				goto out_free_path;
+			}
+			spin_unlock(&fs_info->qgroup_lock);
+		}
+		ret = btrfs_next_item(tree_root, path);
+		if (ret < 0)
+			goto out_free_path;
+		if (ret)
+			break;
+	}
+
+out_add_root:
+	btrfs_release_path(path);
+	ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID);
+	if (ret)
+		goto out_free_path;
+
 	spin_lock(&fs_info->qgroup_lock);
+	qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID);
+	if (IS_ERR(qgroup)) {
+		spin_unlock(&fs_info->qgroup_lock);
+		ret = PTR_ERR(qgroup);
+		goto out_free_path;
+	}
 	fs_info->quota_root = quota_root;
 	fs_info->pending_quota_state = 1;
 	spin_unlock(&fs_info->qgroup_lock);
-- 
1.7.7.6

