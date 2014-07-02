Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15712 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751897AbaGBJCL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 05:02:11 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s62928tq008608
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Jul 2014 17:02:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix wrong uevent target
Date: Wed, 2 Jul 2014 17:03:54 +0800
Message-ID: <1404291834-11113-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

block_device's bd_disk points to the disk, not the object which block_device
is actually corresponding to(the whole disk or a partition), so we would send
uevent to the wrong target. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 95828b0..e8b9214 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -123,7 +123,7 @@ static void btrfs_kobject_uevent(struct block_device *bdev,
 {
 	int ret;
 
-	ret = kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, action);
+	ret = kobject_uevent(&part_to_dev(bdev->bd_part)->kobj, action);
 	if (ret)
 		pr_warn("BTRFS: Sending event '%d' to kobject: '%s' (%p): failed\n",
 			action,
-- 
1.8.1.4

