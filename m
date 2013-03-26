Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45406 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759142Ab3CZLzu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 07:55:50 -0400
Received: by mail-pa0-f41.google.com with SMTP id kx1so1121053pab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 04:55:49 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH 7/7] Btrfs: remove reduplicate check about quota_root in qgroup.c
Date: Tue, 26 Mar 2013 19:55:30 +0800
Message-Id: <1364298930-4507-7-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
References: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The check has been done just before starting/joining a transaction,
so we don't need to check it again.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e123d5c..6fb67df 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -927,9 +927,6 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	btrfs_free_qgroup_config(fs_info);
 	spin_unlock(&fs_info->qgroup_lock);
 
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = btrfs_clean_quota_tree(trans, quota_root);
 	if (ret)
 		goto out;
@@ -965,9 +962,6 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = add_qgroup_relation_item(trans, quota_root, src, dst);
 	if (ret)
 		return ret;
@@ -993,9 +987,6 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 	int err;
 
 	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = del_qgroup_relation_item(trans, quota_root, src, dst);
 	err = del_qgroup_relation_item(trans, quota_root, dst, src);
 	if (err && !ret)
@@ -1017,9 +1008,6 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = add_qgroup_item(trans, quota_root, qgroupid);
 
 	spin_lock(&fs_info->qgroup_lock);
@@ -1040,8 +1028,6 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
 
 	/* check if there are no relations to this qgroup */
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
@@ -1068,9 +1054,6 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
 
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = update_qgroup_limit_item(trans, quota_root, qgroupid,
 				       limit->flags, limit->max_rfer,
 				       limit->max_excl, limit->rsv_rfer,
@@ -1394,9 +1377,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	if (!fs_info->quota_enabled)
 		return 0;
 
-	if (!quota_root)
-		return -EINVAL;
-
 	/*
 	 * create a tracking group for the subvol itself
 	 */
-- 
1.7.7.6

