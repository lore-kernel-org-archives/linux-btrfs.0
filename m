Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35528 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751584AbeDCSgj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:36:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D5BC9ABC9
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Apr 2018 18:36:37 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/16] btrfs: move btrfs_init_dev_replace_tgtdev to dev-replace.c and make static
Date: Tue,  3 Apr 2018 20:34:10 +0200
Message-Id: <fa1f12d13fa8ee4625c111ec0ccea87679dd0b92.1522780026.git.dsterba@suse.com>
In-Reply-To: <cover.1522780026.git.dsterba@suse.com>
References: <cover.1522780026.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function logically belongs there and there's only a single caller,
no need to export it. No code changes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     | 99 --------------------------------------------------
 fs/btrfs/volumes.h     |  4 --
 3 files changed, 99 insertions(+), 103 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e3b8a79c1665..7a87ffad041e 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -188,6 +188,105 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * Initialize a new device for device replace target from a given source dev
+ * and path.
+ *
+ * Return 0 and new device in @device_out, otherwise return < 0
+ */
+static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
+				  const char *device_path,
+				  struct btrfs_device *srcdev,
+				  struct btrfs_device **device_out)
+{
+	struct btrfs_device *device;
+	struct block_device *bdev;
+	struct list_head *devices;
+	struct rcu_string *name;
+	u64 devid = BTRFS_DEV_REPLACE_DEVID;
+	int ret = 0;
+
+	*device_out = NULL;
+	if (fs_info->fs_devices->seeding) {
+		btrfs_err(fs_info, "the filesystem is a seed filesystem!");
+		return -EINVAL;
+	}
+
+	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
+				  fs_info->bdev_holder);
+	if (IS_ERR(bdev)) {
+		btrfs_err(fs_info, "target device %s is invalid!", device_path);
+		return PTR_ERR(bdev);
+	}
+
+	filemap_write_and_wait(bdev->bd_inode->i_mapping);
+
+	devices = &fs_info->fs_devices->devices;
+	list_for_each_entry(device, devices, dev_list) {
+		if (device->bdev == bdev) {
+			btrfs_err(fs_info,
+				  "target device is in the filesystem!");
+			ret = -EEXIST;
+			goto error;
+		}
+	}
+
+
+	if (i_size_read(bdev->bd_inode) <
+	    btrfs_device_get_total_bytes(srcdev)) {
+		btrfs_err(fs_info,
+			  "target device is smaller than source device!");
+		ret = -EINVAL;
+		goto error;
+	}
+
+
+	device = btrfs_alloc_device(NULL, &devid, NULL);
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
+		goto error;
+	}
+
+	name = rcu_string_strdup(device_path, GFP_KERNEL);
+	if (!name) {
+		btrfs_free_device(device);
+		ret = -ENOMEM;
+		goto error;
+	}
+	rcu_assign_pointer(device->name, name);
+
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
+	device->generation = 0;
+	device->io_width = fs_info->sectorsize;
+	device->io_align = fs_info->sectorsize;
+	device->sector_size = fs_info->sectorsize;
+	device->total_bytes = btrfs_device_get_total_bytes(srcdev);
+	device->disk_total_bytes = btrfs_device_get_disk_total_bytes(srcdev);
+	device->bytes_used = btrfs_device_get_bytes_used(srcdev);
+	device->commit_total_bytes = srcdev->commit_total_bytes;
+	device->commit_bytes_used = device->bytes_used;
+	device->fs_info = fs_info;
+	device->bdev = bdev;
+	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
+	set_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
+	device->mode = FMODE_EXCL;
+	device->dev_stats_valid = 1;
+	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
+	device->fs_devices = fs_info->fs_devices;
+	list_add(&device->dev_list, &fs_info->fs_devices->devices);
+	fs_info->fs_devices->num_devices++;
+	fs_info->fs_devices->open_devices++;
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+
+	*device_out = device;
+	return 0;
+
+error:
+	blkdev_put(bdev, FMODE_EXCL);
+	return ret;
+}
+
 /*
  * called from commit_transaction. Writes changed device replace state to
  * disk.
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ca5521cc1a5b..df2d6d06e014 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2592,105 +2592,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	return ret;
 }
 
-/*
- * Initialize a new device for device replace target from a given source dev
- * and path.
- *
- * Return 0 and new device in @device_out, otherwise return < 0
- */
-int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
-				  const char *device_path,
-				  struct btrfs_device *srcdev,
-				  struct btrfs_device **device_out)
-{
-	struct btrfs_device *device;
-	struct block_device *bdev;
-	struct list_head *devices;
-	struct rcu_string *name;
-	u64 devid = BTRFS_DEV_REPLACE_DEVID;
-	int ret = 0;
-
-	*device_out = NULL;
-	if (fs_info->fs_devices->seeding) {
-		btrfs_err(fs_info, "the filesystem is a seed filesystem!");
-		return -EINVAL;
-	}
-
-	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
-				  fs_info->bdev_holder);
-	if (IS_ERR(bdev)) {
-		btrfs_err(fs_info, "target device %s is invalid!", device_path);
-		return PTR_ERR(bdev);
-	}
-
-	filemap_write_and_wait(bdev->bd_inode->i_mapping);
-
-	devices = &fs_info->fs_devices->devices;
-	list_for_each_entry(device, devices, dev_list) {
-		if (device->bdev == bdev) {
-			btrfs_err(fs_info,
-				  "target device is in the filesystem!");
-			ret = -EEXIST;
-			goto error;
-		}
-	}
-
-
-	if (i_size_read(bdev->bd_inode) <
-	    btrfs_device_get_total_bytes(srcdev)) {
-		btrfs_err(fs_info,
-			  "target device is smaller than source device!");
-		ret = -EINVAL;
-		goto error;
-	}
-
-
-	device = btrfs_alloc_device(NULL, &devid, NULL);
-	if (IS_ERR(device)) {
-		ret = PTR_ERR(device);
-		goto error;
-	}
-
-	name = rcu_string_strdup(device_path, GFP_KERNEL);
-	if (!name) {
-		btrfs_free_device(device);
-		ret = -ENOMEM;
-		goto error;
-	}
-	rcu_assign_pointer(device->name, name);
-
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
-	device->generation = 0;
-	device->io_width = fs_info->sectorsize;
-	device->io_align = fs_info->sectorsize;
-	device->sector_size = fs_info->sectorsize;
-	device->total_bytes = btrfs_device_get_total_bytes(srcdev);
-	device->disk_total_bytes = btrfs_device_get_disk_total_bytes(srcdev);
-	device->bytes_used = btrfs_device_get_bytes_used(srcdev);
-	device->commit_total_bytes = srcdev->commit_total_bytes;
-	device->commit_bytes_used = device->bytes_used;
-	device->fs_info = fs_info;
-	device->bdev = bdev;
-	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
-	set_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
-	device->mode = FMODE_EXCL;
-	device->dev_stats_valid = 1;
-	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
-	device->fs_devices = fs_info->fs_devices;
-	list_add(&device->dev_list, &fs_info->fs_devices->devices);
-	fs_info->fs_devices->num_devices++;
-	fs_info->fs_devices->open_devices++;
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-
-	*device_out = device;
-	return 0;
-
-error:
-	blkdev_put(bdev, FMODE_EXCL);
-	return ret;
-}
-
 static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
 					struct btrfs_device *device)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 45e3ece21290..681be2dc0c6a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -445,10 +445,6 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
-int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
-				  const char *device_path,
-				  struct btrfs_device *srcdev,
-				  struct btrfs_device **device_out);
 int btrfs_balance(struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
 int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
-- 
2.16.2

