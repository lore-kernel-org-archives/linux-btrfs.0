Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60064 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756387AbeARN7m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 08:59:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0IDugNm127565
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:42 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fjvfr848v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:41 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0IDxfQ3015216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:41 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0IDxe5B021408
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: make btrfs_free_stale_device() to iterate all stales
Date: Thu, 18 Jan 2018 22:00:34 +0800
Message-Id: <20180118140037.25158-4-anand.jain@oracle.com>
In-Reply-To: <20180118140037.25158-1-anand.jain@oracle.com>
References: <20180118140037.25158-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Let the list iterator iterate further and find other stale
devices and delete it. This is in preparation to add support
for user land request-able stale devices cleanup. Also rename
btrfs_free_stale_device() to btrfs_free_stale_devices().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3f481da9cae7..cd234a5dc763 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -606,21 +606,22 @@ static void pending_bios_fn(struct btrfs_work *work)
 }
 
 
-static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
+static void btrfs_free_stale_devices(struct btrfs_device *cur_dev)
 {
-	struct btrfs_fs_devices *fs_devs;
-	struct btrfs_device *dev;
+	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
+	struct btrfs_device *dev, *tmp_dev;
 
 	if (!cur_dev->name)
 		return;
 
-	list_for_each_entry(fs_devs, &fs_uuids, list) {
-		int del = 1;
+	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
 
 		if (fs_devs->opened)
 			continue;
 
-		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+		list_for_each_entry_safe(dev, tmp_dev,
+					 &fs_devs->devices, dev_list) {
+			int not_found;
 
 			if (dev == cur_dev)
 				continue;
@@ -634,14 +635,12 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			 * either use mapper or non mapper path throughout.
 			 */
 			rcu_read_lock();
-			del = strcmp(rcu_str_deref(dev->name),
+			not_found = strcmp(rcu_str_deref(dev->name),
 						rcu_str_deref(cur_dev->name));
 			rcu_read_unlock();
-			if (!del)
-				break;
-		}
+			if (not_found)
+				continue;
 
-		if (!del) {
 			/* delete the stale device */
 			if (fs_devs->num_devices == 1) {
 				btrfs_sysfs_remove_fsid(fs_devs);
@@ -652,7 +651,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 				list_del(&dev->dev_list);
 				free_device(dev);
 			}
-			break;
 		}
 	}
 }
@@ -780,7 +778,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-		btrfs_free_stale_device(device);
+		btrfs_free_stale_devices(device);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
-- 
2.7.0

