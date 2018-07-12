Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43790 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726693AbeGLGfl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 02:35:41 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>, <nborisov@suse.com>
Subject: [PATCH v4 2/2] btrfs: get device pointer from btrfs_scan_one_device
Date: Thu, 12 Jul 2018 14:23:16 +0800
Message-ID: <1531376596-26333-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1531376596-26333-1-git-send-email-gujx@cn.fujitsu.com>
References: <1531376596-26333-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of pointer to btrfs_fs_devices as an arg in
btrfs_scan_one_device, better to make it as a return value.

And since btrfs_fs_devices can be get by btrfs_device,
better to return btrfs_device than fs_btrfs_devices.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---

Changelog:
v4: as suggested by Anand, change return value of
    btrfs_scan_one_device from btrfs_fs_devices to btrfs_device.
v3: as comment by robot, use PTR_ERR_OR_ZERO, and rebase to misc-next.
v2: as comment by Nikolay, use ERR_CAST instead of cast type manually.

 fs/btrfs/super.c   | 37 ++++++++++++++++++++++++-------------
 fs/btrfs/volumes.c | 17 ++++++-----------
 fs/btrfs/volumes.h |  4 ++--
 3 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 44f58bdb5fa6..e73d547eacff 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -888,7 +888,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
-	struct btrfs_fs_devices *fs_devices = NULL;
+	struct btrfs_device *device = NULL;
 	int error = 0;
 
 	if (!options)
@@ -916,11 +916,13 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 				error = -ENOMEM;
 				goto out;
 			}
-			error = btrfs_scan_one_device(device_name,
-					flags, holder, &fs_devices);
+			device = btrfs_scan_one_device(device_name,
+					flags, holder);
 			kfree(device_name);
-			if (error)
+			if (IS_ERR(device)) {
+				error = PTR_ERR(device);
 				goto out;
+			}
 		}
 	}
 
@@ -1516,6 +1518,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 {
 	struct block_device *bdev = NULL;
 	struct super_block *s;
+	struct btrfs_device *device = NULL;
 	struct btrfs_fs_devices *fs_devices = NULL;
 	struct btrfs_fs_info *fs_info = NULL;
 	struct security_mnt_opts new_sec_opts;
@@ -1537,9 +1540,13 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 			return ERR_PTR(error);
 	}
 
-	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
-	if (error)
+	device = btrfs_scan_one_device(device_name, mode, fs_type);
+	if (IS_ERR(device)) {
+		error = PTR_ERR(device);
 		goto error_sec_opts;
+	}
+
+	fs_devices = device->fs_devices;
 
 	/*
 	 * Setup a dummy root and fs_info for test/set super.  This is because
@@ -2220,7 +2227,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	struct btrfs_ioctl_vol_args *vol;
-	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device = NULL;
 	int ret = -ENOTTY;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2232,15 +2239,19 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
-		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
-					    &btrfs_root_fs_type, &fs_devices);
+		device = btrfs_scan_one_device(vol->name, FMODE_READ,
+					    &btrfs_root_fs_type);
+		ret = PTR_ERR_OR_ZERO(device);
 		break;
 	case BTRFS_IOC_DEVICES_READY:
-		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
-					    &btrfs_root_fs_type, &fs_devices);
-		if (ret)
+		device = btrfs_scan_one_device(vol->name, FMODE_READ,
+					    &btrfs_root_fs_type);
+		if (IS_ERR(device)) {
+			ret = PTR_ERR(device);
 			break;
-		ret = !(fs_devices->num_devices == fs_devices->total_devices);
+		}
+		ret = !(device->fs_devices->num_devices ==
+				device->fs_devices->total_devices);
 		break;
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		ret = btrfs_ioctl_get_supported_features((void __user*)arg);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 52abada5c789..3bc479e8cc22 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1212,14 +1212,13 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
  * and we are not allowed to call set_blocksize during the scan. The superblock
  * is read via pagecache
  */
-int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
-			  struct btrfs_fs_devices **fs_devices_ret)
+struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
+					    void *holder)
 {
 	struct btrfs_super_block *disk_super;
-	struct btrfs_device *device;
+	struct btrfs_device *ret = NULL;
 	struct block_device *bdev;
 	struct page *page;
-	int ret = 0;
 	u64 bytenr;
 
 	/*
@@ -1233,19 +1232,15 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 
 	bdev = blkdev_get_by_path(path, flags, holder);
 	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
+		return ERR_CAST(bdev);
 
 	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
-		ret = -EINVAL;
+		ret = ERR_PTR(-EINVAL);
 		goto error_bdev_put;
 	}
 
 	mutex_lock(&uuid_mutex);
-	device = device_list_add(path, disk_super);
-	if (IS_ERR(device))
-		ret = PTR_ERR(device);
-	else
-		*fs_devices_ret = device->fs_devices;
+	ret = device_list_add(path, disk_super);
 	mutex_unlock(&uuid_mutex);
 
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



