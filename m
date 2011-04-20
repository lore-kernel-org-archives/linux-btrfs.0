From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 2/5] Btrfs: fix the race between reading and updating devices
Date: Wed, 20 Apr 2011 18:07:30 +0800
Message-ID: <4DAEB062.9020907@cn.fujitsu.com>
References: <4DAEB030.1070303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DAEB030.1070303@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On btrfs_congested_fn and __unplug_io_fn paths, we should hold
device_list_mutex to avoid remove/add device path to
update fs_devices->devices

On __btrfs_close_devices and btrfs_prepare_sprout paths, the devices in
fs_devices->devices or fs_devices->devices is updated, so we should hold
the mutex to avoid the reader side to reach them

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    4 ++++
 fs/btrfs/volumes.c |    7 +++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ef6865c..5a70096 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1412,6 +1412,7 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 	struct btrfs_device *device;
 	struct backing_dev_info *bdi;
 
+	mutex_lock(&info->fs_devices->device_list_mutex);
 	list_for_each_entry(device, &info->fs_devices->devices, dev_list) {
 		if (!device->bdev)
 			continue;
@@ -1421,6 +1422,7 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 			break;
 		}
 	}
+	mutex_unlock(&info->fs_devices->device_list_mutex);
 	return ret;
 }
 
@@ -1434,6 +1436,7 @@ static void __unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 	struct btrfs_fs_info *info;
 
 	info = (struct btrfs_fs_info *)bdi->unplug_io_data;
+	mutex_lock(&info->fs_devices->device_list_mutex);
 	list_for_each_entry(device, &info->fs_devices->devices, dev_list) {
 		if (!device->bdev)
 			continue;
@@ -1442,6 +1445,7 @@ static void __unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 		if (bdi->unplug_io_fn)
 			bdi->unplug_io_fn(bdi, page);
 	}
+	mutex_unlock(&info->fs_devices->device_list_mutex);
 }
 
 static void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 69fc902..a672249 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -515,6 +515,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 	if (--fs_devices->opened > 0)
 		return 0;
 
+	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (device->bdev) {
 			blkdev_put(device->bdev, device->mode);
@@ -529,6 +530,8 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		device->writeable = 0;
 		device->in_fs_metadata = 0;
 	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
 	WARN_ON(fs_devices->open_devices);
 	WARN_ON(fs_devices->rw_devices);
 	fs_devices->opened = 0;
@@ -1449,7 +1452,11 @@ static int btrfs_prepare_sprout(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&seed_devices->devices);
 	INIT_LIST_HEAD(&seed_devices->alloc_list);
 	mutex_init(&seed_devices->device_list_mutex);
+
+	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	list_splice_init(&fs_devices->devices, &seed_devices->devices);
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+
 	list_splice_init(&fs_devices->alloc_list, &seed_devices->alloc_list);
 	list_for_each_entry(device, &seed_devices->devices, dev_list) {
 		device->fs_devices = seed_devices;
-- 
1.7.4.4
