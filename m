Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34179 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbdLOL2a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 06:28:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBFBST4s111252
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 11:28:29 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2evd2g0452-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 11:28:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBFBSSWs024599
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 11:28:28 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBFBSSge014520
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 11:28:28 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/6] btrfs: cleanup to make btrfs_free_stale_device() readable
Date: Fri, 15 Dec 2017 19:29:01 +0800
Message-Id: <20171215112901.13264-1-anand.jain@oracle.com>
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
v2: btrfs_device::name is null when we have missing device and
    unmounted. So we still need to check for dev->name.

 fs/btrfs/volumes.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0bf3233859b6..9f3a59f26e84 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -607,8 +607,7 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
-
-static void btrfs_free_stale_device(struct btrfs_device *cur_dev, char *path)
+static void btrfs_free_stale_device(const char *path, struct btrfs_device *skip_dev)
 {
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
@@ -622,20 +621,13 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev, char *path)
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
@@ -784,7 +776,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-		btrfs_free_stale_device(device, NULL);
+		btrfs_free_stale_device(path, device);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
-- 
2.7.0

