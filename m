Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756215AbeAROBi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:01:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0IE1cnF131609
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 14:01:38 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2fjvfr84jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 14:01:38 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0IE1bK8015291
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 14:01:38 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0IE1b2g017933
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 14:01:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: set the total_devices in device_list_add()
Date: Thu, 18 Jan 2018 22:02:34 +0800
Message-Id: <20180118140236.25349-3-anand.jain@oracle.com>
In-Reply-To: <20180118140236.25349-1-anand.jain@oracle.com>
References: <20180118140236.25349-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no other parent for device_list_add() except for
btrfs_scan_one_device(), which would set btrfs_fs_devices::total_devices
if device_list_add is successful and this can be done with in
device_list_add() itself.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0b145276ff46..66e5dada2d74 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -843,6 +843,8 @@ static noinline int device_list_add(const char *path,
 	if (!fs_devices->opened)
 		device->generation = found_transid;
 
+	fs_devices->total_devices = btrfs_super_num_devices(disk_super);
+
 	*fs_devices_ret = fs_devices;
 
 	return 0;
@@ -1184,7 +1186,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct page *page;
 	int ret;
 	u64 devid;
-	u64 total_devices;
 	u64 bytenr;
 
 	/*
@@ -1206,12 +1207,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
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

