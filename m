Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45452 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754092AbeDBDiw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Apr 2018 23:38:52 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 6644648AE782
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Apr 2018 11:38:48 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Let function find_device to be consistent with kernel
Date: Mon, 2 Apr 2018 11:30:12 +0800
Message-ID: <1522639812-28309-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make find_device to be consistent with kernel according
35c70103a528 ("btrfs: refactor find_device helper")

And, modify the compare condition from both devid and uuid to
devid or devid and uuid according
8f18cf13396c ("Btrfs: Make the resizer work based on shrinking and growing devices")

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 volumes.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/volumes.c b/volumes.c
index edad367b..1320b55b 100644
--- a/volumes.c
+++ b/volumes.c
@@ -54,14 +54,22 @@ static inline int nr_data_stripes(struct map_lookup *map)
 
 static LIST_HEAD(fs_uuids);
 
-static struct btrfs_device *__find_device(struct list_head *head, u64 devid,
-					  u8 *uuid)
+/*
+ * Find a device specified by @devid or @uuid in the list of @fs_devices, or
+ * return NULL.
+ *
+ * If devid and uuid are both specified, the match must be exact, otherwise
+ * only devid is used.
+ */
+static struct btrfs_device *find_device(struct btrfs_fs_devices *fs_devices,
+		u64 devid, u8 *uuid)
 {
+	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *dev;
 
 	list_for_each_entry(dev, head, dev_list) {
 		if (dev->devid == devid &&
-		    !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE)) {
+		    (!uuid || !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE))) {
 			return dev;
 		}
 	}
@@ -100,7 +108,7 @@ static int device_list_add(const char *path,
 		fs_devices->lowest_devid = (u64)-1;
 		device = NULL;
 	} else {
-		device = __find_device(&fs_devices->devices, devid,
+		device = find_device(fs_devices, devid,
 				       disk_super->dev_item.uuid);
 	}
 	if (!device) {
@@ -1616,8 +1624,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 		if (!fsid ||
 		    (!memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE) ||
 		     fs_info->ignore_fsid_mismatch)) {
-			device = __find_device(&cur_devices->devices,
-					       devid, uuid);
+			device = find_device(cur_devices, devid, uuid);
 			if (device)
 				return device;
 		}
-- 
2.14.3



