Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53612 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755977AbdLPCsZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 21:48:25 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBG2lxNq190377
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Dec 2017 02:48:25 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2evthq013j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Dec 2017 02:48:24 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBG2mNHO023779
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Dec 2017 02:48:23 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBG2mNlS018150
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Dec 2017 02:48:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 6/6] btrfs: cleanup to make btrfs_free_stale_device() readable
Date: Sat, 16 Dec 2017 10:48:57 +0800
Message-Id: <20171216024857.14334-1-anand.jain@oracle.com>
In-Reply-To: <20171215034739.26090-7-anand.jain@oracle.com>
References: <20171215034739.26090-7-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
index 0bf3233859b6..6d3353ce50d8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -607,8 +607,17 @@ static void pending_bios_fn(struct btrfs_work *work)
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
@@ -622,20 +631,13 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev, char *path)
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
@@ -784,7 +786,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-		btrfs_free_stale_device(device, NULL);
+		btrfs_free_stale_device(path, device);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
-- 
2.7.0

