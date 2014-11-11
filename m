Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21810 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751334AbaKKGlF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 01:41:05 -0500
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v3] btrfs-progs: skip fs with no seed when build seed/sprout mapping for fi show
Date: Tue, 11 Nov 2014 14:39:14 +0800
Message-ID: <1415687954-12968-1-git-send-email-guihc.fnst@cn.fujitsu.com>
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
changlog
        v1->v2: adopt more natural function name:
		no_seed_devices ==> has_seed_devices
	v2->v3: skip such fs after copied, otherwise such fs won't be shown
---
 cmds-filesystem.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index e4b2785..97efdee 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -750,6 +750,22 @@ static int find_and_copy_seed(struct btrfs_fs_devices *seed,
 	return 1;
 }
 
+static int has_seed_devices(struct btrfs_fs_devices *fs_devices)
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
+	return dev_cnt_total != dev_cnt;
+}
+
 static int map_seed_devices(struct list_head *all_uuids,
 			    char *search, int *found)
 {
@@ -799,6 +815,11 @@ static int map_seed_devices(struct list_head *all_uuids,
 						struct btrfs_device, dev_list);
 		if (!device)
 			continue;
+
+		/* skip fs without seeds */
+		if (!has_seed_devices(cur_fs))
+			continue;
+
 		/*
 		 * open_ctree_* detects seed/sprout mapping
 		 */
@@ -956,8 +977,8 @@ devs_only:
 	}
 
 	/*
-	 * scan_for_btrfs() don't build seed/sprout mapping,
-	 * do mapping build for each scanned fs here
+	 * The seed/sprout mapping are not detected yet,
+	 * do mapping build for all umounted fs
 	 */
 	ret = map_seed_devices(&all_uuids, search, &found);
 	if (ret) {
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
