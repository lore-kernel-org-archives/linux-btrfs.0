Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4995 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab2LUJVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 04:21:00 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qBL9MgE4026624
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2012 17:22:42 +0800
Message-ID: <50D42A1A.6050502@cn.fujitsu.com>
Date: Fri, 21 Dec 2012 17:21:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs: fix trivial error in btrfs_ioctl_resize()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes the following problem:
- improper return value
- unnecessary read-only check

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 668475c..773865f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1326,9 +1326,6 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	int ret = 0;
 	int mod = 0;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -1361,6 +1358,10 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		*devstr = '\0';
 		devstr = vol_args->name;
 		devid = simple_strtoull(devstr, &end, 10);
+		if (!devid) {
+			ret = -EINVAL;
+			goto out_free;
+		}
 		printk(KERN_INFO "btrfs: resizing devid %llu\n",
 		       (unsigned long long)devid);
 	}
@@ -1369,7 +1370,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	if (!device) {
 		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
 		       (unsigned long long)devid);
-		ret = -EINVAL;
+		ret = -ENODEV;
 		goto out_free;
 	}
 
@@ -1377,7 +1378,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		printk(KERN_INFO "btrfs: resizer unable to apply on "
 		       "readonly device %llu\n",
 		       (unsigned long long)devid);
-		ret = -EINVAL;
+		ret = -EPERM;
 		goto out_free;
 	}
 
@@ -1399,7 +1400,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	}
 
 	if (device->is_tgtdev_for_dev_replace) {
-		ret = -EINVAL;
+		ret = -EPERM;
 		goto out_free;
 	}
 
-- 
1.7.11.7
