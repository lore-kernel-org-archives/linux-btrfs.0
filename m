Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:56947 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3ATPWu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 10:22:50 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so1983381eaa.25
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 07:22:48 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH 5/5] Btrfs: reorder locks and sanity checks in btrfs_ioctl_defrag
Date: Sun, 20 Jan 2013 17:22:32 +0200
Message-Id: <1358695352-7140-6-git-send-email-idryomov@gmail.com>
In-Reply-To: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
References: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Operation-specific check (whether subvol is readonly or not) should go
after the mutual exclusiveness check.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9c079dd..f198d5d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2187,19 +2187,20 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	struct btrfs_ioctl_defrag_range_args *range;
 	int ret;
 
-	if (btrfs_root_readonly(root))
-		return -EROFS;
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
 
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
 		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		mnt_drop_write_file(file);
 		return -EINVAL;
 	}
-	ret = mnt_want_write_file(file);
-	if (ret) {
-		atomic_set(&root->fs_info->mutually_exclusive_operation_running,
-			   0);
-		return ret;
+
+	if (btrfs_root_readonly(root)) {
+		ret = -EROFS;
+		goto out;
 	}
 
 	switch (inode->i_mode & S_IFMT) {
@@ -2251,8 +2252,8 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 		ret = -EINVAL;
 	}
 out:
-	mnt_drop_write_file(file);
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
+	mnt_drop_write_file(file);
 	return ret;
 }
 
-- 
1.7.9.1

