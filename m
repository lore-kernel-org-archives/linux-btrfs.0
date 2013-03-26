Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42662 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab3CZLzr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 07:55:47 -0400
Received: by mail-pb0-f45.google.com with SMTP id ro8so4736479pbb.4
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 04:55:47 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH 6/7] Btrfs: remove unnecessary spin_lock holding for find_qgroup_rb()
Date: Tue, 26 Mar 2013 19:55:29 +0800
Message-Id: <1364298930-4507-6-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
References: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Since mutex has been used for quota operations, we don't have to
hold spin_lock when calling find_qgroup_rb.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e3598fa..e123d5c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -98,7 +98,10 @@ struct btrfs_qgroup_list {
 	struct btrfs_qgroup *member;
 };
 
-/* must be called with qgroup_lock held */
+/*
+ * don't need to be held by spin_lock, because it has been protected by
+ * quota_lock
+ */
 static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
 					   u64 qgroupid)
 {
@@ -1041,15 +1044,12 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 
 	/* check if there are no relations to this qgroup */
-	spin_lock(&fs_info->qgroup_lock);
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
 	if (qgroup) {
 		if (!list_empty(&qgroup->groups) || !list_empty(&qgroup->members)) {
-			spin_unlock(&fs_info->qgroup_lock);
 			return -EBUSY;
 		}
 	}
-	spin_unlock(&fs_info->qgroup_lock);
 
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
@@ -1081,22 +1081,19 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		       (unsigned long long)qgroupid);
 	}
 
-	spin_lock(&fs_info->qgroup_lock);
-
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
 	if (!qgroup) {
 		ret = -ENOENT;
-		goto unlock;
+		return ret;
 	}
+	spin_lock(&fs_info->qgroup_lock);
 	qgroup->lim_flags = limit->flags;
 	qgroup->max_rfer = limit->max_rfer;
 	qgroup->max_excl = limit->max_excl;
 	qgroup->rsv_rfer = limit->rsv_rfer;
 	qgroup->rsv_excl = limit->rsv_excl;
 
-unlock:
 	spin_unlock(&fs_info->qgroup_lock);
-
 	return ret;
 }
 
-- 
1.7.7.6

