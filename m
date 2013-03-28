Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51849 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3C1OBq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 10:01:46 -0400
Received: by mail-pd0-f182.google.com with SMTP id 3so989843pdj.27
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 07:01:46 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: miaox@cn.fujitsu.com, sensille@gmx.net, wangshilong1991@gmail.com
Subject: [PATCH V3 5/6] Btrfs: fix missing check before assigning/removing qgroup relation
Date: Thu, 28 Mar 2013 22:01:41 +0800
Message-Id: <1364479301-2164-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

If the specified qgroup relation dosen't exist, removing qgroup operations
will return -ENOENT;

If the specified qgroup relation exists, assigning qgroup relations will
return -EEXIST.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h  |    2 ++
 fs/btrfs/ioctl.c  |    4 +++-
 fs/btrfs/qgroup.c |   40 ++++++++++++++++++++++++++++++----------
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9e4ccb3..1ca1c63 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3827,6 +3827,8 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
 int btrfs_quota_rescan(struct btrfs_fs_info *fs_info);
+int btrfs_may_assign_qgroup(struct btrfs_root *root,
+			    struct btrfs_ioctl_qgroup_assign_args *sa);
 int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f66d622..701d812 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3758,13 +3758,15 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	}
 
 	mutex_lock(&root->fs_info->quota_lock);
+	ret = btrfs_may_assign_qgroup(root, sa);
+	if (ret)
+		goto out;
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
 	}
 
-	/* FIXME: check if the IDs really exist */
 	if (sa->assign) {
 		ret = btrfs_add_qgroup_relation(trans, root->fs_info,
 						sa->src, sa->dst);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6f57a98..0e09ac6 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -952,13 +952,9 @@ int btrfs_quota_rescan(struct btrfs_fs_info *fs_info)
 int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
 {
-	struct btrfs_root *quota_root;
+	struct btrfs_root *quota_root = fs_info->quota_root;
 	int ret = 0;
 
-	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = add_qgroup_relation_item(trans, quota_root, src, dst);
 	if (ret)
 		return ret;
@@ -979,14 +975,10 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
 {
-	struct btrfs_root *quota_root;
+	struct btrfs_root *quota_root = fs_info->quota_root;
 	int ret = 0;
 	int err;
 
-	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = del_qgroup_relation_item(trans, quota_root, src, dst);
 	err = del_qgroup_relation_item(trans, quota_root, dst, src);
 	if (err && !ret)
@@ -1681,3 +1673,31 @@ int btrfs_may_create_qgroup(struct btrfs_root *root,
 		return -EBUSY;
 	return 0;
 }
+
+int btrfs_may_assign_qgroup(struct btrfs_root *root,
+			    struct btrfs_ioctl_qgroup_assign_args *sa)
+{
+
+	struct btrfs_qgroup *parent = NULL;
+	struct btrfs_qgroup *member = NULL;
+	struct btrfs_qgroup_list *list;
+
+	if (!root->fs_info->quota_root)
+		return -EINVAL;
+
+	member = find_qgroup_rb(root->fs_info, sa->src);
+	parent = find_qgroup_rb(root->fs_info, sa->dst);
+	if (!member || !parent)
+		return -ENOENT;
+
+	list_for_each_entry(list, &member->groups, next_group) {
+		if (list->group == parent) {
+			if (sa->assign)
+				return -EEXIST;
+			return 0;
+		}
+	}
+	if (sa->assign)
+		return 0;
+	return -ENOENT;
+}
-- 
1.7.7.6

