Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49758 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758719AbaGXDfr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3Ze1m017418
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:40 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/10] Btrfs: cleanup unused latest_devid and latest_trans in fs_devices
Date: Thu, 24 Jul 2014 11:37:15 +0800
Message-ID: <1406173035-29478-10-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The member variants - latest_devid and latest_trans - of fs_devices structure
are set, but no one use them to do anything. so remove them.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 42 +++++++++++-------------------------------
 fs/btrfs/volumes.h |  3 ---
 2 files changed, 11 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0140bff..b1ed417 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -475,14 +475,13 @@ static noinline int device_list_add(const char *path,
 			return PTR_ERR(fs_devices);
 
 		list_add(&fs_devices->list, &fs_uuids);
-		fs_devices->latest_devid = devid;
-		fs_devices->latest_trans = found_transid;
 
 		device = NULL;
 	} else {
 		device = __find_device(&fs_devices->devices, devid,
 				       disk_super->dev_item.uuid);
 	}
+
 	if (!device) {
 		if (fs_devices->opened)
 			return -EBUSY;
@@ -567,10 +566,6 @@ static noinline int device_list_add(const char *path,
 	if (!fs_devices->opened)
 		device->generation = found_transid;
 
-	if (found_transid > fs_devices->latest_trans) {
-		fs_devices->latest_devid = devid;
-		fs_devices->latest_trans = found_transid;
-	}
 	*fs_devices_ret = fs_devices;
 
 	return ret;
@@ -586,8 +581,6 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	if (IS_ERR(fs_devices))
 		return fs_devices;
 
-	fs_devices->latest_devid = orig->latest_devid;
-	fs_devices->latest_trans = orig->latest_trans;
 	fs_devices->total_devices = orig->total_devices;
 
 	/* We have held the volume lock, it is safe to get the devices. */
@@ -631,10 +624,7 @@ void btrfs_close_extra_devices(struct btrfs_fs_info *fs_info,
 			       struct btrfs_fs_devices *fs_devices, int step)
 {
 	struct btrfs_device *device, *next;
-
-	struct block_device *latest_bdev = NULL;
-	u64 latest_devid = 0;
-	u64 latest_transid = 0;
+	struct btrfs_device *latest_dev = NULL;
 
 	mutex_lock(&uuid_mutex);
 again:
@@ -642,11 +632,9 @@ again:
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
 		if (device->in_fs_metadata) {
 			if (!device->is_tgtdev_for_dev_replace &&
-			    (!latest_transid ||
-			     device->generation > latest_transid)) {
-				latest_devid = device->devid;
-				latest_transid = device->generation;
-				latest_bdev = device->bdev;
+			    (!latest_dev ||
+			     device->generation > latest_dev->generation)) {
+				latest_dev = device;
 			}
 			continue;
 		}
@@ -688,9 +676,7 @@ again:
 		goto again;
 	}
 
-	fs_devices->latest_bdev = latest_bdev;
-	fs_devices->latest_devid = latest_devid;
-	fs_devices->latest_trans = latest_transid;
+	fs_devices->latest_bdev = latest_dev->bdev;
 
 	mutex_unlock(&uuid_mutex);
 }
@@ -805,11 +791,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	struct block_device *bdev;
 	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *device;
-	struct block_device *latest_bdev = NULL;
+	struct btrfs_device *latest_dev = NULL;
 	struct buffer_head *bh;
 	struct btrfs_super_block *disk_super;
-	u64 latest_devid = 0;
-	u64 latest_transid = 0;
 	u64 devid;
 	int seeding = 1;
 	int ret = 0;
@@ -837,11 +821,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			goto error_brelse;
 
 		device->generation = btrfs_super_generation(disk_super);
-		if (!latest_transid || device->generation > latest_transid) {
-			latest_devid = devid;
-			latest_transid = device->generation;
-			latest_bdev = bdev;
-		}
+		if (!latest_dev ||
+		    device->generation > latest_dev->generation)
+			latest_dev = device;
 
 		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
 			device->writeable = 0;
@@ -884,9 +866,7 @@ error_brelse:
 	}
 	fs_devices->seeding = seeding;
 	fs_devices->opened = 1;
-	fs_devices->latest_bdev = latest_bdev;
-	fs_devices->latest_devid = latest_devid;
-	fs_devices->latest_trans = latest_transid;
+	fs_devices->latest_bdev = latest_dev->bdev;
 	fs_devices->total_rw_bytes = 0;
 out:
 	return ret;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 90d4fa8..e894ac6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -119,9 +119,6 @@ struct btrfs_device {
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
 
-	/* the device with this id has the most recent copy of the super */
-	u64 latest_devid;
-	u64 latest_trans;
 	u64 num_devices;
 	u64 open_devices;
 	u64 rw_devices;
-- 
1.9.3

