Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61986 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab2LUJTX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 04:19:23 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qBL9L5ix026444
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2012 17:21:05 +0800
Message-ID: <50D429B7.2090404@cn.fujitsu.com>
Date: Fri, 21 Dec 2012 17:19:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs: fix resize a readonly device
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should not resize a readonly device, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 679b82c..668475c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1364,6 +1364,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		printk(KERN_INFO "btrfs: resizing devid %llu\n",
 		       (unsigned long long)devid);
 	}
+
 	device = btrfs_find_device(root->fs_info, devid, NULL, NULL);
 	if (!device) {
 		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
@@ -1371,9 +1372,10 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		ret = -EINVAL;
 		goto out_free;
 	}
-	if (device->fs_devices && device->fs_devices->seeding) {
+
+	if (!device->writeable) {
 		printk(KERN_INFO "btrfs: resizer unable to apply on "
-		       "seeding device %llu\n",
+		       "readonly device %llu\n",
 		       (unsigned long long)devid);
 		ret = -EINVAL;
 		goto out_free;
-- 
1.7.11.7
