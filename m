Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:32954 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753389AbdHWGqT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 02:46:19 -0400
Received: by mail-pg0-f48.google.com with SMTP id t3so4072703pgt.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 23:46:19 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 7/7] Btrfs: fix __user casting in ioctl.c
Date: Tue, 22 Aug 2017 23:46:05 -0700
Message-Id: <a59180cb6452c0813ce7d3a86f85a8abcd74d78c.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cf71d0304671..7a7a82e0963c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2210,7 +2210,7 @@ static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
 
 	inode = file_inode(file);
 	ret = search_ioctl(inode, &args.key, &buf_size,
-			   (char *)(&uarg->buf[0]));
+			   (char __user *)(&uarg->buf[0]));
 	if (ret == 0 && copy_to_user(&uarg->key, &args.key, sizeof(args.key)))
 		ret = -EFAULT;
 	else if (ret == -EOVERFLOW &&
@@ -4512,8 +4512,8 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
-	ret = copy_to_user((void *)(unsigned long)ipa->fspath,
-			   (void *)(unsigned long)ipath->fspath, size);
+	ret = copy_to_user((void __user *)(unsigned long)ipa->fspath,
+			   ipath->fspath, size);
 	if (ret) {
 		ret = -EFAULT;
 		goto out;
@@ -4584,8 +4584,8 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	if (ret < 0)
 		goto out;
 
-	ret = copy_to_user((void *)(unsigned long)loi->inodes,
-			   (void *)(unsigned long)inodes, size);
+	ret = copy_to_user((void __user *)(unsigned long)loi->inodes, inodes,
+			   size);
 	if (ret)
 		ret = -EFAULT;
 
-- 
2.14.1

