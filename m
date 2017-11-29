Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27187 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbdK2EpS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 23:45:18 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT4jH3Q026844
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT4jHZU019120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:17 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAT4jHu9017892
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:17 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
Subject: [PATCH 2/4] btrfs: cleanup device states define BTRFS_DEV_STATE_IN_FS_METADATA
Date: Wed, 29 Nov 2017 12:45:34 +0800
Message-Id: <20171129044536.16260-3-anand.jain@oracle.com>
In-Reply-To: <20171129044536.16260-1-anand.jain@oracle.com>
References: <20171129044536.16260-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently device state is being managed by each individual int
variable such as struct btrfs_device::in_fs_metadata. Instead of
that declare device state BTRFS_DEV_STATE_IN_FS_METADATA and use
the bit operations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 21 ++++++++++++++-------
 fs/btrfs/scrub.c   |  3 ++-
 fs/btrfs/super.c   |  5 +++--
 fs/btrfs/volumes.c | 29 +++++++++++++++++------------
 fs/btrfs/volumes.h |  2 +-
 5 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0d361b6713e1..ab1a514e5c8d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3563,8 +3563,10 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 			continue;
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata ||
-			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+						&dev->dev_state) ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE,
+						&dev->dev_state))
 			continue;
 
 		write_dev_flush(dev);
@@ -3579,8 +3581,10 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 			errors_wait++;
 			continue;
 		}
-		if (!dev->in_fs_metadata ||
-			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+						&dev->dev_state) ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE,
+						&dev->dev_state))
 			continue;
 
 		ret = wait_dev_flush(dev);
@@ -3677,7 +3681,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 			total_errors++;
 			continue;
 		}
-		if (!dev->in_fs_metadata ||
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+						&dev->dev_state) ||
 			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
@@ -3717,8 +3722,10 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata ||
-			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+						&dev->dev_state) ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE,
+						&dev->dev_state))
 			continue;
 
 		ret = wait_dev_supers(dev, max_mirrors);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e027e0de66a5..060fa93731e5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4129,7 +4129,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	}
 
 	mutex_lock(&fs_info->scrub_lock);
-	if (!dev->in_fs_metadata || dev->is_tgtdev_for_dev_replace) {
+	if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &dev->dev_state) ||
+					dev->is_tgtdev_for_dev_replace) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		return -EIO;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 161694b66038..9089aad2f3aa 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1945,8 +1945,9 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
-		if (!device->in_fs_metadata || !device->bdev ||
-		    device->is_tgtdev_for_dev_replace)
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+						&device->dev_state) ||
+			!device->bdev || device->is_tgtdev_for_dev_replace)
 			continue;
 
 		if (i >= nr_devices)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0f5be1808c6e..13a6ae80bee1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -652,7 +652,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 		fs_devices->rotating = 1;
 
 	device->bdev = bdev;
-	device->in_fs_metadata = 0;
+	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	device->mode = flags;
 
 	fs_devices->open_devices++;
@@ -857,7 +857,8 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 again:
 	/* This is the initialized path, it is safe to release the devices. */
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
-		if (device->in_fs_metadata) {
+		if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+							&device->dev_state)) {
 			if (!device->is_tgtdev_for_dev_replace &&
 			    (!latest_dev ||
 			     device->generation > latest_dev->generation)) {
@@ -1600,7 +1601,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 
-	WARN_ON(!device->in_fs_metadata);
+	WARN_ON(!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state));
 	WARN_ON(device->is_tgtdev_for_dev_replace);
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1936,7 +1937,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (ret)
 		goto error_undo;
 
-	device->in_fs_metadata = 0;
+	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	btrfs_scrub_cancel_dev(fs_info, device);
 
 	/*
@@ -2154,7 +2155,8 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
 		 * is held by the caller.
 		 */
 		list_for_each_entry(tmp, devices, dev_list) {
-			if (tmp->in_fs_metadata && !tmp->bdev) {
+			if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+					&tmp->dev_state) && !tmp->bdev) {
 				*device = tmp;
 				break;
 			}
@@ -2410,7 +2412,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->commit_total_bytes = device->total_bytes;
 	device->fs_info = fs_info;
 	device->bdev = bdev;
-	device->in_fs_metadata = 1;
+	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	device->is_tgtdev_for_dev_replace = 0;
 	device->mode = FMODE_EXCL;
 	device->dev_stats_valid = 1;
@@ -2613,7 +2615,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	device->commit_bytes_used = device->bytes_used;
 	device->fs_info = fs_info;
 	device->bdev = bdev;
-	device->in_fs_metadata = 1;
+	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	device->is_tgtdev_for_dev_replace = 1;
 	device->mode = FMODE_EXCL;
 	device->dev_stats_valid = 1;
@@ -2642,7 +2644,7 @@ void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
 	tgtdev->io_align = sectorsize;
 	tgtdev->sector_size = sectorsize;
 	tgtdev->fs_info = fs_info;
-	tgtdev->in_fs_metadata = 1;
+	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &tgtdev->dev_state);
 }
 
 static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
@@ -4694,8 +4696,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		if (!device->in_fs_metadata ||
-		    device->is_tgtdev_for_dev_replace)
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+					&device->dev_state) ||
+					device->is_tgtdev_for_dev_replace)
 			continue;
 
 		if (device->total_bytes > device->bytes_used)
@@ -6498,7 +6501,9 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			}
 			btrfs_report_missing_device(fs_info, devid, uuid, false);
 		}
-		map->stripes[i].dev->in_fs_metadata = 1;
+		set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+				&(map->stripes[i].dev->dev_state));
+
 	}
 
 	write_lock(&map_tree->map_tree.lock);
@@ -6673,7 +6678,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	}
 
 	fill_device_from_item(leaf, dev_item, device);
-	device->in_fs_metadata = 1;
+	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 					!device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2e376a422626..f73b78f26a61 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -48,6 +48,7 @@ struct btrfs_pending_bios {
 #endif
 
 #define BTRFS_DEV_STATE_WRITEABLE	(1UL << 1)
+#define BTRFS_DEV_STATE_IN_FS_METADATA	(1UL << 2)
 
 struct btrfs_device {
 	struct list_head dev_list;
@@ -72,7 +73,6 @@ struct btrfs_device {
 	fmode_t mode;
 
 	unsigned long dev_state;
-	int in_fs_metadata;
 	int missing;
 	int can_discard;
 	int is_tgtdev_for_dev_replace;
-- 
2.15.0

