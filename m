Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32632 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbbGTJ42 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 05:56:28 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6K9scAZ021539
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2015 17:54:38 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: Show detail information when mount failed on missing devices
Date: Mon, 20 Jul 2015 17:54:50 +0800
Message-ID: <afa8fe22bb5c6e18046b6a950cea399d31ab5407.1437386077.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

When mount failed because missing device, we can see following
dmesg:
 [ 1060.267743] BTRFS: too many missing devices, writeable mount is not allowed
 [ 1060.273158] BTRFS: open_ctree failed

This patch add missing_device_number and tolerated_missing_device_number
to above output, to let user know what really happened, and helps
bug-report and debug.

dmesg after patch:
 [  127.050367] BTRFS: missing devices(1) exceeds the limit(0), writeable mount is not allowed
 [  127.056099] BTRFS: open_ctree failed

Changelog v1->v2:
1: Changed to more clear description, suggested-by:
   Anand Jain <anand.jain@oracle.com>

Suggested-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2eda03b..5b44e02 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2950,8 +2950,9 @@ retry_root_backup:
 	if (fs_info->fs_devices->missing_devices >
 	     fs_info->num_tolerated_disk_barrier_failures &&
 	    !(sb->s_flags & MS_RDONLY)) {
-		printk(KERN_WARNING "BTRFS: "
-			"too many missing devices, writeable mount is not allowed\n");
+		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
+			fs_info->fs_devices->missing_devices,
+			fs_info->num_tolerated_disk_barrier_failures);
 		goto fail_sysfs;
 	}
 
-- 
1.8.5.1

