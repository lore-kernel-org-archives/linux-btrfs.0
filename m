Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18215 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753309AbdLDEyd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Dec 2017 23:54:33 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vB44sWB0008088
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB44sWA6002136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:32 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB44sWRR011907
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/5] btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
Date: Mon,  4 Dec 2017 12:54:52 +0800
Message-Id: <20171204045456.8602-2-anand.jain@oracle.com>
In-Reply-To: <20171204045456.8602-1-anand.jain@oracle.com>
References: <20171204045456.8602-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently device state is being managed by each individual int
variable such as struct btrfs_device::writeable. Instead of that
declare device state BTRFS_DEV_STATE_WRITEABLE and use the
bit operations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Remove a unrelated change.
    Start btrfs_device::dev_state position from bit 0.
 fs/btrfs/disk-io.c     | 12 ++++++----
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/extent_io.c   |  3 ++-
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/scrub.c       |  3 ++-
 fs/btrfs/volumes.c     | 60 +++++++++++++++++++++++++++++---------------------
 fs/btrfs/volumes.h     |  4 +++-
 7 files changed, 52 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 10a2a579cc7f..56198cb02b35 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3403,7 +3403,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 			continue;
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		write_dev_flush(dev);
@@ -3418,7 +3419,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 			errors_wait++;
 			continue;
 		}
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		ret = wait_dev_flush(dev);
@@ -3515,7 +3517,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 			total_errors++;
 			continue;
 		}
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		btrfs_set_stack_device_generation(dev_item, 0);
@@ -3554,7 +3557,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		ret = wait_dev_supers(dev, max_mirrors);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 15c01014e5e1..2cd323d184a0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10877,7 +10877,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 	*trimmed = 0;
 
 	/* Not writeable = nothing to do. */
-	if (!device->writeable)
+	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		return 0;
 
 	/* No free space = nothing to do. */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 012d63870b99..25682c5a0dd5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2027,7 +2027,8 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	bio->bi_iter.bi_sector = sector;
 	dev = bbio->stripes[bbio->mirror_num - 1].dev;
 	btrfs_put_bbio(bbio);
-	if (!dev || !dev->bdev || !dev->writeable) {
+	if (!dev || !dev->bdev ||
+		!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state)) {
 		btrfs_bio_counter_dec(fs_info);
 		bio_put(bio);
 		return -EIO;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d748ad1c3620..e59004a17166 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1503,7 +1503,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		goto out_free;
 	}
 
-	if (!device->writeable) {
+	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		btrfs_info(fs_info,
 			   "resizer unable to apply on readonly device %llu",
 		       devid);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b2f871d80982..fa70ff9b7762 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4117,7 +4117,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -ENODEV;
 	}
 
-	if (!is_dev_replace && !readonly && !dev->writeable) {
+	if (!is_dev_replace && !readonly &&
+		!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		rcu_read_lock();
 		name = rcu_dereference(dev->name);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c19a49167966..9d14d83ab8dc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -620,10 +620,15 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 	device->generation = btrfs_super_generation(disk_super);
 
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
-		device->writeable = 0;
+		clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 		fs_devices->seeding = 1;
 	} else {
-		device->writeable = !bdev_read_only(bdev);
+		if (bdev_read_only(bdev))
+			clear_bit(BTRFS_DEV_STATE_WRITEABLE,
+						&device->dev_state);
+		else
+			set_bit(BTRFS_DEV_STATE_WRITEABLE,
+						&device->dev_state);
 	}
 
 	q = bdev_get_queue(bdev);
@@ -635,7 +640,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 	device->mode = flags;
 
 	fs_devices->open_devices++;
-	if (device->writeable &&
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 		fs_devices->rw_devices++;
 		list_add(&device->dev_alloc_list,
@@ -867,9 +872,10 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 			device->bdev = NULL;
 			fs_devices->open_devices--;
 		}
-		if (device->writeable) {
+		if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 			list_del_init(&device->dev_alloc_list);
-			device->writeable = 0;
+			clear_bit(BTRFS_DEV_STATE_WRITEABLE,
+							&device->dev_state);
 			if (!device->is_tgtdev_for_dev_replace)
 				fs_devices->rw_devices--;
 		}
@@ -912,7 +918,8 @@ static void free_device(struct rcu_head *head)
 
 static void btrfs_close_bdev(struct btrfs_device *device)
 {
-	if (device->bdev && device->writeable) {
+	if (device->bdev &&
+		test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		sync_blockdev(device->bdev);
 		invalidate_bdev(device->bdev);
 	}
@@ -930,7 +937,7 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 	if (device->bdev)
 		fs_devices->open_devices--;
 
-	if (device->writeable &&
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 		list_del_init(&device->dev_alloc_list);
 		fs_devices->rw_devices--;
@@ -1893,12 +1900,13 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		goto out;
 	}
 
-	if (device->writeable && fs_info->fs_devices->rw_devices == 1) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
+			fs_info->fs_devices->rw_devices == 1) {
 		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
 		goto out;
 	}
 
-	if (device->writeable) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		mutex_lock(&fs_info->chunk_mutex);
 		list_del_init(&device->dev_alloc_list);
 		device->fs_devices->rw_devices--;
@@ -1960,7 +1968,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	 * the devices list.  All that's left is to zero out the old
 	 * supers and free the device.
 	 */
-	if (device->writeable)
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		btrfs_scratch_superblocks(device->bdev, device->name->str);
 
 	btrfs_close_bdev(device);
@@ -1986,7 +1994,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	return ret;
 
 error_undo:
-	if (device->writeable) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		mutex_lock(&fs_info->chunk_mutex);
 		list_add(&device->dev_alloc_list,
 			 &fs_info->fs_devices->alloc_list);
@@ -2017,7 +2025,7 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 	if (srcdev->missing)
 		fs_devices->missing_devices--;
 
-	if (srcdev->writeable)
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state))
 		fs_devices->rw_devices--;
 
 	if (srcdev->bdev)
@@ -2029,7 +2037,7 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_fs_devices *fs_devices = srcdev->fs_devices;
 
-	if (srcdev->writeable) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state)) {
 		/* zero out the old super if it is writable */
 		btrfs_scratch_superblocks(srcdev->bdev, srcdev->name->str);
 	}
@@ -2385,7 +2393,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	}
 
 	q = bdev_get_queue(bdev);
-	device->writeable = 1;
+	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	device->generation = trans->transid;
 	device->io_width = fs_info->sectorsize;
 	device->io_align = fs_info->sectorsize;
@@ -2594,7 +2602,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	rcu_assign_pointer(device->name, name);
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	device->writeable = 1;
+	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	device->generation = 0;
 	device->io_width = fs_info->sectorsize;
 	device->io_align = fs_info->sectorsize;
@@ -2694,7 +2702,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	u64 old_total;
 	u64 diff;
 
-	if (!device->writeable)
+	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		return -EACCES;
 
 	new_size = round_down(new_size, fs_info->sectorsize);
@@ -3514,7 +3522,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		old_size = btrfs_device_get_total_bytes(device);
 		size_to_free = div_factor(old_size, 1);
 		size_to_free = min_t(u64, size_to_free, SZ_1M);
-		if (!device->writeable ||
+		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
 		    btrfs_device_get_total_bytes(device) -
 		    btrfs_device_get_bytes_used(device) > size_to_free ||
 		    device->is_tgtdev_for_dev_replace)
@@ -4397,7 +4405,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	mutex_lock(&fs_info->chunk_mutex);
 
 	btrfs_device_set_total_bytes(device, new_size);
-	if (device->writeable) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		device->fs_devices->total_rw_bytes -= diff;
 		atomic64_sub(diff, &fs_info->free_chunk_space);
 	}
@@ -4522,7 +4530,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	if (ret) {
 		mutex_lock(&fs_info->chunk_mutex);
 		btrfs_device_set_total_bytes(device, old_size);
-		if (device->writeable)
+		if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 			device->fs_devices->total_rw_bytes += diff;
 		atomic64_add(diff, &fs_info->free_chunk_space);
 		mutex_unlock(&fs_info->chunk_mutex);
@@ -4682,7 +4690,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		u64 max_avail;
 		u64 dev_offset;
 
-		if (!device->writeable) {
+		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 			WARN(1, KERN_ERR
 			       "BTRFS: read-only device in alloc_list\n");
 			continue;
@@ -5041,8 +5049,8 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 			miss_ndevs++;
 			continue;
 		}
-
-		if (!map->stripes[i].dev->writeable) {
+		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE,
+					&map->stripes[i].dev->dev_state)) {
 			readonly = 1;
 			goto end;
 		}
@@ -6211,7 +6219,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bbio->stripes[dev_nr].dev;
 		if (!dev || !dev->bdev ||
-		    (bio_op(first_bio) == REQ_OP_WRITE && !dev->writeable)) {
+		    (bio_op(first_bio) == REQ_OP_WRITE &&
+		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))) {
 			bbio_error(bbio, first_bio, logical);
 			continue;
 		}
@@ -6648,7 +6657,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	}
 
 	if (device->fs_devices != fs_info->fs_devices) {
-		BUG_ON(device->writeable);
+		BUG_ON(test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state));
 		if (device->generation !=
 		    btrfs_device_generation(leaf, dev_item))
 			return -EINVAL;
@@ -6656,7 +6665,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 
 	fill_device_from_item(leaf, dev_item, device);
 	device->in_fs_metadata = 1;
-	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
+					!device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
 		atomic64_add(device->total_bytes - device->bytes_used,
 				&fs_info->free_chunk_space);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index bbb5db6be7f8..b6d1b1f90b73 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -47,6 +47,8 @@ struct btrfs_pending_bios {
 #define btrfs_device_data_ordered_init(device) do { } while (0)
 #endif
 
+#define BTRFS_DEV_STATE_WRITEABLE	(1UL << 0)
+
 struct btrfs_device {
 	struct list_head dev_list;
 	struct list_head dev_alloc_list;
@@ -69,7 +71,7 @@ struct btrfs_device {
 	/* the mode sent to blkdev_get */
 	fmode_t mode;
 
-	int writeable;
+	unsigned long dev_state;
 	int in_fs_metadata;
 	int missing;
 	int is_tgtdev_for_dev_replace;
-- 
2.15.0

