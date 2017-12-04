Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48748 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbdLDEyg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Dec 2017 23:54:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB44saKW072904
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:36 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2embdch0aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 04:54:36 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB44sZ4g013025
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:35 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB44sZFT011920
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:35 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs: cleanup device states define BTRFS_DEV_STATE_REPLACE_TGT
Date: Mon,  4 Dec 2017 12:54:55 +0800
Message-Id: <20171204045456.8602-5-anand.jain@oracle.com>
In-Reply-To: <20171204045456.8602-1-anand.jain@oracle.com>
References: <20171204045456.8602-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently device state is being managed by each individual int
variable such as struct btrfs_device::is_tgtdev_for_dev_replace.
Instead of that declare btrfs_device::dev_state
BTRFS_DEV_STATE_MISSING and use the bit operations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |  5 +++--
 fs/btrfs/extent-tree.c |  3 ++-
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/scrub.c       |  2 +-
 fs/btrfs/super.c       |  5 +++--
 fs/btrfs/volumes.c     | 39 ++++++++++++++++++++++-----------------
 fs/btrfs/volumes.h     |  2 +-
 7 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 559db7667f38..12fd8a203735 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -172,7 +172,8 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 				dev_replace->tgtdev->commit_bytes_used =
 					dev_replace->srcdev->commit_bytes_used;
 			}
-			dev_replace->tgtdev->is_tgtdev_for_dev_replace = 1;
+			set_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+					&dev_replace->tgtdev->dev_state);
 			btrfs_init_dev_replace_tgtdev_for_resume(fs_info,
 				dev_replace->tgtdev);
 		}
@@ -564,7 +565,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 			  dev_missing_or_rcu_str(src_device),
 			  src_device->devid,
 			  rcu_str_deref(tgt_device->name));
-	tgt_device->is_tgtdev_for_dev_replace = 0;
+	clear_bit(BTRFS_DEV_STATE_REPLACE_TGT, &tgt_device->dev_state);
 	tgt_device->devid = src_device->devid;
 	src_device->devid = BTRFS_DEV_REPLACE_DEVID;
 	memcpy(uuid_tmp, tgt_device->uuid, sizeof(uuid_tmp));
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2cd323d184a0..1e65d5d54a8a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9692,7 +9692,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 		 * space to fit our block group in.
 		 */
 		if (device->total_bytes > device->bytes_used + min_free &&
-		    !device->is_tgtdev_for_dev_replace) {
+				!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+				&device->dev_state)) {
 			ret = find_free_dev_extent(trans, device, min_free,
 						   &dev_offset, NULL);
 			if (!ret)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e59004a17166..953563138020 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1528,7 +1528,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		}
 	}
 
-	if (device->is_tgtdev_for_dev_replace) {
+	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
 		ret = -EPERM;
 		goto out_free;
 	}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b6de017066b3..b5a33db38874 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4131,7 +4131,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	mutex_lock(&fs_info->scrub_lock);
 	if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &dev->dev_state) ||
-					dev->is_tgtdev_for_dev_replace) {
+		test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &dev->dev_state)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		return -EIO;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6bae2e046257..b16e3fbd5895 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1973,8 +1973,9 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	rcu_read_lock();
 	list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
 		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
-						&device->dev_state) ||
-			!device->bdev || device->is_tgtdev_for_dev_replace)
+				&device->dev_state) || !device->bdev ||
+				test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+				&device->dev_state))
 			continue;
 
 		if (i >= nr_devices)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c6f7f4935dc4..37b1aed14353 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -845,8 +845,8 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
 		if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
 							&device->dev_state)) {
-			if (!device->is_tgtdev_for_dev_replace &&
-			    (!latest_dev ||
+			if (!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+			     &device->dev_state) && (!latest_dev ||
 			     device->generation > latest_dev->generation)) {
 				latest_dev = device;
 			}
@@ -864,7 +864,8 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 			 * not, which means whether this device is
 			 * used or whether it should be removed.
 			 */
-			if (step == 0 || device->is_tgtdev_for_dev_replace) {
+			if (step == 0 || test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+					&device->dev_state)) {
 				continue;
 			}
 		}
@@ -877,7 +878,8 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 			list_del_init(&device->dev_alloc_list);
 			clear_bit(BTRFS_DEV_STATE_WRITEABLE,
 							&device->dev_state);
-			if (!device->is_tgtdev_for_dev_replace)
+			if (!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+							&device->dev_state))
 				fs_devices->rw_devices--;
 		}
 		list_del_init(&device->dev_list);
@@ -1204,7 +1206,8 @@ int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 
 	*length = 0;
 
-	if (start >= device->total_bytes || device->is_tgtdev_for_dev_replace)
+	if (start >= device->total_bytes ||
+		test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
 		return 0;
 
 	path = btrfs_alloc_path();
@@ -1382,7 +1385,8 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 	max_hole_size = 0;
 
 again:
-	if (search_start >= search_end || device->is_tgtdev_for_dev_replace) {
+	if (search_start >= search_end ||
+		test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
 		ret = -ENOSPC;
 		goto out;
 	}
@@ -1590,7 +1594,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 
 	WARN_ON(!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state));
-	WARN_ON(device->is_tgtdev_for_dev_replace);
+	WARN_ON(test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state));
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -1897,7 +1901,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (ret)
 		goto out;
 
-	if (device->is_tgtdev_for_dev_replace) {
+	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
 		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
 		goto out;
 	}
@@ -2408,7 +2412,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->fs_info = fs_info;
 	device->bdev = bdev;
 	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
-	device->is_tgtdev_for_dev_replace = 0;
+	clear_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
 	device->mode = FMODE_EXCL;
 	device->dev_stats_valid = 1;
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
@@ -2619,7 +2623,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	device->fs_info = fs_info;
 	device->bdev = bdev;
 	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
-	device->is_tgtdev_for_dev_replace = 1;
+	set_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
 	device->mode = FMODE_EXCL;
 	device->dev_stats_valid = 1;
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
@@ -2715,7 +2719,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	diff = round_down(new_size - device->total_bytes, fs_info->sectorsize);
 
 	if (new_size <= device->total_bytes ||
-	    device->is_tgtdev_for_dev_replace) {
+	    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
 		mutex_unlock(&fs_info->chunk_mutex);
 		return -EINVAL;
 	}
@@ -3528,7 +3532,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
 		    btrfs_device_get_total_bytes(device) -
 		    btrfs_device_get_bytes_used(device) > size_to_free ||
-		    device->is_tgtdev_for_dev_replace)
+		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
 			continue;
 
 		ret = btrfs_shrink_device(device, old_size - size_to_free);
@@ -4396,7 +4400,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	new_size = round_down(new_size, fs_info->sectorsize);
 	diff = round_down(old_size - new_size, fs_info->sectorsize);
 
-	if (device->is_tgtdev_for_dev_replace)
+	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
 		return -EINVAL;
 
 	path = btrfs_alloc_path();
@@ -4700,8 +4704,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		}
 
 		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
-					&device->dev_state) ||
-					device->is_tgtdev_for_dev_replace)
+				&device->dev_state) ||
+				test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+				&device->dev_state))
 			continue;
 
 		if (device->total_bytes > device->bytes_used)
@@ -6526,7 +6531,7 @@ static void fill_device_from_item(struct extent_buffer *leaf,
 	device->io_width = btrfs_device_io_width(leaf, dev_item);
 	device->sector_size = btrfs_device_sector_size(leaf, dev_item);
 	WARN_ON(device->devid == BTRFS_DEV_REPLACE_DEVID);
-	device->is_tgtdev_for_dev_replace = 0;
+	clear_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
 
 	ptr = btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
@@ -6676,7 +6681,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	fill_device_from_item(leaf, dev_item, device);
 	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
-					!device->is_tgtdev_for_dev_replace) {
+	   !test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
 		atomic64_add(device->total_bytes - device->bytes_used,
 				&fs_info->free_chunk_space);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index df67fea18708..4096350c2cea 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -50,6 +50,7 @@ struct btrfs_pending_bios {
 #define BTRFS_DEV_STATE_WRITEABLE	(1UL << 0)
 #define BTRFS_DEV_STATE_IN_FS_METADATA	(1UL << 1)
 #define BTRFS_DEV_STATE_MISSING		(1UL << 2)
+#define BTRFS_DEV_STATE_REPLACE_TGT	(1UL << 3)
 
 struct btrfs_device {
 	struct list_head dev_list;
@@ -74,7 +75,6 @@ struct btrfs_device {
 	fmode_t mode;
 
 	unsigned long dev_state;
-	int is_tgtdev_for_dev_replace;
 	blk_status_t last_flush_error;
 	int flush_bio_sent;
 
-- 
2.15.0

