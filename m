Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19767 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750737AbaLJHl6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 02:41:58 -0500
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <Anand.Jain@oracle.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: introduce shrinker for rb_tree that keeps valid btrfs_devices
Date: Wed, 10 Dec 2014 15:39:51 +0800
Message-ID: <1418197191-4960-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1417405154-6170-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1417405154-6170-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following patch:
	btrfs: remove empty fs_devices to prevent memory runout

introduces @valid_dev_root aiming at recording @btrfs_device objects that
have corresponding block devices with btrfs.
But if a block device is broken or unplugged, no one tells the
@valid_dev_root to cleanup the "dead" objects.

To recycle the memory occuppied by those "dead"s, we could rely on
the shrinker. The shrinker's scan function will traverse the
@valid_dev_root and trys to open the devices one by one, if it fails
or encounters a non-btrfs it will remove the "dead" @btrfs_device.

A special case to deal with is that a block device is unplugged and
replugged, then it appears with a new @bdev->bd_dev as devnum.
In this case, we should remove the older since we should have a new
one for that block device already.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 fs/btrfs/super.c   | 10 ++++++++
 fs/btrfs/volumes.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h |  4 +++
 3 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ee09a56..29069af 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1987,6 +1987,12 @@ static struct miscdevice btrfs_misc = {
 	.fops		= &btrfs_ctl_fops
 };
 
+static struct shrinker btrfs_valid_dev_shrinker = {
+	.scan_objects = btrfs_valid_dev_scan,
+	.count_objects = btrfs_valid_dev_count,
+	.seeks = DEFAULT_SEEKS,
+};
+
 MODULE_ALIAS_MISCDEV(BTRFS_MINOR);
 MODULE_ALIAS("devname:btrfs-control");
 
@@ -2100,6 +2106,8 @@ static int __init init_btrfs_fs(void)
 
 	btrfs_init_lockdep();
 
+	register_shrinker(&btrfs_valid_dev_shrinker);
+
 	btrfs_print_info();
 
 	err = btrfs_run_sanity_tests();
@@ -2113,6 +2121,7 @@ static int __init init_btrfs_fs(void)
 	return 0;
 
 unregister_ioctl:
+	unregister_shrinker(&btrfs_valid_dev_shrinker);
 	btrfs_interface_exit();
 free_end_io_wq:
 	btrfs_end_io_wq_exit();
@@ -2153,6 +2162,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_interface_exit();
 	btrfs_end_io_wq_exit();
 	unregister_filesystem(&btrfs_fs_type);
+	unregister_shrinker(&btrfs_valid_dev_shrinker);
 	btrfs_exit_sysfs();
 	btrfs_cleanup_valid_dev_root();
 	btrfs_cleanup_fs_uuids();
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7093cce..62f37b1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -54,6 +54,7 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
 static struct rb_root valid_dev_root = RB_ROOT;
+static atomic_long_t unopened_dev_count = ATOMIC_LONG_INIT(0);
 
 static struct btrfs_device *insert_valid_device(struct btrfs_device *new_dev)
 {
@@ -130,6 +131,8 @@ static void free_invalid_device(struct btrfs_device *invalid_dev)
 {
 	struct btrfs_fs_devices *old_fs;
 
+	atomic_long_dec(&unopened_dev_count);
+
 	old_fs = invalid_dev->fs_devices;
 	mutex_lock(&old_fs->device_list_mutex);
 	list_del(&invalid_dev->dev_list);
@@ -615,6 +618,7 @@ static noinline int device_list_add(const char *path,
 		list_add_rcu(&device->dev_list, &fs_devices->devices);
 		fs_devices->num_devices++;
 		mutex_unlock(&fs_devices->device_list_mutex);
+		atomic_long_inc(&unopened_dev_count);
 
 		ret = 1;
 		device->fs_devices = fs_devices;
@@ -788,6 +792,7 @@ again:
 			blkdev_put(device->bdev, device->mode);
 			device->bdev = NULL;
 			fs_devices->open_devices--;
+			atomic_long_inc(&unopened_dev_count);
 		}
 		if (device->writeable) {
 			list_del_init(&device->dev_alloc_list);
@@ -850,8 +855,10 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		struct btrfs_device *new_device;
 		struct rcu_string *name;
 
-		if (device->bdev)
+		if (device->bdev) {
 			fs_devices->open_devices--;
+			atomic_long_inc(&unopened_dev_count);
+		}
 
 		if (device->writeable &&
 		    device->devid != BTRFS_DEV_REPLACE_DEVID) {
@@ -981,6 +988,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			fs_devices->rotating = 1;
 
 		fs_devices->open_devices++;
+		atomic_long_dec(&unopened_dev_count);
 		if (device->writeable &&
 		    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 			fs_devices->rw_devices++;
@@ -6828,3 +6836,67 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 	}
 	unlock_chunks(root);
 }
+
+static unsigned long shrink_valid_dev_root(void)
+{
+	struct rb_node *n;
+	struct btrfs_device *device;
+	struct block_device *bdev;
+	struct buffer_head *bh;
+	unsigned long freed = 0;
+	unsigned long possible_deads;
+	int ret = 0;
+	dev_t cur_devnum;
+
+	mutex_lock(&uuid_mutex);
+
+	possible_deads = atomic_long_read(&unopened_dev_count);
+	if (!possible_deads)
+		goto out;
+
+	for (n = rb_first(&valid_dev_root); n ; n = rb_next(n)) {
+		device = rb_entry(n, struct btrfs_device, rb_node);
+
+		if (device->bdev)
+			continue;
+		if (!device->name)
+			continue;
+
+		ret = btrfs_get_bdev_and_sb(device->name->str, FMODE_READ,
+						NULL, 0, &bdev, &bh);
+		/* can't open as btrfs, not valid, drop it */
+		if (ret)
+			goto shrink;
+
+		cur_devnum = bdev->bd_dev;
+
+		brelse(bh);
+		blkdev_put(bdev, FMODE_READ);
+
+		if (device->devnum == cur_devnum)
+			continue;
+		/* bdev->bd_dev changed, not valid, drop it */
+
+shrink:
+		rb_erase(n, &valid_dev_root);
+		free_invalid_device(device);
+
+		freed++;
+	}
+
+out:
+	mutex_unlock(&uuid_mutex);
+	return freed;
+}
+
+unsigned long btrfs_valid_dev_scan(struct shrinker *shrink,
+				   struct shrink_control *sc)
+{
+	return shrink_valid_dev_root();
+}
+
+unsigned long btrfs_valid_dev_count(struct shrinker *shrink,
+				    struct shrink_control *sc)
+{
+	return atomic_long_read(&unopened_dev_count);
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7b57cc6..cad974a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -424,6 +424,10 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u8 *uuid);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
 void btrfs_cleanup_valid_dev_root(void);
+unsigned long btrfs_valid_dev_scan(struct shrinker *shrink,
+				   struct shrink_control *sc);
+unsigned long btrfs_valid_dev_count(struct shrinker *shrink,
+				    struct shrink_control *sc);
 void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
-- 
1.8.1.4

