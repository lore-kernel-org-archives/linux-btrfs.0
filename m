Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab2KZIrj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:47:39 -0500
Message-ID: <50B32CC1.6010001@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:48:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 7/9] Btrfs: get write access for scrub
References: <50B32ABF.7040803@cn.fujitsu.com>
In-Reply-To: <50B32ABF.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need get write access for scrub, or we will modify the R/O fs.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5921bb9..a7afafa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3103,10 +3103,11 @@ static noinline long btrfs_ioctl_wait_sync(struct btrfs_root *root,
 	return btrfs_wait_for_commit(root, transid);
 }
 
-static long btrfs_ioctl_scrub(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 {
-	int ret;
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_scrub_args *sa;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3115,12 +3116,21 @@ static long btrfs_ioctl_scrub(struct btrfs_root *root, void __user *arg)
 	if (IS_ERR(sa))
 		return PTR_ERR(sa);
 
+	if (!(sa->flags & BTRFS_SCRUB_READONLY)) {
+		ret = mnt_want_write_file(file);
+		if (ret)
+			goto out;
+	}
+
 	ret = btrfs_scrub_dev(root, sa->devid, sa->start, sa->end,
 			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY);
 
 	if (copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
 
+	if (!(sa->flags & BTRFS_SCRUB_READONLY))
+		mnt_drop_write_file(file);
+out:
 	kfree(sa);
 	return ret;
 }
@@ -3802,7 +3812,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_WAIT_SYNC:
 		return btrfs_ioctl_wait_sync(root, argp);
 	case BTRFS_IOC_SCRUB:
-		return btrfs_ioctl_scrub(root, argp);
+		return btrfs_ioctl_scrub(file, argp);
 	case BTRFS_IOC_SCRUB_CANCEL:
 		return btrfs_ioctl_scrub_cancel(root, argp);
 	case BTRFS_IOC_SCRUB_PROGRESS:
-- 
1.7.11.7

