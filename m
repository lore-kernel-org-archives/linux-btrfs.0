Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab2FNIQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:02 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/10 RESEND] Btrfs: do not resize a seeding device
Date: Thu, 14 Jun 2012 16:23:19 +0800
Message-Id: <1339662206-5307-4-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seeding devices are not supposed to change any more.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 57380ee..5ff79fd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1295,6 +1295,13 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
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

