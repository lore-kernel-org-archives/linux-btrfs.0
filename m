Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:51369 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3CZLzm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 07:55:42 -0400
Received: by mail-da0-f42.google.com with SMTP id n15so3648697dad.29
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 04:55:42 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH 4/7] Btrfs: add a necessary check before assigning/removing qgroup relations
Date: Tue, 26 Mar 2013 19:55:27 +0800
Message-Id: <1364298930-4507-4-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
References: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This is one of most important reason why we introduce a mutex here,
the previous code dosen't check 'src' and 'dst' before assigning/removing
a qgroup relations. Without the mutex lock, and checks may leads
a race conditon.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8a01326..1cd96f6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3735,6 +3735,82 @@ drop_write:
 	return ret;
 }
 
+static int may_qgroup_assign(struct btrfs_root *root,
+			     struct btrfs_ioctl_qgroup_assign_args *sa)
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
+	key.offset = sa->src;
+	ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
+				&key, path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		goto out;
+
+	btrfs_release_path(path);
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_INFO_KEY;
+	key.offset = sa->dst;
+	ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
+				&key, path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		goto out;
+
+	btrfs_release_path(path);
+	key.objectid = sa->src;
+	key.type = BTRFS_QGROUP_RELATION_KEY;
+	key.offset = sa->dst;
+	ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
+				&key, path, 0, 0);
+	if (sa->assign) {
+		if (!ret)
+			ret = -EEXIST;
+		if (ret < 0)
+			goto out;
+	} else {
+		if (ret > 0)
+			ret = -ENOENT;
+		if (ret < 0)
+			goto out;
+	}
+
+	btrfs_release_path(path);
+	key.objectid = sa->dst;
+	key.type = BTRFS_QGROUP_RELATION_KEY;
+	key.offset = sa->src;
+	if (sa->assign) {
+		if (!ret)
+			ret = -EEXIST;
+		if (ret < 0)
+			goto out;
+	} else {
+		if (ret > 0)
+			ret = -ENOENT;
+		if (ret < 0)
+			goto out;
+	}
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
@@ -3757,13 +3833,16 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	}
 
 	mutex_lock(&root->fs_info->quota_lock);
+	ret = may_qgroup_assign(root, sa);
+	if (ret)
+		goto out;
+
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
 	}
 
-	/* FIXME: check if the IDs really exist */
 	if (sa->assign) {
 		ret = btrfs_add_qgroup_relation(trans, root->fs_info,
 						sa->src, sa->dst);
-- 
1.7.7.6

