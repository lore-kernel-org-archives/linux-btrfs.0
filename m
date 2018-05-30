Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48086 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968491AbeE3Gzt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:55:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4U6p0kQ167651
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:48 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2j9ev890g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:48 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6tlHO004092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:47 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6tlIB019383
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:47 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: fix device_list_add() missing device_list_mutex()
Date: Wed, 30 May 2018 14:58:17 +0800
Message-Id: <20180530065821.28385-3-anand.jain@oracle.com>
In-Reply-To: <20180530065821.28385-1-anand.jain@oracle.com>
References: <20180530065821.28385-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the device is added or if the device pointer is retrieved
for writing, make sure that device_list_mutex is held. Also
make sure it is held when we check fs_devices::opened and
fs_devices::total_devices is updated.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4edba7c5c050..0fdb9b717398 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -765,21 +765,26 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		if (IS_ERR(fs_devices))
 			return ERR_CAST(fs_devices);
 
+		mutex_lock(&fs_devices->device_list_mutex);
 		list_add(&fs_devices->fs_list, &fs_uuids);
 
 		device = NULL;
 	} else {
+		mutex_lock(&fs_devices->device_list_mutex);
 		device = find_device(fs_devices, devid,
 				disk_super->dev_item.uuid);
 	}
 
 	if (!device) {
-		if (fs_devices->opened)
+		if (fs_devices->opened) {
+			mutex_unlock(&fs_devices->device_list_mutex);
 			return ERR_PTR(-EBUSY);
+		}
 
 		device = btrfs_alloc_device(NULL, &devid,
 					    disk_super->dev_item.uuid);
 		if (IS_ERR(device)) {
+			mutex_unlock(&fs_devices->device_list_mutex);
 			/* we can safely leave the fs_devices entry around */
 			return device;
 		}
@@ -787,14 +792,13 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name) {
 			btrfs_free_device(device);
+			mutex_unlock(&fs_devices->device_list_mutex);
 			return ERR_PTR(-ENOMEM);
 		}
 		rcu_assign_pointer(device->name, name);
 
-		mutex_lock(&fs_devices->device_list_mutex);
 		list_add_rcu(&device->dev_list, &fs_devices->devices);
 		fs_devices->num_devices++;
-		mutex_unlock(&fs_devices->device_list_mutex);
 
 		device->fs_devices = fs_devices;
 		*new_device_added = true;
@@ -841,12 +845,15 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 			 * with larger generation number or the last-in if
 			 * generation are equal.
 			 */
+			mutex_unlock(&fs_devices->device_list_mutex);
 			return ERR_PTR(-EEXIST);
 		}
 
 		name = rcu_string_strdup(path, GFP_NOFS);
-		if (!name)
+		if (!name) {
+			mutex_unlock(&fs_devices->device_list_mutex);
 			return ERR_PTR(-ENOMEM);
+		}
 		rcu_string_free(device->name);
 		rcu_assign_pointer(device->name, name);
 		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
@@ -866,6 +873,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 
 	fs_devices->total_devices = btrfs_super_num_devices(disk_super);
 
+	mutex_unlock(&fs_devices->device_list_mutex);
 	return device;
 }
 
-- 
2.7.0

