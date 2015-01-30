Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60688 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760128AbbA3JXN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 04:23:13 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0U9ML0C028864
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2015 17:22:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v5 8/9] btrfs: Use sb_want_write() to protect label change.
Date: Fri, 30 Jan 2015 17:20:53 +0800
Message-ID: <1422609654-19519-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
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
---
 fs/btrfs/sysfs.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index b2e7bb4..3218245 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -25,6 +25,7 @@
 #include <linux/bug.h>
 #include <linux/genhd.h>
 #include <linux/debugfs.h>
+#include <linux/mount.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -377,8 +378,6 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	int ret;
 	size_t p_len;
 
-	if (fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
 
 	/*
 	 * p_len is the len until the first occurrence of either
@@ -389,9 +388,15 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	if (p_len >= BTRFS_LABEL_SIZE)
 		return -EINVAL;
 
+	ret = sb_want_write(fs_info->sb);
+	if (ret)
+		return ret;
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
@@ -399,9 +404,10 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
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

