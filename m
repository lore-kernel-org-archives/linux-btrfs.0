From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 5/5] Btrfs: using rcu lock in the reader side of devices list
Date: Wed, 20 Apr 2011 18:09:16 +0800
Message-ID: <4DAEB0CC.1000004@cn.fujitsu.com>
References: <4DAEB030.1070303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DAEB030.1070303@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

fs_devices->devices is only updated on remove and add device paths, so we can
use rcu to protect it in the reader side

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   21 +++++++------
 fs/btrfs/ioctl.c   |    7 ++--
 fs/btrfs/volumes.c |   85 ++++++++++++++++++++++++++++++++++++----------------
 fs/btrfs/volumes.h |    2 +
 4 files changed, 76 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5a70096..ea13c9f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1412,8 +1412,8 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 	struct btrfs_device *device;
 	struct backing_dev_info *bdi;
 
-	mutex_lock(&info->fs_devices->device_list_mutex);
-	list_for_each_entry(device, &info->fs_devices->devices, dev_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(device, &info->fs_devices->devices, dev_list) {
 		if (!device->bdev)
 			continue;
 		bdi = blk_get_backing_dev_info(device->bdev);
@@ -1422,7 +1422,7 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 			break;
 		}
 	}
-	mutex_unlock(&info->fs_devices->device_list_mutex);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1436,8 +1436,9 @@ static void __unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 	struct btrfs_fs_info *info;
 
 	info = (struct btrfs_fs_info *)bdi->unplug_io_data;
-	mutex_lock(&info->fs_devices->device_list_mutex);
-	list_for_each_entry(device, &info->fs_devices->devices, dev_list) {
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(device, &info->fs_devices->devices, dev_list) {
 		if (!device->bdev)
 			continue;
 
@@ -1445,7 +1446,7 @@ static void __unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 		if (bdi->unplug_io_fn)
 			bdi->unplug_io_fn(bdi, page);
 	}
-	mutex_unlock(&info->fs_devices->device_list_mutex);
+	rcu_read_unlock();
 }
 
 static void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
@@ -2414,9 +2415,9 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	sb = &root->fs_info->super_for_commit;
 	dev_item = &sb->dev_item;
 
-	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	rcu_read_lock();
 	head = &root->fs_info->fs_devices->devices;
-	list_for_each_entry(dev, head, dev_list) {
+	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (!dev->bdev) {
 			total_errors++;
 			continue;
@@ -2449,7 +2450,7 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	}
 
 	total_errors = 0;
-	list_for_each_entry(dev, head, dev_list) {
+	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (!dev->bdev)
 			continue;
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -2459,7 +2460,7 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		if (ret)
 			total_errors++;
 	}
-	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+	rcu_read_unlock();
 	if (total_errors > max_errors) {
 		printk(KERN_ERR "btrfs: %d errors while writing supers\n",
 		       total_errors);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f580a3a..c2f8920 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -275,8 +275,9 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	list_for_each_entry(device, &fs_info->fs_devices->devices, dev_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(device, &fs_info->fs_devices->devices,
+				dev_list) {
 		if (!device->bdev)
 			continue;
 		q = bdev_get_queue(device->bdev);
@@ -286,7 +287,7 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 				     minlen);
 		}
 	}
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	rcu_read_unlock();
 	if (!num_devices)
 		return -EOPNOTSUPP;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f43b946..8998ce7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -397,7 +397,7 @@ static noinline int device_list_add(const char *path,
 		INIT_LIST_HEAD(&device->dev_alloc_list);
 
 		mutex_lock(&fs_devices->device_list_mutex);
-		list_add(&device->dev_list, &fs_devices->devices);
+		list_add_rcu(&device->dev_list, &fs_devices->devices);
 		mutex_unlock(&fs_devices->device_list_mutex);
 
 		device->fs_devices = fs_devices;
@@ -505,6 +505,29 @@ again:
 	return 0;
 }
 
+static void __free_device(struct work_struct *work)
+{
+	struct btrfs_device *device;
+
+	device = container_of(work, struct btrfs_device, rcu_work);
+
+	if (device->bdev)
+		blkdev_put(device->bdev, device->mode);
+
+	kfree(device->name);
+	kfree(device);
+}
+
+static void free_device(struct rcu_head *head)
+{
+	struct btrfs_device *device;
+
+	device = container_of(head, struct btrfs_device, rcu);
+
+	INIT_WORK(&device->rcu_work, __free_device);
+	schedule_work(&device->rcu_work);
+}
+
 static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
@@ -514,18 +537,27 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-		if (device->bdev) {
-			blkdev_put(device->bdev, device->mode);
+		struct btrfs_device *new_device;
+
+		if (device->bdev)
 			fs_devices->open_devices--;
-		}
+
 		if (device->writeable) {
 			list_del_init(&device->dev_alloc_list);
 			fs_devices->rw_devices--;
 		}
 
-		device->bdev = NULL;
-		device->writeable = 0;
-		device->in_fs_metadata = 0;
+		new_device = kmalloc(sizeof(*new_device), GFP_NOFS);
+		BUG_ON(!new_device);
+		memcpy(new_device, device, sizeof(*new_device));
+		new_device->name = kstrdup(device->name, GFP_NOFS);
+		BUG_ON(!new_device->name);
+		new_device->bdev = NULL;
+		new_device->writeable = 0;
+		new_device->in_fs_metadata = 0;
+		list_replace_rcu(&device->dev_list, &new_device->dev_list);
+
+		call_rcu(&device->rcu, free_device);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
@@ -1238,11 +1270,13 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	struct block_device *bdev;
 	struct buffer_head *bh = NULL;
 	struct btrfs_super_block *disk_super;
+	struct btrfs_fs_devices *cur_devices;
 	u64 all_avail;
 	u64 devid;
 	u64 num_devices;
 	u8 *dev_uuid;
 	int ret = 0;
+	bool clear_super = false;
 
 	mutex_lock(&uuid_mutex);
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -1328,6 +1362,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		list_del_init(&device->dev_alloc_list);
 		unlock_chunks(root);
 		root->fs_info->fs_devices->rw_devices--;
+		clear_super = true;
 	}
 
 	ret = btrfs_shrink_device(device, 0);
@@ -1338,16 +1373,15 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (ret)
 		goto error_undo;
 
-	device->in_fs_metadata = 0;
-
 	/*
 	 * the device list mutex makes sure that we don't change
 	 * the device list while someone else is writing out all
 	 * the device supers.
 	 */
+
+	cur_devices = device->fs_devices;
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	list_del_init(&device->dev_list);
-	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+	list_del_rcu(&device->dev_list);
 
 	device->fs_devices->num_devices--;
 
@@ -1361,36 +1395,36 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->bdev == root->fs_info->fs_devices->latest_bdev)
 		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
 
-	if (device->bdev) {
-		blkdev_put(device->bdev, device->mode);
-		device->bdev = NULL;
+	if (device->bdev)
 		device->fs_devices->open_devices--;
-	}
+
+	call_rcu(&device->rcu, free_device);
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	num_devices = btrfs_super_num_devices(&root->fs_info->super_copy) - 1;
 	btrfs_set_super_num_devices(&root->fs_info->super_copy, num_devices);
 
-	if (device->fs_devices->open_devices == 0) {
+	if (cur_devices->open_devices == 0) {
 		struct btrfs_fs_devices *fs_devices;
 		fs_devices = root->fs_info->fs_devices;
 		while (fs_devices) {
-			if (fs_devices->seed == device->fs_devices)
+			if (fs_devices->seed == cur_devices)
 				break;
 			fs_devices = fs_devices->seed;
 		}
-		fs_devices->seed = device->fs_devices->seed;
-		device->fs_devices->seed = NULL;
+		fs_devices->seed = cur_devices->seed;
+		cur_devices->seed = NULL;
 		lock_chunks(root);
-		__btrfs_close_devices(device->fs_devices);
+		__btrfs_close_devices(cur_devices);
 		unlock_chunks(root);
-		free_fs_devices(device->fs_devices);
+		free_fs_devices(cur_devices);
 	}
 
 	/*
 	 * at this point, the device is zero sized.  We want to
 	 * remove it from the devices list and zero out the old super
 	 */
-	if (device->writeable) {
+	if (clear_super) {
 		/* make sure this device isn't detected as part of
 		 * the FS anymore
 		 */
@@ -1399,8 +1433,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		sync_dirty_buffer(bh);
 	}
 
-	kfree(device->name);
-	kfree(device);
 	ret = 0;
 
 error_brelse:
@@ -1459,7 +1491,8 @@ static int btrfs_prepare_sprout(struct btrfs_trans_handle *trans,
 	mutex_init(&seed_devices->device_list_mutex);
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	list_splice_init(&fs_devices->devices, &seed_devices->devices);
+	list_splice_init_rcu(&fs_devices->devices, &seed_devices->devices,
+			      synchronize_rcu);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	list_splice_init(&fs_devices->alloc_list, &seed_devices->alloc_list);
@@ -1658,7 +1691,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	 * half setup
 	 */
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	list_add(&device->dev_list, &root->fs_info->fs_devices->devices);
+	list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->devices);
 	list_add(&device->dev_alloc_list,
 		 &root->fs_info->fs_devices->alloc_list);
 	root->fs_info->fs_devices->num_devices++;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index cc2eada..f1b2e4f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -86,6 +86,8 @@ struct btrfs_device {
 	u8 uuid[BTRFS_UUID_SIZE];
 
 	struct btrfs_work work;
+	struct rcu_head rcu;
+	struct work_struct rcu_work;
 };
 
 struct btrfs_fs_devices {
-- 
1.7.4.4
