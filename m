Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60451 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932839AbaICNey (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:54 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYoVr006749
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] Btrfs: scan all the devices and build the fs device list by btrfs's self
Date: Wed, 3 Sep 2014 21:36:33 +0800
Message-ID: <1409751393-5403-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original code need scan the devices and build the fs device list by the user
tool by udev or users' selves. It is flexible. But if someone re-install the
filesystem module, and forget to scan the devices by himself, or we plug some
devices with btrfs, but udev thread is blocked and doesn't register the disk
into btrfs in time, the filesystem would report that "can not open some device"
when mounting the filesystem, it was uncomfortable, this patch fixes this problem
by scanning all the devices if we find the number of devices is not right when
we mount the filesystem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c   |   3 ++
 fs/btrfs/volumes.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/volumes.h |   5 ++-
 3 files changed, 103 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6b98358..2a8c664 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1264,6 +1264,9 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	if (error)
 		return ERR_PTR(error);
 
+	if (fs_devices->num_devices != fs_devices->total_devices)
+		btrfs_scan_all_devices(fs_type);
+
 	/*
 	 * Setup a dummy root and fs_info for test/set super.  This is because
 	 * we don't actually fill this stuff out until open_ctree, but we need
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9d52fd8..aa4665e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
+#include <linux/genhd.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -236,6 +237,29 @@ btrfs_get_bdev_and_sb_by_path(const char *device_path, fmode_t flags,
 	return 0;
 }
 
+static int
+btrfs_get_bdev_and_sb_by_dev(dev_t dev, fmode_t flags, void *holder, int flush,
+			     struct block_device **bdev,
+			     struct buffer_head **bh)
+{
+	int ret;
+
+	*bdev = blkdev_get_by_dev(dev, flags, holder);
+	if (IS_ERR(*bdev)) {
+		printk(KERN_INFO "BTRFS: open device %d:%d failed\n",
+		       MAJOR(dev), MINOR(dev));
+		return PTR_ERR(*bdev);
+	}
+
+	ret = __btrfs_get_sb(*bdev, flush, bh);
+	if (ret) {
+		blkdev_put(*bdev, flags);
+		return ret;
+	}
+
+	return 0;
+}
+
 static void requeue_list(struct btrfs_pending_bios *pending_bios,
 			struct bio *head, struct bio *tail)
 {
@@ -466,8 +490,9 @@ static void pending_bios_fn(struct btrfs_work *work)
  * < 0 - error
  */
 static noinline int device_list_add(const char *path,
-			   struct btrfs_super_block *disk_super,
-			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
+				    struct btrfs_super_block *disk_super,
+				    u64 devid, dev_t devnum,
+				    struct btrfs_fs_devices **fs_devices_ret)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
@@ -493,7 +518,7 @@ static noinline int device_list_add(const char *path,
 		if (fs_devices->opened)
 			return -EBUSY;
 
-		device = btrfs_alloc_device(NULL, &devid,
+		device = btrfs_alloc_device(NULL, &devid, devnum,
 					    disk_super->dev_item.uuid);
 		if (IS_ERR(device)) {
 			/* we can safely leave the fs_devices entry around */
@@ -561,6 +586,7 @@ static noinline int device_list_add(const char *path,
 		if (device->missing) {
 			fs_devices->missing_devices--;
 			device->missing = 0;
+			device->devnum = devnum;
 		}
 	}
 
@@ -597,7 +623,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		struct rcu_string *name;
 
 		device = btrfs_alloc_device(NULL, &orig_dev->devid,
-					    orig_dev->uuid);
+					    orig_dev->devnum, orig_dev->uuid);
 		if (IS_ERR(device))
 			goto error;
 
@@ -735,7 +761,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 			fs_devices->missing_devices--;
 
 		new_device = btrfs_alloc_device(NULL, &device->devid,
-						device->uuid);
+						device->devnum, device->uuid);
 		BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
 
 		/* Safe because we are under uuid_mutex */
@@ -811,7 +837,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		/* Just open everything we can; ignore failures here */
-		if (btrfs_get_bdev_and_sb_by_path(device->name->str, flags,
+		if (btrfs_get_bdev_and_sb_by_dev(device->devnum, flags,
 						  holder, 1, &bdev, &bh))
 			continue;
 
@@ -945,7 +971,8 @@ static int __scan_device(struct block_device *bdev, const char *path,
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
 
-	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
+	ret = device_list_add(path, disk_super, devid, bdev->bd_dev,
+			      fs_devices_ret);
 	if (ret > 0) {
 		if (disk_super->label[0]) {
 			if (disk_super->label[BTRFS_LABEL_SIZE - 1])
@@ -995,6 +1022,63 @@ error:
 	return ret;
 }
 
+static void btrfs_scan_partitions_on_disk(struct gendisk *disk, void *holder)
+{
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+	struct block_device *bdev;
+	char buf[BDEVNAME_SIZE];
+	fmode_t mode = FMODE_READ | FMODE_EXCL;
+	int count = 0;
+	int ret;
+
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0 |
+					  DISK_PITER_REVERSE);
+	while ((part = disk_part_iter_next(&piter))) {
+		if (count && !part->partno)
+			continue;
+
+		count++;
+		bdev = bdget(part_devt(part));
+		if (!bdev)
+			continue;
+
+		if (blkdev_get(bdev, mode, holder))
+			continue;
+
+		ret = __scan_device(bdev, bdevname(bdev, buf), NULL);
+		if (!ret)
+			btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
+		blkdev_put(bdev, mode);
+	}
+	disk_part_iter_exit(&piter);
+}
+
+void btrfs_scan_all_devices(void *holder)
+{
+	struct class_dev_iter iter;
+	struct device *dev;
+	struct gendisk *disk;
+
+	mutex_lock(&uuid_mutex);
+	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
+	while ((dev = class_dev_iter_next(&iter))) {
+		disk = dev_to_disk(dev);
+
+		if (!get_capacity(disk) ||
+		    (!disk_max_parts(disk) &&
+		     (disk->flags & GENHD_FL_REMOVABLE)))
+			continue;
+
+		if (disk->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
+			continue;
+
+		btrfs_scan_partitions_on_disk(disk, holder);
+	}
+	class_dev_iter_exit(&iter);
+	mutex_unlock(&uuid_mutex);
+}
+
 /* helper to account the used device space in the range */
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length)
@@ -2140,7 +2224,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
-	device = btrfs_alloc_device(root->fs_info, NULL, NULL);
+	device = btrfs_alloc_device(root->fs_info, NULL, bdev->bd_dev, NULL);
 	if (IS_ERR(device)) {
 		/* we can safely leave the fs_devices entry around */
 		ret = PTR_ERR(device);
@@ -2352,7 +2436,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 	}
 
 
-	device = btrfs_alloc_device(NULL, &devid, NULL);
+	device = btrfs_alloc_device(NULL, &devid, bdev->bd_dev, NULL);
 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
 		goto error;
@@ -5867,7 +5951,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 {
 	struct btrfs_device *device;
 
-	device = btrfs_alloc_device(NULL, &devid, dev_uuid);
+	device = btrfs_alloc_device(NULL, &devid, 0, dev_uuid);
 	if (IS_ERR(device))
 		return NULL;
 
@@ -5895,7 +5979,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
  * destroyed with kfree() right away.
  */
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
-					const u64 *devid,
+					const u64 *devid, dev_t devnum,
 					const u8 *uuid)
 {
 	struct btrfs_device *dev;
@@ -5920,6 +6004,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 		}
 	}
 	dev->devid = tmp;
+	dev->devnum = devnum;
 
 	if (uuid)
 		memcpy(dev->uuid, uuid, BTRFS_UUID_SIZE);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2b37da3..cfb6539 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -69,6 +69,7 @@ struct btrfs_device {
 
 	/* the mode sent to blkdev_get */
 	fmode_t mode;
+	dev_t devnum;
 
 	int writeable;
 	int in_fs_metadata;
@@ -288,6 +289,8 @@ struct btrfs_bio_stripe {
 	u64 length; /* only used for discard mappings */
 };
 
+void btrfs_scan_all_devices(void *holder);
+
 struct btrfs_bio;
 typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
 
@@ -414,7 +417,7 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 					 char *device_path,
 					 struct btrfs_device **device);
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
-					const u64 *devid,
+					const u64 *devid, dev_t devnum,
 					const u8 *uuid);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
 void btrfs_cleanup_fs_uuids(void);
-- 
1.9.3

