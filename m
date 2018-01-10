Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32860 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932791AbeAJBtA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 20:49:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A1l1YE063004
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 01:49:00 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2fd84kg6ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 01:48:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0A1mxtQ016340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 01:48:59 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0A1mwZl021953
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 01:48:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: drop devid as device_list_add() arg
Date: Wed, 10 Jan 2018 09:49:50 +0800
Message-Id: <20180110014950.9138-5-anand.jain@oracle.com>
In-Reply-To: <20180110014950.9138-1-anand.jain@oracle.com>
References: <20180110014950.9138-1-anand.jain@oracle.com>
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
index d74d01971d0c..bd2e8616755e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -731,12 +731,13 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
  * < 0 - error
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
@@ -1184,7 +1185,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct block_device *bdev;
 	struct page *page;
 	int ret = 0;
-	u64 devid;
 	u64 bytenr;
 
 	/*
@@ -1205,10 +1205,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
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

