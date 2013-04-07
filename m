Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56443 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933324Ab3DGKuz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 06:50:55 -0400
Received: by mail-pd0-f178.google.com with SMTP id w11so2686469pde.23
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 03:50:55 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH V3 2/5] Btrfs: remove some unnecessary spin_lock usages
Date: Sun,  7 Apr 2013 18:50:17 +0800
Message-Id: <1365331820-973-3-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
References: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

We use mutex lock to protect all the user change operations.
So when we are calling find_qgroup_rb() to check whether qgroup
exists, we don't have to hold spin_lock.

Besides, when enabling/disabling quota, it must be single thread
when operations come here. spin lock must be firstly used to
clear quota_root when disabling quota, while enabling quota, spin
lock must be used to complete the last assign work.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5837cb5..466bcd6 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -98,7 +98,7 @@ struct btrfs_qgroup_list {
 	struct btrfs_qgroup *member;
 };
 
-/* must be called with qgroup_lock held */
+/* must be called with qgroup_ioctl_lock held */
 static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
 					   u64 qgroupid)
 {
@@ -794,13 +794,10 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	int slot;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	spin_lock(&fs_info->qgroup_lock);
 	if (fs_info->quota_root) {
 		fs_info->pending_quota_state = 1;
-		spin_unlock(&fs_info->qgroup_lock);
 		goto out;
 	}
-	spin_unlock(&fs_info->qgroup_lock);
 
 	/*
 	 * initially create the quota tree
@@ -862,14 +859,11 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 			if (ret)
 				goto out_free_path;
 
-			spin_lock(&fs_info->qgroup_lock);
 			qgroup = add_qgroup_rb(fs_info, found_key.offset);
 			if (IS_ERR(qgroup)) {
-				spin_unlock(&fs_info->qgroup_lock);
 				ret = PTR_ERR(qgroup);
 				goto out_free_path;
 			}
-			spin_unlock(&fs_info->qgroup_lock);
 		}
 		ret = btrfs_next_item(tree_root, path);
 		if (ret < 0)
@@ -884,13 +878,12 @@ out_add_root:
 	if (ret)
 		goto out_free_path;
 
-	spin_lock(&fs_info->qgroup_lock);
 	qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID);
 	if (IS_ERR(qgroup)) {
-		spin_unlock(&fs_info->qgroup_lock);
 		ret = PTR_ERR(qgroup);
 		goto out_free_path;
 	}
+	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_root = quota_root;
 	fs_info->pending_quota_state = 1;
 	spin_unlock(&fs_info->qgroup_lock);
@@ -915,11 +908,9 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	spin_lock(&fs_info->qgroup_lock);
-	if (!fs_info->quota_root) {
-		spin_unlock(&fs_info->qgroup_lock);
+	if (!fs_info->quota_root)
 		goto out;
-	}
+	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_enabled = 0;
 	fs_info->pending_quota_state = 0;
 	quota_root = fs_info->quota_root;
@@ -1062,16 +1053,13 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	}
 
 	/* check if there are no relations to this qgroup */
-	spin_lock(&fs_info->qgroup_lock);
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
 	if (qgroup) {
 		if (!list_empty(&qgroup->groups) || !list_empty(&qgroup->members)) {
-			spin_unlock(&fs_info->qgroup_lock);
 			ret = -EBUSY;
 			goto out;
 		}
 	}
-	spin_unlock(&fs_info->qgroup_lock);
 
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
@@ -1108,20 +1096,17 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		       (unsigned long long)qgroupid);
 	}
 
-	spin_lock(&fs_info->qgroup_lock);
-
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
 	if (!qgroup) {
 		ret = -ENOENT;
-		goto unlock;
+		goto out;
 	}
+	spin_lock(&fs_info->qgroup_lock);
 	qgroup->lim_flags = limit->flags;
 	qgroup->max_rfer = limit->max_rfer;
 	qgroup->max_excl = limit->max_excl;
 	qgroup->rsv_rfer = limit->rsv_rfer;
 	qgroup->rsv_excl = limit->rsv_excl;
-
-unlock:
 	spin_unlock(&fs_info->qgroup_lock);
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
-- 
1.7.11.7

