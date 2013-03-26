Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36524 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3CZLzk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 07:55:40 -0400
Received: by mail-pd0-f179.google.com with SMTP id x11so90206pdj.24
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 04:55:39 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH 3/7] Btrfs: add a necessary check before creating/destroying a qgroup
Date: Tue, 26 Mar 2013 19:55:26 +0800
Message-Id: <1364298930-4507-3-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
References: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch try to add a check before creating/destroying a qgroup.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3c4fde0..8a01326 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3784,6 +3784,42 @@ drop_write:
 	return ret;
 }
 
+static int may_qgroup_create(struct btrfs_root *root,
+			     struct btrfs_ioctl_qgroup_create_args *sa)
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
+	key.offset = sa->qgroupid;
+
+	ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
+				&key, path, 0, 0);
+	if (sa->create) {
+		if (!ret)
+			ret = -EEXIST;
+		if (ret > 0)
+			ret = 0;
+		goto out;
+	}
+	if (ret > 0)
+		ret = -ENOENT;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
@@ -3810,13 +3846,16 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto out;
 	}
 	mutex_lock(&root->fs_info->quota_lock);
+	ret = may_qgroup_create(root, sa);
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
-- 
1.7.7.6

