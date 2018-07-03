Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43748 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753718AbeGCFLp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 01:11:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6354pWA051032
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:11:44 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2jwyccq2jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2018 05:11:44 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w635Bhba005745
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:11:43 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w635BhTi027327
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:11:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: declare fs_devices in btrfs_init_new_device()
Date: Tue,  3 Jul 2018 13:14:50 +0800
Message-Id: <20180703051451.3673-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are many instances of the %fs_info->fs_devices pointer
de-reference, so declare a %fs_devices pointer instead.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 18cd73703951..f7fa0ea26e9c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2409,12 +2409,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	struct list_head *devices;
 	struct super_block *sb = fs_info->sb;
 	struct rcu_string *name;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u64 tmp;
 	int seeding_dev = 0;
 	int ret = 0;
 	bool unlocked = false;
 
-	if (sb_rdonly(sb) && !fs_info->fs_devices->seeding)
+	if (sb_rdonly(sb) && !fs_devices->seeding)
 		return -EROFS;
 
 	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
@@ -2422,7 +2423,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	if (fs_info->fs_devices->seeding) {
+	if (fs_devices->seeding) {
 		seeding_dev = 1;
 		down_write(&sb->s_umount);
 		mutex_lock(&uuid_mutex);
@@ -2430,18 +2431,18 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	filemap_write_and_wait(bdev->bd_inode->i_mapping);
 
-	devices = &fs_info->fs_devices->devices;
+	devices = &fs_devices->devices;
 
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry(device, devices, dev_list) {
 		if (device->bdev == bdev) {
 			ret = -EEXIST;
 			mutex_unlock(
-				&fs_info->fs_devices->device_list_mutex);
+				&fs_devices->device_list_mutex);
 			goto error;
 		}
 	}
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 
 	device = btrfs_alloc_device(fs_info, NULL, NULL);
 	if (IS_ERR(device)) {
@@ -2490,23 +2491,22 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		}
 	}
 
-	device->fs_devices = fs_info->fs_devices;
+	device->fs_devices = fs_devices;
 
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
-	list_add_rcu(&device->dev_list, &fs_info->fs_devices->devices);
-	list_add(&device->dev_alloc_list,
-		 &fs_info->fs_devices->alloc_list);
-	fs_info->fs_devices->num_devices++;
-	fs_info->fs_devices->open_devices++;
-	fs_info->fs_devices->rw_devices++;
-	fs_info->fs_devices->total_devices++;
-	fs_info->fs_devices->total_rw_bytes += device->total_bytes;
+	list_add_rcu(&device->dev_list, &fs_devices->devices);
+	list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
+	fs_devices->num_devices++;
+	fs_devices->open_devices++;
+	fs_devices->rw_devices++;
+	fs_devices->total_devices++;
+	fs_devices->total_rw_bytes += device->total_bytes;
 
 	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
 
 	if (!blk_queue_nonrot(q))
-		fs_info->fs_devices->rotating = 1;
+		fs_devices->rotating = 1;
 
 	tmp = btrfs_super_total_bytes(fs_info->super_copy);
 	btrfs_set_super_total_bytes(fs_info->super_copy,
@@ -2516,7 +2516,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_set_super_num_devices(fs_info->super_copy, tmp + 1);
 
 	/* add sysfs device entry */
-	btrfs_sysfs_add_device_link(fs_info->fs_devices, device);
+	btrfs_sysfs_add_device_link(fs_devices, device);
 
 	/*
 	 * we've got more storage, clear any full flags on the space
@@ -2525,7 +2525,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_clear_space_info_full(fs_info);
 
 	mutex_unlock(&fs_info->chunk_mutex);
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
 		mutex_lock(&fs_info->chunk_mutex);
@@ -2557,7 +2557,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		 */
 		snprintf(fsid_buf, BTRFS_UUID_UNPARSED_SIZE, "%pU",
 						fs_info->fsid);
-		if (kobject_rename(&fs_info->fs_devices->fsid_kobj, fsid_buf))
+		if (kobject_rename(&fs_devices->fsid_kobj, fsid_buf))
 			btrfs_warn(fs_info,
 				   "sysfs: failed to create fsid for sprout");
 	}
@@ -2592,7 +2592,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	return ret;
 
 error_sysfs:
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
+	btrfs_sysfs_rm_device_link(fs_devices, device);
 error_trans:
 	if (seeding_dev)
 		sb->s_flags |= SB_RDONLY;
-- 
2.15.0

