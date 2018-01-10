Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbeAJFRH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 00:17:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A5H6Fg010004
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:17:07 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2fd8bdrhek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:17:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5EZMd023135
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:35 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0A5EZZO011552
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:35 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: make btrfs_free_stale_device() to match the path
Date: Wed, 10 Jan 2018 13:15:23 +0800
Message-Id: <20180110051523.3681-7-anand.jain@oracle.com>
In-Reply-To: <20180110051523.3681-1-anand.jain@oracle.com>
References: <20180110051523.3681-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

The btrfs_free_stale_device() is updated to match for the given
device path and delete it. (It searches for only unmounted list of
devices.) Also drop the comment about different path being used
for the same device, since now we will have cli to clean any
device that's not a concern any more.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a3edd4d92c57..5adf2d3f949a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -605,8 +605,17 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
-
-static void btrfs_free_stale_devices(struct btrfs_device *skip_dev)
+/*
+ * btrfs_free_stale_device()
+ *  Search and remove all stale (devices which are not mounted) devices.
+ *  When both inputs are NULL, it will search and release all stale devices.
+ *  path:	Optional. When provided will it release all unmounted devices
+ *		matching this path only.
+ *  skip_dev:	Optional. Will skip this device when searching for the stale
+ *		devices.
+ */
+static void btrfs_free_stale_devices(const char *path,
+				     struct btrfs_device *skip_dev)
 {
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
@@ -620,19 +629,15 @@ static void btrfs_free_stale_devices(struct btrfs_device *skip_dev)
 					 &fs_devs->devices, dev_list) {
 			int not_found = 0;
 
-			if (skip_dev && (skip_dev == dev || !dev->name))
+			if (skip_dev && skip_dev == dev)
+				continue;
+			if (path && !dev->name)
 				continue;
 
-			/*
-			 * Todo: This won't be enough. What if the same device
-			 * comes back (with new uuid and) with its mapper path?
-			 * But for now, this does help as mostly an admin will
-			 * either use mapper or non mapper path throughout.
-			 */
 			rcu_read_lock();
-			if (skip_dev)
+			if (path)
 				not_found = strcmp(rcu_str_deref(dev->name),
-						   rcu_str_deref(skip_dev->name));
+						   path);
 			rcu_read_unlock();
 			if (not_found)
 				continue;
@@ -774,7 +779,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-		btrfs_free_stale_devices(device);
+		btrfs_free_stale_devices(path, device);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
-- 
2.7.0

