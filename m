Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61879 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761830AbbA2C0A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 21:26:00 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0T2PIYB026370
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 10:25:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND v4 7/8] btrfs: Use mnt_want_write() to protect label change.
Date: Thu, 29 Jan 2015 10:24:40 +0800
Message-ID: <1422498281-20493-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the new vfs API get_vfsmount_sb() to get a vfsmount and use it to
do the write protection of the label change transaction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/sysfs.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index b2e7bb4..cdfa6b9 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -25,6 +25,7 @@
 #include <linux/bug.h>
 #include <linux/genhd.h>
 #include <linux/debugfs.h>
+#include <linux/mount.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -374,11 +375,10 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = fs_info->fs_root;
+	struct vfsmount *vfsmount;
 	int ret;
 	size_t p_len;
 
-	if (fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
 
 	/*
 	 * p_len is the len until the first occurrence of either
@@ -389,9 +389,21 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	if (p_len >= BTRFS_LABEL_SIZE)
 		return -EINVAL;
 
+	vfsmount = get_vfsmount_sb(fs_info->sb);
+	if (!vfsmount)
+		return -EINVAL;
+
+	ret = mnt_want_write(vfsmount);
+	if (ret) {
+		mntput(vfsmount);
+		return ret;
+	}
+
 	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 
 	spin_lock(&root->fs_info->super_lock);
 	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
@@ -399,9 +411,11 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	spin_unlock(&root->fs_info->super_lock);
 	ret = btrfs_commit_transaction(trans, root);
 
+out:
+	mnt_drop_write(vfsmount);
+	mntput(vfsmount);
 	if (!ret)
 		return len;
-
 	return ret;
 }
 BTRFS_ATTR_RW(label, btrfs_label_show, btrfs_label_store);
-- 
2.2.2

