Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41354 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbeAVNa6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 08:30:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0MDQjqC013796
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:57 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2fngrd83kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:57 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0MDUvSi001987
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:57 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0MDUvL8032163
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:57 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: drop devid as device_list_add() arg
Date: Mon, 22 Jan 2018 21:29:43 +0800
Message-Id: <20180122132943.14729-5-anand.jain@oracle.com>
In-Reply-To: <20180122132943.14729-1-anand.jain@oracle.com>
References: <20180122132943.14729-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As struct btrfs_disk_super is being passed, so it can get devid
the same way its parent does.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a86c3a14ec89..03f2685a5018 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -733,12 +733,13 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
  * error pointer when failed
  */
 static noinline struct btrfs_device *device_list_add(const char *path,
-			   struct btrfs_super_block *disk_super, u64 devid)
+			   struct btrfs_super_block *disk_super)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
 	struct rcu_string *name;
 	u64 found_transid = btrfs_super_generation(disk_super);
+	u64 devid = btrfs_stack_device_id(&disk_super->dev_item);
 
 	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
@@ -1186,7 +1187,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct block_device *bdev;
 	struct page *page;
 	int ret = 0;
-	u64 devid;
 	u64 bytenr;
 
 	/*
@@ -1207,10 +1207,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		goto error_bdev_put;
 	}
 
-	devid = btrfs_stack_device_id(&disk_super->dev_item);
-
 	mutex_lock(&uuid_mutex);
-	device = device_list_add(path, disk_super, devid);
+	device = device_list_add(path, disk_super);
 	mutex_unlock(&uuid_mutex);
 	if (IS_ERR(device))
 		ret = PTR_ERR(device);
-- 
2.7.0

