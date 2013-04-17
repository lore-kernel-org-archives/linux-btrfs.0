Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62912 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966531Ab3DQOuh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 10:50:37 -0400
Received: by mail-pd0-f178.google.com with SMTP id w11so902571pde.23
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 07:50:36 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs: add all ioctl checks before user change for quota operations
Date: Wed, 17 Apr 2013 22:49:51 +0800
Message-Id: <1366210191-7456-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Since all the quota configurations are loaded in memory, and we can
have ioctl checks before operating in the disk. It is safe to do such
things because qgroup_ioctl_lock is held outside.

Without these extra checks firstly, it should be ok to do user change
for quota operations. For example:

if we want to add an existed qgroup, we will do:
	->add_qgroup_item()
		->add_qgroup_rb()

add_qgroup_item() will return -EEXIST to us, however, qgroups are all
in memory, why not check them in memory firstly.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
Since this patch relies on my previous patchset, so it
is based on the latest btrfs-next branch.
---
 fs/btrfs/qgroup.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f9fb52e..f175471 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -956,6 +956,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *parent;
 	struct btrfs_qgroup *member;
+	struct btrfs_qgroup_list *list;
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
@@ -971,6 +972,14 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	/* check if such qgroup relation exist firstly */
+	list_for_each_entry(list, &member->groups, next_group) {
+		if (list->group == parent) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
 	ret = add_qgroup_relation_item(trans, quota_root, src, dst);
 	if (ret)
 		goto out;
@@ -993,6 +1002,9 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
 {
 	struct btrfs_root *quota_root;
+	struct btrfs_qgroup *parent;
+	struct btrfs_qgroup *member;
+	struct btrfs_qgroup_list *list;
 	int ret = 0;
 	int err;
 
@@ -1003,6 +1015,21 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	member = find_qgroup_rb(fs_info, src);
+	parent = find_qgroup_rb(fs_info, dst);
+	if (!member || !parent) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* check if such qgroup relation exist firstly */
+	list_for_each_entry(list, &member->groups, next_group) {
+		if (list->group == parent)
+			goto exist;
+	}
+	ret = -ENOENT;
+	goto out;
+exist:
 	ret = del_qgroup_relation_item(trans, quota_root, src, dst);
 	err = del_qgroup_relation_item(trans, quota_root, dst, src);
 	if (err && !ret)
@@ -1010,7 +1037,6 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 
 	spin_lock(&fs_info->qgroup_lock);
 	del_relation_rb(fs_info, src, dst);
-
 	spin_unlock(&fs_info->qgroup_lock);
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
@@ -1030,8 +1056,15 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 		ret = -EINVAL;
 		goto out;
 	}
+	qgroup = find_qgroup_rb(fs_info, qgroupid);
+	if (qgroup) {
+		ret = -EEXIST;
+		goto out;
+	}
 
 	ret = add_qgroup_item(trans, quota_root, qgroupid);
+	if (ret)
+		goto out;
 
 	spin_lock(&fs_info->qgroup_lock);
 	qgroup = add_qgroup_rb(fs_info, qgroupid);
@@ -1058,15 +1091,18 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	/* check if there are no relations to this qgroup */
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
-	if (qgroup) {
-		if (!list_empty(&qgroup->groups) || !list_empty(&qgroup->members)) {
+	if (!qgroup) {
+		ret = -ENOENT;
+		goto out;
+	} else {
+		/* check if there are no relations to this qgroup */
+		if (!list_empty(&qgroup->groups) ||
+		    !list_empty(&qgroup->members)) {
 			ret = -EBUSY;
 			goto out;
 		}
 	}
-
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
 	spin_lock(&fs_info->qgroup_lock);
-- 
1.7.11.7

