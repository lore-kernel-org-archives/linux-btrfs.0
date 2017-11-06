Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17674 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdKFIgP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 03:36:15 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA68aEpX001886
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aD2f030946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:14 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA68aDj7005200
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/7] btrfs: optimize use of volume_mutex in btrfs_ioctl_resize()
Date: Mon,  6 Nov 2017 16:36:12 +0800
Message-Id: <20171106083618.7617-2-anand.jain@oracle.com>
In-Reply-To: <20171106083618.7617-1-anand.jain@oracle.com>
References: <20171106083618.7617-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can push volume_mutex lock further down after the memory operation.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 09c95f1b07dc..2eb220213d63 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1470,7 +1470,6 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 	}
 
-	mutex_lock(&fs_info->volume_mutex);
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -1495,12 +1494,13 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		btrfs_info(fs_info, "resizing devid %llu", devid);
 	}
 
+	mutex_lock(&fs_info->volume_mutex);
 	device = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!device) {
 		btrfs_info(fs_info, "resizer unable to find device %llu",
 			   devid);
 		ret = -ENODEV;
-		goto out_free;
+		goto out_mutex;
 	}
 
 	if (!device->writeable) {
@@ -1508,7 +1508,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			   "resizer unable to apply on readonly device %llu",
 		       devid);
 		ret = -EPERM;
-		goto out_free;
+		goto out_mutex;
 	}
 
 	if (!strcmp(sizestr, "max"))
@@ -1524,13 +1524,13 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		new_size = memparse(sizestr, &retptr);
 		if (*retptr != '\0' || new_size == 0) {
 			ret = -EINVAL;
-			goto out_free;
+			goto out_mutex;
 		}
 	}
 
 	if (device->is_tgtdev_for_dev_replace) {
 		ret = -EPERM;
-		goto out_free;
+		goto out_mutex;
 	}
 
 	old_size = btrfs_device_get_total_bytes(device);
@@ -1538,24 +1538,24 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	if (mod < 0) {
 		if (new_size > old_size) {
 			ret = -EINVAL;
-			goto out_free;
+			goto out_mutex;
 		}
 		new_size = old_size - new_size;
 	} else if (mod > 0) {
 		if (new_size > ULLONG_MAX - old_size) {
 			ret = -ERANGE;
-			goto out_free;
+			goto out_mutex;
 		}
 		new_size = old_size + new_size;
 	}
 
 	if (new_size < SZ_256M) {
 		ret = -EINVAL;
-		goto out_free;
+		goto out_mutex;
 	}
 	if (new_size > device->bdev->bd_inode->i_size) {
 		ret = -EFBIG;
-		goto out_free;
+		goto out_mutex;
 	}
 
 	new_size = round_down(new_size, fs_info->sectorsize);
@@ -1567,7 +1567,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
-			goto out_free;
+			goto out_mutex;
 		}
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans);
@@ -1575,10 +1575,11 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		ret = btrfs_shrink_device(device, new_size);
 	} /* equal, nothing need to do */
 
+out_mutex:
+	mutex_unlock(&fs_info->volume_mutex);
 out_free:
 	kfree(vol_args);
 out:
-	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	mnt_drop_write_file(file);
 	return ret;
-- 
2.13.1

