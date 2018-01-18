Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60098 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756437AbeARN7p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 08:59:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0IDunEa127618
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:45 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2fjvfr848y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0IDxigm005075
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:44 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0IDxiZU016497
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:44 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: make btrfs_free_stale_devices() to match the path
Date: Thu, 18 Jan 2018 22:00:37 +0800
Message-Id: <20180118140037.25158-7-anand.jain@oracle.com>
In-Reply-To: <20180118140037.25158-1-anand.jain@oracle.com>
References: <20180118140037.25158-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

The btrfs_free_stale_devices() is updated to match for the given
device path and delete it. (It searches for only unmounted list of
devices.) Also drop the comment about different path being used
for the same device, since now we will have cli to clean any
device that's not a concern any more.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a3edd4d92c57..68674da7f5fc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -605,8 +605,17 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
-
-static void btrfs_free_stale_devices(struct btrfs_device *skip_dev)
+/*
+ * btrfs_free_stale_devices()
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

