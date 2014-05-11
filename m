Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37186 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaEKPRM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 11:17:12 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Murphy <lists@colorremedies.com>
Subject: [PATCH] Btrfs: fix NULL pointer crash of deleting a seed device
Date: Sun, 11 May 2014 23:14:59 +0800
Message-Id: <1399821299-15131-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same as normal devices, seed devices should be initialized with
fs_info->dev_root as well, otherwise we'll get a NULL pointer crash.

Cc: Chris Murphy <lists@colorremedies.com>
Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49d7fab..bddf2bd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6058,10 +6058,14 @@ void btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
 
-	mutex_lock(&fs_devices->device_list_mutex);
-	list_for_each_entry(device, &fs_devices->devices, dev_list)
-		device->dev_root = fs_info->dev_root;
-	mutex_unlock(&fs_devices->device_list_mutex);
+	while (fs_devices) {
+		mutex_lock(&fs_devices->device_list_mutex);
+		list_for_each_entry(device, &fs_devices->devices, dev_list)
+			device->dev_root = fs_info->dev_root;
+		mutex_unlock(&fs_devices->device_list_mutex);
+
+		fs_devices = fs_devices->seed;
+	}
 }
 
 static void __btrfs_reset_dev_stats(struct btrfs_device *dev)
-- 
1.8.1.4

