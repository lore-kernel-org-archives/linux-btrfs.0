Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758710AbeAIOtb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:49:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EnJ4I168815
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:49:30 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fcsj19rkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:49:23 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09Eje18014910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:40 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w09EjekV027786
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs: drop devid as device_list_add() arg
Date: Tue,  9 Jan 2018 22:46:24 +0800
Message-Id: <20180109144625.28381-5-anand.jain@oracle.com>
In-Reply-To: <20180109144625.28381-1-anand.jain@oracle.com>
References: <20180109144625.28381-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As struct btrfs_disk_super is being passed, so it can get devid
the same way its parent does.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2317ca1b3d83..f942e8193862 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -732,12 +732,13 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
  */
 static noinline int device_list_add(const char *path,
 			   struct btrfs_super_block *disk_super,
-			   u64 devid, struct btrfs_device **device_ret)
+			   struct btrfs_device **device_ret)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
 	struct rcu_string *name;
 	u64 found_transid = btrfs_super_generation(disk_super);
+	u64 devid = btrfs_stack_device_id(&disk_super->dev_item);
 
 	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
@@ -1187,7 +1188,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct block_device *bdev;
 	struct page *page;
 	int ret;
-	u64 devid;
 	u64 bytenr;
 
 	/*
@@ -1208,10 +1208,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		goto error_bdev_put;
 	}
 
-	devid = btrfs_stack_device_id(&disk_super->dev_item);
-
 	mutex_lock(&uuid_mutex);
-	ret = device_list_add(path, disk_super, devid, &device);
+	ret = device_list_add(path, disk_super, &device);
 	mutex_unlock(&uuid_mutex);
 
 	*fs_devices_ret = device->fs_devices;
-- 
2.7.0

