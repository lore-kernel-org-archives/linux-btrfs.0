Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62547 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751580AbbBFFrp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 00:47:45 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t165l0BO016596
	for <linux-btrfs@vger.kernel.org>; Fri, 6 Feb 2015 13:47:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v7 8/9] btrfs: Use sb_want_write() to protect label change.
Date: Fri, 6 Feb 2015 13:45:33 +0800
Message-ID: <1423201534-19309-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423201534-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423201534-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the new vfs API sb_want_write() to do the write protection of the
label change transaction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v4:
  Newly introduced.
v5:
  Change to use sb_want_write().
v6:
  Move sb_want_write() at the beginning of the function.
v7:
  None
---
 fs/btrfs/sysfs.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index b2e7bb4..7e548f7 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -25,6 +25,7 @@
 #include <linux/bug.h>
 #include <linux/genhd.h>
 #include <linux/debugfs.h>
+#include <linux/mount.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -377,8 +378,9 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	int ret;
 	size_t p_len;
 
-	if (fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
+	ret = sb_want_write(fs_info->sb);
+	if (ret)
+		return ret;
 
 	/*
 	 * p_len is the len until the first occurrence of either
@@ -386,12 +388,17 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	 */
 	p_len = strcspn(buf, "\n");
 
-	if (p_len >= BTRFS_LABEL_SIZE)
-		return -EINVAL;
+	if (p_len >= BTRFS_LABEL_SIZE) {
+		ret = -EINVAL;
+		goto out;
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
@@ -399,9 +406,10 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	spin_unlock(&root->fs_info->super_lock);
 	ret = btrfs_commit_transaction(trans, root);
 
+out:
+	sb_drop_write(fs_info->sb);
 	if (!ret)
 		return len;
-
 	return ret;
 }
 BTRFS_ATTR_RW(label, btrfs_label_show, btrfs_label_store);
-- 
2.2.2

