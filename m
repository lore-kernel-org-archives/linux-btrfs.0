Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53724 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932501AbeAIOuk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:50:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EnM7T172833
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:50:40 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fcyub00a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:50:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w09Ejc4I018841
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:39 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w09Ejcqb027775
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs: get device pointer from device_list_add()
Date: Tue,  9 Jan 2018 22:46:23 +0800
Message-Id: <20180109144625.28381-4-anand.jain@oracle.com>
In-Reply-To: <20180109144625.28381-1-anand.jain@oracle.com>
References: <20180109144625.28381-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of pointer to btrfs_fs_devices from device_list_add() its
better to get pointer to btrfs_device, then we have both, pointer
to btrfs_device and btrfs_fs_devices. This is needed in preparation
to add handling reappearing missing device feature.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f9aaf65e27f5..2317ca1b3d83 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -732,7 +732,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
  */
 static noinline int device_list_add(const char *path,
 			   struct btrfs_super_block *disk_super,
-			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
+			   u64 devid, struct btrfs_device **device_ret)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
@@ -846,7 +846,7 @@ static noinline int device_list_add(const char *path,
 
 	fs_devices->total_devices = btrfs_super_num_devices(disk_super);
 
-	*fs_devices_ret = fs_devices;
+	*device_ret = device;
 
 	return 0;
 }
@@ -1183,6 +1183,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret)
 {
 	struct btrfs_super_block *disk_super;
+	struct btrfs_device *device;
 	struct block_device *bdev;
 	struct page *page;
 	int ret;
@@ -1210,9 +1211,11 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 
 	mutex_lock(&uuid_mutex);
-	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
+	ret = device_list_add(path, disk_super, devid, &device);
 	mutex_unlock(&uuid_mutex);
 
+	*fs_devices_ret = device->fs_devices;
+
 	btrfs_release_disk_super(page);
 
 error_bdev_put:
-- 
2.7.0

