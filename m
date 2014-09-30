Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54728 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbaI3WAt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 18:00:49 -0400
Received: by mail-pd0-f178.google.com with SMTP id y10so5383591pdj.9
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 15:00:48 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
Subject: [PATCH v2 2/3] btrfs: fix sparse address space warnings
Date: Tue, 30 Sep 2014 15:01:41 -0700
Message-Id: <49ca3ccf1c2fd2091c6fbec1d14e393b95b0fff8.1412114127.git.osandov@osandov.com>
In-Reply-To: <cover.1412114127.git.osandov@osandov.com>
References: <cover.1412114127.git.osandov@osandov.com>
In-Reply-To: <cover.1412114127.git.osandov@osandov.com>
References: <cover.1412114127.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several casts of ioctl fields from userspace are missing the __user annotation.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8a8e298..0f9a5a1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2176,7 +2176,7 @@ static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
 
 	inode = file_inode(file);
 	ret = search_ioctl(inode, &args.key, &buf_size,
-			   (char *)(&uarg->buf[0]));
+			   (char __user *)(&uarg->buf[0]));
 	if (ret == 0 && copy_to_user(&uarg->key, &args.key, sizeof(args.key)))
 		ret = -EFAULT;
 	else if (ret == -EOVERFLOW &&
@@ -4247,7 +4247,7 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
-	ret = copy_to_user((void *)(unsigned long)ipa->fspath,
+	ret = copy_to_user((void __user *)(unsigned long)ipa->fspath,
 			   (void *)(unsigned long)ipath->fspath, size);
 	if (ret) {
 		ret = -EFAULT;
@@ -4322,7 +4322,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 	if (ret < 0)
 		goto out;
 
-	ret = copy_to_user((void *)(unsigned long)loi->inodes,
+	ret = copy_to_user((void __user *)(unsigned long)loi->inodes,
 			   (void *)(unsigned long)inodes, size);
 	if (ret)
 		ret = -EFAULT;
-- 
2.1.1

