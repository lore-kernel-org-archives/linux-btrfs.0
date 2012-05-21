Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20425 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab2EUCYR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 22:24:17 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4L2OENB032420
	for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2012 10:24:15 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2 v2] Btrfs: do not resize a seeding device
Date: Mon, 21 May 2012 10:28:38 +0800
Message-Id: <1337567319-1657-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seeding devices are not supposed to change any more.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
v1->v2: use EINVAL instead, suggested by David Sterba

 fs/btrfs/ioctl.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f056469..ec2245d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1303,6 +1303,13 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		ret = -EINVAL;
 		goto out_free;
 	}
+	if (device->fs_devices && device->fs_devices->seeding) {
+		printk(KERN_INFO "btrfs: resizer unable to apply on "
+		       "seeding device %s\n", device->name);
+		ret = -EINVAL;
+		goto out_free;
+	}
+
 	if (!strcmp(sizestr, "max"))
 		new_size = device->bdev->bd_inode->i_size;
 	else {
-- 
1.6.5.2

