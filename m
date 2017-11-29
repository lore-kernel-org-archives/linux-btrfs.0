Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27191 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdK2EpU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 23:45:20 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT4jJEH026855
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT4jIMf000443
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:19 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAT4jIL5026333
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
Subject: [PATCH 3/4] btrfs: cleanup device states define BTRFS_DEV_STATE_MISSING
Date: Wed, 29 Nov 2017 12:45:35 +0800
Message-Id: <20171129044536.16260-4-anand.jain@oracle.com>
In-Reply-To: <20171129044536.16260-1-anand.jain@oracle.com>
References: <20171129044536.16260-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently device state is being managed by each individual int
variable such as struct btrfs_device::missing. Instead of that
declare btrfs_device::dev_state BTRFS_DEV_STATE_MISSING and use
the bit operations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |  3 ++-
 fs/btrfs/disk-io.c     |  4 ++--
 fs/btrfs/scrub.c       |  7 ++++---
 fs/btrfs/super.c       |  2 +-
 fs/btrfs/volumes.c     | 33 +++++++++++++++++++--------------
 fs/btrfs/volumes.h     |  2 +-
 6 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 4b6ceb38cb5f..559db7667f38 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -306,7 +306,8 @@ void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
 
 static inline char *dev_missing_or_rcu_str(struct btrfs_device *device)
 {
-	return device->missing ? "<missing disk>" : rcu_str_deref(device->name);
+	return test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state) ?
+				"<missing disk>" : rcu_str_deref(device->name);
 }
 
 int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ab1a514e5c8d..ac1079fc9382 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3559,7 +3559,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 	/* send down all the barriers */
 	head = &info->fs_devices->devices;
 	list_for_each_entry_rcu(dev, head, dev_list) {
-		if (dev->missing)
+		if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state))
 			continue;
 		if (!dev->bdev)
 			continue;
@@ -3575,7 +3575,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 	/* wait for all the barriers */
 	list_for_each_entry_rcu(dev, head, dev_list) {
-		if (dev->missing)
+		if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state))
 			continue;
 		if (!dev->bdev) {
 			errors_wait++;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 060fa93731e5..666c00cbee03 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2535,7 +2535,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 	}
 
 	WARN_ON(sblock->page_count == 0);
-	if (dev->missing) {
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state)) {
 		/*
 		 * This case should only be hit for RAID 5/6 device replace. See
 		 * the comment in scrub_missing_raid56_pages() for details.
@@ -2870,7 +2870,7 @@ static int scrub_extent_for_parity(struct scrub_parity *sparity,
 	u8 csum[BTRFS_CSUM_SIZE];
 	u32 blocksize;
 
-	if (dev->missing) {
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state)) {
 		scrub_parity_mark_sectors_error(sparity, logical, len);
 		return 0;
 	}
@@ -4112,7 +4112,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
-	if (!dev || (dev->missing && !is_dev_replace)) {
+	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
+						!is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		return -ENODEV;
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9089aad2f3aa..4b70ae6f0245 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2243,7 +2243,7 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 	while (cur_devices) {
 		head = &cur_devices->devices;
 		list_for_each_entry(dev, head, dev_list) {
-			if (dev->missing)
+			if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state))
 				continue;
 			if (!dev->name)
 				continue;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 13a6ae80bee1..75839e07ce10 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -773,9 +773,9 @@ static noinline int device_list_add(const char *path,
 			return -ENOMEM;
 		rcu_string_free(device->name);
 		rcu_assign_pointer(device->name, name);
-		if (device->missing) {
+		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
 			fs_devices->missing_devices--;
-			device->missing = 0;
+			clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
 		}
 	}
 
@@ -957,7 +957,7 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 		fs_devices->rw_devices--;
 	}
 
-	if (device->missing)
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		fs_devices->missing_devices--;
 
 	new_device = btrfs_alloc_device(NULL, &device->devid,
@@ -1844,7 +1844,8 @@ struct btrfs_device *btrfs_find_next_active_device(struct btrfs_fs_devices *fs_d
 
 	list_for_each_entry(next_device, &fs_devs->devices, dev_list) {
 		if (next_device != device &&
-			!next_device->missing && next_device->bdev)
+			!test_bit(BTRFS_DEV_STATE_MISSING,
+				&next_device->dev_state) && next_device->bdev)
 			return next_device;
 	}
 
@@ -1957,7 +1958,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	device->fs_devices->num_devices--;
 	device->fs_devices->total_devices--;
 
-	if (device->missing)
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		device->fs_devices->missing_devices--;
 
 	btrfs_assign_next_active_device(fs_info, device, NULL);
@@ -2031,7 +2032,7 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 	list_del_rcu(&srcdev->dev_list);
 	list_del_rcu(&srcdev->dev_alloc_list);
 	fs_devices->num_devices--;
-	if (srcdev->missing)
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &srcdev->dev_state))
 		fs_devices->missing_devices--;
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state))
@@ -5048,7 +5049,7 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	for (i = 0; i < map->num_stripes; i++) {
 		struct btrfs_device *device = map->stripes[i].dev;
 
-		if (device->missing) {
+		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
 			miss_ndevs++;
 			continue;
 		}
@@ -6079,7 +6080,8 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
 	int should_queue = 1;
 	struct btrfs_pending_bios *pending_bios;
 
-	if (device->missing || !device->bdev) {
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state) ||
+			!device->bdev) {
 		bio_io_error(bio);
 		return;
 	}
@@ -6282,7 +6284,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
 	device->fs_devices = fs_devices;
 	fs_devices->num_devices++;
 
-	device->missing = 1;
+	set_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
 	fs_devices->missing_devices++;
 
 	return device;
@@ -6644,7 +6646,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 							dev_uuid, false);
 		}
 
-		if(!device->bdev && !device->missing) {
+		if (!device->bdev && !test_bit(BTRFS_DEV_STATE_MISSING,
+							&device->dev_state)) {
 			/*
 			 * this happens when a device that was properly setup
 			 * in the device info lists suddenly goes bad.
@@ -6652,12 +6655,13 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 			 * device->missing to one here
 			 */
 			device->fs_devices->missing_devices++;
-			device->missing = 1;
+			set_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
 		}
 
 		/* Move the device to its own fs_devices */
 		if (device->fs_devices != fs_devices) {
-			ASSERT(device->missing);
+			ASSERT(test_bit(BTRFS_DEV_STATE_MISSING,
+							&device->dev_state));
 
 			list_move(&device->dev_list, &fs_devices->devices);
 			device->fs_devices->num_devices--;
@@ -6843,8 +6847,9 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
 		for (i = 0; i < map->num_stripes; i++) {
 			struct btrfs_device *dev = map->stripes[i].dev;
 
-			if (!dev || !dev->bdev || dev->missing ||
-			    dev->last_flush_error)
+			if (!dev || !dev->bdev ||
+				test_bit(BTRFS_DEV_STATE_MISSING,
+				&dev->dev_state) || dev->last_flush_error)
 				missing++;
 		}
 		if (missing > max_tolerated) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index f73b78f26a61..2fbff6902c8d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -49,6 +49,7 @@ struct btrfs_pending_bios {
 
 #define BTRFS_DEV_STATE_WRITEABLE	(1UL << 1)
 #define BTRFS_DEV_STATE_IN_FS_METADATA	(1UL << 2)
+#define BTRFS_DEV_STATE_MISSING		(1UL << 3)
 
 struct btrfs_device {
 	struct list_head dev_list;
@@ -73,7 +74,6 @@ struct btrfs_device {
 	fmode_t mode;
 
 	unsigned long dev_state;
-	int missing;
 	int can_discard;
 	int is_tgtdev_for_dev_replace;
 	blk_status_t last_flush_error;
-- 
2.15.0

