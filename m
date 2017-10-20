Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51984 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751633AbdJTOH3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 10:07:29 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9KE7SAs003036
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 14:07:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9KE7Rk7001319
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 14:07:28 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9KE7RQa004984
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 14:07:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: match btrfs_device->mode same as it used for open
Date: Fri, 20 Oct 2017 22:07:15 +0800
Message-Id: <20171020140715.3110-1-anand.jain@oracle.com>
In-Reply-To: <20171020103325.9595-1-anand.jain@oracle.com>
References: <20171020103325.9595-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We aren't setting the FMODE_WRITE when initializing btrfs_device
structure and when calling blkdev_put, however we are setting it
only when calling blkdev_get_by_path().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Reword commit log.

 fs/btrfs/volumes.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b39737568c22..765c2bd2d8d9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2323,12 +2323,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	u64 tmp;
 	int seeding_dev = 0;
 	int ret = 0;
+	fmode_t flag = FMODE_WRITE | FMODE_EXCL;
 
 	if (sb_rdonly(sb) && !fs_info->fs_devices->seeding)
 		return -EROFS;
 
-	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
-				  fs_info->bdev_holder);
+	bdev = blkdev_get_by_path(device_path, flag, fs_info->bdev_holder);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
@@ -2392,7 +2392,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
 	device->is_tgtdev_for_dev_replace = 0;
-	device->mode = FMODE_EXCL;
+	device->mode = flag;
 	device->dev_stats_valid = 1;
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 
@@ -2506,7 +2506,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 	kfree(device);
 error:
-	blkdev_put(bdev, FMODE_EXCL);
+	blkdev_put(bdev, flag);
 	if (seeding_dev) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
@@ -2526,6 +2526,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	struct rcu_string *name;
 	u64 devid = BTRFS_DEV_REPLACE_DEVID;
 	int ret = 0;
+	fmode_t flags = FMODE_WRITE | FMODE_EXCL;
 
 	*device_out = NULL;
 	if (fs_info->fs_devices->seeding) {
@@ -2533,8 +2534,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
-	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
-				  fs_info->bdev_holder);
+	bdev = blkdev_get_by_path(device_path, flags, fs_info->bdev_holder);
 	if (IS_ERR(bdev)) {
 		btrfs_err(fs_info, "target device %s is invalid!", device_path);
 		return PTR_ERR(bdev);
@@ -2595,7 +2595,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
 	device->is_tgtdev_for_dev_replace = 1;
-	device->mode = FMODE_EXCL;
+	device->mode = flags;
 	device->dev_stats_valid = 1;
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_info->fs_devices;
@@ -2608,7 +2608,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	return ret;
 
 error:
-	blkdev_put(bdev, FMODE_EXCL);
+	blkdev_put(bdev, flags);
 	return ret;
 }
 
-- 
2.13.1

