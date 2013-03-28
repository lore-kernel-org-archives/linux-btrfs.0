Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45414 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3C1Ky6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 06:54:58 -0400
Received: by mail-pd0-f180.google.com with SMTP id g10so4053516pdj.11
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 03:54:57 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH V2 4/6] Btrfs: fix missing check before creating/destroying a qgroup
Date: Thu, 28 Mar 2013 18:54:45 +0800
Message-Id: <1364468087-1702-3-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1364468055-1669-1-git-send-email-wangshilong1991@gmail.com>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

For creating a qgroup, if the qgroup exsits, return -EEXIST.
For destroying a qgroup, if there are qgroup relations, return -EBUSY,
if the qgroup dosen't exist, return -ENOENT.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h  |    2 ++
 fs/btrfs/ioctl.c  |    5 ++++-
 fs/btrfs/qgroup.c |   45 ++++++++++++++++++++++++++-------------------
 3 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3fc393d..9e4ccb3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3831,6 +3831,8 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
+int btrfs_may_create_qgroup(struct btrfs_root *root,
+			    struct btrfs_ioctl_qgroup_create_args *sa);
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, u64 qgroupid,
 			char *name);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7c72b12..f66d622 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3811,13 +3811,16 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto out;
 	}
 	mutex_lock(&root->fs_info->quota_lock);
+	ret = btrfs_may_create_qgroup(root, sa);
+	if (ret)
+		goto out_unlock;
+
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_unlock;
 	}
 
-	/* FIXME: check if the IDs really exist */
 	if (sa->create) {
 		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid,
 					  NULL);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index bed0e22..6f57a98 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1003,15 +1003,13 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, u64 qgroupid, char *name)
 {
-	struct btrfs_root *quota_root;
+	struct btrfs_root *quota_root = fs_info->quota_root;
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
 
-	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = add_qgroup_item(trans, quota_root, qgroupid);
+	if (ret)
+		return ret;
 
 	spin_lock(&fs_info->qgroup_lock);
 	qgroup = add_qgroup_rb(fs_info, qgroupid);
@@ -1026,22 +1024,9 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, u64 qgroupid)
 {
-	struct btrfs_root *quota_root;
-	struct btrfs_qgroup *qgroup;
+	struct btrfs_root *quota_root = fs_info->quota_root;
 	int ret = 0;
 
-	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
-
-	/* check if there are no relations to this qgroup */
-	qgroup = find_qgroup_rb(fs_info, qgroupid);
-	if (qgroup) {
-		if (!list_empty(&qgroup->groups) ||
-		    !list_empty(&qgroup->members))
-			return -EBUSY;
-	}
-
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
 	spin_lock(&fs_info->qgroup_lock);
@@ -1674,3 +1659,25 @@ int btrfs_may_limit_qgroup(struct btrfs_root *root, u64 qgroupid)
 		return -ENOENT;
 	return 0;
 }
+
+int btrfs_may_create_qgroup(struct btrfs_root *root,
+			    struct btrfs_ioctl_qgroup_create_args *sa)
+{
+	struct btrfs_qgroup *qgroup = NULL;
+
+	if (!root->fs_info->quota_root)
+		return -EINVAL;
+
+	qgroup = find_qgroup_rb(root->fs_info, sa->qgroupid);
+	if (sa->create) {
+		if (qgroup)
+			return -EEXIST;
+		return 0;
+	}
+	if (!qgroup)
+		return -ENOENT;
+	/* check if there are no relations to this qgroup */
+	if (!list_empty(&qgroup->groups) || !list_empty(&qgroup->members))
+		return -EBUSY;
+	return 0;
+}
-- 
1.7.7.6

