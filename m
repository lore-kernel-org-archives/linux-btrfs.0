Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:56484 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3CZLzp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 07:55:45 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so3621413dak.6
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 04:55:44 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH 5/7] Btrfs: fix missing check before btrfs_qgroup_inherit()
Date: Tue, 26 Mar 2013 19:55:28 +0800
Message-Id: <1364298930-4507-5-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
References: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The original code dosen't have necessary checks before
doing qgroup_inherit. Fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1cd96f6..86e7fb3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -708,6 +708,49 @@ static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
 	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
 }
 
+static int check_qgroup_inherit(struct btrfs_root *root,
+				struct btrfs_qgroup_inherit *inherit)
+{
+	int ret = 0;
+	u64 *i_qgroups;
+	u64 nums = 0;
+	u64 i = 0;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+
+	if (!inherit)
+		return 0;
+	if (!root->fs_info->quota_root)
+		return -EINVAL;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		return ret;
+	}
+
+	i_qgroups = (u64 *)(inherit + 1);
+	nums = inherit->num_qgroups + inherit->num_ref_copies +
+	       inherit->num_excl_copies;
+	for (i = 0; i < nums; ++i) {
+		btrfs_release_path(path);
+		key.objectid = 0;
+		key.type = BTRFS_QGROUP_INFO_KEY;
+		key.offset = *i_qgroups;
+
+		ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
+					&key, path, 0, 0);
+		if (ret > 0)
+			ret = -EINVAL;
+		if (ret)
+			goto out;
+		++i_qgroups;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * Create a new subvolume below @parent.  This is largely modeled after
  * sys_mkdirat and vfs_mkdir, but we only do a single component lookup
@@ -753,6 +796,11 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	if (btrfs_root_refs(&BTRFS_I(dir)->root->root_item) == 0)
 		goto out_up_read;
 
+	mutex_lock(&BTRFS_I(dir)->root->fs_info->quota_lock);
+	error = check_qgroup_inherit(BTRFS_I(dir)->root, inherit);
+	if (error)
+		goto out_unlock_mutex;
+
 	if (snap_src) {
 		error = create_snapshot(snap_src, dir, dentry, name, namelen,
 					async_transid, readonly, inherit);
@@ -762,6 +810,8 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	}
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
+out_unlock_mutex:
+	mutex_unlock(&BTRFS_I(dir)->root->fs_info->quota_lock);
 out_up_read:
 	up_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
 out_dput:
-- 
1.7.7.6

