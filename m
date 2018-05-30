Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935905AbeE3Gzv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:55:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4U6p9nA099194
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:51 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2j9ev8904c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:51 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6todB011380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:50 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4U6toiK002761
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: btrfs_free_stale_devices() rename local variables
Date: Wed, 30 May 2018 14:58:19 +0800
Message-Id: <20180530065821.28385-5-anand.jain@oracle.com>
In-Reply-To: <20180530065821.28385-1-anand.jain@oracle.com>
References: <20180530065821.28385-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Over the years we named %fs_devices and %devices to represent,
the struct btrfs_fs_devices and the struct btrfs_device. So
follow the same norm here too. No functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e3dd25238eb9..fd656eb75225 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -635,43 +635,44 @@ static void pending_bios_fn(struct btrfs_work *work)
  *		devices.
  */
 static void btrfs_free_stale_devices(const char *path,
-				     struct btrfs_device *skip_dev)
+				     struct btrfs_device *skip_device)
 {
-	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
-	struct btrfs_device *dev, *tmp_dev;
+	struct btrfs_fs_devices *fs_devices, *tmp_fs_devices;
+	struct btrfs_device *device, *tmp_device;
 
-	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, fs_list) {
+	list_for_each_entry_safe(fs_devices, tmp_fs_devices, &fs_uuids,
+				 fs_list) {
 
-		if (fs_devs->opened)
+		if (fs_devices->opened)
 			continue;
 
-		list_for_each_entry_safe(dev, tmp_dev,
-					 &fs_devs->devices, dev_list) {
+		list_for_each_entry_safe(device, tmp_device,
+					 &fs_devices->devices, dev_list) {
 			int not_found = 0;
 
-			if (skip_dev && skip_dev == dev)
+			if (skip_device && skip_device == device)
 				continue;
-			if (path && !dev->name)
+			if (path && !device->name)
 				continue;
 
 			rcu_read_lock();
 			if (path)
-				not_found = strcmp(rcu_str_deref(dev->name),
+				not_found = strcmp(rcu_str_deref(device->name),
 						   path);
 			rcu_read_unlock();
 			if (not_found)
 				continue;
 
 			/* delete the stale device */
-			if (fs_devs->num_devices == 1) {
-				btrfs_sysfs_remove_fsid(fs_devs);
-				list_del(&fs_devs->fs_list);
-				free_fs_devices(fs_devs);
+			if (fs_devices->num_devices == 1) {
+				btrfs_sysfs_remove_fsid(fs_devices);
+				list_del(&fs_devices->fs_list);
+				free_fs_devices(fs_devices);
 				break;
 			} else {
-				fs_devs->num_devices--;
-				list_del(&dev->dev_list);
-				btrfs_free_device(dev);
+				fs_devices->num_devices--;
+				list_del(&device->dev_list);
+				btrfs_free_device(device);
 			}
 		}
 	}
-- 
2.7.0

