Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53513 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3C1Kyz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 06:54:55 -0400
Received: by mail-pd0-f179.google.com with SMTP id x11so1121560pdj.10
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 03:54:55 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH V2 3/6] Btrfs: fix missing check before updating qgroup limit
Date: Thu, 28 Mar 2013 18:54:44 +0800
Message-Id: <1364468087-1702-2-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1364468055-1669-1-git-send-email-wangshilong1991@gmail.com>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

We should check whether a qgroup exists before updating qgroup limit,
if the relative qgroup dosen't exsit, return -EEXIST and do not join
a transaction, fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h  |    1 +
 fs/btrfs/ioctl.c  |   18 ++++++++++--------
 fs/btrfs/qgroup.c |   15 ++++++++++++---
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a11a8ed..3fc393d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3094,6 +3094,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
+int btrfs_may_limit_qgroup(struct btrfs_root *root, u64 qgroupid);
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e2950f1..7c72b12 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3859,20 +3859,22 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		ret = PTR_ERR(sa);
 		goto drop_write;
 	}
-	mutex_lock(&root->fs_info->quota_lock);
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		goto out;
-	}
-
 	qgroupid = sa->qgroupid;
 	if (!qgroupid) {
 		/* take the current subvol as qgroup */
 		qgroupid = root->root_key.objectid;
 	}
 
-	/* FIXME: check if the IDs really exist */
+	mutex_lock(&root->fs_info->quota_lock);
+	ret = btrfs_may_limit_qgroup(root, qgroupid);
+	if (ret)
+		goto out;
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 	ret = btrfs_limit_qgroup(trans, root->fs_info, qgroupid, &sa->lim);
 
 	err = btrfs_end_transaction(trans, root);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7df372a..bed0e22 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1059,9 +1059,6 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
 
-	if (!quota_root)
-		return -EINVAL;
-
 	ret = update_qgroup_limit_item(trans, quota_root, qgroupid,
 				       limit->flags, limit->max_rfer,
 				       limit->max_excl, limit->rsv_rfer,
@@ -1665,3 +1662,15 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 		trans->delayed_ref_elem.seq);
 	BUG();
 }
+
+int btrfs_may_limit_qgroup(struct btrfs_root *root, u64 qgroupid)
+{
+	struct btrfs_qgroup *qgroup = NULL;
+
+	if (!root->fs_info->quota_root)
+		return -EINVAL;
+	qgroup = find_qgroup_rb(root->fs_info, qgroupid);
+	if (!qgroup)
+		return -ENOENT;
+	return 0;
+}
-- 
1.7.7.6

