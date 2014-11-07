Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59987 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbaKGCJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 21:09:15 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sA7292Lb011247
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Nov 2014 10:09:02 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: skip fs with no seed when build seed/sprout mapping for fi show
Date: Fri, 7 Nov 2014 10:07:41 +0800
Message-ID: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no need to try to build seed/sprout mapping for those btrfs
without seed devices, so just skip such fs.
We could get the total number of devices from the disk super block, if it
equals the number of items in list @fs_devices->devices, then there shouldn't
be any seed devices.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 67fe52b..0d49cd1 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -795,6 +795,22 @@ out:
 	return ret;
 }
 
+static int no_seed_devices(struct btrfs_fs_devices *fs_devices)
+{
+	struct btrfs_device *device;
+	int dev_cnt_total, dev_cnt = 0;
+
+	device = list_first_entry(&fs_devices->devices, struct btrfs_device,
+				  dev_list);
+
+	dev_cnt_total = device->total_devs;
+
+	list_for_each_entry(device, &fs_devices->devices, dev_list)
+		dev_cnt++;
+
+	return dev_cnt_total == dev_cnt;
+}
+
 static int map_seed_devices(struct list_head *all_uuids)
 {
 	struct btrfs_fs_devices *cur_fs, *cur_seed;
@@ -812,6 +828,11 @@ static int map_seed_devices(struct list_head *all_uuids)
 						struct btrfs_device, dev_list);
 		if (!device)
 			continue;
+
+		/* skip fs without seeds */
+		if (no_seed_devices(cur_fs))
+			continue;
+
 		/*
 		 * open_ctree_* detects seed/sprout mapping
 		 */
@@ -976,8 +997,8 @@ devs_only:
 	}
 
 	/*
-	 * scan_for_btrfs() don't build seed/sprout mapping,
-	 * do mapping build for each scanned fs here
+	 * The seed/sprout mapping are not detected yet,
+	 * do mapping build for all umounted fs
 	 */
 	ret = map_seed_devices(&all_uuids);
 	if (ret) {
-- 
1.8.1.4

