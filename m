Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58192 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932588AbaLBMiO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 07:38:14 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB2Cble8001486
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Dec 2014 20:37:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v4 10/10] Btrfs, replace: enable dev-replace for raid56
Date: Tue, 2 Dec 2014 20:39:31 +0800
Message-ID: <1417523971-15553-11-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1417523971-15553-1-git-send-email-miaox@cn.fujitsu.com>
References: <1417523971-15553-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- None.
---
 fs/btrfs/dev-replace.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 326919b..51133ea 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -316,11 +316,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	struct btrfs_device *tgt_device = NULL;
 	struct btrfs_device *src_device = NULL;
 
-	if (btrfs_fs_incompat(fs_info, RAID56)) {
-		btrfs_warn(fs_info, "dev_replace cannot yet handle RAID5/RAID6");
-		return -EOPNOTSUPP;
-	}
-
 	switch (args->start.cont_reading_from_srcdev_mode) {
 	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS:
 	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID:
-- 
1.9.3

