Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968263AbeE3Gzr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:55:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4U6oujl044803
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:46 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2j9ev810q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:46 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6tkkK004033
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:46 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6tj7g019375
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:46 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: do btrfs_free_stale_devices() outside of device_list_add()
Date: Wed, 30 May 2018 14:58:16 +0800
Message-Id: <20180530065821.28385-2-anand.jain@oracle.com>
In-Reply-To: <20180530065821.28385-1-anand.jain@oracle.com>
References: <20180530065821.28385-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_stale_devices() looks for device path reused for another
fsid, and deletes the older fs_devices::device entry.

In preparation to handle proper locks in the device_list_add(),
move the btrfs_free_stale_devices() outside of the device_list_add()
as these two functions has two distinct purpose.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0a47b4162d12..4edba7c5c050 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -750,7 +750,8 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
  * error pointer when failed
  */
 static noinline struct btrfs_device *device_list_add(const char *path,
-			   struct btrfs_super_block *disk_super)
+			   struct btrfs_super_block *disk_super,
+			   bool *new_device_added)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
@@ -796,7 +797,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		mutex_unlock(&fs_devices->device_list_mutex);
 
 		device->fs_devices = fs_devices;
-		btrfs_free_stale_devices(path, device);
+		*new_device_added = true;
 
 		if (disk_super->label[0])
 			pr_info("BTRFS: device label %s devid %llu transid %llu %s\n",
@@ -1223,6 +1224,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret)
 {
 	struct btrfs_super_block *disk_super;
+	bool new_device_added = false;
 	struct btrfs_device *device;
 	struct block_device *bdev;
 	struct page *page;
@@ -1248,11 +1250,14 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	}
 
 	mutex_lock(&uuid_mutex);
-	device = device_list_add(path, disk_super);
-	if (IS_ERR(device))
+	device = device_list_add(path, disk_super, &new_device_added);
+	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
-	else
+	} else {
 		*fs_devices_ret = device->fs_devices;
+		if (new_device_added)
+			btrfs_free_stale_devices(path, device);
+	}
 	mutex_unlock(&uuid_mutex);
 
 	btrfs_release_disk_super(page);
-- 
2.7.0

