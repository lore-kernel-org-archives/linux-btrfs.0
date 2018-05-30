Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937114AbeE3Gzx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:55:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4U6ovVv031695
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:52 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2j9ev890fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6tq5E004279
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:52 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6tpVE024089
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: fix btrfs_free_stale_devices() with needed locks
Date: Wed, 30 May 2018 14:58:20 +0800
Message-Id: <20180530065821.28385-6-anand.jain@oracle.com>
In-Reply-To: <20180530065821.28385-1-anand.jain@oracle.com>
References: <20180530065821.28385-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_stale_devices() finds the stale (not opened) matching
device path in the fs_uuid list. We are already under uuid_mutex
so when we check for each fs_devices, hold the respective
device_list_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fd656eb75225..a6a23b0185e5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -643,8 +643,11 @@ static void btrfs_free_stale_devices(const char *path,
 	list_for_each_entry_safe(fs_devices, tmp_fs_devices, &fs_uuids,
 				 fs_list) {
 
-		if (fs_devices->opened)
+		mutex_lock(&fs_devices->device_list_mutex);
+		if (fs_devices->opened) {
+			mutex_unlock(&fs_devices->device_list_mutex);
 			continue;
+		}
 
 		list_for_each_entry_safe(device, tmp_device,
 					 &fs_devices->devices, dev_list) {
@@ -664,16 +667,18 @@ static void btrfs_free_stale_devices(const char *path,
 				continue;
 
 			/* delete the stale device */
-			if (fs_devices->num_devices == 1) {
-				btrfs_sysfs_remove_fsid(fs_devices);
-				list_del(&fs_devices->fs_list);
-				free_fs_devices(fs_devices);
+			fs_devices->num_devices--;
+			list_del(&device->dev_list);
+			btrfs_free_device(device);
+
+			if (fs_devices->num_devices == 0)
 				break;
-			} else {
-				fs_devices->num_devices--;
-				list_del(&device->dev_list);
-				btrfs_free_device(device);
-			}
+		}
+		mutex_unlock(&fs_devices->device_list_mutex);
+		if (fs_devices->num_devices == 0) {
+			btrfs_sysfs_remove_fsid(fs_devices);
+			list_del(&fs_devices->fs_list);
+			free_fs_devices(fs_devices);
 		}
 	}
 }
-- 
2.7.0

