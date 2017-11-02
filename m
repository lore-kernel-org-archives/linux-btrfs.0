Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17125 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933888AbdKBB4l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 21:56:41 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA21uePL016756
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA21udAX025355
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:39 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA21udSV030047
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs: change how we set In_sync
Date: Wed,  1 Nov 2017 18:54:05 -0600
Message-Id: <20171102005405.20420-5-bo.li.liu@oracle.com>
In-Reply-To: <20171102005405.20420-1-bo.li.liu@oracle.com>
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current method sometimes can report In_sync status wrongly if the
out-of-sync device happens to be the first one we check, and since it
will be the only one, it'll be set In_sync, but later if a newer
device is found, we then change it to !In_sync, but it's not reported
in kernel log.

This changes it to set In_sync flag after iterating all devices, at
this point we have the latest device so we can report out-of-sync
device precisely.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b83b7c8..43f03a6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1010,26 +1010,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			device->generation =
 				btrfs_stack_device_generation(&disk_super->dev_item);
 
-		/* no lock is required during the initial stage. */
-		if (!latest_dev) {
-			set_bit(In_sync, &device->flags);
-			latest_dev = device;
-		} else {
-			if (device->generation > latest_dev->generation) {
-				set_bit(In_sync, &device->flags);
-				clear_bit(In_sync, &latest_dev->flags);
-				latest_dev = device;
-			} else if (device->generation == latest_dev->generation) {
-				set_bit(In_sync, &device->flags);
-			}
-			/*
-			 * if (device->generation < latest_dev->generation)
-			 *	# don't set In_sync
-			 */
-		}
-
-		if (!test_bit(In_sync, &device->flags))
-			pr_info("dev %s gen %llu is not In_sync\n", device->name->str, device->generation);
+		if (!latest_dev ||
+                    device->generation > latest_dev->generation)
+                        latest_dev = device;
 
 		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
 			device->writeable = 0;
@@ -1063,6 +1046,21 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		blkdev_put(bdev, flags);
 		continue;
 	}
+
+	/* set In_sync flag */
+	list_for_each_entry(device, head, dev_list) {
+		ASSERT(device->generation <= latest_dev->generation);
+		if (device->generation == latest_dev->generation) {
+			set_bit(In_sync, &device->flags);
+			pr_debug("btrfs: dev %s gen %llu is In_sync\n",
+				 device->name->str, device->generation);
+		} else {
+			clear_bit(In_sync, &device->flags);
+			pr_info("btrfs: dev %s gen %llu is not In_sync\n",
+				device->name->str, device->generation);
+		}
+	}
+
 	if (fs_devices->open_devices == 0) {
 		ret = -EINVAL;
 		goto out;
-- 
2.9.4

