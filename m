Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45030 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753019AbeAJWwv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 17:52:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0AMqPQ9155505
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 22:52:51 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2fdtjurcdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 22:52:51 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0AMqo9I028680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 22:52:50 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0AMqoYQ014533
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 22:52:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: drop devid as device_list_add() arg
Date: Thu, 11 Jan 2018 06:53:37 +0800
Message-Id: <20180110225337.5877-5-anand.jain@oracle.com>
In-Reply-To: <20180110225337.5877-1-anand.jain@oracle.com>
References: <20180110225337.5877-1-anand.jain@oracle.com>
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
index d93ee0b91ad9..e947e47f8fff 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -730,12 +730,13 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
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
@@ -1183,7 +1184,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct block_device *bdev;
 	struct page *page;
 	int ret = 0;
-	u64 devid;
 	u64 bytenr;
 
 	/*
@@ -1204,10 +1204,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
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

