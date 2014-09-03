Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13195 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755983AbaICNeJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:09 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DY3Cd006642
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:03 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/18] Btrfs: fix unprotected assignment of the target device
Date: Wed, 3 Sep 2014 21:35:32 +0800
Message-ID: <1409751347-5296-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We didn't protect the assignment of the target device, it might cause the
problem that the super block update was skipped because we might find wrong
size of the target device during the assignment. Fix it by moving the
assignment sentences into the initialization function of the target device.
And there is another merit that we can check if the target device is suitable
more early.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 32 ++++++++------------------------
 fs/btrfs/volumes.c     | 23 +++++++++++++++++++----
 fs/btrfs/volumes.h     |  1 +
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 10dfb41..72dc02e 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -330,29 +330,19 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 		return -EINVAL;
 
 	mutex_lock(&fs_info->volume_mutex);
-	ret = btrfs_init_dev_replace_tgtdev(root, args->start.tgtdev_name,
-					    &tgt_device);
-	if (ret) {
-		btrfs_err(fs_info, "target device %s is invalid!",
-		       args->start.tgtdev_name);
-		mutex_unlock(&fs_info->volume_mutex);
-		return -EINVAL;
-	}
-
 	ret = btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
 					    args->start.srcdev_name,
 					    &src_device);
-	mutex_unlock(&fs_info->volume_mutex);
 	if (ret) {
-		ret = -EINVAL;
-		goto leave_no_lock;
+		mutex_unlock(&fs_info->volume_mutex);
+		return ret;
 	}
 
-	if (tgt_device->total_bytes < src_device->total_bytes) {
-		btrfs_err(fs_info, "target device is smaller than source device!");
-		ret = -EINVAL;
-		goto leave_no_lock;
-	}
+	ret = btrfs_init_dev_replace_tgtdev(root, args->start.tgtdev_name,
+					    src_device, &tgt_device);
+	mutex_unlock(&fs_info->volume_mutex);
+	if (ret)
+		return ret;
 
 	btrfs_dev_replace_lock(dev_replace);
 	switch (dev_replace->replace_state) {
@@ -380,10 +370,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 		      src_device->devid,
 		      rcu_str_deref(tgt_device->name));
 
-	tgt_device->total_bytes = src_device->total_bytes;
-	tgt_device->disk_total_bytes = src_device->disk_total_bytes;
-	tgt_device->bytes_used = src_device->bytes_used;
-
 	/*
 	 * from now on, the writes to the srcdev are all duplicated to
 	 * go to the tgtdev as well (refer to btrfs_map_block()).
@@ -426,9 +412,7 @@ leave:
 	dev_replace->srcdev = NULL;
 	dev_replace->tgtdev = NULL;
 	btrfs_dev_replace_unlock(dev_replace);
-leave_no_lock:
-	if (tgt_device)
-		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
+	btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 483fc6d..1646659 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2295,6 +2295,7 @@ error:
 }
 
 int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
+				  struct btrfs_device *srcdev,
 				  struct btrfs_device **device_out)
 {
 	struct request_queue *q;
@@ -2307,24 +2308,37 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 	int ret = 0;
 
 	*device_out = NULL;
-	if (fs_info->fs_devices->seeding)
+	if (fs_info->fs_devices->seeding) {
+		btrfs_err(fs_info, "the filesystem is a seed filesystem!");
 		return -EINVAL;
+	}
 
 	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
 				  fs_info->bdev_holder);
-	if (IS_ERR(bdev))
+	if (IS_ERR(bdev)) {
+		btrfs_err(fs_info, "target device %s is invalid!", device_path);
 		return PTR_ERR(bdev);
+	}
 
 	filemap_write_and_wait(bdev->bd_inode->i_mapping);
 
 	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
 		if (device->bdev == bdev) {
+			btrfs_err(fs_info, "target device is in the filesystem!");
 			ret = -EEXIST;
 			goto error;
 		}
 	}
 
+
+	if (i_size_read(bdev->bd_inode) < srcdev->total_bytes) {
+		btrfs_err(fs_info, "target device is smaller than source device!");
+		ret = -EINVAL;
+		goto error;
+	}
+
+
 	device = btrfs_alloc_device(NULL, &devid, NULL);
 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
@@ -2348,8 +2362,9 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 	device->io_width = root->sectorsize;
 	device->io_align = root->sectorsize;
 	device->sector_size = root->sectorsize;
-	device->total_bytes = i_size_read(bdev->bd_inode);
-	device->disk_total_bytes = device->total_bytes;
+	device->total_bytes = srcdev->total_bytes;
+	device->disk_total_bytes = srcdev->disk_total_bytes;
+	device->bytes_used = srcdev->bytes_used;
 	device->dev_root = fs_info->dev_root;
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 37f8bff..e15f288 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -322,6 +322,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
+				  struct btrfs_device *srcdev,
 				  struct btrfs_device **device_out);
 int btrfs_balance(struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
-- 
1.9.3

