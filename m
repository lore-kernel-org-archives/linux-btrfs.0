Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42109 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3C1LBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 07:01:42 -0400
Received: by mail-pa0-f47.google.com with SMTP id bj3so2163555pad.6
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 04:01:42 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH V2 6/6] Btrfs: fix missing check before btrfs_qgroup_inherit()
Date: Thu, 28 Mar 2013 18:54:47 +0800
Message-Id: <1364468087-1702-5-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1364468055-1669-1-git-send-email-wangshilong1991@gmail.com>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The original code forgot to check 'inherit',we should gurantee
that all the qgroups in the struct 'inherit' exist before
btrfs_qgroup_inherit().

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h  |    2 ++
 fs/btrfs/ioctl.c  |    6 ++++++
 fs/btrfs/qgroup.c |   29 ++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1ca1c63..0e73385 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3855,6 +3855,8 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 			     struct btrfs_delayed_extent_op *extent_op);
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		      struct btrfs_fs_info *fs_info);
+int btrfs_may_inherit_qgroup(struct btrfs_root *root,
+			     struct btrfs_qgroup_inherit *inherit);
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 701d812..96fda7e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -753,6 +753,11 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	if (btrfs_root_refs(&BTRFS_I(dir)->root->root_item) == 0)
 		goto out_up_read;
 	mutex_lock(&BTRFS_I(dir)->root->fs_info->quota_lock);
+
+	error = btrfs_may_inherit_qgroup(BTRFS_I(dir)->root, inherit);
+	if (error)
+		goto out_unlock_mutex;
+
 	if (snap_src) {
 		error = create_snapshot(snap_src, dir, dentry, name, namelen,
 					async_transid, readonly, inherit);
@@ -762,6 +767,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	}
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
+out_unlock_mutex:
 	mutex_unlock(&BTRFS_I(dir)->root->fs_info->quota_lock);
 out_up_read:
 	up_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0e09ac6..14fca77 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1359,9 +1359,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	if (!fs_info->quota_enabled)
 		return 0;
 
-	if (!quota_root)
-		return -EINVAL;
-
 	/*
 	 * create a tracking group for the subvol itself
 	 */
@@ -1701,3 +1698,29 @@ int btrfs_may_assign_qgroup(struct btrfs_root *root,
 		return 0;
 	return -ENOENT;
 }
+
+int btrfs_may_inherit_qgroup(struct btrfs_root *root,
+			     struct btrfs_qgroup_inherit *inherit)
+{
+	u64 i = 0;
+	u64 *i_qgroups = NULL;
+	u64 nums = 0;
+	struct btrfs_qgroup *qgroup = NULL;
+
+	if (!inherit)
+		return 0;
+	if (!root->fs_info->quota_root)
+		return -EINVAL;
+
+	i_qgroups = (u64 *)(inherit + 1);
+	nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
+	       2 * inherit->num_excl_copies;
+	for (i = 0; i < nums; ++i) {
+		qgroup = find_qgroup_rb(root->fs_info, *i_qgroups);
+		if (!qgroup)
+			return -EINVAL;
+
+		++i_qgroups;
+	}
+	return 0;
+}
-- 
1.7.7.6

