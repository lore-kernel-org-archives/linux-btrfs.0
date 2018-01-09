Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56598 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757414AbeAIONK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:13:10 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09ED5PK144158
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:13:10 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fcpfyt346-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:13:07 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w09ECZGv017089
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:36 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09ECZ9Q023086
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:35 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: cleanup to make btrfs_free_stale_device() readable
Date: Tue,  9 Jan 2018 22:13:14 +0800
Message-Id: <20180109141314.23795-7-anand.jain@oracle.com>
In-Reply-To: <20180109141314.23795-1-anand.jain@oracle.com>
References: <20180109141314.23795-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Now as the there is path in arg, so instead of reading the path from
cur_device just get it from the caller, and so the purpose of cur_device
is to skip the device, so rename it to skip_dev. Also drop the comment
about different path being used for the same device, since now we will
have cli to clean any device that's not a concern any more.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3: add btrfs_free_stale_device() fn description, as suggested by
    Nikolay
    Fix line with longer than 80 char
v2: btrfs_device::name is null when we have missing device and
    unmounted. So we still need to check for dev->name.

 fs/btrfs/volumes.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f87d30aa0e18..848824fe98a3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -605,8 +605,17 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
-
-static void btrfs_free_stale_device(struct btrfs_device *cur_dev, char *path)
+/*
+ * btrfs_free_stale_device()
+ *  Search and remove all stale (devices which are not mounted) devices.
+ *  When both inputs are NULL, it will search and release all stale devices.
+ *  path:	Optional. When provided will it release all unmounted devices
+ *  		matching this path only.
+ *  skip_dev:	Optional. Will skip this device when searching for the stale
+ *  		devices.
+ */
+static void btrfs_free_stale_device(const char *path,
+				    struct btrfs_device *skip_dev)
 {
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
@@ -620,20 +629,13 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev, char *path)
 				         &fs_devs->devices, dev_list) {
 			int not_found;
 
-			if (cur_dev && (cur_dev == dev || !dev->name))
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
-			if (cur_dev)
-				not_found = strcmp(rcu_str_deref(dev->name),
-						   rcu_str_deref(cur_dev->name));
-			else if (path)
+			if (path)
 				not_found = strcmp(rcu_str_deref(dev->name), path);
 			else
 				not_found = 0;
@@ -778,7 +780,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-		btrfs_free_stale_device(device, NULL);
+		btrfs_free_stale_device(path, device);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
-- 
2.7.0

