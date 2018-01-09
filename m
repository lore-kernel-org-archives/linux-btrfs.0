Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54602 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbeAIPNf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 10:13:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09FBvEu007189
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 15:13:33 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2fcyub0969-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 15:13:33 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09EjgGc014932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:42 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09EjfXW012122
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] btrfs: move uuid_mutex closer to exclusivity
Date: Tue,  9 Jan 2018 22:46:25 +0800
Message-Id: <20180109144625.28381-6-anand.jain@oracle.com>
In-Reply-To: <20180109144625.28381-1-anand.jain@oracle.com>
References: <20180109144625.28381-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

move uuid_mutex with in device_list_add().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f942e8193862..283417bf3b00 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -740,6 +740,7 @@ static noinline int device_list_add(const char *path,
 	u64 found_transid = btrfs_super_generation(disk_super);
 	u64 devid = btrfs_stack_device_id(&disk_super->dev_item);
 
+	mutex_lock(&uuid_mutex);
 	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
 		fs_devices = alloc_fs_devices(disk_super->fsid);
@@ -847,6 +848,8 @@ static noinline int device_list_add(const char *path,
 
 	fs_devices->total_devices = btrfs_super_num_devices(disk_super);
 
+	mutex_unlock(&uuid_mutex);
+
 	*device_ret = device;
 
 	return 0;
@@ -1208,9 +1211,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		goto error_bdev_put;
 	}
 
-	mutex_lock(&uuid_mutex);
 	ret = device_list_add(path, disk_super, &device);
-	mutex_unlock(&uuid_mutex);
 
 	*fs_devices_ret = device->fs_devices;
 
-- 
2.7.0

