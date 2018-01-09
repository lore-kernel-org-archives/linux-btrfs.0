Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932432AbeAIOui (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:50:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EnSh2169829
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:50:38 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2fcsj19s74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:50:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09EjbCW029631
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:37 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w09Ejbv2000741
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] btrfs: set the total_devices in device_list_add()
Date: Tue,  9 Jan 2018 22:46:22 +0800
Message-Id: <20180109144625.28381-3-anand.jain@oracle.com>
In-Reply-To: <20180109144625.28381-1-anand.jain@oracle.com>
References: <20180109144625.28381-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no other parent for device_list_add() except for
btrfs_scan_one_device(), which would set btrfs_fs_devices::total_devices
if device_list_add is successful and this can be done with in
device_list_add() itself.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 091eb452f3c8..f9aaf65e27f5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -844,6 +844,8 @@ static noinline int device_list_add(const char *path,
 	if (!fs_devices->opened)
 		device->generation = found_transid;
 
+	fs_devices->total_devices = btrfs_super_num_devices(disk_super);
+
 	*fs_devices_ret = fs_devices;
 
 	return 0;
@@ -1185,7 +1187,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct page *page;
 	int ret;
 	u64 devid;
-	u64 total_devices;
 	u64 bytenr;
 
 	/*
@@ -1207,12 +1208,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	}
 
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
-	total_devices = btrfs_super_num_devices(disk_super);
 
 	mutex_lock(&uuid_mutex);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
-	if (!ret && fs_devices_ret)
-		(*fs_devices_ret)->total_devices = total_devices;
 	mutex_unlock(&uuid_mutex);
 
 	btrfs_release_disk_super(page);
-- 
2.7.0

