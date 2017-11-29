Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27179 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdK2EpR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 23:45:17 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT4jGJg026840
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT4jGRF019087
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:16 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAT4jGtY026242
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
Subject: [PATCH 1/4] btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
Date: Wed, 29 Nov 2017 12:45:33 +0800
Message-Id: <20171129044536.16260-2-anand.jain@oracle.com>
In-Reply-To: <20171129044536.16260-1-anand.jain@oracle.com>
References: <20171129044536.16260-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently device state is being managed by each individual int
variable such as struct btrfs_device::writeable. Instead of that
declare device state BTRFS_DEV_STATE_WRITEABLE and use the
bit operations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c     | 12 ++++++----
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/extent_io.c   |  3 ++-
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/scrub.c       |  3 ++-
 fs/btrfs/volumes.c     | 63 +++++++++++++++++++++++++++++---------------------
 fs/btrfs/volumes.h     |  4 +++-
 7 files changed, 54 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfdab849037b..0d361b6713e1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3563,7 +3563,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 			continue;
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		write_dev_flush(dev);
@@ -3578,7 +3579,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 			errors_wait++;
 			continue;
 		}
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		ret = wait_dev_flush(dev);
@@ -3675,7 +3677,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 			total_errors++;
 			continue;
 		}
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		btrfs_set_stack_device_generation(dev_item, 0);
@@ -3714,7 +3717,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		ret = wait_dev_supers(dev, max_mirrors);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2d7e86b51d1..f81d928754e1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10935,7 +10935,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 	*trimmed = 0;
 
 	/* Not writeable = nothing to do. */
-	if (!device->writeable)
+	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		return 0;
 
 	/* No free space = nothing to do. */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7fa50e12f18e..f51c797847c7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2028,7 +2028,8 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
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
index 6c7a49faf4e0..8a74c83503d6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1518,7 +1518,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		goto out_free;
 	}
 
-	if (!device->writeable) {
+	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		btrfs_info(fs_info,
 			   "resizer unable to apply on readonly device %llu",
 		       devid);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e3f6c49e5c4d..e027e0de66a5 100644
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
index 397b335d108c..0f5be1808c6e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -634,10 +634,15 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
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
@@ -651,7 +656,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 	device->mode = flags;
 
 	fs_devices->open_devices++;
-	if (device->writeable &&
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 		fs_devices->rw_devices++;
 		list_add(&device->dev_alloc_list,
@@ -881,9 +886,10 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
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
@@ -925,7 +931,8 @@ static void free_device(struct rcu_head *head)
 
 static void btrfs_close_bdev(struct btrfs_device *device)
 {
-	if (device->bdev && device->writeable) {
+	if (device->bdev &&
+		test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		sync_blockdev(device->bdev);
 		invalidate_bdev(device->bdev);
 	}
@@ -943,7 +950,7 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 	if (device->bdev)
 		fs_devices->open_devices--;
 
-	if (device->writeable &&
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 		list_del_init(&device->dev_alloc_list);
 		fs_devices->rw_devices--;
@@ -1901,12 +1908,13 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
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
@@ -1968,7 +1976,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	 * the devices list.  All that's left is to zero out the old
 	 * supers and free the device.
 	 */
-	if (device->writeable)
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		btrfs_scratch_superblocks(device->bdev, device->name->str);
 
 	btrfs_close_bdev(device);
@@ -1994,7 +2002,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	return ret;
 
 error_undo:
-	if (device->writeable) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		mutex_lock(&fs_info->chunk_mutex);
 		list_add(&device->dev_alloc_list,
 			 &fs_info->fs_devices->alloc_list);
@@ -2025,7 +2033,7 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 	if (srcdev->missing)
 		fs_devices->missing_devices--;
 
-	if (srcdev->writeable)
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state))
 		fs_devices->rw_devices--;
 
 	if (srcdev->bdev)
@@ -2037,7 +2045,7 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_fs_devices *fs_devices = srcdev->fs_devices;
 
-	if (srcdev->writeable) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state)) {
 		/* zero out the old super if it is writable */
 		btrfs_scratch_superblocks(srcdev->bdev, srcdev->name->str);
 	}
@@ -2391,7 +2399,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	q = bdev_get_queue(bdev);
 	if (blk_queue_discard(q))
 		device->can_discard = 1;
-	device->writeable = 1;
+	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	device->generation = trans->transid;
 	device->io_width = fs_info->sectorsize;
 	device->io_align = fs_info->sectorsize;
@@ -2592,7 +2600,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	if (blk_queue_discard(q))
 		device->can_discard = 1;
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	device->writeable = 1;
+	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	device->generation = 0;
 	device->io_width = fs_info->sectorsize;
 	device->io_align = fs_info->sectorsize;
@@ -2692,7 +2700,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	u64 old_total;
 	u64 diff;
 
-	if (!device->writeable)
+	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		return -EACCES;
 
 	new_size = round_down(new_size, fs_info->sectorsize);
@@ -3512,7 +3520,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		old_size = btrfs_device_get_total_bytes(device);
 		size_to_free = div_factor(old_size, 1);
 		size_to_free = min_t(u64, size_to_free, SZ_1M);
-		if (!device->writeable ||
+		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
 		    btrfs_device_get_total_bytes(device) -
 		    btrfs_device_get_bytes_used(device) > size_to_free ||
 		    device->is_tgtdev_for_dev_replace)
@@ -4395,7 +4403,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	mutex_lock(&fs_info->chunk_mutex);
 
 	btrfs_device_set_total_bytes(device, new_size);
-	if (device->writeable) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		device->fs_devices->total_rw_bytes -= diff;
 		atomic64_sub(diff, &fs_info->free_chunk_space);
 	}
@@ -4520,7 +4528,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	if (ret) {
 		mutex_lock(&fs_info->chunk_mutex);
 		btrfs_device_set_total_bytes(device, old_size);
-		if (device->writeable)
+		if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 			device->fs_devices->total_rw_bytes += diff;
 		atomic64_add(diff, &fs_info->free_chunk_space);
 		mutex_unlock(&fs_info->chunk_mutex);
@@ -4680,7 +4688,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		u64 max_avail;
 		u64 dev_offset;
 
-		if (!device->writeable) {
+		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 			WARN(1, KERN_ERR
 			       "BTRFS: read-only device in alloc_list\n");
 			continue;
@@ -5035,12 +5043,13 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 
 	map = em->map_lookup;
 	for (i = 0; i < map->num_stripes; i++) {
-		if (map->stripes[i].dev->missing) {
+		struct btrfs_device *device = map->stripes[i].dev;
+
+		if (device->missing) {
 			miss_ndevs++;
 			continue;
 		}
-
-		if (!map->stripes[i].dev->writeable) {
+		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 			readonly = 1;
 			goto end;
 		}
@@ -6220,7 +6229,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bbio->stripes[dev_nr].dev;
 		if (!dev || !dev->bdev ||
-		    (bio_op(first_bio) == REQ_OP_WRITE && !dev->writeable)) {
+		    (bio_op(first_bio) == REQ_OP_WRITE &&
+		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))) {
 			bbio_error(bbio, first_bio, logical);
 			continue;
 		}
@@ -6656,7 +6666,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	}
 
 	if (device->fs_devices != fs_info->fs_devices) {
-		BUG_ON(device->writeable);
+		BUG_ON(test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state));
 		if (device->generation !=
 		    btrfs_device_generation(leaf, dev_item))
 			return -EINVAL;
@@ -6664,7 +6674,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 
 	fill_device_from_item(leaf, dev_item, device);
 	device->in_fs_metadata = 1;
-	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
+					!device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
 		atomic64_add(device->total_bytes - device->bytes_used,
 				&fs_info->free_chunk_space);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ff15208344a7..2e376a422626 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -47,6 +47,8 @@ struct btrfs_pending_bios {
 #define btrfs_device_data_ordered_init(device) do { } while (0)
 #endif
 
+#define BTRFS_DEV_STATE_WRITEABLE	(1UL << 1)
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
 	int can_discard;
-- 
2.15.0

