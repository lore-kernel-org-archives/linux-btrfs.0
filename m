Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3724 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727594AbeGPJmL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 05:42:11 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>
Subject: [PATCH v5 2/2] btrfs: get device pointer from btrfs_scan_one_device
Date: Mon, 16 Jul 2018 17:11:17 +0800
Message-ID: <1531732277-23517-2-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1531733656-23806-1-git-send-email-gujx@cn.fujitsu.com>

Instead of pointer to btrfs_fs_devices as an arg in
btrfs_scan_one_device, better to make it as a return value.

And since btrfs_fs_devices can be get by btrfs_device,
better to return btrfs_device than fs_btrfs_devices.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---

Changelog:
v5: rebase to misc-next.
v4: as suggested by Anand, change return value of
    btrfs_scan_one_device from btrfs_fs_devices to btrfs_device.
v3: as comment by robot, use PTR_ERR_OR_ZERO, and rebase to misc-next.
v2: as comment by Nikolay, use ERR_CAST instead of cast type manually.

 fs/btrfs/super.c   | 35 ++++++++++++++++++++++-------------
 fs/btrfs/volumes.c | 22 ++++++++--------------
 fs/btrfs/volumes.h |  4 ++--
 3 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index dcab4a0244e5..413bbe2d6db2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -888,7 +888,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
-	struct btrfs_fs_devices *fs_devices = NULL;
+	struct btrfs_device *device = NULL;
 	int error = 0;
 
 	lockdep_assert_held(&uuid_mutex);
@@ -918,11 +918,13 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 				error = -ENOMEM;
 				goto out;
 			}
-			error = btrfs_scan_one_device(device_name, flags,
-							holder, &fs_devices);
+			device = btrfs_scan_one_device(device_name, flags,
+							holder);
 			kfree(device_name);
-			if (error)
+			if (IS_ERR(device)) {
+				error = PTR_ERR(device);
 				goto out;
+			}
 		}
 	}
 
@@ -1518,6 +1520,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 {
 	struct block_device *bdev = NULL;
 	struct super_block *s;
+	struct btrfs_device *device = NULL;
 	struct btrfs_fs_devices *fs_devices = NULL;
 	struct btrfs_fs_info *fs_info = NULL;
 	struct security_mnt_opts new_sec_opts;
@@ -1561,12 +1564,15 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 		goto error_fs_info;
 	}
 
-	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
-	if (error) {
+	device = btrfs_scan_one_device(device_name, mode, fs_type);
+	if (IS_ERR(device)) {
+		error = PTR_ERR(device);
 		mutex_unlock(&uuid_mutex);
 		goto error_fs_info;
 	}
 
+	fs_devices = device->fs_devices;
+
 	fs_info->fs_devices = fs_devices;
 
 	error = btrfs_open_devices(fs_devices, mode, fs_type);
@@ -2227,7 +2233,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	struct btrfs_ioctl_vol_args *vol;
-	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device = NULL;
 	int ret = -ENOTTY;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2240,19 +2246,22 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
 		mutex_lock(&uuid_mutex);
-		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
-					    &btrfs_root_fs_type, &fs_devices);
+		device = btrfs_scan_one_device(vol->name, FMODE_READ,
+					    &btrfs_root_fs_type);
+		ret = PTR_ERR_OR_ZERO(device);
 		mutex_unlock(&uuid_mutex);
 		break;
 	case BTRFS_IOC_DEVICES_READY:
 		mutex_lock(&uuid_mutex);
-		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
-					    &btrfs_root_fs_type, &fs_devices);
-		if (ret) {
+		device = btrfs_scan_one_device(vol->name, FMODE_READ,
+					    &btrfs_root_fs_type);
+		if (IS_ERR(device)) {
+			ret = PTR_ERR(device);
 			mutex_unlock(&uuid_mutex);
 			break;
 		}
-		ret = !(fs_devices->num_devices == fs_devices->total_devices);
+		ret = !(device->fs_devices->num_devices ==
+				device->fs_devices->total_devices);
 		mutex_unlock(&uuid_mutex);
 		break;
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 88d37bfa99c8..9f485696461b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1213,15 +1213,14 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
  * and we are not allowed to call set_blocksize during the scan. The superblock
  * is read via pagecache
  */
-int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
-			  struct btrfs_fs_devices **fs_devices_ret)
+struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
+					   void *holder)
 {
 	struct btrfs_super_block *disk_super;
 	bool new_device_added = false;
-	struct btrfs_device *device;
+	struct btrfs_device *ret = NULL;
 	struct block_device *bdev;
 	struct page *page;
-	int ret = 0;
 	u64 bytenr;
 
 	lockdep_assert_held(&uuid_mutex);
@@ -1237,21 +1236,16 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 
 	bdev = blkdev_get_by_path(path, flags, holder);
 	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
+		return ERR_CAST(bdev);
 
 	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
-		ret = -EINVAL;
+		ret = ERR_PTR(-EINVAL);
 		goto error_bdev_put;
 	}
 
-	device = device_list_add(path, disk_super, &new_device_added);
-	if (IS_ERR(device)) {
-		ret = PTR_ERR(device);
-	} else {
-		*fs_devices_ret = device->fs_devices;
-		if (new_device_added)
-			btrfs_free_stale_devices(path, device);
-	}
+	ret = device_list_add(path, disk_super, &new_device_added);
+	if (new_device_added)
+		btrfs_free_stale_devices(path, ret);
 
 	btrfs_release_disk_super(page);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9665b84b1026..06d8bb7dd557 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -403,8 +403,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			   int mirror_num, int async_submit);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
-int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
-			  struct btrfs_fs_devices **fs_devices_ret);
+struct btrfs_device *btrfs_scan_one_device(const char *path,
+					   fmode_t flags, void *holder);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
-- 
2.17.1



