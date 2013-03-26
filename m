Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:59926 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab3CZLzi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 07:55:38 -0400
Received: by mail-da0-f53.google.com with SMTP id n34so2517593dal.26
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 04:55:37 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH 2/7] Btrfs: add a necessary check before updating qgroup limit
Date: Tue, 26 Mar 2013 19:55:25 +0800
Message-Id: <1364298930-4507-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
References: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Add a necessary check before updating qgroup limit,
if the relative qgroup dosen't exsit, do not join transaction.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b8ab81..3c4fde0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3837,6 +3837,33 @@ drop_write:
 	return ret;
 }
 
+static int may_qgroup_limit(struct btrfs_root *root, u64 qgroupid)
+{
+	int ret = 0;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+
+	if (!root->fs_info->quota_root)
+		return -EINVAL;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		return ret;
+	}
+
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_INFO_KEY;
+	key.offset = qgroupid;
+
+	ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
+				&key, path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
+	btrfs_free_path(path);
+	return ret;
+}
+
 static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
@@ -3859,19 +3886,21 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 	mutex_lock(&root->fs_info->quota_lock);
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
+	ret = may_qgroup_limit(root, qgroupid);
+	if (ret)
+		goto out;
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 
-	/* FIXME: check if the IDs really exist */
 	ret = btrfs_limit_qgroup(trans, root->fs_info, qgroupid, &sa->lim);
 
 	err = btrfs_end_transaction(trans, root);
-- 
1.7.7.6

